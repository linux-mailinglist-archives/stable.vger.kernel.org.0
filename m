Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76991596E4D
	for <lists+stable@lfdr.de>; Wed, 17 Aug 2022 14:18:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236674AbiHQMQs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Aug 2022 08:16:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234942AbiHQMQr (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Aug 2022 08:16:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5346870B5
        for <stable@vger.kernel.org>; Wed, 17 Aug 2022 05:16:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 82197B81D90
        for <stable@vger.kernel.org>; Wed, 17 Aug 2022 12:16:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E36DFC433C1;
        Wed, 17 Aug 2022 12:16:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660738604;
        bh=3cik05wtfZbDgOyplH/TpJ4Ipi+HW233Ml5b1EMTg4E=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hsZ3VkoWena+hfZ9pA7WzgAA+nMXbhITiJiSoc9Mw1TSmCSWoJq6FBFXKmtapinEK
         oHXy5zsrjyobEW9aie7dLhOyijFoD/WoXSZYTbkZZl8D7XC0yWvJpg/HHyP/y7DOIV
         u6Nw5NpB+J1NMFPFVCob5+UzSIPEdzL+S9VP/tBU=
Date:   Wed, 17 Aug 2022 14:16:41 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Michal =?iso-8859-1?Q?Such=E1nek?= <msuchanek@suse.de>
Cc:     Coiby Xu <coxu@redhat.com>, bhe@redhat.com, will@kernel.org,
        zohar@linux.ibm.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] arm64: kexec_file: use more system
 keyrings to verify kernel" failed to apply to 5.19-stable tree
Message-ID: <YvzcKd2BMSpM9IZV@kroah.com>
References: <166057758347124@kroah.com>
 <20220816063256.qzc6jh744i2zc6ou@Rk>
 <YvtOfWDg2SXdcqgL@kroah.com>
 <20220816104559.xwovh5y4bcx6n37a@Rk>
 <YvzZILTQYXBanipB@kroah.com>
 <20220817121115.GA28810@kitsune.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220817121115.GA28810@kitsune.suse.cz>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Aug 17, 2022 at 02:11:15PM +0200, Michal Suchánek wrote:
> On Wed, Aug 17, 2022 at 02:03:44PM +0200, Greg KH wrote:
> > On Tue, Aug 16, 2022 at 06:45:59PM +0800, Coiby Xu wrote:
> > > On Tue, Aug 16, 2022 at 09:59:57AM +0200, Greg KH wrote:
> > > > On Tue, Aug 16, 2022 at 02:32:56PM +0800, Coiby Xu wrote:
> > > > > Hi Greg,
> > > > > 
> > > > > Good to see you here:)
> > > > > 
> > > > > On Mon, Aug 15, 2022 at 05:33:03PM +0200, gregkh@linuxfoundation.org wrote:
> > > > > >
> > > > > > The patch below does not apply to the 5.19-stable tree.
> > > > > > If someone wants it applied there, or to any other stable or longterm
> > > > > > tree, then please email the backport, including the original git commit
> > > > > > id to <stable@vger.kernel.org>.
> > > > > >
> > > > > > thanks,
> > > > > >
> > > > > > greg k-h
> > > > > >
> > > > > > ------------------ original commit in Linus's tree ------------------
> > > > > >
> > > > > > > From 0d519cadf75184a24313568e7f489a7fc9b1be3b Mon Sep 17 00:00:00 2001
> > > > > > From: Coiby Xu <coxu@redhat.com>
> > > > > > Date: Thu, 14 Jul 2022 21:40:26 +0800
> > > > > > Subject: [PATCH] arm64: kexec_file: use more system keyrings to verify kernel
> > > > > > image signature
> > > > > >
> > > > > > Currently, when loading a kernel image via the kexec_file_load() system
> > > > > > call, arm64 can only use the .builtin_trusted_keys keyring to verify
> > > > > > a signature whereas x86 can use three more keyrings i.e.
> > > > > > .secondary_trusted_keys, .machine and .platform keyrings. For example,
> > > > > > one resulting problem is kexec'ing a kernel image  would be rejected
> > > > > > with the error "Lockdown: kexec: kexec of unsigned images is restricted;
> > > > > > see man kernel_lockdown.7".
> > > > > >
> > > > > > This patch set enables arm64 to make use of the same keyrings as x86 to
> > > > > > verify the signature kexec'ed kernel image.
> > > > > >
> > > > > > Fixes: 732b7b93d849 ("arm64: kexec_file: add kernel signature verification support")
> > > > > > Cc: stable@vger.kernel.org # 105e10e2cf1c: kexec_file: drop weak attribute from functions
> > > > 
> > > > This is not a valid commit id in Linus's tree.
> > > > 
> > > > > > Cc: stable@vger.kernel.org # 34d5960af253: kexec: clean up arch_kexec_kernel_verify_sig
> > > > 
> > > > This is not a valid commit id in Linus's tree
> > > > 
> > > > > > Cc: stable@vger.kernel.org # 83b7bb2d49ae: kexec, KEYS: make the code in bzImage64_verify_sig generic
> > > > 
> > > > And this too is not a valid commit in Linus's tree.
> > > 
> > > Sorry for the confusion. The correct commit ids are as follows,
> > > 
> > > 0738eceb6201 ("kexec: drop weak attribute from functions")
> > > 689a71493bd2 ("kexec: clean up arch_kexec_kernel_verify_sig")
> > > c903dae8941d ("kexec, KEYS: make the code in bzImage64_verify_sig generic")
> > 
> > What order do they need to be applied in?
> 
> This is the whole series as seen in Linus tree from oldest to newest:
> 
> 65d9a9a60fd71be964effb2e94747a6acb6e7015 kexec_file: drop weak attribute from functions
> 0738eceb6201691534df07e0928d0a6168a35787 kexec: drop weak attribute from functions
> 689a71493bd2f31c024f8c0395f85a1fd4b2138e kexec: clean up arch_kexec_kernel_verify_sig
> c903dae8941deb55043ee46ded29e84e97cd84bb kexec, KEYS: make the code in bzImage64_verify_sig generic
> 0d519cadf75184a24313568e7f489a7fc9b1be3b arm64: kexec_file: use more system keyrings to verify kernel image signature

Great!

> (with the exception of the s390 patch which stands on its own)

What s390 patch?

Now you confused me again...

greg k-h
