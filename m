Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5238024DB39
	for <lists+stable@lfdr.de>; Fri, 21 Aug 2020 18:36:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728515AbgHUQgM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Aug 2020 12:36:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:50060 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728440AbgHUQVJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Aug 2020 12:21:09 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 696DA22B47;
        Fri, 21 Aug 2020 16:20:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598026820;
        bh=HqtT5doAifp9T3ikPbQo5IxVfM1uWmbFHqq6m6yONIU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=awWx1UayTEnMJDXRZPEvKr3iP9I96qD+kyqGr1im2yr97X0A6u3606iAx/OFfXRP+
         cZq/BZxYGWsnEJMuu1XsALQMxmZyefrEKpPYwsZ/Fml6AOzkpzSLKvuU+0SQEyqqUe
         QRRVHhuHiesAECQ6saUlsZRfKJiNOR2McBYr5/Xc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bodo Stroesser <bstroesser@ts.fujitsu.com>,
        JiangYu <lnsyyj@hotmail.com>,
        Mike Christie <michael.christie@oracle.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 04/22] scsi: target: tcmu: Fix crash on ARM during cmd completion
Date:   Fri, 21 Aug 2020 12:19:56 -0400
Message-Id: <20200821162014.349506-4-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200821162014.349506-1-sashal@kernel.org>
References: <20200821162014.349506-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bodo Stroesser <bstroesser@ts.fujitsu.com>

[ Upstream commit 5a0c256d96f020e4771f6fd5524b80f89a2d3132 ]

If tcmu_handle_completions() has to process a padding shorter than
sizeof(struct tcmu_cmd_entry), the current call to
tcmu_flush_dcache_range() with sizeof(struct tcmu_cmd_entry) as length
param is wrong and causes crashes on e.g. ARM, because
tcmu_flush_dcache_range() in this case calls
flush_dcache_page(vmalloc_to_page(start)); with start being an invalid
address above the end of the vmalloc'ed area.

The fix is to use the minimum of remaining ring space and sizeof(struct
tcmu_cmd_entry) as the length param.

The patch was tested on kernel 4.19.118.

See https://bugzilla.kernel.org/show_bug.cgi?id=208045#c10

Link: https://lore.kernel.org/r/20200629093756.8947-1-bstroesser@ts.fujitsu.com
Tested-by: JiangYu <lnsyyj@hotmail.com>
Acked-by: Mike Christie <michael.christie@oracle.com>
Signed-off-by: Bodo Stroesser <bstroesser@ts.fujitsu.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/target/target_core_user.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index c43c942e1f876..bccde58bc5e30 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -590,7 +590,14 @@ static unsigned int tcmu_handle_completions(struct tcmu_dev *udev)
 		struct tcmu_cmd_entry *entry = (void *) mb + CMDR_OFF + udev->cmdr_last_cleaned;
 		struct tcmu_cmd *cmd;
 
-		tcmu_flush_dcache_range(entry, sizeof(*entry));
+		/*
+		 * Flush max. up to end of cmd ring since current entry might
+		 * be a padding that is shorter than sizeof(*entry)
+		 */
+		size_t ring_left = head_to_end(udev->cmdr_last_cleaned,
+					       udev->cmdr_size);
+		tcmu_flush_dcache_range(entry, ring_left < sizeof(*entry) ?
+					ring_left : sizeof(*entry));
 
 		if (tcmu_hdr_get_op(entry->hdr.len_op) == TCMU_OP_PAD) {
 			UPDATE_HEAD(udev->cmdr_last_cleaned,
-- 
2.25.1

