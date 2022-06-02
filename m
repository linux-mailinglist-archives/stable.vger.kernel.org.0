Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22E0853C063
	for <lists+stable@lfdr.de>; Thu,  2 Jun 2022 23:33:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230034AbiFBVc5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jun 2022 17:32:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229634AbiFBVcx (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Jun 2022 17:32:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 722897641
        for <stable@vger.kernel.org>; Thu,  2 Jun 2022 14:32:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 379D0B82187
        for <stable@vger.kernel.org>; Thu,  2 Jun 2022 21:32:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAC5AC3411F;
        Thu,  2 Jun 2022 21:32:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654205568;
        bh=wOVpPMTaeCWzLWlQlyLICMuR27ac7M4fqukyOaNMa/o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=By9uMGgi4i+gQXQ95wFY7zu31RH5abf6M0xZ7L7TMjtB+50aYnGMw/7vJzOMB5Uwz
         UVfzyLLITxA0WDSAXAJybdgwd1/CsMzOuuihDBElRPmQYakVNIU4mX6pTMyeI3KENz
         8P+qBtKr4fcAhSyrW8ecLyDDqg4fFRltMGZzD0wN+X0A0Sdsl6b0uy4SmTtwEnSs4P
         ixwO0Zw9vN4GBofKV1g6fpN55sDt/daCZHMVG1QJ3gCKY4l3wuD4Up4Rh91Sfg3SVx
         bV4UwGzWnl2ipKk0DhgmjhWaP3PL83lCp3oHlWffin3ymyDhKV1t5glJdOT/iU/jks
         tSM0A/0NbI6gg==
Date:   Thu, 2 Jun 2022 14:32:46 -0700
From:   Nathan Chancellor <nathan@kernel.org>
To:     Thomas Sattler <sattler@med.uni-frankfurt.de>
Cc:     stable@vger.kernel.org, regressions@lists.linux.dev
Subject: Re: boot loop since 5.17.6
Message-ID: <YpksflOG2Y1Xng89@dev-arch.thelio-3990X>
References: <11495172-41dd-5c44-3ef6-8d3ff3ebd1b2@med.uni-frankfurt.de>
 <c3b370a8-193e-329b-c73a-1371bd62edf3@med.uni-frankfurt.de>
 <181a6369-e373-b020-2059-33fb5161d8d3@med.uni-frankfurt.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <181a6369-e373-b020-2059-33fb5161d8d3@med.uni-frankfurt.de>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jun 02, 2022 at 09:24:18PM +0200, Thomas Sattler wrote:
> with these three diffs reverted, I was able to boot
> all affected 5.17.x kernels (x={6,7,8,9,10,11,12})
> 
> 
> 
> Am 02.06.22 um 18:42 schrieb Thomas Sattler:
> > some more information:
> > 
> > $ cat /proc/version
> > Linux version 5.17.5 (root@dragon) (x86_64-pc-linux-gnu-gcc (Gentoo
> > 11.2.1_p20220115 p4) 11.2.1 20220115, GNU ld (Gentoo 2.37_p1 p2) 2.37)
> > #130 SMP PREEMPT Thu Apr 28 10:50:24 CEST 2022
> > 
> > $ uname -mi
> > x86_64 GenuineIntel
> > 
> > 
> > I tried to compile 5.17.6 without the three mentioned diffs which
> > modify the following files:
> > 
> >     tools/objtool/check.c   and
> >     tools/objtool/elf.c      and
> >     tools/objtool/include/objtool/elf.h
> > 
> > and was then able to successfully boot 5.17.6.

5.17.6 has commit 60d2b0b1018a ("objtool: Fix code relocs vs weak
symbols"), which has a known issue that is fixed with commit
ead165fa1042 ("objtool: Fix symbol creation"). If you apply ead165fa1042
on 5.17.6 or newer, does that resolve your issue?

ead165fa1042 is tagged for stable but I don't think Greg picks up
patches from mainline until they are in a tagged -rc release.

Cheers,
Nathan
