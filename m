Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A0B84B37AA
	for <lists+stable@lfdr.de>; Sat, 12 Feb 2022 20:42:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231195AbiBLTmv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 12 Feb 2022 14:42:51 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:55556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230072AbiBLTmt (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 12 Feb 2022 14:42:49 -0500
Received: from cavan.codon.org.uk (irc.codon.org.uk [IPv6:2a00:1098:84:22e::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B53FA606CC;
        Sat, 12 Feb 2022 11:42:42 -0800 (PST)
Received: by cavan.codon.org.uk (Postfix, from userid 1000)
        id 4E74840A64; Sat, 12 Feb 2022 19:42:40 +0000 (GMT)
Date:   Sat, 12 Feb 2022 19:42:40 +0000
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
Message-ID: <20220212194240.GA4131@srcf.ucam.org>
References: <9D0C961D-9999-4C41-A44B-22FEAF0DAB7F@live.com>
 <20220209164957.GB12763@srcf.ucam.org>
 <5A3C2EBF-13FF-4C37-B2A0-1533A818109F@live.com>
 <20220209183545.GA14552@srcf.ucam.org>
 <20220209193705.GA15463@srcf.ucam.org>
 <2F1CC5DE-5A03-46D2-95E7-DD07A4EF2766@live.com>
 <20220210180905.GB18445@srcf.ucam.org>
 <99BB011C-71DE-49FA-81CB-BE2AC9613030@live.com>
 <20220211162857.GB10606@srcf.ucam.org>
 <F078BEBE-3DED-4EE3-A2B8-2C5744B5454C@live.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <F078BEBE-3DED-4EE3-A2B8-2C5744B5454C@live.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-0.8 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,KHOP_HELO_FCRDNS,SPF_HELO_NEUTRAL,
        SPF_NEUTRAL,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Feb 12, 2022 at 05:53:47AM +0000, Aditya Garg wrote:

> Feb 12 11:01:52 MacBook kernel: Reading EFI variable db-d719b2cb-3d3a-4596-a3bc-dad00e67656f

Ok. With CONFIG_LOAD_UEFI_KEYS=n, can you run:

cat /sys/firmware/efi/efivars/db-d719b2cb-3d3a-4596-a3bc-dad00e67656f

and see whether it generates the same failure? If so then my (handwavy) 
guess is that something's going wrong with a firmware codepath for the 
d719b2cb-3d3a-4596-a3bc-dad00e67656f GUID. Someone could potentially 
then figure out whether the same happens under Windows, but the easiest 
thing is probably to just return a failure on Apple hardware when 
someone tries to access anything with that GUID.
