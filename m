Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D7A7599A55
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 13:03:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348311AbiHSK5O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 06:57:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347912AbiHSK5N (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 06:57:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CA34F47D5;
        Fri, 19 Aug 2022 03:57:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D6F0A615FC;
        Fri, 19 Aug 2022 10:57:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7E66C433D6;
        Fri, 19 Aug 2022 10:57:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660906632;
        bh=cLUYf4HbteXyxGdivlNYB7UKIKFNgOPMrepEztjtCso=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=1vsNTt9PO/DkgMT/+dB4QZcRUxYMz2raRuCJEo5Csp5/qwPU12+9A4UUDDR3d5C2v
         JeTlzlG9dMaLMOI1E2owwma7Xw964I7SJY1o/clMaZQCkMWzaHdbkoBDBtZeA4fH5v
         JNhT6qZ2t/+lUoUj/78mwKotKLB3VW30CRZ3M2zQ=
Date:   Fri, 19 Aug 2022 12:57:09 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jean-Philippe Brucker <jean-philippe@linaro.org>
Cc:     RAJESH DASARI <raajeshdasari@gmail.com>, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org, df@google.com
Subject: Re: bpf selftest failed in 5.4.210 kernel
Message-ID: <Yv9shQ3i49efHG6f@kroah.com>
References: <CAPXMrf-C5XEUfOJd3GCtgtHOkc8DxDGbLxE5=GFmr+Py0zKxJA@mail.gmail.com>
 <Yv3M8wqMkLwlaHxa@kroah.com>
 <Yv3wZLuPEL9B/h83@myrica>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yv3wZLuPEL9B/h83@myrica>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Aug 18, 2022 at 08:55:16AM +0100, Jean-Philippe Brucker wrote:
> On Thu, Aug 18, 2022 at 07:24:03AM +0200, Greg KH wrote:
> > On Wed, Aug 17, 2022 at 09:22:00PM +0300, RAJESH DASARI wrote:
> > > Hi ,
> > > 
> > > We are running bpf selftests on 5.4.210 kernel version and we see that
> > > test case 11 of  test_align failed. Please find the below error.
> > > 
> > > selftests: bpf: test_align
> > > Test  11: pointer variable subtraction ... Failed to find match 16:
> > > R5_w=pkt(id=2,off=0,r=0,umin_value=2,umax_value=1082,var_off=(0x2;
> > > 0xfffffffc)
> > > # func#0 @0
> > > # 0: R1=ctx(id=0,off=0,imm=0) R10=fp0
> > > # 0: (61) r2 = *(u32 *)(r1 +76)
> > > # 1: R1=ctx(id=0,off=0,imm=0) R2_w=pkt(id=0,off=0,r=0,imm=0) R10=fp0
> > > # 1: (61) r3 = *(u32 *)(r1 +80)
> > > 
> > > For complete errors please see the attached file. The same test case
> > > execution was successful in the 5.4.209 version , could you please let
> > > me know any known issue with the recent changes in 5.4.210 and how to
> > > fix these errors.
> > 
> > Can you use 'git bisect' to find the offending commit?
> 
> It probably is 6098562ed9df ("selftests/bpf: Fix "dubious pointer
> arithmetic" test")
> https://lore.kernel.org/all/20220803145005.2385039-6-ovidiu.panait@windriver.com/
> Could you try reverting that?
> 
> The patch didn't have a Fixes: tags, because the bugfix it refers to was
> merged at the same time. That bugfix is upstream commit b02709587ea3
> ("bpf: Fix propagation of 32-bit signed bounds from 64-bit bounds.")
> 
> Since b02709587ea3 was only backported down to 5.10, this fix shouldn't be
> in 5.4. Sorry for not catching this earlier.

Can you send in a revert for this?

thanks,

greg k-h
