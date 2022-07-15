Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B80A4576075
	for <lists+stable@lfdr.de>; Fri, 15 Jul 2022 13:29:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234352AbiGOL3z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jul 2022 07:29:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232881AbiGOL3e (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Jul 2022 07:29:34 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 938F664D3;
        Fri, 15 Jul 2022 04:28:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F27E7B82B72;
        Fri, 15 Jul 2022 11:28:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 372BCC34115;
        Fri, 15 Jul 2022 11:28:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657884518;
        bh=chfXvT3Kw9OdeX3QrMS/wQpa5pJxeEVlUHF+qmPGx8o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nIXIvsGqJQSDfkfdA5Ct5BuNNtf85HQLj8rBjMgxlEJ8xgFxusngnVdyfTEnBLed/
         lF/k2fMAqp2vSt96Vm3pbhsRROOnPDkUHGdqUEs08mNZofOpoxZ7tE5xH8foiwDsl7
         PbQ2mI7vlrNKMLXev0JSLVT7OnLMSHby+ONY+Wdg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 5.10.131
Date:   Fri, 15 Jul 2022 13:28:27 +0200
Message-Id: <165788450638244@kroah.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <165788450619772@kroah.com>
References: <165788450619772@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

diff --git a/Makefile b/Makefile
index b0a35378803d..53f1a45ae69b 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 5
 PATCHLEVEL = 10
-SUBLEVEL = 130
+SUBLEVEL = 131
 EXTRAVERSION =
 NAME = Dare mighty things
 
diff --git a/drivers/mtd/nand/raw/gpmi-nand/gpmi-nand.c b/drivers/mtd/nand/raw/gpmi-nand/gpmi-nand.c
index 8d096ca770b0..92e8ca56f566 100644
--- a/drivers/mtd/nand/raw/gpmi-nand/gpmi-nand.c
+++ b/drivers/mtd/nand/raw/gpmi-nand/gpmi-nand.c
@@ -683,7 +683,7 @@ static void gpmi_nfc_compute_timings(struct gpmi_nand_data *this,
 	hw->timing0 = BF_GPMI_TIMING0_ADDRESS_SETUP(addr_setup_cycles) |
 		      BF_GPMI_TIMING0_DATA_HOLD(data_hold_cycles) |
 		      BF_GPMI_TIMING0_DATA_SETUP(data_setup_cycles);
-	hw->timing1 = BF_GPMI_TIMING1_BUSY_TIMEOUT(DIV_ROUND_UP(busy_timeout_cycles, 4096));
+	hw->timing1 = BF_GPMI_TIMING1_BUSY_TIMEOUT(busy_timeout_cycles * 4096);
 
 	/*
 	 * Derive NFC ideal delay from {3}:
