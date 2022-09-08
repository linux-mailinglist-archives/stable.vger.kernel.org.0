Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E24FE5B1BFC
	for <lists+stable@lfdr.de>; Thu,  8 Sep 2022 13:56:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230138AbiIHL4g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Sep 2022 07:56:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229783AbiIHL4f (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 8 Sep 2022 07:56:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FBA3E4DC2
        for <stable@vger.kernel.org>; Thu,  8 Sep 2022 04:56:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1C390B82075
        for <stable@vger.kernel.org>; Thu,  8 Sep 2022 11:56:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66DACC433D6;
        Thu,  8 Sep 2022 11:56:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662638190;
        bh=+2FYrQz9gjeurSkDSb8lzYXL4fLdZN4DQT4XaXeR0Ho=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=dup2qn0xCgbhDs3wWTpCF/NMaBtu8i5UnpeMnpIXlUTV/p8nf+8aTNIuRqR17X5gg
         pYcXf50j0DQxsLSqt9xug/IlEzyaTn4L1Y9XAeWNRRGABGPiBLGTKMZnMMTh2dJK96
         0YkgcWr+Om9ali8oL12SvBz1l91cTlDHrtH5tHx4=
Date:   Thu, 8 Sep 2022 13:56:52 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Ovidiu Panait <ovidiu.panait@windriver.com>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 4.14 0/3] bpf: fix CVE-2021-4159
Message-ID: <YxnYhPU3Re3xpTGf@kroah.com>
References: <20220906153855.2515437-1-ovidiu.panait@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220906153855.2515437-1-ovidiu.panait@windriver.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 06, 2022 at 06:38:52PM +0300, Ovidiu Panait wrote:
> All test_verifier/test_align selftests pass in qemu for x86-64 with this
> series applied:
> root@intel-x86-64:~# ./test_verifier
> ...
> #433/p xadd/w check unaligned pkt OK
> #434/p pass unmodified ctx pointer to helper OK
> #435/p pass modified ctx pointer to helper, 1 OK
> #436/u pass modified ctx pointer to helper, 2 OK
> #436/p pass modified ctx pointer to helper, 2 OK
> #437/p pass modified ctx pointer to helper, 3 OK
> Summary: 667 PASSED, 0 FAILED
> 
> root@intel-x86-64:~# ./test_align
> Test   0: mov ... PASS
> Test   1: shift ... PASS
> Test   2: addsub ... PASS
> Test   3: mul ... PASS
> Test   4: unknown shift ... PASS
> Test   5: unknown mul ... PASS
> Test   6: packet const offset ... PASS
> Test   7: packet variable offset ... PASS
> Test   8: packet variable offset 2 ... PASS
> Test   9: dubious pointer arithmetic ... PASS
> Test  10: variable subtraction ... PASS
> Test  11: pointer variable subtraction ... PASS
> Results: 12 pass 0 fail
> 
> 
> John Fastabend (1):
>   bpf: Verifer, adjust_scalar_min_max_vals to always call
>     update_reg_bounds()
> 
> Maxim Mikityanskiy (1):
>   bpf: Fix the off-by-two error in range markings
> 
> Stanislav Fomichev (1):
>   selftests/bpf: Fix test_align verifier log patterns
> 
>  kernel/bpf/verifier.c                       |  1 +
>  tools/testing/selftests/bpf/test_align.c    | 27 +++++++++++----------
>  tools/testing/selftests/bpf/test_verifier.c | 16 ++++++------
>  3 files changed, 23 insertions(+), 21 deletions(-)
> 
> -- 
> 2.37.2
> 

All now queued up, thanks.

greg k-h
