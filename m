Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 008D0568D0A
	for <lists+stable@lfdr.de>; Wed,  6 Jul 2022 17:33:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233905AbiGFPbp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Jul 2022 11:31:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233826AbiGFPbQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Jul 2022 11:31:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E5621EC57;
        Wed,  6 Jul 2022 08:31:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2775561FE1;
        Wed,  6 Jul 2022 15:31:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9168C341CA;
        Wed,  6 Jul 2022 15:31:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657121474;
        bh=ZFp9+Yw28TQhbhmiQOVJ3uRa9TI1VoMCgjXTFboPp84=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T70dYUMJUebXF2Hf8bIDTMlOyjjijwlWjvEe3sJMyc8mdO02U/2YtAVL2b8OokTWI
         wJxfHbSu/Se7K2o8qsVznYtse5t9M0ER0zboGi6Np+4XGuOrZtWSlSxuC8ALje+pnz
         7SHd/pDm5rqrDKrE3p76BmrbEDRzoDoIbXM7Xq/dP4T/n/bB0gnFYqIS3wfwJdk5SL
         DlUw/PhbUBy47z/xdJeDvWVRcmfyxOJYSvZI4mywvfcNyeBgjVV51PX+2ggfIgIGkE
         FDt+CxfFXmz0ilsTPbu/9lVI1u0QCIIcAQu7C/Z+6QBCG/DNXeU/6eTGO269iVCb0v
         lbcZbyWGPupiQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mark Pearson <markpearson@lenovo.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>, hmh@hmh.eng.br,
        markgross@kernel.org, ibm-acpi-devel@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org
Subject: [PATCH AUTOSEL 5.18 13/22] platform/x86: thinkpad_acpi: do not use PSC mode on Intel platforms
Date:   Wed,  6 Jul 2022 11:30:31 -0400
Message-Id: <20220706153041.1597639-13-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220706153041.1597639-1-sashal@kernel.org>
References: <20220706153041.1597639-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mark Pearson <markpearson@lenovo.com>

[ Upstream commit bce6243f767f7da88aa4674d5d678f9f156eaba9 ]

PSC platform profile mode is only supported on Linux for AMD platforms.

Some older Intel platforms (e.g T490) are advertising it's capability
as Windows uses it - but on Linux we should only be using MMC profile
for Intel systems.

Add a check to prevent it being enabled incorrectly.

Signed-off-by: Mark Pearson <markpearson@lenovo.com>
Link: https://lore.kernel.org/r/20220627181449.3537-1-markpearson@lenovo.com
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/thinkpad_acpi.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/platform/x86/thinkpad_acpi.c b/drivers/platform/x86/thinkpad_acpi.c
index 5d1e0a3a5c1e..832ab77ab961 100644
--- a/drivers/platform/x86/thinkpad_acpi.c
+++ b/drivers/platform/x86/thinkpad_acpi.c
@@ -10540,6 +10540,11 @@ static int tpacpi_dytc_profile_init(struct ibm_init_struct *iibm)
 				dytc_mmc_get_available = true;
 		}
 	} else if (dytc_capabilities & BIT(DYTC_FC_PSC)) { /* PSC MODE */
+		/* Support for this only works on AMD platforms */
+		if (boot_cpu_data.x86_vendor != X86_VENDOR_AMD) {
+			dbg_printk(TPACPI_DBG_INIT, "PSC not support on Intel platforms\n");
+			return -ENODEV;
+		}
 		pr_debug("PSC is supported\n");
 	} else {
 		dbg_printk(TPACPI_DBG_INIT, "No DYTC support available\n");
-- 
2.35.1

