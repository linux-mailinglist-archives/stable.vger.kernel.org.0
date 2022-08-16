Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A4CF595778
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 12:04:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233995AbiHPKEe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 06:04:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231441AbiHPKDu (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 06:03:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E48261322FB
        for <stable@vger.kernel.org>; Tue, 16 Aug 2022 01:27:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8A577B81648
        for <stable@vger.kernel.org>; Tue, 16 Aug 2022 08:27:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D097AC433C1;
        Tue, 16 Aug 2022 08:27:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660638446;
        bh=hFU6NOKybRE/gOpJ9qySCsLauYLBdjGFzKD6Nk9RpAw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Fl9ddYrjCuoBGHkHyUPARNwhVyoBODGNzuB2rfttZ/bp9AFLRjd6TL3fZgzjLl3lE
         ShNnFwE3SeHBWJ/7VnaXy7kHNqCTbk+9vMiu4OTHJhJqbZIu0SSaNus5EU7wBkkZe/
         sAy+pzz9hx3VBlQrw8nfEPyaSb+K7l8PzXNR4LMM=
Date:   Tue, 16 Aug 2022 09:59:57 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Coiby Xu <coxu@redhat.com>
Cc:     bhe@redhat.com, msuchanek@suse.de, will@kernel.org,
        zohar@linux.ibm.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] arm64: kexec_file: use more system
 keyrings to verify kernel" failed to apply to 5.19-stable tree
Message-ID: <YvtOfWDg2SXdcqgL@kroah.com>
References: <166057758347124@kroah.com>
 <20220816063256.qzc6jh744i2zc6ou@Rk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220816063256.qzc6jh744i2zc6ou@Rk>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 16, 2022 at 02:32:56PM +0800, Coiby Xu wrote:
> Hi Greg,
> 
> Good to see you here:)
> 
> On Mon, Aug 15, 2022 at 05:33:03PM +0200, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 5.19-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> > 
> > thanks,
> > 
> > greg k-h
> > 
> > ------------------ original commit in Linus's tree ------------------
> > 
> > > From 0d519cadf75184a24313568e7f489a7fc9b1be3b Mon Sep 17 00:00:00 2001
> > From: Coiby Xu <coxu@redhat.com>
> > Date: Thu, 14 Jul 2022 21:40:26 +0800
> > Subject: [PATCH] arm64: kexec_file: use more system keyrings to verify kernel
> > image signature
> > 
> > Currently, when loading a kernel image via the kexec_file_load() system
> > call, arm64 can only use the .builtin_trusted_keys keyring to verify
> > a signature whereas x86 can use three more keyrings i.e.
> > .secondary_trusted_keys, .machine and .platform keyrings. For example,
> > one resulting problem is kexec'ing a kernel image  would be rejected
> > with the error "Lockdown: kexec: kexec of unsigned images is restricted;
> > see man kernel_lockdown.7".
> > 
> > This patch set enables arm64 to make use of the same keyrings as x86 to
> > verify the signature kexec'ed kernel image.
> > 
> > Fixes: 732b7b93d849 ("arm64: kexec_file: add kernel signature verification support")
> > Cc: stable@vger.kernel.org # 105e10e2cf1c: kexec_file: drop weak attribute from functions

This is not a valid commit id in Linus's tree.

> > Cc: stable@vger.kernel.org # 34d5960af253: kexec: clean up arch_kexec_kernel_verify_sig

This is not a valid commit id in Linus's tree

> > Cc: stable@vger.kernel.org # 83b7bb2d49ae: kexec, KEYS: make the code in bzImage64_verify_sig generic

And this too is not a valid commit in Linus's tree.

> 
> I've added the above three patch prerequisites following [1]. I assume
> there is a program automatically picking up this patch. But somehow it
> fails to pick up the prerequisites first. Is it because the commit ids
> change when the patches are finally applied to Linus's tree?

Where did you get those commit ids from?

> If it's
> true, how do we make sure the we have the correct commit ids? Note [1]
> strongly recommends "Cc: stable@vger.kernel.org" to submit patches to
> stable tree but it seems there is no way to know beforehand the correct
> commit ids of the prerequisites that are yet to arrive in Linus's tree.

Hopefully the git ids can be stable when they are merged to a
maintainer's tree.  If not, then you can respond to this "failed" email
with the full series of what needs to be done here, as I have no idea :(

thanks,

greg k-h
