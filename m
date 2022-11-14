Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B4D5627FFF
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 14:02:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237644AbiKNNC5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 08:02:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237717AbiKNNC4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 08:02:56 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 179C62982C
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 05:02:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CDA2EB80EA5
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 13:02:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 352BFC433D6;
        Mon, 14 Nov 2022 13:02:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1668430973;
        bh=Ssg8k+NMIufQLSoccvghYXXee5E2Xctt2SA572kWGF8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kJHZyEUOnhsLxVUaOILAyoJDSYNbynp5L8n/AqGwUodmGcU7FlvYc3LjxpROLP3TX
         8l16BjyzNjnXie05sJDdID8HLsx1cEXpRzQI20g8pFgjRCrv2J4iBbw05HsKGPQaOP
         Ok/is/kg+ffogiTmVMbIW+kin1bj0tppMd67IRtM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>,
        Jarkko Nikula <jarkko.nikula@linux.intel.com>
Subject: [PATCH 6.0 054/190] platform/x86: p2sb: Dont fail if unknown CPU is found
Date:   Mon, 14 Nov 2022 13:44:38 +0100
Message-Id: <20221114124501.133828583@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114124458.806324402@linuxfoundation.org>
References: <20221114124458.806324402@linuxfoundation.org>
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

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 53eb64c88f17b14b324fbdfd417f56c5d3fa6fee ]

We have accessing P2SB from a very few places for quite known hardware.

When a new SoC appears in intel-family.h it's not obvious that it needs
to be added to p2sb.c as well. Instead, provide default BDF and refactor
p2sb_get_devfn() to always succeed. If in the future we would need to
exclude something, we may add a list of unsupported IDs.

Without this change the iTCO on Intel Comet Lake SoCs became unavailable:

  i801_smbus 0000:00:1f.4: failed to create iTCO device

Fixes: 5c7b9167ddf8 ("i2c: i801: convert to use common P2SB accessor")
Reported-and-tested-by: Jarkko Nikula <jarkko.nikula@linux.intel.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20221104154916.35231-1-andriy.shevchenko@linux.intel.com
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/p2sb.c | 15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/drivers/platform/x86/p2sb.c b/drivers/platform/x86/p2sb.c
index 384d0962ae93..1cf2471d54dd 100644
--- a/drivers/platform/x86/p2sb.c
+++ b/drivers/platform/x86/p2sb.c
@@ -19,26 +19,23 @@
 #define P2SBC			0xe0
 #define P2SBC_HIDE		BIT(8)
 
+#define P2SB_DEVFN_DEFAULT	PCI_DEVFN(31, 1)
+
 static const struct x86_cpu_id p2sb_cpu_ids[] = {
 	X86_MATCH_INTEL_FAM6_MODEL(ATOM_GOLDMONT,	PCI_DEVFN(13, 0)),
-	X86_MATCH_INTEL_FAM6_MODEL(ATOM_GOLDMONT_D,	PCI_DEVFN(31, 1)),
-	X86_MATCH_INTEL_FAM6_MODEL(ATOM_SILVERMONT_D,	PCI_DEVFN(31, 1)),
-	X86_MATCH_INTEL_FAM6_MODEL(KABYLAKE,		PCI_DEVFN(31, 1)),
-	X86_MATCH_INTEL_FAM6_MODEL(KABYLAKE_L,		PCI_DEVFN(31, 1)),
-	X86_MATCH_INTEL_FAM6_MODEL(SKYLAKE,		PCI_DEVFN(31, 1)),
-	X86_MATCH_INTEL_FAM6_MODEL(SKYLAKE_L,		PCI_DEVFN(31, 1)),
 	{}
 };
 
 static int p2sb_get_devfn(unsigned int *devfn)
 {
+	unsigned int fn = P2SB_DEVFN_DEFAULT;
 	const struct x86_cpu_id *id;
 
 	id = x86_match_cpu(p2sb_cpu_ids);
-	if (!id)
-		return -ENODEV;
+	if (id)
+		fn = (unsigned int)id->driver_data;
 
-	*devfn = (unsigned int)id->driver_data;
+	*devfn = fn;
 	return 0;
 }
 
-- 
2.35.1



