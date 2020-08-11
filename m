Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00C4524173B
	for <lists+stable@lfdr.de>; Tue, 11 Aug 2020 09:34:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727888AbgHKHeX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Aug 2020 03:34:23 -0400
Received: from mga07.intel.com ([134.134.136.100]:25244 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726397AbgHKHeX (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 11 Aug 2020 03:34:23 -0400
IronPort-SDR: 1qh/JpHc2gQbXcHrO8MJ985deNm2O+ipGqKRXdlj4foBTZGUKjf3ZXYID3+VeR4mvUWIUbFt5v
 +/LknAS5/YoQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9709"; a="218018393"
X-IronPort-AV: E=Sophos;i="5.75,460,1589266800"; 
   d="scan'208";a="218018393"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2020 00:34:03 -0700
IronPort-SDR: ah5TXQcW71B0YmfkuWj6hYSelNwE/jj4U+agS9CQoT9xW9oa0WCM0t/pspjQOC0SmBCqm4MRfN
 CBkRcNvzCs+Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,460,1589266800"; 
   d="scan'208";a="324686543"
Received: from joy-optiplex-7040.sh.intel.com ([10.239.13.16])
  by orsmga008.jf.intel.com with ESMTP; 11 Aug 2020 00:34:01 -0700
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     stable@vger.kernel.org
Cc:     zhenyuw@linux.intel.com, julien@sroos.eu,
        Yan Zhao <yan.y.zhao@intel.com>
Subject: [PATCH] drm/i915/gvt: do not check len & max_len for lri
Date:   Tue, 11 Aug 2020 15:16:51 +0800
Message-Id: <20200811071651.3446-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.17.1
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

hi
This is the upstream commit dbafc67307ec06036b25b223a251af03fe07969a,
and we'd like to backport it to v5.4.
have done the code rebase for the attached patch.

lri usually of variable len and far exceeding 127 dwords.

Fixes: 00a33be40634 ("drm/i915/gvt: Add valid length check for MI variable commands")
Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
Acked-by: Zhenyu Wang <zhenyuw@linux.intel.com>
Signed-off-by: Zhenyu Wang <zhenyuw@linux.intel.com>
Link: http://patchwork.freedesktop.org/patch/msgid/20200304095121.21609-1-yan.y.zhao@intel.com
---
 drivers/gpu/drm/i915/gvt/cmd_parser.c | 12 ------------
 1 file changed, 12 deletions(-)

diff --git a/drivers/gpu/drm/i915/gvt/cmd_parser.c b/drivers/gpu/drm/i915/gvt/cmd_parser.c
index e753b1e706e2..582e28be383c 100644
--- a/drivers/gpu/drm/i915/gvt/cmd_parser.c
+++ b/drivers/gpu/drm/i915/gvt/cmd_parser.c
@@ -963,18 +963,6 @@ static int cmd_handler_lri(struct parser_exec_state *s)
 	int i, ret = 0;
 	int cmd_len = cmd_length(s);
 	struct intel_gvt *gvt = s->vgpu->gvt;
-	u32 valid_len = CMD_LEN(1);
-
-	/*
-	 * Official intel docs are somewhat sloppy , check the definition of
-	 * MI_LOAD_REGISTER_IMM.
-	 */
-	#define MAX_VALID_LEN 127
-	if ((cmd_len < valid_len) || (cmd_len > MAX_VALID_LEN)) {
-		gvt_err("len is not valid:  len=%u  valid_len=%u\n",
-			cmd_len, valid_len);
-		return -EFAULT;
-	}
 
 	for (i = 1; i < cmd_len; i += 2) {
 		if (IS_BROADWELL(gvt->dev_priv) && s->ring_id != RCS0) {
-- 
2.17.1

