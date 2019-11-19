Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EFE4C101920
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 07:12:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727170AbfKSFVG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:21:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:35684 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727148AbfKSFVG (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:21:06 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B34A422317;
        Tue, 19 Nov 2019 05:21:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574140865;
        bh=6O0vfID8jp8yafge8N3fX5f9V8VFwfcvHpXL7Dzw+iA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TVWEszmXHYriNRer5sIG4+JLPZVa8jZtn7vlCIZUkFHDuwI5BLr0iVM36HyYtWxJV
         Nvyqz+iyJJqd8hfvbntNp0mvqM2+PEtawXItwQGKRanQQ4+0/E6jzzI93I5kvUFR4R
         MSjFb8i//4phSnBDslq8/fwjaeAREe/7jN62YG4U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+4b73ad6fc767e576e275@syzkaller.appspotmail.com,
        Ursula Braun <ubraun@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.3 13/48] net/smc: fix refcount non-blocking connect() -part 2
Date:   Tue, 19 Nov 2019 06:19:33 +0100
Message-Id: <20191119051000.159408916@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119050946.745015350@linuxfoundation.org>
References: <20191119050946.745015350@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ursula Braun <ubraun@linux.ibm.com>

[ Upstream commit 6d6dd528d5af05dc2d0c773951ed68d630a0c3f1 ]

If an SMC socket is immediately terminated after a non-blocking connect()
has been called, a memory leak is possible.
Due to the sock_hold move in
commit 301428ea3708 ("net/smc: fix refcounting for non-blocking connect()")
an extra sock_put() is needed in smc_connect_work(), if the internal
TCP socket is aborted and cancels the sk_stream_wait_connect() of the
connect worker.

Reported-by: syzbot+4b73ad6fc767e576e275@syzkaller.appspotmail.com
Fixes: 301428ea3708 ("net/smc: fix refcounting for non-blocking connect()")
Signed-off-by: Ursula Braun <ubraun@linux.ibm.com>
Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/smc/af_smc.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -796,6 +796,7 @@ static void smc_connect_work(struct work
 			smc->sk.sk_err = EPIPE;
 		else if (signal_pending(current))
 			smc->sk.sk_err = -sock_intr_errno(timeo);
+		sock_put(&smc->sk); /* passive closing */
 		goto out;
 	}
 


