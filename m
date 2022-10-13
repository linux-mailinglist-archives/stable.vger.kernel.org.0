Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B37975FE16A
	for <lists+stable@lfdr.de>; Thu, 13 Oct 2022 20:37:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232098AbiJMShk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Oct 2022 14:37:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231173AbiJMShV (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Oct 2022 14:37:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F208E43152;
        Thu, 13 Oct 2022 11:33:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BC095618B8;
        Thu, 13 Oct 2022 17:58:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5756C433D7;
        Thu, 13 Oct 2022 17:58:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665683925;
        bh=OEVHSmyP6ry9HP1rzqnCniac1P21E4uC7zWTb3gHzHk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VUlXjfSzjP666S5HT/BvcAftShfsD9mOw84ULE51yyeXtvXw9vI2iqULTWBjuXTJS
         Gg9TzK8KbSIQAoqkCrD5+pUZUnrQY6Ihnbo44w4kJsc60/PorP0Mj9xewJRQcKBPBb
         TPljA4VUSxRtetDM9WEcORuFovgEH3BLwKMJvnTo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aditya Garg <gargaditya08@live.com>,
        Samuel Jiang <chyishian.jiang@gmail.com>,
        Orlando Chamberlain <redecorating@protonmail.com>,
        Mimi Zohar <zohar@linux.ibm.com>
Subject: [PATCH 5.15 09/27] efi: Correct Macmini DMI match in uefi cert quirk
Date:   Thu, 13 Oct 2022 19:52:38 +0200
Message-Id: <20221013175143.863780029@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221013175143.518476113@linuxfoundation.org>
References: <20221013175143.518476113@linuxfoundation.org>
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
@@ -30,7 +30,7 @@ static const struct dmi_system_id uefi_s
 	{ UEFI_QUIRK_SKIP_CERT("Apple Inc.", "MacBookAir8,1") },
 	{ UEFI_QUIRK_SKIP_CERT("Apple Inc.", "MacBookAir8,2") },
 	{ UEFI_QUIRK_SKIP_CERT("Apple Inc.", "MacBookAir9,1") },
-	{ UEFI_QUIRK_SKIP_CERT("Apple Inc.", "MacMini8,1") },
+	{ UEFI_QUIRK_SKIP_CERT("Apple Inc.", "Macmini8,1") },
 	{ UEFI_QUIRK_SKIP_CERT("Apple Inc.", "MacPro7,1") },
 	{ UEFI_QUIRK_SKIP_CERT("Apple Inc.", "iMac20,1") },
 	{ UEFI_QUIRK_SKIP_CERT("Apple Inc.", "iMac20,2") },


