Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD6414B14F5
	for <lists+stable@lfdr.de>; Thu, 10 Feb 2022 19:09:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245540AbiBJSJJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Feb 2022 13:09:09 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:36022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242648AbiBJSJJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Feb 2022 13:09:09 -0500
X-Greylist: delayed 81120 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 10 Feb 2022 10:09:07 PST
Received: from cavan.codon.org.uk (cavan.codon.org.uk [176.126.240.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0039F110C;
        Thu, 10 Feb 2022 10:09:06 -0800 (PST)
Received: by cavan.codon.org.uk (Postfix, from userid 1000)
        id 4117240A61; Thu, 10 Feb 2022 18:09:05 +0000 (GMT)
Date:   Thu, 10 Feb 2022 18:09:05 +0000
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
Message-ID: <20220210180905.GB18445@srcf.ucam.org>
References: <9D0C961D-9999-4C41-A44B-22FEAF0DAB7F@live.com>
 <20220209164957.GB12763@srcf.ucam.org>
 <5A3C2EBF-13FF-4C37-B2A0-1533A818109F@live.com>
 <20220209183545.GA14552@srcf.ucam.org>
 <20220209193705.GA15463@srcf.ucam.org>
 <2F1CC5DE-5A03-46D2-95E7-DD07A4EF2766@live.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2F1CC5DE-5A03-46D2-95E7-DD07A4EF2766@live.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 10, 2022 at 05:49:50AM +0000, Aditya Garg wrote:

> Looks like there is some error in this patch

I'm sorry, I'd build tested it here but clearly screwed that up. Try 
this one?

diff --git a/drivers/firmware/efi/runtime-wrappers.c b/drivers/firmware/efi/runtime-wrappers.c
index f3e54f6616f0..18b2ab40bee5 100644
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
+	char guid_str[sizeof(efi_guid_t)+1];
 
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
