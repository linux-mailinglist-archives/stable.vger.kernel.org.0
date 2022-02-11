Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC4F54B2A5D
	for <lists+stable@lfdr.de>; Fri, 11 Feb 2022 17:31:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351509AbiBKQ3E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Feb 2022 11:29:04 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:33482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235352AbiBKQ3C (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Feb 2022 11:29:02 -0500
Received: from cavan.codon.org.uk (irc.codon.org.uk [IPv6:2a00:1098:84:22e::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A881EC03;
        Fri, 11 Feb 2022 08:28:58 -0800 (PST)
Received: by cavan.codon.org.uk (Postfix, from userid 1000)
        id 447E840A67; Fri, 11 Feb 2022 16:28:57 +0000 (GMT)
Date:   Fri, 11 Feb 2022 16:28:57 +0000
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
Message-ID: <20220211162857.GB10606@srcf.ucam.org>
References: <9D0C961D-9999-4C41-A44B-22FEAF0DAB7F@live.com>
 <20220209164957.GB12763@srcf.ucam.org>
 <5A3C2EBF-13FF-4C37-B2A0-1533A818109F@live.com>
 <20220209183545.GA14552@srcf.ucam.org>
 <20220209193705.GA15463@srcf.ucam.org>
 <2F1CC5DE-5A03-46D2-95E7-DD07A4EF2766@live.com>
 <20220210180905.GB18445@srcf.ucam.org>
 <99BB011C-71DE-49FA-81CB-BE2AC9613030@live.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <99BB011C-71DE-49FA-81CB-BE2AC9613030@live.com>
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

On Fri, Feb 11, 2022 at 04:51:22AM +0000, Aditya Garg wrote:

> With this patch, I built 2 kernels, one with CONFIG_LOAD_UEFI_KEYS=y and other with CONFIG_LOAD_UEFI_KEYS=n. I have got different variables causing panics in both cases. The logs couldn't get saved in journalctl so, I clicked a picture of the same. The kernel anyways was refusing to boot after these logs.

Oh gosh I'm an idiot. Please try this one instead.

diff --git a/drivers/firmware/efi/runtime-wrappers.c b/drivers/firmware/efi/runtime-wrappers.c
index f3e54f6616f0..79a003c2f7b6 100644
--- a/drivers/firmware/efi/runtime-wrappers.c
+++ b/drivers/firmware/efi/runtime-wrappers.c
@@ -32,6 +32,8 @@
 #include <linux/stringify.h>
 #include <linux/workqueue.h>
 #include <linux/completion.h>
+#include <linux/ucs2_string.h>
+#include <linux/slab.h>
 
 #include <asm/efi.h>
 
@@ -179,6 +181,9 @@ static void efi_call_rts(struct work_struct *work)
 {
 	void *arg1, *arg2, *arg3, *arg4, *arg5;
 	efi_status_t status = EFI_NOT_FOUND;
+	unsigned long utf8_name_size;
+	char *utf8_name;
+	char guid_str[UUID_STRING_LEN + 1];
 
 	arg1 = efi_rts_work.arg1;
 	arg2 = efi_rts_work.arg2;
@@ -203,6 +208,17 @@ static void efi_call_rts(struct work_struct *work)
 				       (efi_time_t *)arg2);
 		break;
 	case EFI_GET_VARIABLE:
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

