Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE4AE5FE03D
	for <lists+stable@lfdr.de>; Thu, 13 Oct 2022 20:05:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231329AbiJMSFv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Oct 2022 14:05:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231207AbiJMSFJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Oct 2022 14:05:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C64B4157F45;
        Thu, 13 Oct 2022 11:04:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BA9AA61941;
        Thu, 13 Oct 2022 17:59:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1787C433C1;
        Thu, 13 Oct 2022 17:59:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665683941;
        bh=R56tc7ab5Ae7BCl75vsYTgnxuRRQc6ZCGNdTc3leahg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Pqqjf8IfVdSiADsbvp0iwQ4PPMN6AXHEj/xv5dQalbAfsiB5fODVocU6PDuzmfrE3
         TsMpLNvETAu4ghBHBXWbgesOj0XbSaYSCOUvI/nlp8HEz9qUh+n9gORewijKrO6zsL
         5zAxyyqCQQ4FYQ7svXIHraWs7ien7IhzLpK6SkpM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aditya Garg <gargaditya08@live.com>,
        Samuel Jiang <chyishian.jiang@gmail.com>,
        Orlando Chamberlain <redecorating@protonmail.com>,
        Mimi Zohar <zohar@linux.ibm.com>
Subject: [PATCH 5.19 11/33] efi: Correct Macmini DMI match in uefi cert quirk
Date:   Thu, 13 Oct 2022 19:52:43 +0200
Message-Id: <20221013175145.629145950@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221013175145.236739253@linuxfoundation.org>
References: <20221013175145.236739253@linuxfoundation.org>
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

From: Orlando Chamberlain <redecorating@protonmail.com>

commit bab715bdaa9ebf28d99a6d1efb2704a30125e96d upstream.

It turns out Apple doesn't capitalise the "mini" in "Macmini" in DMI, which
is inconsistent with other model line names.

Correct the capitalisation of Macmini in the quirk for skipping loading
platform certs on T2 Macs.

Currently users get:

------------[ cut here ]------------
[Firmware Bug]: Page fault caused by firmware at PA: 0xffffa30640054000
WARNING: CPU: 1 PID: 8 at arch/x86/platform/efi/quirks.c:735 efi_crash_gracefully_on_page_fault+0x55/0xe0
Modules linked in:
CPU: 1 PID: 8 Comm: kworker/u12:0 Not tainted 5.18.14-arch1-2-t2 #1 4535eb3fc40fd08edab32a509fbf4c9bc52d111e
Hardware name: Apple Inc. Macmini8,1/Mac-7BA5B2DFE22DDD8C, BIOS 1731.120.10.0.0 (iBridge: 19.16.15071.0.0,0) 04/24/2022
Workqueue: efi_rts_wq efi_call_rts
...
---[ end trace 0000000000000000 ]---
efi: Froze efi_rts_wq and disabled EFI Runtime Services
integrity: Couldn't get size: 0x8000000000000015
integrity: MODSIGN: Couldn't get UEFI db list
efi: EFI Runtime Services are disabled!
integrity: Couldn't get size: 0x8000000000000015
integrity: Couldn't get UEFI dbx list

Fixes: 155ca952c7ca ("efi: Do not import certificates from UEFI Secure Boot for T2 Macs")
Cc: stable@vger.kernel.org
Cc: Aditya Garg <gargaditya08@live.com>
Tested-by: Samuel Jiang <chyishian.jiang@gmail.com>
Signed-off-by: Orlando Chamberlain <redecorating@protonmail.com>
Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/integrity/platform_certs/load_uefi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/security/integrity/platform_certs/load_uefi.c
+++ b/security/integrity/platform_certs/load_uefi.c
@@ -31,7 +31,7 @@ static const struct dmi_system_id uefi_s
 	{ UEFI_QUIRK_SKIP_CERT("Apple Inc.", "MacBookAir8,1") },
 	{ UEFI_QUIRK_SKIP_CERT("Apple Inc.", "MacBookAir8,2") },
 	{ UEFI_QUIRK_SKIP_CERT("Apple Inc.", "MacBookAir9,1") },
-	{ UEFI_QUIRK_SKIP_CERT("Apple Inc.", "MacMini8,1") },
+	{ UEFI_QUIRK_SKIP_CERT("Apple Inc.", "Macmini8,1") },
 	{ UEFI_QUIRK_SKIP_CERT("Apple Inc.", "MacPro7,1") },
 	{ UEFI_QUIRK_SKIP_CERT("Apple Inc.", "iMac20,1") },
 	{ UEFI_QUIRK_SKIP_CERT("Apple Inc.", "iMac20,2") },


