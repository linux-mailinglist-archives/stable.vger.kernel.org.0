Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F9DB524E5F
	for <lists+stable@lfdr.de>; Thu, 12 May 2022 15:36:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242178AbiELNg3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 May 2022 09:36:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354501AbiELNgW (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 May 2022 09:36:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C83E4286E0
        for <stable@vger.kernel.org>; Thu, 12 May 2022 06:36:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4637CB826AE
        for <stable@vger.kernel.org>; Thu, 12 May 2022 13:36:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F8FAC385B8;
        Thu, 12 May 2022 13:36:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652362578;
        bh=vtNyACv1GDds57wk0/3xK+KFuOW2R4mH4WQUTyTX3os=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WNgeKpSYwdR77+nHeQ9LpSy5EY8F43n4EIp/8pLqhiJcJWrovNweOB/YK9olf8nYV
         EoVDawe+xf+ZiCjSoQ4f94P52z51DUexp2Hj/kLGpq/0U7OYBz6FFYB7+YVkEOlhKx
         GAwLr5HMbVm/yri4wzYFlF4OwWly9sGb9Tc13XxU=
Date:   Thu, 12 May 2022 15:36:16 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Nathan Chancellor <nathan@kernel.org>
Cc:     Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org,
        Nick Desaulniers <ndesaulniers@google.com>,
        Tom Rix <trix@redhat.com>, llvm@lists.linux.dev
Subject: Re: Warning fixes for clang + x86_64 allmodconfig on 5.10 and 5.4
Message-ID: <Yn0NUKoWB2V87R4G@kroah.com>
References: <YnqlnFWCrEz11T5Y@dev-arch.thelio-3990X>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YnqlnFWCrEz11T5Y@dev-arch.thelio-3990X>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 10, 2022 at 10:49:16AM -0700, Nathan Chancellor wrote:
> Hi Greg and Sasha,
> 
> A recent change in LLVM [1] strengthened -Wenum-conversion, which
> revealed a couple of instances in 5.10 and 5.4 (the oldest release that
> I personally build test). They are fixed with the following changes,
> please consider applying them wherever they apply cleanly (I have
> included the release they first appeared in):
> 
> 1f1e87b4dc45 ("block: drbd: drbd_nl: Make conversion to 'enum drbd_ret_code' explicit") [5.13]
> 353f7f3a9dd5 ("drm/amd/display/dc/gpio/gpio_service: Pass around correct dce_{version, environment} types") [5.14]
> 
> Since I am here already, please consider applying the following
> additional changes where they cleanly apply, as they resolve other
> warnings present in x86_64 allmodconfig with clang:
> 
> 7bf03e7504e4 ("drm/i915: Cast remain to unsigned long in eb_relocate_vma") [5.8]
> 8a64ef042eab ("nfp: bpf: silence bitwise vs. logical OR warning") [5.15]
> 
> If there are any problems or questions, please let me know!
> 
> [1]: https://github.com/llvm/llvm-project/commit/882915df61e33f3a2b7f58e52f572717e1c11499

All now queued up, thanks.

greg k-h
