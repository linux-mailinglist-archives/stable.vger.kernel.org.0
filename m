Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CD5C63DF3B
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 19:45:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231284AbiK3SpL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 13:45:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231279AbiK3Sor (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 13:44:47 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7A072B279
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 10:44:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 961F1B81C9F
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 18:44:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3E45C433C1;
        Wed, 30 Nov 2022 18:44:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669833884;
        bh=4F6l+GTfifoW8ZfiZu68QNiySBmgTAO7o1adpcIkHug=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fUKFCB8haZb/rxk9ge3kZlaRjzhimChcx0ro99TpmVG0spc8UG2CZ64MKCtbk6sPh
         8PrRiijER1dlPH9Y9BlhXBMnBSH31GHuRr73dusjRPukcW6WNqZTBeWiy5SX+5Zj64
         1GHe/be+brp1tgKWk1npahn/Qncbd30tvniIFMUg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        "David E. Box" <david.e.box@linux.intel.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 022/289] platform/x86/intel/pmt: Sapphire Rapids PMT errata fix
Date:   Wed, 30 Nov 2022 19:20:07 +0100
Message-Id: <20221130180544.636178894@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180544.105550592@linuxfoundation.org>
References: <20221130180544.105550592@linuxfoundation.org>
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
index 53d7fd2943b4..46598dcb634a 100644
--- a/drivers/platform/x86/intel/pmt/class.c
+++ b/drivers/platform/x86/intel/pmt/class.c
@@ -9,6 +9,7 @@
  */
 
 #include <linux/kernel.h>
+#include <linux/io-64-nonatomic-lo-hi.h>
 #include <linux/module.h>
 #include <linux/mm.h>
 #include <linux/pci.h>
@@ -19,6 +20,7 @@
 #define PMT_XA_START		0
 #define PMT_XA_MAX		INT_MAX
 #define PMT_XA_LIMIT		XA_LIMIT(PMT_XA_START, PMT_XA_MAX)
+#define GUID_SPR_PUNIT		0x9956f43f
 
 bool intel_pmt_is_early_client_hw(struct device *dev)
 {
@@ -33,6 +35,29 @@ bool intel_pmt_is_early_client_hw(struct device *dev)
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
@@ -54,7 +79,11 @@ intel_pmt_read(struct file *filp, struct kobject *kobj,
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



