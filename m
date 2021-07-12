Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C4943C47C8
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:28:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234663AbhGLGfG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:35:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:54932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235717AbhGLGdQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:33:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D531B61107;
        Mon, 12 Jul 2021 06:29:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626071394;
        bh=FvwUpQ2nmy72RY4rak7jDjupjX9dGsTCsai5zJ8RPPE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TUDpKk1BOWytu28BbUKq9r7yLgnyqEjODhqXmfexVik/6RtNA5zU8Sh6PrXVVdtwv
         LruzGK4DaUaz/6pD/4WWEN03lkM/1Ale9sjzKsSiA5/txbcAJvaN7Zf857E1gHKBPC
         tb86uY1WT3p5P4x4dEPtZQywr3glxqcceb+nR4QQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+0f7e7e5e2f4f40fa89c0@syzkaller.appspotmail.com,
        Norbert Slusarek <nslusarek@gmx.net>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 5.10 050/593] can: bcm: delay release of struct bcm_op after synchronize_rcu()
Date:   Mon, 12 Jul 2021 08:03:30 +0200
Message-Id: <20210712060848.631325566@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060843.180606720@linuxfoundation.org>
References: <20210712060843.180606720@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>

commit d5f9023fa61ee8b94f37a93f08e94b136cf1e463 upstream.

can_rx_register() callbacks may be called concurrently to the call to
can_rx_unregister(). The callbacks and callback data, though, are
protected by RCU and the struct sock reference count.

So the callback data is really attached to the life of sk, meaning
that it should be released on sk_destruct. However, bcm_remove_op()
calls tasklet_kill(), and RCU callbacks may be called under RCU
softirq, so that cannot be used on kernels before the introduction of
HRTIMER_MODE_SOFT.

However, bcm_rx_handler() is called under RCU protection, so after
calling can_rx_unregister(), we may call synchronize_rcu() in order to
wait for any RCU read-side critical sections to finish. That is,
bcm_rx_handler() won't be called anymore for those ops. So, we only
free them, after we do that synchronize_rcu().

Fixes: ffd980f976e7 ("[CAN]: Add broadcast manager (bcm) protocol")
Link: https://lore.kernel.org/r/20210619161813.2098382-1-cascardo@canonical.com
Cc: linux-stable <stable@vger.kernel.org>
Reported-by: syzbot+0f7e7e5e2f4f40fa89c0@syzkaller.appspotmail.com
Reported-by: Norbert Slusarek <nslusarek@gmx.net>
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Acked-by: Oliver Hartkopp <socketcan@hartkopp.net>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/can/bcm.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/net/can/bcm.c
+++ b/net/can/bcm.c
@@ -785,6 +785,7 @@ static int bcm_delete_rx_op(struct list_
 						  bcm_rx_handler, op);
 
 			list_del(&op->list);
+			synchronize_rcu();
 			bcm_remove_op(op);
 			return 1; /* done */
 		}
@@ -1533,9 +1534,13 @@ static int bcm_release(struct socket *so
 					  REGMASK(op->can_id),
 					  bcm_rx_handler, op);
 
-		bcm_remove_op(op);
 	}
 
+	synchronize_rcu();
+
+	list_for_each_entry_safe(op, next, &bo->rx_ops, list)
+		bcm_remove_op(op);
+
 #if IS_ENABLED(CONFIG_PROC_FS)
 	/* remove procfs entry */
 	if (net->can.bcmproc_dir && bo->bcm_proc_read)


