Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE59260E61B
	for <lists+stable@lfdr.de>; Wed, 26 Oct 2022 19:03:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233807AbiJZRDP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Oct 2022 13:03:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233881AbiJZRDN (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Oct 2022 13:03:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF3BDB7F56;
        Wed, 26 Oct 2022 10:03:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4B89861FE7;
        Wed, 26 Oct 2022 17:03:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DFD0C433C1;
        Wed, 26 Oct 2022 17:03:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666803791;
        bh=/+wI55XT5dYZeXKI1VjmZB/J7L9+8Ueltl/gh45JRz8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WECt2ysqUJirH3O5D1Qwgukz0uJIs1l3FEG/Pn647kRzJsIAZDaxWgWzhlfwd0XXN
         dJGupANP2VKMASK0ZmKJRK12zGxXLBk8EwI4N5DNnO/MZ8iL3XM5Nup2U3NfLCB1hY
         vcMzwefnX9+rEogzbTKp6rQUJ4SNkSZoenesiADE=
Date:   Wed, 26 Oct 2022 19:02:55 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     stable@vger.kernel.org, James Morse <james.morse@arm.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Ionela Voinescu <ionela.voinescu@arm.com>,
        Shreyas K K <quic_shrekk@quicinc.com>,
        Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>,
        Reiji Watanabe <reijiw@google.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        "moderated list:ARM64 PORT (AARCH64 ARCHITECTURE)" 
        <linux-arm-kernel@lists.infradead.org>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH stable 4.19] arm64: errata: Remove AES hwcap for COMPAT
 tasks
Message-ID: <Y1loP4wJEgBdZvL3@kroah.com>
References: <20221020230110.1255660-1-f.fainelli@gmail.com>
 <20221020230110.1255660-3-f.fainelli@gmail.com>
 <Y1llLTazLS6LyOWB@kroah.com>
 <4f0ae178-f075-1f24-43b7-7ba8e494db76@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4f0ae178-f075-1f24-43b7-7ba8e494db76@gmail.com>
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 26, 2022 at 09:51:20AM -0700, Florian Fainelli wrote:
> 
> 
> On 10/26/2022 9:49 AM, Greg Kroah-Hartman wrote:
> > On Thu, Oct 20, 2022 at 04:01:07PM -0700, Florian Fainelli wrote:
> > > From: James Morse <james.morse@arm.com>
> > > 
> > > commit 44b3834b2eed595af07021b1c64e6f9bc396398b upstream
> > > 
> > > Cortex-A57 and Cortex-A72 have an erratum where an interrupt that
> > > occurs between a pair of AES instructions in aarch32 mode may corrupt
> > > the ELR. The task will subsequently produce the wrong AES result.
> > > 
> > > The AES instructions are part of the cryptographic extensions, which are
> > > optional. User-space software will detect the support for these
> > > instructions from the hwcaps. If the platform doesn't support these
> > > instructions a software implementation should be used.
> > > 
> > > Remove the hwcap bits on affected parts to indicate user-space should
> > > not use the AES instructions.
> > > 
> > > Acked-by: Ard Biesheuvel <ardb@kernel.org>
> > > Signed-off-by: James Morse <james.morse@arm.com>
> > > Link: https://lore.kernel.org/r/20220714161523.279570-3-james.morse@arm.com
> > > Signed-off-by: Will Deacon <will@kernel.org>
> > > [florian: resolved conflicts in arch/arm64/tools/cpucaps and cpu_errata.c]
> > > Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> > > Change-Id: I651a0db2e9d2f304d210ae979ae586e7dcc9744d
> > 
> > No need for Change-Id: in upstream patches :)
> 
> Meh, the perils of working with Gerrit in the same tree.. do you need me to
> resubmit or can you strip those when you apply the patches?

I stripped them all, no worries.
