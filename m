Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4969734CA9B
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:41:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234352AbhC2IjM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:39:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:53654 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234920AbhC2Ihg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:37:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BDEBB61864;
        Mon, 29 Mar 2021 08:37:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617007055;
        bh=hBmRt23ZzivxlArg4Rxed9t1LB6z0cZmFysrOK5yjic=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=djav7f7PW3AECpiBycOH8u9HPMbz1dg0NM9QEFN2Ov2EAEe7rWpx0Qx17tTjrnKQm
         doLYKhXdQHoBEfx63sBls6crOp/n9vBGrCiaoFlq0McbXhO8jlwN80Ps60NHSUL7Xx
         Ll39XInODAgj3ItZrW3Hcdz7/Voz+Y2nuCTL5xZw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "David E. Box" <david.e.box@linux.intel.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 205/254] platform/x86: intel_pmt_crashlog: Fix incorrect macros
Date:   Mon, 29 Mar 2021 09:58:41 +0200
Message-Id: <20210329075639.832318189@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075633.135869143@linuxfoundation.org>
References: <20210329075633.135869143@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David E. Box <david.e.box@linux.intel.com>

[ Upstream commit 10c931cdfe64ebc38a15a485dd794915044f2111 ]

Fixes off-by-one bugs in the macro assignments for the crashlog control
bits. Was initially tested on emulation but bug revealed after testing on
silicon.

Fixes: 5ef9998c96b0 ("platform/x86: Intel PMT Crashlog capability driver")
Signed-off-by: David E. Box <david.e.box@linux.intel.com>
Link: https://lore.kernel.org/r/20210317024455.3071477-2-david.e.box@linux.intel.com
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/intel_pmt_crashlog.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/platform/x86/intel_pmt_crashlog.c b/drivers/platform/x86/intel_pmt_crashlog.c
index 97dd749c8290..92d315a16cfd 100644
--- a/drivers/platform/x86/intel_pmt_crashlog.c
+++ b/drivers/platform/x86/intel_pmt_crashlog.c
@@ -23,18 +23,17 @@
 #define CRASH_TYPE_OOBMSM	1
 
 /* Control Flags */
-#define CRASHLOG_FLAG_DISABLE		BIT(27)
+#define CRASHLOG_FLAG_DISABLE		BIT(28)
 
 /*
- * Bits 28 and 29 control the state of bit 31.
+ * Bits 29 and 30 control the state of bit 31.
  *
- * Bit 28 will clear bit 31, if set, allowing a new crashlog to be captured.
- * Bit 29 will immediately trigger a crashlog to be generated, setting bit 31.
- * Bit 30 is read-only and reserved as 0.
+ * Bit 29 will clear bit 31, if set, allowing a new crashlog to be captured.
+ * Bit 30 will immediately trigger a crashlog to be generated, setting bit 31.
  * Bit 31 is the read-only status with a 1 indicating log is complete.
  */
-#define CRASHLOG_FLAG_TRIGGER_CLEAR	BIT(28)
-#define CRASHLOG_FLAG_TRIGGER_EXECUTE	BIT(29)
+#define CRASHLOG_FLAG_TRIGGER_CLEAR	BIT(29)
+#define CRASHLOG_FLAG_TRIGGER_EXECUTE	BIT(30)
 #define CRASHLOG_FLAG_TRIGGER_COMPLETE	BIT(31)
 #define CRASHLOG_FLAG_TRIGGER_MASK	GENMASK(31, 28)
 
-- 
2.30.1



