Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B048E4AFD94
	for <lists+stable@lfdr.de>; Wed,  9 Feb 2022 20:38:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229588AbiBITh1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Feb 2022 14:37:27 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:40574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230353AbiBIThL (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Feb 2022 14:37:11 -0500
Received: from cavan.codon.org.uk (irc.codon.org.uk [IPv6:2a00:1098:84:22e::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C989BC050CF9;
        Wed,  9 Feb 2022 11:37:08 -0800 (PST)
Received: by cavan.codon.org.uk (Postfix, from userid 1000)
        id B196F40A63; Wed,  9 Feb 2022 19:37:05 +0000 (GMT)
Date:   Wed, 9 Feb 2022 19:37:05 +0000
From:   Matthew Garrett <mjg59@srcf.ucam.org>
To:     Aditya Garg <gargaditya08@live.com>
Cc:     Ard Biesheuvel <ardb@kernel.org>, Jeremy Kerr <jk@ozlabs.org>,
        "joeyli.kernel@gmail.com" <joeyli.kernel@gmail.com>,
        "zohar@linux.ibm.com" <zohar@linux.ibm.com>,
        "jmorris@namei.org" <jmorris@namei.org>,
        "eric.snowberg@oracle.com" <eric.snowberg@oracle.com>,
        "dhowells@redhat.com" <dhowells@redhat.com>,
        "jlee@suse.com" <jlee@suse.com>,
        "James.Bottomley@hansenpartnership.com" 
        <James.Bottomley@HansenPartnership.com>,
        "jarkko@kernel.org" <jarkko@kernel.org>,
        "mic@digikod.net" <mic@digikod.net>,
        "dmitry.kasatkin@gmail.com" <dmitry.kasatkin@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "linux-security-module@vger.kernel.org" 
        <linux-security-module@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "keyrings@vger.kernel.org" <keyrings@vger.kernel.org>,
        "linux-integrity@vger.kernel.org" <linux-integrity@vger.kernel.org>,
        Orlando Chamberlain <redecorating@protonmail.com>,
        Aun-Ali Zaidi <admin@kodeit.net>
Subject: Re: [PATCH] efi: Do not import certificates from UEFI Secure Boot
 for T2 Macs
Message-ID: <20220209193705.GA15463@srcf.ucam.org>
References: <9D0C961D-9999-4C41-A44B-22FEAF0DAB7F@live.com>
 <20220209164957.GB12763@srcf.ucam.org>
 <5A3C2EBF-13FF-4C37-B2A0-1533A818109F@live.com>
 <20220209183545.GA14552@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220209183545.GA14552@srcf.ucam.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,KHOP_HELO_FCRDNS,SPF_HELO_NEUTRAL,
        SPF_NEUTRAL,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Feb 09, 2022 at 06:35:45PM +0000, Matthew Garrett wrote:

> The LOAD_UEFI_KEYS code isn't doing anything special here - it's just 
> trying to read some variables. If we simply disable that then the 
> expectation would be that reading the same variables from userland would 
> trigger the same failure. So the question is which of the variables that 
> LOAD_UEFI_KEYS accesses is triggering the failure, and what's special 
> about that? If it's a specific variable GUID or name that's failing, we 
> should block that on Apple hardware in order to avoid issues caused by 
> userland performing equivalent accesses.

ie, can you try something like this?

diff --git a/drivers/firmware/efi/runtime-wrappers.c b/drivers/firmware/efi/runtime-wrappers.c
index f3e54f6616f0..01cbd4811d1e 100644
--- a/drivers/firmware/efi/runtime-wrappers.c
+++ b/drivers/firmware/efi/runtime-wrappers.c
@@ -32,6 +32,8 @@
 #include <linux/stringify.h>
 #include <linux/workqueue.h>
 #include <linux/completion.h>
+#include <linux/ucs2_string.h>
+#include <linux/slab.h>
 
 #include <asm/efi.h>
 
@@ -203,6 +205,21 @@ static void efi_call_rts(struct work_struct *work)
 				       (efi_time_t *)arg2);
 		break;
 	case EFI_GET_VARIABLE:
+		unsigned long utf8_name_size;
+		char *utf8_name;
+		char guid_str[sizeof(efi_guid_t)+1];
+
+		utf8_name_size = ucs2_utf8size((efi_char16_t *)arg1);
+		utf8_name = kmalloc(utf8_name_size+1, GFP_KERNEL);
+		if (!utf8_name) {
+			printk(KERN_INFO "failed to allocate UTF8 buffer\n");
+			break;
+		}
+
+		ucs2_as_utf8(utf8_name, (efi_char16_t *)arg1, utf8_name_size + 1);
+		efi_guid_to_str((efi_guid_t *)arg2, guid_str);
+
+		printk(KERN_INFO "Reading EFI variable %s-%s\n", utf8_name, guid_str);
 		status = efi_call_virt(get_variable, (efi_char16_t *)arg1,
 				       (efi_guid_t *)arg2, (u32 *)arg3,
 				       (unsigned long *)arg4, (void *)arg5);

