Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64358576077
	for <lists+stable@lfdr.de>; Fri, 15 Jul 2022 13:30:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231586AbiGOL35 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jul 2022 07:29:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232893AbiGOL3f (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Jul 2022 07:29:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F936E09F;
        Fri, 15 Jul 2022 04:28:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0F715B82B9C;
        Fri, 15 Jul 2022 11:28:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37C83C3411E;
        Fri, 15 Jul 2022 11:28:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657884521;
        bh=xStRHoffTtxu5I7bWMKYORj8Bgll5IRF43GVx8/Osds=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dyznh9HEHJRgrbvod7ruOjdrBSCmQB7YfPX/gErJILzIfH6GDMvpHLE0iFUAj9dRt
         ja5qnyErLMC7zjaiPGU1pDhOjpBwxZcFTyQjXvfDOSMDGb4ba7WvgQyIMr3m/OEB0p
         CzzAvk62EeqsNcS/fVdzFzWvxHHXVmHUSjl2E4zY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 5.15.55
Date:   Fri, 15 Jul 2022 13:28:33 +0200
Message-Id: <1657884512246178@kroah.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <1657884512211161@kroah.com>
References: <1657884512211161@kroah.com>
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
index f8dc156aa302..c95f0f59885f 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 5
 PATCHLEVEL = 15
-SUBLEVEL = 54
+SUBLEVEL = 55
 EXTRAVERSION =
 NAME = Trick or Treat
 
diff --git a/drivers/mtd/nand/raw/gpmi-nand/gpmi-nand.c b/drivers/mtd/nand/raw/gpmi-nand/gpmi-nand.c
index 6eb067777703..b72b387c08ef 100644
--- a/drivers/mtd/nand/raw/gpmi-nand/gpmi-nand.c
+++ b/drivers/mtd/nand/raw/gpmi-nand/gpmi-nand.c
@@ -685,7 +685,7 @@ static void gpmi_nfc_compute_timings(struct gpmi_nand_data *this,
 	hw->timing0 = BF_GPMI_TIMING0_ADDRESS_SETUP(addr_setup_cycles) |
 		      BF_GPMI_TIMING0_DATA_HOLD(data_hold_cycles) |
 		      BF_GPMI_TIMING0_DATA_SETUP(data_setup_cycles);
-	hw->timing1 = BF_GPMI_TIMING1_BUSY_TIMEOUT(DIV_ROUND_UP(busy_timeout_cycles, 4096));
+	hw->timing1 = BF_GPMI_TIMING1_BUSY_TIMEOUT(busy_timeout_cycles * 4096);
 
 	/*
 	 * Derive NFC ideal delay from {3}:
