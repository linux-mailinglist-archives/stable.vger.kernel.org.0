Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A16C59D1B0
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 09:05:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240839AbiHWHEP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 03:04:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240840AbiHWHEN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 03:04:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EFC352DD4;
        Tue, 23 Aug 2022 00:04:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8D535614D8;
        Tue, 23 Aug 2022 07:04:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E4D5C433C1;
        Tue, 23 Aug 2022 07:04:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661238250;
        bh=/ErH2CPzRYTG2tg/l8g8IYvNmSNUuu2eBK3ns9EWnRw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=wH12risihUV3w2niamhFyJBNSW5U2AhMT/N4oArG0qRf9YzYDb+sPWA8fPMPkLOgm
         noxZEmdP7pk0hqnmh8pewnkoe95VLex1voTEVB+Owko3htZgefhfrnVGi26WBt1xf0
         pjPdUauyZtn3uTzxWiZmt3c3VsyuyKNfl9Z8jZ70=
Date:   Tue, 23 Aug 2022 09:04:08 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     RAJESH DASARI <raajeshdasari@gmail.com>
Cc:     Jean-Philippe Brucker <jean-philippe@linaro.org>,
        stable@vger.kernel.org, linux-kernel@vger.kernel.org, df@google.com
Subject: Re: bpf selftest failed in 5.4.210 kernel
Message-ID: <YwR76AVTOsdXNpxh@kroah.com>
References: <CAPXMrf-C5XEUfOJd3GCtgtHOkc8DxDGbLxE5=GFmr+Py0zKxJA@mail.gmail.com>
 <Yv3M8wqMkLwlaHxa@kroah.com>
 <Yv3wZLuPEL9B/h83@myrica>
 <Yv9shQ3i49efHG6f@kroah.com>
 <CAPXMrf8VsNMKNLxFjdytk57mk_9ZC0avg1qCGLSMOZNirpdboQ@mail.gmail.com>
 <YwCGoRt6ifOC6mCD@kroah.com>
 <CAPXMrf-Gc-Mv1goZrk59GG96OLPxEUC-FKT6Dwo6TU6D7po=gw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPXMrf-Gc-Mv1goZrk59GG96OLPxEUC-FKT6Dwo6TU6D7po=gw@mail.gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 22, 2022 at 10:23:02PM +0300, RAJESH DASARI wrote:
> Hi,
> 
> Please find the test scenarios which I have tried.
> 
> Test 1:
> 
> Running system Kernel version (tag/commit) :  v5.4.210
> Kernel source code checkout : v5.4.210
> test_align test case execution status : Failure
> 
> Test 2:
> 
> Running system Kernel version (tag/commit) : v5.4.210
> Kernel source code checkout : v5.4.209
> test_align test case execution status : Failure
> 
> Test 3:
> 
> Running system Kernel version (tag/commit) : v5.4.209
> Kernel source code checkout : v5.4.209
> test_align test case execution status : Success
> 
> Test 4:
> 
> Running system Kernel version (tag/commit) : ACPI: APEI: Better fix to
> avoid spamming the console with old error logs ( Kernel compiled at
> this commit  and system is booted with this change)
> Kernel source code checkout : v5.4.210 but reverted selftests/bpf: Fix
> test_align verifier log patterns and selftests/bpf: Fix "dubious
> pointer arithmetic" test. If I revert only the Fix "dubious pointer
> arithmetic" test, the testcase still fails.
> test_align test case execution status : Success
> 
> Test 5:
> 
> Running system Kernel version (tag/commit) :  v5.4.210 but reverted
> commit (bpf: Verifer, adjust_scalar_min_max_vals to always call
> update_reg_bounds() )
> Kernel source code checkout : v5.4.210 but reverted selftests/bpf: Fix
> test_align verifier log patterns and selftests/bpf: Fix "dubious
> pointer arithmetic" test.
> test_align test case execution status : Success
> 
> Test 6 :
> 
> Running system Kernel version (tag/commit) : bpf: Test_verifier, #70
> error message updates for 32-bit right shift( Kernel compiled at this
> commit  and system is booted with this change)
> Kernel source code checkout : v5.4.209 or v5.4.210
> test_align test case execution status : Failure

I'm sorry, but I don't know what to do with this report at all.

Is there some failure somewhere?  If you use 'git bisect' do you find
the offending commit?

confused,

greg k-h
