Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3018FF4A2A
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 13:08:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390569AbfKHMHS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 07:07:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:54074 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389080AbfKHLlA (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 06:41:00 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A25DE21D7E;
        Fri,  8 Nov 2019 11:40:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573213258;
        bh=e6NTprb3jfTz+2nF7tlFhfvKaDMh0ejXCMzptpLJ9aA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ze7CrEFRHCpqVE+fRp9TpcOVzjPXAXVFd0540Yzx4sP3LZ5Hf5HS6xkTpY6exSzn3
         /rVwvj3K+Z6w7lvdkHUDf3iX6EEC+ELA/wjLhJFtzSpcYwte7G5ICNLi3Nohnh4k16
         n4VN2CP7vDTu+sUVjId0hq7xtXnKcXIBFckVcglM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Qiuxu Zhuo <qiuxu.zhuo@intel.com>,
        Aristeu Rozanski <aris@redhat.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-edac <linux-edac@vger.kernel.org>,
        Tony Luck <tony.luck@intel.com>, Borislav Petkov <bp@suse.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 123/205] EDAC, sb_edac: Return early on ADDRV bit and address type test
Date:   Fri,  8 Nov 2019 06:36:30 -0500
Message-Id: <20191108113752.12502-123-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191108113752.12502-1-sashal@kernel.org>
References: <20191108113752.12502-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qiuxu Zhuo <qiuxu.zhuo@intel.com>

[ Upstream commit dcc960b225ceb2bd66c45e0845d03e577f7010f9 ]

Users of the mce_register_decode_chain() are called for every logged
error. EDAC drivers should check:

1) Is this a memory error? [bit 7 in status register]
2) Is there a valid address? [bit 58 in status register]
3) Is the address a system address? [bitfield 8:6 in misc register]

The sb_edac driver performed test "1" twice. Waited far too long to
perform check "2". Didn't do check "3" at all.

Fix it by moving the test for valid address from
sbridge_mce_output_error() into sbridge_mce_check_error() and add a test
for the type immediately after. Delete the redundant check for the type
of the error from sbridge_mce_output_error().

Signed-off-by: Qiuxu Zhuo <qiuxu.zhuo@intel.com>
Cc: Aristeu Rozanski <aris@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Qiuxu Zhuo <qiuxu.zhuo@intel.com>
Cc: linux-edac <linux-edac@vger.kernel.org>
Link: http://lkml.kernel.org/r/20180907230828.13901-2-tony.luck@intel.com
[ Re-word commit message. ]
Signed-off-by: Tony Luck <tony.luck@intel.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/edac/sb_edac.c | 68 ++++++++++++++++++++++--------------------
 1 file changed, 35 insertions(+), 33 deletions(-)

diff --git a/drivers/edac/sb_edac.c b/drivers/edac/sb_edac.c
index 72cea3cb86224..7447f1453200d 100644
--- a/drivers/edac/sb_edac.c
+++ b/drivers/edac/sb_edac.c
@@ -2912,35 +2912,27 @@ static void sbridge_mce_output_error(struct mem_ctl_info *mci,
 	 *	cccc = channel
 	 * If the mask doesn't match, report an error to the parsing logic
 	 */
-	if (! ((errcode & 0xef80) == 0x80)) {
-		optype = "Can't parse: it is not a mem";
-	} else {
-		switch (optypenum) {
-		case 0:
-			optype = "generic undef request error";
-			break;
-		case 1:
-			optype = "memory read error";
-			break;
-		case 2:
-			optype = "memory write error";
-			break;
-		case 3:
-			optype = "addr/cmd error";
-			break;
-		case 4:
-			optype = "memory scrubbing error";
-			break;
-		default:
-			optype = "reserved";
-			break;
-		}
+	switch (optypenum) {
+	case 0:
+		optype = "generic undef request error";
+		break;
+	case 1:
+		optype = "memory read error";
+		break;
+	case 2:
+		optype = "memory write error";
+		break;
+	case 3:
+		optype = "addr/cmd error";
+		break;
+	case 4:
+		optype = "memory scrubbing error";
+		break;
+	default:
+		optype = "reserved";
+		break;
 	}
 
-	/* Only decode errors with an valid address (ADDRV) */
-	if (!GET_BITFIELD(m->status, 58, 58))
-		return;
-
 	if (pvt->info.type == KNIGHTS_LANDING) {
 		if (channel == 14) {
 			edac_dbg(0, "%s%s err_code:%04x:%04x EDRAM bank %d\n",
@@ -3046,17 +3038,11 @@ static int sbridge_mce_check_error(struct notifier_block *nb, unsigned long val,
 {
 	struct mce *mce = (struct mce *)data;
 	struct mem_ctl_info *mci;
-	struct sbridge_pvt *pvt;
 	char *type;
 
 	if (edac_get_report_status() == EDAC_REPORTING_DISABLED)
 		return NOTIFY_DONE;
 
-	mci = get_mci_for_node_id(mce->socketid, IMC0);
-	if (!mci)
-		return NOTIFY_DONE;
-	pvt = mci->pvt_info;
-
 	/*
 	 * Just let mcelog handle it if the error is
 	 * outside the memory controller. A memory error
@@ -3066,6 +3052,22 @@ static int sbridge_mce_check_error(struct notifier_block *nb, unsigned long val,
 	if ((mce->status & 0xefff) >> 7 != 1)
 		return NOTIFY_DONE;
 
+	/* Check ADDRV bit in STATUS */
+	if (!GET_BITFIELD(mce->status, 58, 58))
+		return NOTIFY_DONE;
+
+	/* Check MISCV bit in STATUS */
+	if (!GET_BITFIELD(mce->status, 59, 59))
+		return NOTIFY_DONE;
+
+	/* Check address type in MISC (physical address only) */
+	if (GET_BITFIELD(mce->misc, 6, 8) != 2)
+		return NOTIFY_DONE;
+
+	mci = get_mci_for_node_id(mce->socketid, IMC0);
+	if (!mci)
+		return NOTIFY_DONE;
+
 	if (mce->mcgstatus & MCG_STATUS_MCIP)
 		type = "Exception";
 	else
-- 
2.20.1

