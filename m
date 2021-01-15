Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2626A2F7C0D
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 14:09:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730195AbhAONIf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 08:08:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:36414 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732001AbhAOMao (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 Jan 2021 07:30:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 655EA23359;
        Fri, 15 Jan 2021 12:29:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610713779;
        bh=XKgiajTu+HVz3vlQtjB2OADN1vzKXJqxGgK3oPODjTE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oB2nQUmvWQ+kMKtB0kF3llZJncAFjuLUjsexlwlXUPkuCk6DMtef+KfgsvW8I3DJM
         ntXIbbGVZ1mU1wSzyyd2zKuGempD04mZzA4dDc5I8utSW6wvJ9R1M6VXT/yXmjBzcQ
         jx4zdiw14s0SrwUAw0doTF+CZt49Nx9K+iTCe5fs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Disseldorp <ddiss@suse.de>,
        Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bart.vanassche@sandisk.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 02/18] target: bounds check XCOPY segment descriptor list
Date:   Fri, 15 Jan 2021 13:27:30 +0100
Message-Id: <20210115121955.231591863@linuxfoundation.org>
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

[ Upstream commit af9f62c1686268c0517b289274d38f3a03bebd2a ]

Check the length of the XCOPY request segment descriptor list against
the value advertised via the MAXIMUM SEGMENT DESCRIPTOR COUNT field in
the RECEIVE COPY OPERATING PARAMETERS response.

spc4r37 6.4.3.5 states:
  If the number of segment descriptors exceeds the allowed number, the
  copy manager shall terminate the command with CHECK CONDITION status,
  with the sense key set to ILLEGAL REQUEST, and the additional sense
  code set to TOO MANY SEGMENT DESCRIPTORS.

This functionality is testable using the libiscsi
ExtendedCopy.DescrLimits test.

Signed-off-by: David Disseldorp <ddiss@suse.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/target/target_core_xcopy.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/target/target_core_xcopy.c b/drivers/target/target_core_xcopy.c
index 6415e9b09a529..cd71957c7075f 100644
--- a/drivers/target/target_core_xcopy.c
+++ b/drivers/target/target_core_xcopy.c
@@ -305,17 +305,26 @@ static int target_xcopy_parse_segdesc_02(struct se_cmd *se_cmd, struct xcopy_op
 
 static int target_xcopy_parse_segment_descriptors(struct se_cmd *se_cmd,
 				struct xcopy_op *xop, unsigned char *p,
-				unsigned int sdll)
+				unsigned int sdll, sense_reason_t *sense_ret)
 {
 	unsigned char *desc = p;
 	unsigned int start = 0;
 	int offset = sdll % XCOPY_SEGMENT_DESC_LEN, rc, ret = 0;
 
+	*sense_ret = TCM_INVALID_PARAMETER_LIST;
+
 	if (offset != 0) {
 		pr_err("XCOPY segment descriptor list length is not"
 			" multiple of %d\n", XCOPY_SEGMENT_DESC_LEN);
 		return -EINVAL;
 	}
+	if (sdll > RCR_OP_MAX_SG_DESC_COUNT * XCOPY_SEGMENT_DESC_LEN) {
+		pr_err("XCOPY supports %u segment descriptor(s), sdll: %u too"
+			" large..\n", RCR_OP_MAX_SG_DESC_COUNT, sdll);
+		/* spc4r37 6.4.3.5 SEGMENT DESCRIPTOR LIST LENGTH field */
+		*sense_ret = TCM_TOO_MANY_SEGMENT_DESCS;
+		return -EINVAL;
+	}
 
 	while (start < sdll) {
 		/*
@@ -913,7 +922,8 @@ sense_reason_t target_do_xcopy(struct se_cmd *se_cmd)
 	seg_desc = &p[16];
 	seg_desc += (rc * XCOPY_TARGET_DESC_LEN);
 
-	rc = target_xcopy_parse_segment_descriptors(se_cmd, xop, seg_desc, sdll);
+	rc = target_xcopy_parse_segment_descriptors(se_cmd, xop, seg_desc,
+						    sdll, &ret);
 	if (rc <= 0) {
 		xcopy_pt_undepend_remotedev(xop);
 		goto out;
-- 
2.27.0



