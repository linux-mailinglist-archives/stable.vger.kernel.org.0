Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE8DC63DE2E
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 19:34:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230308AbiK3Ses (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 13:34:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230387AbiK3SeY (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 13:34:24 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D60D25C62
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 10:34:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D73ACB81CA4
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 18:34:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E4DCC433D6;
        Wed, 30 Nov 2022 18:34:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669833260;
        bh=++s6e1n63Rx6jR6J2PIMdaNCVffbqMTFrD0e4OpuXMs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b/ydfl9gxFagJuX7Hd3t9tvC3r5fZXGIlVtZ175aZKLjV4uoFPsvq4Gh/oNY9XhQ4
         bG1A0NQqb+LJkVCwjJiPd5J2ivEeLp7OoYsCTsRIDrQZ3eyfViNCGmtgV9jR2OZXlv
         w5MG00TQa2Xjy0pzxT3xddyAsx1rJ20tJpOAuWnY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        "David E. Box" <david.e.box@linux.intel.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 043/206] platform/x86/intel/pmt: Sapphire Rapids PMT errata fix
Date:   Wed, 30 Nov 2022 19:21:35 +0100
Message-Id: <20221130180534.092663306@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180532.974348590@linuxfoundation.org>
References: <20221130180532.974348590@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David E. Box <david.e.box@linux.intel.com>

[ Upstream commit bcdfa1f77ea7f67368d20384932a9d1e3047ddd2 ]

On Sapphire Rapids, due to a hardware issue affecting the PUNIT telemetry
region, reads that are not done in QWORD quantities and alignment may
return incorrect data. Use a custom 64-bit copy for this region.

Signed-off-by: David E. Box <david.e.box@linux.intel.com>
Link: https://lore.kernel.org/r/20221105034228.1376677-1-david.e.box@linux.intel.com
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/intel/pmt/class.c | 31 +++++++++++++++++++++++++-
 1 file changed, 30 insertions(+), 1 deletion(-)

diff --git a/drivers/platform/x86/intel/pmt/class.c b/drivers/platform/x86/intel/pmt/class.c
index 659b1073033c..586a5877422b 100644
--- a/drivers/platform/x86/intel/pmt/class.c
+++ b/drivers/platform/x86/intel/pmt/class.c
@@ -9,6 +9,7 @@
  */
 
 #include <linux/kernel.h>
+#include <linux/io-64-nonatomic-lo-hi.h>
 #include <linux/module.h>
 #include <linux/mm.h>
 #include <linux/pci.h>
@@ -18,6 +19,7 @@
 #define PMT_XA_START		0
 #define PMT_XA_MAX		INT_MAX
 #define PMT_XA_LIMIT		XA_LIMIT(PMT_XA_START, PMT_XA_MAX)
+#define GUID_SPR_PUNIT		0x9956f43f
 
 /*
  * Early implementations of PMT on client platforms have some
@@ -41,6 +43,29 @@ bool intel_pmt_is_early_client_hw(struct device *dev)
 }
 EXPORT_SYMBOL_GPL(intel_pmt_is_early_client_hw);
 
+static inline int
+pmt_memcpy64_fromio(void *to, const u64 __iomem *from, size_t count)
+{
+	int i, remain;
+	u64 *buf = to;
+
+	if (!IS_ALIGNED((unsigned long)from, 8))
+		return -EFAULT;
+
+	for (i = 0; i < count/8; i++)
+		buf[i] = readq(&from[i]);
+
+	/* Copy any remaining bytes */
+	remain = count % 8;
+	if (remain) {
+		u64 tmp = readq(&from[i]);
+
+		memcpy(&buf[i], &tmp, remain);
+	}
+
+	return count;
+}
+
 /*
  * sysfs
  */
@@ -62,7 +87,11 @@ intel_pmt_read(struct file *filp, struct kobject *kobj,
 	if (count > entry->size - off)
 		count = entry->size - off;
 
-	memcpy_fromio(buf, entry->base + off, count);
+	if (entry->guid == GUID_SPR_PUNIT)
+		/* PUNIT on SPR only supports aligned 64-bit read */
+		count = pmt_memcpy64_fromio(buf, entry->base + off, count);
+	else
+		memcpy_fromio(buf, entry->base + off, count);
 
 	return count;
 }
-- 
2.35.1



