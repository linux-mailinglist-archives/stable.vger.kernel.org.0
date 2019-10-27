Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BBBBCE670D
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 22:17:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730091AbfJ0VRh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 17:17:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:37462 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731078AbfJ0VRg (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Oct 2019 17:17:36 -0400
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 96CF9205C9;
        Sun, 27 Oct 2019 21:17:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572211055;
        bh=Ii/x99Y43DIXENaiW8bkvF2LMelP892XpD/IMXCT2sI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JEGKJ1K1FBvZTkUYE1FVFNDxkOgxoQ2b0F52WWojhu0IzlU5bMwgnT8TwYJ4oVP84
         QCDie05QL4prUaXBFQpk7ZfS2qgLPmFG0yeqVyvTwWCYAqIIIX8xfZi/4qWLP0pTU1
         dXyqL0zlx/yjVNHoHgg4SpY4jZPVnLKqnGUuQUq8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mark Wunderlich <mark.wunderlich@intel.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 017/197] nvme-tcp: fix wrong stop condition in io_work
Date:   Sun, 27 Oct 2019 21:58:55 +0100
Message-Id: <20191027203352.605976499@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191027203351.684916567@linuxfoundation.org>
References: <20191027203351.684916567@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wunderlich, Mark <mark.wunderlich@intel.com>

[ Upstream commit ddef29578a81a1d4d8f2b26a7adbfe21407ee3ea ]

Allow the do/while statement to continue if current time
is not after the proposed time 'deadline'. Intent is to
allow loop to proceed for a specific time period. Currently
the loop, as coded, will exit after first pass.

Signed-off-by: Mark Wunderlich <mark.wunderlich@intel.com>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/tcp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/nvme/host/tcp.c b/drivers/nvme/host/tcp.c
index 606b13d35d16f..bdadb27b28bbb 100644
--- a/drivers/nvme/host/tcp.c
+++ b/drivers/nvme/host/tcp.c
@@ -1039,7 +1039,7 @@ static void nvme_tcp_io_work(struct work_struct *w)
 {
 	struct nvme_tcp_queue *queue =
 		container_of(w, struct nvme_tcp_queue, io_work);
-	unsigned long start = jiffies + msecs_to_jiffies(1);
+	unsigned long deadline = jiffies + msecs_to_jiffies(1);
 
 	do {
 		bool pending = false;
@@ -1064,7 +1064,7 @@ static void nvme_tcp_io_work(struct work_struct *w)
 		if (!pending)
 			return;
 
-	} while (time_after(jiffies, start)); /* quota is exhausted */
+	} while (!time_after(jiffies, deadline)); /* quota is exhausted */
 
 	queue_work_on(queue->io_cpu, nvme_tcp_wq, &queue->io_work);
 }
-- 
2.20.1



