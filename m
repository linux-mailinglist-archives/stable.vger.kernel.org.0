Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 592CF3C5F58
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 17:34:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235529AbhGLPhM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 11:37:12 -0400
Received: from mo4-p01-ob.smtp.rzone.de ([85.215.255.52]:32593 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232203AbhGLPhM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Jul 2021 11:37:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1626103880;
    s=strato-dkim-0002; d=hartkopp.net;
    h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=B70DVUwqAql7xbJnbxtjSYSaBgGKgUW0tV9cVXDNBxs=;
    b=flhkqRqjfUr25vF/Kg/TUWuXoKy/vRIXiCfc/0KeOtm/p7n/N5DUiGBHwCLZylv71o
    MOlIhNpH5pcEMOO5lzFs4yX1HwbIl13DpemYlhy+i7XqkIrCAk8+GgJWBRXhOBuj6tq2
    7HIs51FoKL7G9Cgb3YnqdUislTpfj6FZUvhpr/rNxyvfQPNnYhjMje2vkJOxzC4/IJxh
    sLss3OK0gifpmXerEg7aPbNH53AsgW5j54I0kfmE4D6+0txZrHpfEqpdjKFp8W7exzWu
    ZtLN0GQviwFXzpKzy+9atoaC++xr8oQDPq/WgYuoEb8UgJ2OMNJsj3cJK3oD7POOOjja
    Iccg==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjGrp7owjzFK3JbFk1mS/xvEBL7X5sbo3UIh+JyKAeyWJabqMyH2G"
X-RZG-CLASS-ID: mo00
Received: from silver.lan
    by smtp.strato.de (RZmta 47.28.1 AUTH)
    with ESMTPSA id h0143fx6CFVJUqT
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Mon, 12 Jul 2021 17:31:19 +0200 (CEST)
From:   Oliver Hartkopp <socketcan@hartkopp.net>
To:     gregkh@linuxfoundation.org
Cc:     Thadeu Lima de Souza Cascardo <cascardo@canonical.com>,
        linux-stable <stable@vger.kernel.org>,
        syzbot+0f7e7e5e2f4f40fa89c0@syzkaller.appspotmail.com,
        Norbert Slusarek <nslusarek@gmx.net>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH stable 4.4 4.9] can: bcm: delay release of struct bcm_op after synchronize_rcu()
Date:   Mon, 12 Jul 2021 17:30:36 +0200
Message-Id: <20210712153036.5937-2-socketcan@hartkopp.net>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210712153036.5937-1-socketcan@hartkopp.net>
References: <20210712153036.5937-1-socketcan@hartkopp.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>

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
---
 net/can/bcm.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/net/can/bcm.c b/net/can/bcm.c
index c6fee58baac4..3e131dc5f0e5 100644
--- a/net/can/bcm.c
+++ b/net/can/bcm.c
@@ -811,10 +811,11 @@ static int bcm_delete_rx_op(struct list_head *ops, canid_t can_id, int ifindex)
 				can_rx_unregister(NULL, op->can_id,
 						  REGMASK(op->can_id),
 						  bcm_rx_handler, op);
 
 			list_del(&op->list);
+			synchronize_rcu();
 			bcm_remove_op(op);
 			return 1; /* done */
 		}
 	}
 
@@ -1536,13 +1537,17 @@ static int bcm_release(struct socket *sock)
 		} else
 			can_rx_unregister(NULL, op->can_id,
 					  REGMASK(op->can_id),
 					  bcm_rx_handler, op);
 
-		bcm_remove_op(op);
 	}
 
+	synchronize_rcu();
+
+	list_for_each_entry_safe(op, next, &bo->rx_ops, list)
+		bcm_remove_op(op);
+
 	/* remove procfs entry */
 	if (proc_dir && bo->bcm_proc_read)
 		remove_proc_entry(bo->procname, proc_dir);
 
 	/* remove device reference */
-- 
2.30.2

