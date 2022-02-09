Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63F3A4AFA77
	for <lists+stable@lfdr.de>; Wed,  9 Feb 2022 19:37:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239777AbiBIShb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Feb 2022 13:37:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239608AbiBISfx (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Feb 2022 13:35:53 -0500
X-Greylist: delayed 6349 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 09 Feb 2022 10:35:48 PST
Received: from cavan.codon.org.uk (irc.codon.org.uk [IPv6:2a00:1098:84:22e::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D50FEC05CB82;
        Wed,  9 Feb 2022 10:35:48 -0800 (PST)
Received: by cavan.codon.org.uk (Postfix, from userid 1000)
        id F07A540A63; Wed,  9 Feb 2022 18:35:45 +0000 (GMT)
Date:   Wed, 9 Feb 2022 18:35:45 +0000
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
Message-ID: <20220209183545.GA14552@srcf.ucam.org>
References: <9D0C961D-9999-4C41-A44B-22FEAF0DAB7F@live.com>
 <20220209164957.GB12763@srcf.ucam.org>
 <5A3C2EBF-13FF-4C37-B2A0-1533A818109F@live.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5A3C2EBF-13FF-4C37-B2A0-1533A818109F@live.com>
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

On Wed, Feb 09, 2022 at 06:02:34PM +0000, Aditya Garg wrote:
> 
> 
> > On 09-Feb-2022, at 10:19 PM, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> > 
> > On Wed, Feb 09, 2022 at 02:27:51PM +0000, Aditya Garg wrote:
> >> From: Aditya Garg <gargaditya08@live.com>
> >> 
> >> On T2 Macs, the secure boot is handled by the T2 Chip. If enabled, only
> >> macOS and Windows are allowed to boot on these machines. Thus we need to
> >> disable secure boot for Linux. If we boot into Linux after disabling
> >> secure boot, if CONFIG_LOAD_UEFI_KEYS is enabled, EFI Runtime services
> >> fail to start, with the following logs in dmesg
> > 
> > Which specific variable request is triggering the failure? Do any 
> > runtime variable accesses work on these machines?
> Commit f5390cd0b43c2e54c7cf5506c7da4a37c5cef746 in Linus’ tree was also added to force EFI v1.1 on these machines, since v2.4, reported by them was causing kernel panics.
> 
> So, EFI 1.1 without import certificates seems to work and have been able to modify the variables, thus the remaining EFI variable accesses seem to work.

The LOAD_UEFI_KEYS code isn't doing anything special here - it's just 
trying to read some variables. If we simply disable that then the 
expectation would be that reading the same variables from userland would 
trigger the same failure. So the question is which of the variables that 
LOAD_UEFI_KEYS accesses is triggering the failure, and what's special 
about that? If it's a specific variable GUID or name that's failing, we 
should block that on Apple hardware in order to avoid issues caused by 
userland performing equivalent accesses.
