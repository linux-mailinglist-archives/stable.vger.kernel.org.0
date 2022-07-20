Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8AF357B20F
	for <lists+stable@lfdr.de>; Wed, 20 Jul 2022 09:48:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229636AbiGTHsc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Jul 2022 03:48:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231910AbiGTHs3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 Jul 2022 03:48:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C98F45A8A0;
        Wed, 20 Jul 2022 00:48:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 670D961953;
        Wed, 20 Jul 2022 07:48:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33C81C3411E;
        Wed, 20 Jul 2022 07:48:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658303307;
        bh=AikbkVL9wsoNXabyJQJht/n2BbeKYHlqevsM3Iw1eYI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BMDQ2uxZE5pDsXjlpKPO9OUbi34vLy6Js4dNVwfZgF6uLc0qPPs4kUMaDVS1PIH17
         ckUtmtBFX2zwL+OHRr/vwRdqKxbHy07LloMFFnTSklQBF35JsbSn3Wd5y8JpJQgAJd
         Hyf7lCTlgxmuhEW3EpWjFitugASSY1vUeNMosW2U=
Date:   Wed, 20 Jul 2022 09:48:24 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Alexandre Chartre <alexandre.chartre@oracle.com>,
        Kim Phillips <kim.phillips@amd.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Borislav Petkov <bp@suse.de>,
        Josh Poimboeuf <jpoimboe@kernel.org>, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, pbonzini@redhat.com, chang.seok.bae@intel.com,
        pawan.kumar.gupta@linux.intel.com, babu.moger@amd.com,
        jmattson@google.com, jing2.liu@intel.com, sandipan.das@amd.com,
        sblbir@amazon.com, keescook@chromium.org, tony.luck@intel.com,
        jane.malalane@citrix.com, bigeasy@linutronix.de
Subject: Re: [PATCH AUTOSEL 5.10 05/25] x86/bugs: Report AMD retbleed
 vulnerability
Message-ID: <YtezSJQfqZNQtmRa@kroah.com>
References: <20220720011616.1024753-1-sashal@kernel.org>
 <20220720011616.1024753-5-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220720011616.1024753-5-sashal@kernel.org>
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jul 19, 2022 at 09:15:56PM -0400, Sasha Levin wrote:
> From: Alexandre Chartre <alexandre.chartre@oracle.com>
> 
> [ Upstream commit 6b80b59b3555706508008f1f127b5412c89c7fd8 ]
> 
> Report that AMD x86 CPUs are vulnerable to the RETBleed (Arbitrary
> Speculative Code Execution with Return Instructions) attack.
> 
>   [peterz: add hygon]
>   [kim: invert parity; fam15h]
> 
> Co-developed-by: Kim Phillips <kim.phillips@amd.com>
> Signed-off-by: Kim Phillips <kim.phillips@amd.com>
> Signed-off-by: Alexandre Chartre <alexandre.chartre@oracle.com>
> Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> Signed-off-by: Borislav Petkov <bp@suse.de>
> Reviewed-by: Josh Poimboeuf <jpoimboe@kernel.org>
> Signed-off-by: Borislav Petkov <bp@suse.de>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  arch/x86/include/asm/cpufeatures.h |  1 +
>  arch/x86/kernel/cpu/bugs.c         | 13 +++++++++++++
>  arch/x86/kernel/cpu/common.c       | 19 +++++++++++++++++++
>  drivers/base/cpu.c                 |  8 ++++++++
>  include/linux/cpu.h                |  2 ++
>  5 files changed, 43 insertions(+)

This part of the larger retbleed series already queued up, so no need to
add it again.

thanks,

greg k-h
