Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF59C5490BE
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:26:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380554AbiFMOBZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 10:01:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380551AbiFMN7F (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 09:59:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 499A98CB2E;
        Mon, 13 Jun 2022 04:37:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7C4DFB80E2C;
        Mon, 13 Jun 2022 11:37:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA73DC3411C;
        Mon, 13 Jun 2022 11:37:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655120265;
        bh=FnCeao+/GWV3XE4N4cPu+iNp9VP0bsdVQ0g152ZehB8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QLK6tsiAg3+A3EWoGSEmDILytSiWTC8shJVJAxeS/38CBX/DGlH+oZydRzy5DCB72
         f4aTaB14ht0WtXenmG0iziLljC8P8f49Gnk9TL4EM7t4zut9q56ZO6vBIFXE3f/TJN
         gpU2W2T8wJxo/9vooPtig+/10S8DgWegkaG5xQGY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jorge Lopez <jorge.lopez2@hp.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 291/339] platform/x86: hp-wmi: Resolve WMI query failures on some devices
Date:   Mon, 13 Jun 2022 12:11:56 +0200
Message-Id: <20220613094935.462088879@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094926.497929857@linuxfoundation.org>
References: <20220613094926.497929857@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jorge Lopez <jorge.lopez2@hp.com>

[ Upstream commit dc6a6ab58379f25bf991d8e4a13b001ed806e881 ]

WMI queries fail on some devices where the ACPI method HWMC
unconditionally attempts to create Fields beyond the buffer
if the buffer is too small, this breaks essential features
such as power profiles:

         CreateByteField (Arg1, 0x10, D008)
         CreateByteField (Arg1, 0x11, D009)
         CreateByteField (Arg1, 0x12, D010)
         CreateDWordField (Arg1, 0x10, D032)
         CreateField (Arg1, 0x80, 0x0400, D128)

In cases where args->data had zero length, ACPI BIOS Error
(bug): AE_AML_BUFFER_LIMIT, Field [D008] at bit
offset/length 128/8 exceeds size of target Buffer (128 bits)
(20211217/dsopcode-198) was obtained.

ACPI BIOS Error (bug): AE_AML_BUFFER_LIMIT, Field [D009] at bit
offset/length 136/8 exceeds size of target Buffer (136bits)
(20211217/dsopcode-198)

The original code created a buffer size of 128 bytes regardless if
the WMI call required a smaller buffer or not.  This particular
behavior occurs in older BIOS and reproduced in OMEN laptops.  Newer
BIOS handles buffer sizes properly and meets the latest specification
requirements.  This is the reason why testing with a dynamically
allocated buffer did not uncover any failures with the test systems at
hand.

This patch was tested on several OMEN, Elite, and Zbooks.  It was
confirmed the patch resolves HPWMI_FAN GET/SET calls in an OMEN
Laptop 15-ek0xxx.  No problems were reported when testing on several Elite
and Zbooks notebooks.

Fixes: 4b4967cbd268 ("platform/x86: hp-wmi: Changing bios_args.data to be dynamically allocated")
Signed-off-by: Jorge Lopez <jorge.lopez2@hp.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Link: https://lore.kernel.org/r/20220608212923.8585-2-jorge.lopez2@hp.com
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/hp-wmi.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/platform/x86/hp-wmi.c b/drivers/platform/x86/hp-wmi.c
index 0e9a25b56e0e..d3540dd62d06 100644
--- a/drivers/platform/x86/hp-wmi.c
+++ b/drivers/platform/x86/hp-wmi.c
@@ -290,14 +290,16 @@ static int hp_wmi_perform_query(int query, enum hp_wmi_command command,
 	struct bios_return *bios_return;
 	union acpi_object *obj = NULL;
 	struct bios_args *args = NULL;
-	int mid, actual_outsize, ret;
+	int mid, actual_insize, actual_outsize;
 	size_t bios_args_size;
+	int ret;
 
 	mid = encode_outsize_for_pvsz(outsize);
 	if (WARN_ON(mid < 0))
 		return mid;
 
-	bios_args_size = struct_size(args, data, insize);
+	actual_insize = max(insize, 128);
+	bios_args_size = struct_size(args, data, actual_insize);
 	args = kmalloc(bios_args_size, GFP_KERNEL);
 	if (!args)
 		return -ENOMEM;
-- 
2.35.1



