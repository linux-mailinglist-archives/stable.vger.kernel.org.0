Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44EC66B45E4
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:38:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232708AbjCJOi1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:38:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232720AbjCJOiQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:38:16 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01E246581
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:37:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7E144B822C4
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:37:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2D94C433A0;
        Fri, 10 Mar 2023 14:37:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678459073;
        bh=DnzvdBgtUq78er1gpvlD+rEpjrckOBMfuDXf8hRiTl0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YUQGIguCLmtbKDBYrXOK/OpSnySz15xGxExIzN8AqXpaGutZwCPH27iquLbGmEDUm
         76kORSofAdTdu9nKupqxq2+aXbbFv9cFASebNALWhVR4zOuMRckCryar7YFkFzMuRB
         zwHgIMU/Vx24Sbzc3GkcPWJhy38uEWnaYQRlkc2s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, "Borislav Petkov (AMD)" <bp@alien8.de>
Subject: [PATCH 5.4 239/357] x86/microcode/amd: Remove load_microcode_amd()s bsp parameter
Date:   Fri, 10 Mar 2023 14:38:48 +0100
Message-Id: <20230310133745.293561131@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133733.973883071@linuxfoundation.org>
References: <20230310133733.973883071@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Borislav Petkov (AMD) <bp@alien8.de>

commit 2355370cd941cbb20882cc3f34460f9f2b8f9a18 upstream.

It is always the BSP.

No functional changes.

Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Link: https://lore.kernel.org/r/20230130161709.11615-2-bp@alien8.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/microcode/amd.c |   17 +++++------------
 1 file changed, 5 insertions(+), 12 deletions(-)

--- a/arch/x86/kernel/cpu/microcode/amd.c
+++ b/arch/x86/kernel/cpu/microcode/amd.c
@@ -548,8 +548,7 @@ void load_ucode_amd_ap(unsigned int cpui
 	apply_microcode_early_amd(cpuid_1_eax, cp.data, cp.size, false);
 }
 
-static enum ucode_state
-load_microcode_amd(bool save, u8 family, const u8 *data, size_t size);
+static enum ucode_state load_microcode_amd(u8 family, const u8 *data, size_t size);
 
 int __init save_microcode_in_initrd_amd(unsigned int cpuid_1_eax)
 {
@@ -567,7 +566,7 @@ int __init save_microcode_in_initrd_amd(
 	if (!desc.mc)
 		return -EINVAL;
 
-	ret = load_microcode_amd(true, x86_family(cpuid_1_eax), desc.data, desc.size);
+	ret = load_microcode_amd(x86_family(cpuid_1_eax), desc.data, desc.size);
 	if (ret > UCODE_UPDATED)
 		return -EINVAL;
 
@@ -845,8 +844,7 @@ static enum ucode_state __load_microcode
 	return UCODE_OK;
 }
 
-static enum ucode_state
-load_microcode_amd(bool save, u8 family, const u8 *data, size_t size)
+static enum ucode_state load_microcode_amd(u8 family, const u8 *data, size_t size)
 {
 	struct ucode_patch *p;
 	enum ucode_state ret;
@@ -870,10 +868,6 @@ load_microcode_amd(bool save, u8 family,
 		ret = UCODE_NEW;
 	}
 
-	/* save BSP's matching patch for early load */
-	if (!save)
-		return ret;
-
 	memset(amd_ucode_patch, 0, PATCH_MAX_SIZE);
 	memcpy(amd_ucode_patch, p->data, min_t(u32, p->size, PATCH_MAX_SIZE));
 
@@ -901,12 +895,11 @@ static enum ucode_state request_microcod
 {
 	char fw_name[36] = "amd-ucode/microcode_amd.bin";
 	struct cpuinfo_x86 *c = &cpu_data(cpu);
-	bool bsp = c->cpu_index == boot_cpu_data.cpu_index;
 	enum ucode_state ret = UCODE_NFOUND;
 	const struct firmware *fw;
 
 	/* reload ucode container only on the boot cpu */
-	if (!refresh_fw || !bsp)
+	if (!refresh_fw)
 		return UCODE_OK;
 
 	if (c->x86 >= 0x15)
@@ -921,7 +914,7 @@ static enum ucode_state request_microcod
 	if (!verify_container(fw->data, fw->size, false))
 		goto fw_release;
 
-	ret = load_microcode_amd(bsp, c->x86, fw->data, fw->size);
+	ret = load_microcode_amd(c->x86, fw->data, fw->size);
 
  fw_release:
 	release_firmware(fw);


