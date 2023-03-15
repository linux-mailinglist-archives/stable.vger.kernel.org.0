Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C3206BAA2B
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 08:57:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230516AbjCOH5Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 03:57:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231397AbjCOH5X (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 03:57:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A228D34025
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 00:57:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 56564B81CC1
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 07:57:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C710DC433EF;
        Wed, 15 Mar 2023 07:57:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678867040;
        bh=VE540exbj0n5SH+UHMY6wuhbuSOEmaj7ybVr4pdyNyY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=dRR1FxS9eI65AGMYbaspJKOtHVYWYtforyPPphpWKiL4vWW1CGdxW0uJngT2daxDa
         KTzLcXMpLiDInNMPaskz7uUA+Ycnb2rckcNN2vJ4jj+gBFCXtZcOwAzinSbu+sqII9
         5xm9eC/nCWHd9RHBZr3KItQsw4rUHVk0LcjgNYkA=
Date:   Wed, 15 Mar 2023 08:57:17 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Rhythm Mahajan <rhythm.m.mahajan@oracle.com>
Cc:     tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, bp@suse.de,
        pawan.kumar.gupta@linux.intel.com, cascardo@canonical.com,
        surajjs@amazon.com, daniel.sneddon@linux.intel.com,
        peterz@infradead.org, stable@vger.kernel.org
Subject: Re: [PATCH 4.14] x86/cpu: Fix LFENCE serialization check in
 init_amd()
Message-ID: <ZBF6XaeboXtY6VS5@kroah.com>
References: <20230314111159.3536249-1-rhythm.m.mahajan@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230314111159.3536249-1-rhythm.m.mahajan@oracle.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 14, 2023 at 04:11:59AM -0700, Rhythm Mahajan wrote:
> The commit: 3f235279828c ("x86/cpu: Restore AMD's DE_CFG MSR after resume")
> renamed the MSR_F10H_DECFG_LFENCE_SERIALIZE macro to
> MSR_AMD64_DE_CFG_LFENCE_SERIALIZE.
> The fix changed MSR_F10H_DECFG_LFENCE_SERIALIZE to
> MSR_AMD64_DE_CFG_LFENCE_SERIALIZE_BIT in the init_amd() function,
> but should have used MSR_AMD64_DE_CFG_LFENCE_SERIALIZE.
> This causes a discrepancy in the LFENCE serialization
> check in the init_amd() function.
> 
> This causes a ~16% sysbench memory regression, when running:
>   sysbench --test=memory run
> 
> Fixes: 3f235279828c2a8aff3164fef08d58f7af2d64fc("x86/cpu: Restore AMD's DE_CFG MSR after resume
> ")

Odd line-wrapping :(

And please use the proper way to reference SHA1 as documented in the
kernel documentation.

And why is this only needed in 4.14.y?  What about Linus's tree and all
of the other stable trees?

Please get this fixed in Linus's tree first and then we can take a
backport.

thanks,

greg k-h
