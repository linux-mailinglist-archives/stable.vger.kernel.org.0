Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94638585E8B
	for <lists+stable@lfdr.de>; Sun, 31 Jul 2022 12:52:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236596AbiGaKwC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 31 Jul 2022 06:52:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236932AbiGaKvn (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 31 Jul 2022 06:51:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24C2311C1D;
        Sun, 31 Jul 2022 03:51:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B5DA060B3D;
        Sun, 31 Jul 2022 10:51:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4F80C433D6;
        Sun, 31 Jul 2022 10:51:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1659264689;
        bh=MunCRz4iDw3y/y30NFQENR1/LutQOobmgpG0mlatK8I=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=wXO2QhbQybadf3Gz9VBoy/niwXFBEKyIVBGHD30RsiX9lUFTogcqzt+e0CfR0LEOc
         wsF1t+iNomP8SoEMWM6EcL0rXPterwNY3MnnEmXWjVSlwUyKq91pMyj09gSsR/3oyS
         pvS7/Qx7AxHSEQPnhimXXXhX81kSJgvoAszRK0bE=
Date:   Sun, 31 Jul 2022 12:51:26 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Tianchen Ding <dtcccc@linux.alibaba.com>
Cc:     ast@kernel.org, linux-kernel@vger.kernel.org, lmb@cloudflare.com,
        sashal@kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 373/575] selftests: bpf: Convert sk_lookup ctx
 access tests to PROG_TEST_RUN
Message-ID: <YuZervPnZnCV32LA@kroah.com>
References: <20211115165356.685521944@linuxfoundation.org>
 <6258c4a1-0132-5afe-8dab-afa4ca3c49d6@linux.alibaba.com>
 <YuEPI/8xAMPl5XDw@kroah.com>
 <d6740ddd-c154-0cba-9ab3-34b55822402a@linux.alibaba.com>
 <2ace00b0-c2db-536f-e55b-f13e02165a8b@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2ace00b0-c2db-536f-e55b-f13e02165a8b@linux.alibaba.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 28, 2022 at 11:09:32AM +0800, Tianchen Ding wrote:
> On 2022/7/28 11:03, Tianchen Ding wrote:
> > On 2022/7/27 18:10, Greg KH wrote:
> > > On Mon, Jul 25, 2022 at 10:53:38AM +0800, Tianchen Ding wrote:
> > > > Hi Greg.
> > > > 
> > > > We found a compile error when building tools/testing/selftests/bpf/ on 5.10.
> > > > 
> > > > tools/testing/selftests/bpf/prog_tests/sk_lookup.c:1092:15: error: 'struct bpf_sk_lookup' has no member named 'cookie'
> > > >   1092 |  if (CHECK(ctx.cookie == 0, "ctx.cookie", "no socket selected\n"))
> > > > 
> > > > It requires 7c32e8f8bc33 ("bpf: Add PROG_TEST_RUN support for sk_lookup programs") from upstream.
> > > > 
> > > > Maybe the left patches of this patchset are needed for 5.10 LTS?
> > > > https://lore.kernel.org/bpf/20210303101816.36774-1-lmb@cloudflare.com/
> > > 
> > > If so, please submit them with the git commit ids so that I can fix this
> > > up.
> > > 
> > > thanks,
> > > 
> > > greg k-h
> > 
> > These 2 commits from upstream are necessary for bpf selftests build pass on 5.10.y:
> > 607b9cc92bd7208338d714a22b8082fe83bcb177 bpf: Consolidate shared test timing code
> > 7c32e8f8bc33a5f4b113a630857e46634e3e143b bpf: Add PROG_TEST_RUN support for sk_lookup programs
> > 
> > This commit does not impact building stage, but can avoid a test case failure (by skipping it):
> > b4f894633fa14d7d46ba7676f950b90a401504bb selftests: bpf: Don't run sk_lookup in verifier tests
> > 
> > Thanks.
> 
> Or should I submit complete patches?

Yes, please submit complete patches.

thanks,

greg k-h
