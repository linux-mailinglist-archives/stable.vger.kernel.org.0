Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1F1865D387
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 13:59:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230488AbjADM6J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 07:58:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234813AbjADM6G (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 07:58:06 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 923671DDCF
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 04:58:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8EB386141C
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 12:58:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92E3CC433D2;
        Wed,  4 Jan 2023 12:58:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672837082;
        bh=iEqVLUkRLNktMoh8Deh09Lj8eUIReQ3ynXMsQoC/nUA=;
        h=Subject:To:Cc:From:Date:From;
        b=uWydCdM/jEdJ0jWp5ugp2Y+7OUp9oOf5woHkp/ellUYu3OEqB+aWMp90eQ83q0YZd
         P5PbGWYjOSI50VBnzSgkafsEw3FjPlknduGk9LT2jv1ckfcCOjGqfvu1Lo63KC5/gu
         3/0Lh83iDe4JZvb6fM23M3WvVTZcFXt7OvnPx/1Q=
Subject: FAILED: patch "[PATCH] platform/x86/amd: pmc: Add a workaround for an s0i3 issue on" failed to apply to 6.1-stable tree
To:     mario.limonciello@amd.com, Rajib.Mahapatra@amd.com,
        hdegoede@redhat.com, rrangel@chromium.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 04 Jan 2023 13:57:58 +0100
Message-ID: <1672837078133245@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 6.1-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

260ad3de7183 ("platform/x86/amd: pmc: Add a workaround for an s0i3 issue on Cezanne")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 260ad3de718301ed8c22e28558e3a31c99f54cf6 Mon Sep 17 00:00:00 2001
From: Mario Limonciello <mario.limonciello@amd.com>
Date: Wed, 16 Nov 2022 09:43:41 -0600
Subject: [PATCH] platform/x86/amd: pmc: Add a workaround for an s0i3 issue on
 Cezanne

Cezanne platforms under the right circumstances have a synchronization
problem where attempting to enter s2idle may fail if the x86 cores are
put into HLT before hardware resume from the previous attempt has
completed.

To avoid this issue add a 10-20ms delay before entering s2idle another
time. This workaround will only be applied on interrupts that wake the
hardware but don't break the s2idle loop.

Cc: stable@vger.kernel.org # 6.1
Cc: "Mahapatra, Rajib" <Rajib.Mahapatra@amd.com>
Cc: "Raul Rangel" <rrangel@chromium.org>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Link: https://lore.kernel.org/r/20221116154341.13382-1-mario.limonciello@amd.com
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>

diff --git a/drivers/platform/x86/amd/pmc.c b/drivers/platform/x86/amd/pmc.c
index ef4ae977b8e0..439d282aafd1 100644
--- a/drivers/platform/x86/amd/pmc.c
+++ b/drivers/platform/x86/amd/pmc.c
@@ -739,8 +739,14 @@ static void amd_pmc_s2idle_prepare(void)
 static void amd_pmc_s2idle_check(void)
 {
 	struct amd_pmc_dev *pdev = &pmc;
+	struct smu_metrics table;
 	int rc;
 
+	/* CZN: Ensure that future s0i3 entry attempts at least 10ms passed */
+	if (pdev->cpu_id == AMD_CPU_ID_CZN && !get_metrics_table(pdev, &table) &&
+	    table.s0i3_last_entry_status)
+		usleep_range(10000, 20000);
+
 	/* Dump the IdleMask before we add to the STB */
 	amd_pmc_idlemask_read(pdev, pdev->dev, NULL);
 

