Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 097A34D7ECF
	for <lists+stable@lfdr.de>; Mon, 14 Mar 2022 10:39:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233136AbiCNJkw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Mar 2022 05:40:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237418AbiCNJku (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Mar 2022 05:40:50 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5847344756;
        Mon, 14 Mar 2022 02:39:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id AE540CE10D7;
        Mon, 14 Mar 2022 09:39:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16FA4C340E9;
        Mon, 14 Mar 2022 09:39:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647250778;
        bh=c4ccepNMKWa0TheQBdTQEQ99OmozLH48X5gJw1qPbpQ=;
        h=Date:From:To:cc:Subject:In-Reply-To:References:From;
        b=ehXEhQbjxmMC75RJ3fZ4OTacmIzlSuOgAlI4dMNPiTlUmuLWzzKcR2fU78R2CHU0f
         1ABiDuwHwjBOoWW0YNAoZNEdfKEUSr4Ow6YEMyorR58iMBiNV8GJpkwSgUNTmbQQiu
         u6C6ei59SLWMq9B6GuOE1cLXp4SgP/jZYKjEYAj264+fDoF4ousuX09meImghK7whe
         4h3+0R2dvxeWKwxeRtYkwfmNfYrZHIznie2H19FActp37Xme3qnAOASBCTh2BEeriu
         TmNQaIz+Zp1KLJWEEMgQa0UXze8QreaG/CcN+Y7X+sRWISU/2wpiVk8oNlR++xG5On
         gkChCFooKer9w==
Date:   Mon, 14 Mar 2022 10:39:34 +0100 (CET)
From:   Jiri Kosina <jikos@kernel.org>
To:     Gwendal Grignou <gwendal@chromium.org>
cc:     srinivas.pandruvada@linux.intel.com, linux-input@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] HID: intel-ish-hid: Use dma_alloc_coherent for firmware
 update
In-Reply-To: <20220209050947.2119465-1-gwendal@chromium.org>
Message-ID: <nycvar.YFH.7.76.2203141039271.24795@cbobk.fhfr.pm>
References: <20220209050947.2119465-1-gwendal@chromium.org>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 8 Feb 2022, Gwendal Grignou wrote:

> Allocating memory with kmalloc and GPF_DMA32 is not allowed, the
> allocator will ignore the attribute.
> 
> Instead, use dma_alloc_coherent() API as we allocate a small amount of
> memory to transfer firmware fragment to the ISH.
> 
> On Arcada chromebook, after the patch the warning:
> "Unexpected gfp: 0x4 (GFP_DMA32). Fixing up to gfp: 0xcc0 (GFP_KERNEL).  Fix your code!"
> is gone. The ISH firmware is loaded properly and we can interact with
> the ISH:
> > ectool  --name cros_ish version
> ...
> Build info:    arcada_ish_v2.0.3661+3c1a1c1ae0 2022-02-08 05:37:47 @localhost
> Tool version:  v2.0.12300-900b03ec7f 2022-02-08 10:01:48 @localhost
> 
> Fixes: commit 91b228107da3 ("HID: intel-ish-hid: ISH firmware loader client driver")
> Signed-off-by: Gwendal Grignou <gwendal@chromium.org>
> Cc: stable@vger.kernel.org

Applied, thanks.

-- 
Jiri Kosina
SUSE Labs

