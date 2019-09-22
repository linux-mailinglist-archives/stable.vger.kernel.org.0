Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 99B4EBA937
	for <lists+stable@lfdr.de>; Sun, 22 Sep 2019 21:51:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725883AbfIVTMn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Sep 2019 15:12:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:60600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2438691AbfIVS54 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 22 Sep 2019 14:57:56 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 39D982186A;
        Sun, 22 Sep 2019 18:57:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569178676;
        bh=F5UZtW5wJQuWwJm1UKn0QprMlUWyCj5JSSwknCe4+0k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nMJfSwpTYO3Fl8mJ4zxn4tjIAhc1PWTndNUrcoSbqxN9z50vKp0GNtD71tFKd3pO2
         fSk23meW+0tvaQMgMBCoI4JnYThxTTI7y6BsRXRql1HSvvIGAiQpk598renTxO7W4n
         bUrl/252RLSr9C1LTz+cfdUvuLIG8JXExs6+Dnuc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Guoqing Jiang <jgq516@gmail.com>,
        Guoqing Jiang <guoqing.jiang@cloud.ionos.com>,
        Song Liu <songliubraving@fb.com>,
        Sasha Levin <sashal@kernel.org>, linux-raid@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 25/89] md: don't call spare_active in md_reap_sync_thread if all member devices can't work
Date:   Sun, 22 Sep 2019 14:56:13 -0400
Message-Id: <20190922185717.3412-25-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190922185717.3412-1-sashal@kernel.org>
References: <20190922185717.3412-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guoqing Jiang <jgq516@gmail.com>

[ Upstream commit 0d8ed0e9bf9643f27f4816dca61081784dedb38d ]

When add one disk to array, the md_reap_sync_thread is responsible
to activate the spare and set In_sync flag for the new member in
spare_active().

But if raid1 has one member disk A, and disk B is added to the array.
Then we offline A before all the datas are synchronized from A to B,
obviously B doesn't have the latest data as A, but B is still marked
with In_sync flag.

So let's not call spare_active under the condition, otherwise B is
still showed with 'U' state which is not correct.

Signed-off-by: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
Signed-off-by: Song Liu <songliubraving@fb.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/md.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 764ed9c466294..d185725e100c0 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -8906,7 +8906,8 @@ void md_reap_sync_thread(struct mddev *mddev)
 	/* resync has finished, collect result */
 	md_unregister_thread(&mddev->sync_thread);
 	if (!test_bit(MD_RECOVERY_INTR, &mddev->recovery) &&
-	    !test_bit(MD_RECOVERY_REQUESTED, &mddev->recovery)) {
+	    !test_bit(MD_RECOVERY_REQUESTED, &mddev->recovery) &&
+	    mddev->degraded != mddev->raid_disks) {
 		/* success...*/
 		/* activate any spares */
 		if (mddev->pers->spare_active(mddev)) {
-- 
2.20.1

