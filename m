Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 724264B3A06
	for <lists+stable@lfdr.de>; Sun, 13 Feb 2022 08:47:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234263AbiBMHrX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 13 Feb 2022 02:47:23 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:58156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229555AbiBMHrV (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 13 Feb 2022 02:47:21 -0500
X-Greylist: delayed 468 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sat, 12 Feb 2022 23:47:15 PST
Received: from bmailout2.hostsharing.net (bmailout2.hostsharing.net [IPv6:2a01:37:3000::53df:4ef0:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 361756267;
        Sat, 12 Feb 2022 23:47:14 -0800 (PST)
Received: from h08.hostsharing.net (h08.hostsharing.net [83.223.95.28])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "*.hostsharing.net", Issuer "RapidSSL TLS DV RSA Mixed SHA256 2020 CA-1" (verified OK))
        by bmailout2.hostsharing.net (Postfix) with ESMTPS id 5CA532800B3D2;
        Sun, 13 Feb 2022 08:39:24 +0100 (CET)
Received: by h08.hostsharing.net (Postfix, from userid 100393)
        id 3FDC22DEC2D; Sun, 13 Feb 2022 08:39:24 +0100 (CET)
Date:   Sun, 13 Feb 2022 08:39:24 +0100
From:   Lukas Wunner <lukas@wunner.de>
To:     Aditya Garg <gargaditya08@live.com>
Cc:     David Laight <David.Laight@ACULAB.COM>,
        Ard Biesheuvel <ardb@kernel.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Jeremy Kerr <jk@ozlabs.org>,
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
Subject: Re: [PATCH v3] efi: Do not import certificates from UEFI Secure Boot
 for T2 Macs
Message-ID: <20220213073924.GA7648@wunner.de>
References: <9D0C961D-9999-4C41-A44B-22FEAF0DAB7F@live.com>
 <755cffe1dfaf43ea87cfeea124160fe0@AcuMS.aculab.com>
 <B6D697AB-2AC5-4925-8300-26BBB4AC3D99@live.com>
 <20103919-A276-4CA6-B1AD-6E45DB58500B@live.com>
 <7038A8ED-AC52-4966-836B-7B346713AEE9@live.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7038A8ED-AC52-4966-836B-7B346713AEE9@live.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 10, 2022 at 10:47:25AM +0000, Aditya Garg wrote:
> +/* Apple Macs with T2 Security chip don't support these UEFI variables.
> + * The T2 chip manages the Secure Boot and does not allow Linux to boot
> + * if it is turned on. If turned off, an attempt to get certificates
> + * causes a crash, so we simply return 0 for them in each function.
> + */
> +
> +static const struct dmi_system_id uefi_skip_cert[] = {
> +
> +	{ UEFI_QUIRK_SKIP_CERT("Apple Inc.", "MacBookPro15,1") },
> +	{ UEFI_QUIRK_SKIP_CERT("Apple Inc.", "MacBookPro15,2") },
> +	{ UEFI_QUIRK_SKIP_CERT("Apple Inc.", "MacBookPro15,3") },
> +	{ UEFI_QUIRK_SKIP_CERT("Apple Inc.", "MacBookPro15,4") },
> +	{ UEFI_QUIRK_SKIP_CERT("Apple Inc.", "MacBookPro16,1") },
> +	{ UEFI_QUIRK_SKIP_CERT("Apple Inc.", "MacBookPro16,2") },
> +	{ UEFI_QUIRK_SKIP_CERT("Apple Inc.", "MacBookPro16,3") },
> +	{ UEFI_QUIRK_SKIP_CERT("Apple Inc.", "MacBookPro16,4") },
> +	{ UEFI_QUIRK_SKIP_CERT("Apple Inc.", "MacBookAir8,1") },
> +	{ UEFI_QUIRK_SKIP_CERT("Apple Inc.", "MacBookAir8,2") },
> +	{ UEFI_QUIRK_SKIP_CERT("Apple Inc.", "MacBookAir9,1") },
> +	{ UEFI_QUIRK_SKIP_CERT("Apple Inc.", "MacMini8,1") },
> +	{ UEFI_QUIRK_SKIP_CERT("Apple Inc.", "MacPro7,1") },
> +	{ UEFI_QUIRK_SKIP_CERT("Apple Inc.", "iMac20,1") },
> +	{ UEFI_QUIRK_SKIP_CERT("Apple Inc.", "iMac20,2") },
> +	{ }
> +};

The T2 is represented by a PCI device with ID 106B:1802.  I think it
would be more elegant to sense presence of that device instead of
hardcoding a long dmi list, i.e.:

static bool apple_t2_present(void)
{
	struct pci_dev *pdev;

	if (!x86_apple_machine)
		return false;

	pdev = pci_get_device(PCI_VENDOR_ID_APPLE, 0x1802, NULL);
	if (pdev) {
		pci_put_dev(pdev);
		return true;
	}

	return false;
}
