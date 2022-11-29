Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBE1763C5DA
	for <lists+stable@lfdr.de>; Tue, 29 Nov 2022 17:59:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236397AbiK2Q7P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Nov 2022 11:59:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236406AbiK2Q6y (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 29 Nov 2022 11:58:54 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7987A6F0DE
        for <stable@vger.kernel.org>; Tue, 29 Nov 2022 08:53:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 15E0D61808
        for <stable@vger.kernel.org>; Tue, 29 Nov 2022 16:53:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0907C433D6;
        Tue, 29 Nov 2022 16:53:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669740815;
        bh=A+O+P55WoZtJiv1V61NmOUeGgQ4AKeHGDE82Fn5rdHg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=EqVe5RfLuianCyYt3H+hdJFlRcSyr4IyXml4KhJejVtLRsnuPHSuZGlQLcM5a5jTB
         Y8/K2sACd1q7g90eJCixxiHyPugsqjGfUluWdwfV/2UprZjxlto2kZKTQgf6o1+GDr
         AF5BXhMZMoLbSI9/CI7oC2L2bZpyxTldJ1/F6bLQKiXBns318pPX1HViedCBk8tTl3
         oRf26QlzSGy8CtV/A6Iw6H5BmNx3ToMCFZQ+HuSZzB+nZmJ6tq7BEx53Ymu2EB1ynB
         CPeCAQYmzVtqHwxkQQ77q5AUIamr0vTBOM/pZs1Fse2+URl1KziaazoigcyVR+mQz9
         QYI8WdIuRRZIQ==
Date:   Tue, 29 Nov 2022 17:53:29 +0100
From:   Greg KH <gregkh@kernel.org>
To:     Vincent Donnefort <vdonnefort@google.com>
Cc:     kernel-team@android.com, Marc Zyngier <maz@kernel.org>,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.15] KVM: arm64: pkvm: Fixup boot mode to reflect that
 the kernel resumes from EL1
Message-ID: <Y4Y5CRCW/DuK4AHS@kroah.com>
References: <20221128185222.1291038-1-vdonnefort@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221128185222.1291038-1-vdonnefort@google.com>
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 28, 2022 at 06:52:22PM +0000, Vincent Donnefort wrote:
> From: Marc Zyngier <maz@kernel.org>
> 
> The kernel has an awfully complicated boot sequence in order to cope
> with the various EL2 configurations, including those that "enhanced"
> the architecture. We go from EL2 to EL1, then back to EL2, staying
> at EL2 if VHE capable and otherwise go back to EL1.
> 
> Here's a paracetamol tablet for you.
> 
> The cpu_resume path follows the same logic, because coming up with
> two versions of a square wheel is hard.
> 
> However, things aren't this straightforward with pKVM, as the host
> resume path is always proxied by the hypervisor, which means that
> the kernel is always entered at EL1. Which contradicts what the
> __boot_cpu_mode[] array contains (it obviously says EL2).
> 
> This thus triggers a HVC call from EL1 to EL2 in a vain attempt
> to upgrade from EL1 to EL2 VHE, which we are, funnily enough,
> reluctant to grant to the host kernel. This is also completely
> unexpected, and puzzles your average EL2 hacker.
> 
> Address it by fixing up the boot mode at the point the host gets
> deprivileged. is_hyp_mode_available() and co already have a static
> branch to deal with this, making it pretty safe.
> 
> This stable fix doesn't have an upstream version. The entire bootflow
> has been reworked from 6.0 and that fixed the boot mode at the same
> time, from commit 005e12676af0 ("arm64: head: record CPU boot mode after
> enabling the MMU") to be precise. However, the latter is part of a 20
> patches long series and can't be simply cherry-pick'ed.
> 
> Link: https://lore.kernel.org/r/20220624150651.1358849-1-ardb@kernel.org/
> Link: https://lore.kernel.org/r/20221011165400.1241729-1-maz@kernel.org/
> Cc: <stable@vger.kernel.org> # 5.15+
> Reported-by: Vincent Donnefort <vdonnefort@google.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> Tested-by: Vincent Donnefort <vdonnefort@google.com>
> [Vincent: Add a paragraph about why this patch is for stable only]
> Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

Now queued up, thanks.

greg k-h
