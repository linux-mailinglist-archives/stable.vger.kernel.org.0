Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 148AA66AAB0
	for <lists+stable@lfdr.de>; Sat, 14 Jan 2023 10:49:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229720AbjANJtF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 14 Jan 2023 04:49:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229840AbjANJtE (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 14 Jan 2023 04:49:04 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F9A2769B;
        Sat, 14 Jan 2023 01:49:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2A08AB808C7;
        Sat, 14 Jan 2023 09:49:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56236C433EF;
        Sat, 14 Jan 2023 09:49:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673689740;
        bh=+hMv+Svmm+dRm+e9VzK/6V4/+PwwyRsmIeGLUjQ4Fqo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ME1n68EzsJlnbttczOCVRPV9DMvdUFNJVZeU41P/CIhMVbwbZ4huc8rmtcTWrHzm4
         mWTPnItAyHOssscO9EB2kTRfJte+b2XrflMZJFS4iyD01yT0vn1/ApwdphHqfe/CKH
         Hw8PH/UZAkgdLRCFkvImPdWlCene5FZLqtrhOOaI=
Date:   Sat, 14 Jan 2023 10:48:57 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Stephen Boyd <swboyd@chromium.org>
Cc:     stable@vger.kernel.org, Denis Nikitin <denik@chromium.org>,
        linux-kernel@vger.kernel.org, patches@lists.linux.dev,
        Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH 5.15.y] KVM: arm64: nvhe: Fix build with profile
 optimization
Message-ID: <Y8J6iSOVwGslj3jV@kroah.com>
References: <20230113002210.3984665-1-swboyd@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230113002210.3984665-1-swboyd@chromium.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 12, 2023 at 04:22:10PM -0800, Stephen Boyd wrote:
> From: Denis Nikitin <denik@chromium.org>
> 
> commit bde971a83bbff78561458ded236605a365411b87 upstream.
> 
> Kernel build with clang and KCFLAGS=-fprofile-sample-use=<profile> fails with:
> 
> error: arch/arm64/kvm/hyp/nvhe/kvm_nvhe.tmp.o: Unexpected SHT_REL
> section ".rel.llvm.call-graph-profile"
> 
> Starting from 13.0.0 llvm can generate SHT_REL section, see
> https://reviews.llvm.org/rGca3bdb57fa1ac98b711a735de048c12b5fdd8086.
> gen-hyprel does not support SHT_REL relocation section.
> 
> Filter out profile use flags to fix the build with profile optimization.
> 
> Signed-off-by: Denis Nikitin <denik@chromium.org>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> Link: https://lore.kernel.org/r/20221014184532.3153551-1-denik@chromium.org
> Signed-off-by: Stephen Boyd <swboyd@chromium.org>
> ---
> 
> I need this to properly compile 5.15.y stable kernels in the chromeos build
> system.

Now queued up, thanks.

greg k-h
