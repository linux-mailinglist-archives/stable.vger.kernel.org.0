Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 070D4D16B1
	for <lists+stable@lfdr.de>; Wed,  9 Oct 2019 19:32:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732302AbfJIRbz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Oct 2019 13:31:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:48098 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732033AbfJIRX6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 9 Oct 2019 13:23:58 -0400
Received: from sasha-vm.mshome.net (unknown [167.220.2.234])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5A4B721929;
        Wed,  9 Oct 2019 17:23:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570641838;
        bh=p1HFA6X3IDlFuyTeWwZLG00ihvwnsActcDW+mlTwb1U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TT9M21ot8y8eR7hbW5QJgZ8bhOXHsHwSTxh8j+33eQCegSj32a7GgW6SBsQdVfn7F
         5Z2dVrdY4CdnqQHx1putX0fcvkmWi8fqyCITu9blC8WHbTRd6N5wIHPklHIglci5Pn
         zjd7usVVXCw+ZlAwxjnMWsnRfARqHzr3f6gCTtYY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Wunderlich, Mark" <mark.wunderlich@intel.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Sasha Levin <sashal@kernel.org>, linux-nvme@lists.infradead.org
Subject: [PATCH AUTOSEL 5.3 18/68] nvme-tcp: fix wrong stop condition in io_work
Date:   Wed,  9 Oct 2019 13:04:57 -0400
Message-Id: <20191009170547.32204-18-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191009170547.32204-1-sashal@kernel.org>
References: <20191009170547.32204-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Wunderlich, Mark" <mark.wunderlich@intel.com>

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

