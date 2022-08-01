Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBFA1586908
	for <lists+stable@lfdr.de>; Mon,  1 Aug 2022 13:56:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232391AbiHAL4Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Aug 2022 07:56:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232740AbiHALz6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Aug 2022 07:55:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EEF6402CA;
        Mon,  1 Aug 2022 04:51:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2B807B8116E;
        Mon,  1 Aug 2022 11:51:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DC9FC433C1;
        Mon,  1 Aug 2022 11:51:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1659354690;
        bh=VA2wohoCImHpJ67x4JVTxx0JPiyhyzHT+u6woSJvBRU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uWLXyapyjFUuJv54+vYBIHf+FSvUmBsv1HgFbCSNi1CqLyc8m/VV4lMrKswBlbA39
         HeMsvkIgRk9pdOM1d3J2oa4dt8gYOzFJg+3w0TjGFTxkUM9wwJd163qPVVqFkIjC5P
         TqO3zgPeZAjQRAFLDVEGcJi0kRWdUk0Cfkvpkrp4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Robert Richter <rric@kernel.org>,
        Toshi Kani <toshi.kani@hpe.com>, Borislav Petkov <bp@suse.de>,
        Robert Elliott <elliott@hpe.com>
Subject: [PATCH 5.10 51/65] EDAC/ghes: Set the DIMM label unconditionally
Date:   Mon,  1 Aug 2022 13:47:08 +0200
Message-Id: <20220801114135.826131097@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220801114133.641770326@linuxfoundation.org>
References: <20220801114133.641770326@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Toshi Kani <toshi.kani@hpe.com>

commit 5e2805d5379619c4a2e3ae4994e73b36439f4bad upstream.

The commit

  cb51a371d08e ("EDAC/ghes: Setup DIMM label from DMI and use it in error reports")

enforced that both the bank and device strings passed to
dimm_setup_label() are not NULL.

However, there are BIOSes, for example on a

  HPE ProLiant DL360 Gen10/ProLiant DL360 Gen10, BIOS U32 03/15/2019

which don't populate both strings:

  Handle 0x0020, DMI type 17, 84 bytes
  Memory Device
          Array Handle: 0x0013
          Error Information Handle: Not Provided
          Total Width: 72 bits
          Data Width: 64 bits
          Size: 32 GB
          Form Factor: DIMM
          Set: None
          Locator: PROC 1 DIMM 1        <===== device
          Bank Locator: Not Specified   <===== bank

This results in a buffer overflow because ghes_edac_register() calls
strlen() on an uninitialized label, which had non-zero values left over
from krealloc_array():

  detected buffer overflow in __fortify_strlen
   ------------[ cut here ]------------
   kernel BUG at lib/string_helpers.c:983!
   invalid opcode: 0000 [#1] PREEMPT SMP NOPTI
   CPU: 1 PID: 1 Comm: swapper/0 Tainted: G          I       5.18.6-200.fc36.x86_64 #1
   Hardware name: HPE ProLiant DL360 Gen10/ProLiant DL360 Gen10, BIOS U32 03/15/2019
   RIP: 0010:fortify_panic
   ...
   Call Trace:
    <TASK>
    ghes_edac_register.cold
    ghes_probe
    platform_probe
    really_probe
    __driver_probe_device
    driver_probe_device
    __driver_attach
    ? __device_attach_driver
    bus_for_each_dev
    bus_add_driver
    driver_register
    acpi_ghes_init
    acpi_init
    ? acpi_sleep_proc_init
    do_one_initcall

The label contains garbage because the commit in Fixes reallocs the
DIMMs array while scanning the system but doesn't clear the newly
allocated memory.

Change dimm_setup_label() to always initialize the label to fix the
issue. Set it to the empty string in case BIOS does not provide both
bank and device so that ghes_edac_register() can keep the default label
given by edac_mc_alloc_dimms().

  [ bp: Rewrite commit message. ]

Fixes: b9cae27728d1f ("EDAC/ghes: Scan the system once on driver init")
Co-developed-by: Robert Richter <rric@kernel.org>
Signed-off-by: Robert Richter <rric@kernel.org>
Signed-off-by: Toshi Kani <toshi.kani@hpe.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Tested-by: Robert Elliott <elliott@hpe.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20220719220124.760359-1-toshi.kani@hpe.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/edac/ghes_edac.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

--- a/drivers/edac/ghes_edac.c
+++ b/drivers/edac/ghes_edac.c
@@ -101,9 +101,14 @@ static void dimm_setup_label(struct dimm
 
 	dmi_memdev_name(handle, &bank, &device);
 
-	/* both strings must be non-zero */
-	if (bank && *bank && device && *device)
-		snprintf(dimm->label, sizeof(dimm->label), "%s %s", bank, device);
+	/*
+	 * Set to a NULL string when both bank and device are zero. In this case,
+	 * the label assigned by default will be preserved.
+	 */
+	snprintf(dimm->label, sizeof(dimm->label), "%s%s%s",
+		 (bank && *bank) ? bank : "",
+		 (bank && *bank && device && *device) ? " " : "",
+		 (device && *device) ? device : "");
 }
 
 static void assign_dmi_dimm_info(struct dimm_info *dimm, struct memdev_dmi_entry *entry)


