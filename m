Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7ED81CA964
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 19:20:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392552AbfJCQmC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:42:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:52724 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392547AbfJCQmB (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:42:01 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8A5162054F;
        Thu,  3 Oct 2019 16:42:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570120921;
        bh=c0HS9vBTQOn2wgK3HorCqLxirZgXOoitDmt8CKIkcZw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KUaiof9ECA8p/hAR1Ec0w7Mpuhc6QQfRZMeYNtwvSD8ZdXDBfMoCV9s2HLbOqbcBA
         fCWL7Lb9281QcnfjIw3fRCL4reS9AbycaBzDgY3PzkIgJR1hOtftIe+bIyLrpqB5zR
         OeODjSw4F4kRiCFfWMhK52z+1PnslBoaiqONpNtQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Guoqing Jiang <guoqing.jiang@cloud.ionos.com>,
        Song Liu <songliubraving@fb.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 087/344] md: dont call spare_active in md_reap_sync_thread if all member devices cant work
Date:   Thu,  3 Oct 2019 17:50:52 +0200
Message-Id: <20191003154548.746624703@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154540.062170222@linuxfoundation.org>
References: <20191003154540.062170222@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 24638ccedce42..fd62be3ca2871 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -9043,7 +9043,8 @@ void md_reap_sync_thread(struct mddev *mddev)
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



