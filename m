Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4043D2F7BFB
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 14:09:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731111AbhAOMaq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 07:30:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:36438 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732134AbhAOMaq (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 Jan 2021 07:30:46 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9670923356;
        Fri, 15 Jan 2021 12:29:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610713782;
        bh=a3aBdZm8dV/Bub/c4/6P6HE7kFP2TaG3fxG112kOtPI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tGQM75mEhv7uN4AHaciSxSw3ny8wTVpMvErFeo4FKqSBN0cslm0nZgeLgnoNfAZfz
         N/gg688D0Uw5GT1yF/PJay4BR3Lve3QEB2H0sGH6535nZlSloz/NBiTMsOHDVSwdIB
         28AqpAKolBbrV+E+yFrxz7DP8f2qV16ivUPoQC4w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Disseldorp <ddiss@suse.de>,
        Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bart.vanassche@sandisk.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 03/18] target: simplify XCOPY wwn->se_dev lookup helper
Date:   Fri, 15 Jan 2021 13:27:31 +0100
Message-Id: <20210115121955.281900571@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210115121955.112329537@linuxfoundation.org>
References: <20210115121955.112329537@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Disseldorp <ddiss@suse.de>

[ Upstream commit 94aae4caacda89a1bdb7198b260f4ca3595b7ed7 ]

target_xcopy_locate_se_dev_e4() is used to locate an se_dev, based on
the WWN provided with the XCOPY request. Remove a couple of unneeded
arguments, and rely on the caller for the src/dst test.

Signed-off-by: David Disseldorp <ddiss@suse.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/target/target_core_xcopy.c | 28 +++++++++-------------------
 1 file changed, 9 insertions(+), 19 deletions(-)

diff --git a/drivers/target/target_core_xcopy.c b/drivers/target/target_core_xcopy.c
index cd71957c7075f..c7bd27bfe3d8c 100644
--- a/drivers/target/target_core_xcopy.c
+++ b/drivers/target/target_core_xcopy.c
@@ -52,18 +52,13 @@ static int target_xcopy_gen_naa_ieee(struct se_device *dev, unsigned char *buf)
 	return 0;
 }
 
-static int target_xcopy_locate_se_dev_e4(struct se_cmd *se_cmd, struct xcopy_op *xop,
-					bool src)
+static int target_xcopy_locate_se_dev_e4(const unsigned char *dev_wwn,
+					struct se_device **found_dev)
 {
 	struct se_device *se_dev;
-	unsigned char tmp_dev_wwn[XCOPY_NAA_IEEE_REGEX_LEN], *dev_wwn;
+	unsigned char tmp_dev_wwn[XCOPY_NAA_IEEE_REGEX_LEN];
 	int rc;
 
-	if (src)
-		dev_wwn = &xop->dst_tid_wwn[0];
-	else
-		dev_wwn = &xop->src_tid_wwn[0];
-
 	mutex_lock(&g_device_mutex);
 	list_for_each_entry(se_dev, &g_device_list, g_dev_node) {
 
@@ -77,15 +72,8 @@ static int target_xcopy_locate_se_dev_e4(struct se_cmd *se_cmd, struct xcopy_op
 		if (rc != 0)
 			continue;
 
-		if (src) {
-			xop->dst_dev = se_dev;
-			pr_debug("XCOPY 0xe4: Setting xop->dst_dev: %p from located"
-				" se_dev\n", xop->dst_dev);
-		} else {
-			xop->src_dev = se_dev;
-			pr_debug("XCOPY 0xe4: Setting xop->src_dev: %p from located"
-				" se_dev\n", xop->src_dev);
-		}
+		*found_dev = se_dev;
+		pr_debug("XCOPY 0xe4: located se_dev: %p\n", se_dev);
 
 		rc = target_depend_item(&se_dev->dev_group.cg_item);
 		if (rc != 0) {
@@ -242,9 +230,11 @@ static int target_xcopy_parse_target_descriptors(struct se_cmd *se_cmd,
 	}
 
 	if (xop->op_origin == XCOL_SOURCE_RECV_OP)
-		rc = target_xcopy_locate_se_dev_e4(se_cmd, xop, true);
+		rc = target_xcopy_locate_se_dev_e4(xop->dst_tid_wwn,
+						&xop->dst_dev);
 	else
-		rc = target_xcopy_locate_se_dev_e4(se_cmd, xop, false);
+		rc = target_xcopy_locate_se_dev_e4(xop->src_tid_wwn,
+						&xop->src_dev);
 	/*
 	 * If a matching IEEE NAA 0x83 descriptor for the requested device
 	 * is not located on this node, return COPY_ABORTED with ASQ/ASQC
-- 
2.27.0



