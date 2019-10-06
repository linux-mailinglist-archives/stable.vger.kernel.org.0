Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B71BCD62C
	for <lists+stable@lfdr.de>; Sun,  6 Oct 2019 19:44:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731023AbfJFRoD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Oct 2019 13:44:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:44142 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731598AbfJFRoB (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 6 Oct 2019 13:44:01 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A900D20700;
        Sun,  6 Oct 2019 17:44:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570383841;
        bh=1gC8dF8dzfLCl1x3XsU1+O9RnKWeN/KhwwtSk3TzVcw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NY0OV9aMq/VNql3FX8nby40asCWs1cPPk5iN6N5Bq1IvQvr0ujnDdfiETldsH/2ys
         tnf4V5erajSv+RZ2EIgln255YnphoJLXaG3lgJ3p7Uk8tYN9hVJzRbQzME0xwDd1XK
         sFqVDMP04GuuiSHtWKsfGzd33w8+9MDmHBWn7sAQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Oleksandr Natalenko <oleksandr@natalenko.name>,
        Paolo Valente <paolo.valente@linaro.org>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 114/166] block, bfq: push up injection only after setting service time
Date:   Sun,  6 Oct 2019 19:21:20 +0200
Message-Id: <20191006171222.946938472@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191006171212.850660298@linuxfoundation.org>
References: <20191006171212.850660298@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Valente <paolo.valente@linaro.org>

[ Upstream commit 58494c980f40274c465ebfdece02d401def088bf ]

If equal to 0, the injection limit for a bfq_queue is pushed to 1
after a first sample of the total service time of the I/O requests of
the queue is computed (to allow injection to start). Yet, because of a
mistake in the branch that performs this action, the push may happen
also in some other case. This commit fixes this issue.

Tested-by: Oleksandr Natalenko <oleksandr@natalenko.name>
Signed-off-by: Paolo Valente <paolo.valente@linaro.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/bfq-iosched.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/block/bfq-iosched.c b/block/bfq-iosched.c
index b33be928d164f..70bcbd02edcb1 100644
--- a/block/bfq-iosched.c
+++ b/block/bfq-iosched.c
@@ -5809,12 +5809,14 @@ static void bfq_update_inject_limit(struct bfq_data *bfqd,
 	 */
 	if ((bfqq->last_serv_time_ns == 0 && bfqd->rq_in_driver == 1) ||
 	    tot_time_ns < bfqq->last_serv_time_ns) {
+		if (bfqq->last_serv_time_ns == 0) {
+			/*
+			 * Now we certainly have a base value: make sure we
+			 * start trying injection.
+			 */
+			bfqq->inject_limit = max_t(unsigned int, 1, old_limit);
+		}
 		bfqq->last_serv_time_ns = tot_time_ns;
-		/*
-		 * Now we certainly have a base value: make sure we
-		 * start trying injection.
-		 */
-		bfqq->inject_limit = max_t(unsigned int, 1, old_limit);
 	} else if (!bfqd->rqs_injected && bfqd->rq_in_driver == 1)
 		/*
 		 * No I/O injected and no request still in service in
-- 
2.20.1



