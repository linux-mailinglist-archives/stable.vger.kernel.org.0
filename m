Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4238EF56D0
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 21:04:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390692AbfKHTLO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 14:11:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:43626 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391997AbfKHTLO (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 14:11:14 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2925A206A3;
        Fri,  8 Nov 2019 19:11:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573240273;
        bh=09BxqHp169q6fr0ZCElDEycFydF5NK0HyBEQ4yC+1cA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ErSpFERoDImty+s2xpanS1JWjMEQjc3bgd5KWoeU2jSb9MF+T5QNQdH6Lm4S1rN76
         BYeQABMDhm+Jx7XGrrDGvwk+uCmnf32PG921T9AcFukphBwqPt+xcOI5xb17LK7Sa1
         uAOIitk31w9upTZokremqawnk9sa+hzjS53sK0K8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+4c063e6dea39e4b79f29@syzkaller.appspotmail.com,
        Karsten Graul <kgraul@linux.ibm.com>,
        Ursula Braun <ubraun@linux.ibm.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.3 114/140] net/smc: fix refcounting for non-blocking connect()
Date:   Fri,  8 Nov 2019 19:50:42 +0100
Message-Id: <20191108174912.010960142@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191108174900.189064908@linuxfoundation.org>
References: <20191108174900.189064908@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ursula Braun <ubraun@linux.ibm.com>

[ Upstream commit 301428ea3708188dc4a243e6e6b46c03b46a0fbc ]

If a nonblocking socket is immediately closed after connect(),
the connect worker may not have started. This results in a refcount
problem, since sock_hold() is called from the connect worker.
This patch moves the sock_hold in front of the connect worker
scheduling.

Reported-by: syzbot+4c063e6dea39e4b79f29@syzkaller.appspotmail.com
Fixes: 50717a37db03 ("net/smc: nonblocking connect rework")
Reviewed-by: Karsten Graul <kgraul@linux.ibm.com>
Signed-off-by: Ursula Braun <ubraun@linux.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/smc/af_smc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -707,8 +707,6 @@ static int __smc_connect(struct smc_sock
 	int smc_type;
 	int rc = 0;
 
-	sock_hold(&smc->sk); /* sock put in passive closing */
-
 	if (smc->use_fallback)
 		return smc_connect_fallback(smc, smc->fallback_rsn);
 
@@ -853,6 +851,8 @@ static int smc_connect(struct socket *so
 	rc = kernel_connect(smc->clcsock, addr, alen, flags);
 	if (rc && rc != -EINPROGRESS)
 		goto out;
+
+	sock_hold(&smc->sk); /* sock put in passive closing */
 	if (flags & O_NONBLOCK) {
 		if (schedule_work(&smc->connect_work))
 			smc->connect_nonblock = 1;


