Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 65FD0104A78
	for <lists+stable@lfdr.de>; Thu, 21 Nov 2019 06:57:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725904AbfKUF5P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Nov 2019 00:57:15 -0500
Received: from mga17.intel.com ([192.55.52.151]:58123 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725842AbfKUF5P (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 21 Nov 2019 00:57:15 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 20 Nov 2019 21:57:14 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,224,1571727600"; 
   d="scan'208";a="290210623"
Received: from debian-skl.sh.intel.com ([10.239.13.15])
  by orsmga001.jf.intel.com with ESMTP; 20 Nov 2019 21:57:13 -0800
From:   Zhenyu Wang <zhenyuw@linux.intel.com>
To:     intel-gvt-dev@lists.freedesktop.org
Cc:     stable@vger.kernel.org
Subject: [PATCH] drm/i915/gvt: Fix cmd length check for MI_ATOMIC
Date:   Thu, 21 Nov 2019 13:57:45 +0800
Message-Id: <20191121055745.12723-1-zhenyuw@linux.intel.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Correct valid command length check for MI_ATOMIC, need to check inline
data available field instead of operand data length for whole command.

Fixes: 00a33be40634 ("drm/i915/gvt: Add valid length check for MI variable commands")
Cc: stable@vger.kernel.org
Signed-off-by: Zhenyu Wang <zhenyuw@linux.intel.com>
---
 drivers/gpu/drm/i915/gvt/cmd_parser.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/i915/gvt/cmd_parser.c b/drivers/gpu/drm/i915/gvt/cmd_parser.c
index 6a3ac8cde95d..21a176cd8acc 100644
--- a/drivers/gpu/drm/i915/gvt/cmd_parser.c
+++ b/drivers/gpu/drm/i915/gvt/cmd_parser.c
@@ -1599,9 +1599,9 @@ static int cmd_handler_mi_op_2f(struct parser_exec_state *s)
 	if (!(cmd_val(s, 0) & (1 << 22)))
 		return ret;
 
-	/* check if QWORD */
-	if (DWORD_FIELD(0, 20, 19) == 1)
-		valid_len += 8;
+	/* check inline data */
+	if (cmd_val(s, 0) & BIT(18))
+		valid_len = CMD_LEN(9);
 	ret = gvt_check_valid_cmd_length(cmd_length(s),
 			valid_len);
 	if (ret)
-- 
2.24.0

