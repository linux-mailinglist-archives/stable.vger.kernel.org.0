Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D16B2506A5
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 19:39:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726502AbgHXRjB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 13:39:01 -0400
Received: from mga03.intel.com ([134.134.136.65]:14058 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726429AbgHXRjB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Aug 2020 13:39:01 -0400
IronPort-SDR: 3/nVyT8NyH6u5Q7J3dDI6/ErPgEcraR1+uCPBCc1Wsq/D0Iv6C1aD2geeOnaDCpsqcpwl/PKI9
 EdC3BDnXaetA==
X-IronPort-AV: E=McAfee;i="6000,8403,9723"; a="155947636"
X-IronPort-AV: E=Sophos;i="5.76,349,1592895600"; 
   d="scan'208";a="155947636"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Aug 2020 10:38:59 -0700
IronPort-SDR: ASDlAofjocUSMIYGzbaj5gDU0bc97VjF7h1cCJ02ujr9++LCPFwdmKrHjDjjDB2p2yVa/HwjGf
 2SJmBgnaNfdQ==
X-IronPort-AV: E=Sophos;i="5.76,349,1592895600"; 
   d="scan'208";a="443305024"
Received: from agluck-desk2.sc.intel.com ([10.3.52.68])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Aug 2020 10:38:59 -0700
From:   Tony Luck <tony.luck@intel.com>
To:     stable@vger.kernel.org
Cc:     Tony Luck <tony.luck@intel.com>,
        Gabriele Paoloni <gabriele.paoloni@intel.com>,
        Borislav Petkov <bp@suse.de>
Subject: [PATCH backport to v5.4] EDAC/{i7core,sb,pnd2,skx}: Fix error event severity
Date:   Mon, 24 Aug 2020 10:38:58 -0700
Message-Id: <20200824173858.815-1-tony.luck@intel.com>
X-Mailer: git-send-email 2.21.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 45bc6098a3e279d8e391d22428396687562797e2 upstream

IA32_MCG_STATUS.RIPV indicates whether the return RIP value pushed onto
the stack as part of machine check delivery is valid or not.

Various drivers copied a code fragment that uses the RIPV bit to
determine the severity of the error as either HW_EVENT_ERR_UNCORRECTED
or HW_EVENT_ERR_FATAL, but this check is reversed (marking errors where
RIPV is set as "FATAL").

Reverse the tests so that the error is marked fatal when RIPV is not set.

Reported-by: Gabriele Paoloni <gabriele.paoloni@intel.com>
Signed-off-by: Tony Luck <tony.luck@intel.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
---
 drivers/edac/i7core_edac.c | 4 ++--
 drivers/edac/pnd2_edac.c   | 2 +-
 drivers/edac/sb_edac.c     | 6 +++---
 drivers/edac/skx_common.c  | 6 +++---
 4 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/edac/i7core_edac.c b/drivers/edac/i7core_edac.c
index a71cca6eeb33..6be7e65f7389 100644
--- a/drivers/edac/i7core_edac.c
+++ b/drivers/edac/i7core_edac.c
@@ -1711,9 +1711,9 @@ static void i7core_mce_output_error(struct mem_ctl_info *mci,
 	if (uncorrected_error) {
 		core_err_cnt = 1;
 		if (ripv)
-			tp_event = HW_EVENT_ERR_FATAL;
-		else
 			tp_event = HW_EVENT_ERR_UNCORRECTED;
+		else
+			tp_event = HW_EVENT_ERR_FATAL;
 	} else {
 		tp_event = HW_EVENT_ERR_CORRECTED;
 	}
diff --git a/drivers/edac/pnd2_edac.c b/drivers/edac/pnd2_edac.c
index b1193be1ef1d..dac45e2071b3 100644
--- a/drivers/edac/pnd2_edac.c
+++ b/drivers/edac/pnd2_edac.c
@@ -1155,7 +1155,7 @@ static void pnd2_mce_output_error(struct mem_ctl_info *mci, const struct mce *m,
 	u32 optypenum = GET_BITFIELD(m->status, 4, 6);
 	int rc;
 
-	tp_event = uc_err ? (ripv ? HW_EVENT_ERR_FATAL : HW_EVENT_ERR_UNCORRECTED) :
+	tp_event = uc_err ? (ripv ? HW_EVENT_ERR_UNCORRECTED : HW_EVENT_ERR_FATAL) :
 						 HW_EVENT_ERR_CORRECTED;
 
 	/*
diff --git a/drivers/edac/sb_edac.c b/drivers/edac/sb_edac.c
index f743502ca9b7..d2f02e539b68 100644
--- a/drivers/edac/sb_edac.c
+++ b/drivers/edac/sb_edac.c
@@ -2981,11 +2981,11 @@ static void sbridge_mce_output_error(struct mem_ctl_info *mci,
 	if (uncorrected_error) {
 		core_err_cnt = 1;
 		if (ripv) {
-			type = "FATAL";
-			tp_event = HW_EVENT_ERR_FATAL;
-		} else {
 			type = "NON_FATAL";
 			tp_event = HW_EVENT_ERR_UNCORRECTED;
+		} else {
+			type = "FATAL";
+			tp_event = HW_EVENT_ERR_FATAL;
 		}
 	} else {
 		type = "CORRECTED";
diff --git a/drivers/edac/skx_common.c b/drivers/edac/skx_common.c
index 2177ad765bd1..1b5253e88303 100644
--- a/drivers/edac/skx_common.c
+++ b/drivers/edac/skx_common.c
@@ -490,11 +490,11 @@ static void skx_mce_output_error(struct mem_ctl_info *mci,
 	if (uncorrected_error) {
 		core_err_cnt = 1;
 		if (ripv) {
-			type = "FATAL";
-			tp_event = HW_EVENT_ERR_FATAL;
-		} else {
 			type = "NON_FATAL";
 			tp_event = HW_EVENT_ERR_UNCORRECTED;
+		} else {
+			type = "FATAL";
+			tp_event = HW_EVENT_ERR_FATAL;
 		}
 	} else {
 		type = "CORRECTED";
-- 
2.21.1

