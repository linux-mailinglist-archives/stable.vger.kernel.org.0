Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B07855A93EA
	for <lists+stable@lfdr.de>; Thu,  1 Sep 2022 12:10:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233318AbiIAKKH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Sep 2022 06:10:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233351AbiIAKKC (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Sep 2022 06:10:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DADC1262A
        for <stable@vger.kernel.org>; Thu,  1 Sep 2022 03:10:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DFE5161BBD
        for <stable@vger.kernel.org>; Thu,  1 Sep 2022 10:10:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 772A9C433C1;
        Thu,  1 Sep 2022 10:09:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662027000;
        bh=eQK1dW8MpFgNWago+wyyY/BQo8fhq2coqW9OZSsqews=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TrYY4KWt+AFa2kr5YpvXktVZi5xuCXoRmkSPh1lFzZDc1yeZBBawwgFKX2TChy6p6
         YIeZAbddGyLJjObN1joCELPLWUKuLY7Vkv6aaSnsXWNLFbU6uuncJeKZYJssgiYQJV
         ugpYLKArsd49YUh77Fd6EJOOiIgtlKjRd8XTUUgM=
Date:   Thu, 1 Sep 2022 12:09:52 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Ovidiu Panait <ovidiu.panait@windriver.com>
Cc:     stable@vger.kernel.org, raajeshdasari@gmail.com,
        jean-philippe@linaro.org
Subject: Re: [PATCH 4.19 0/2] bpf: fix test_verifier, test_align selftests
Message-ID: <YxCE8IvP3Xfn7QAV@kroah.com>
References: <20220829115054.1714528-1-ovidiu.panait@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220829115054.1714528-1-ovidiu.panait@windriver.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 29, 2022 at 02:50:52PM +0300, Ovidiu Panait wrote:
> Backport of upstream commits [1] and [2] to 4.19-stable broke test_verifier and
> test_align bpf selftests.
> [1] 2fa7d94afc1a ("bpf: Fix the off-by-two error in range markings")
> [2] 294f2fc6da27 ("bpf: Verifer, adjust_scalar_min_max_vals to always call
>                    update_reg_bounds()")
> 
> This series fixes all failing test_verifier/test_align testcases for 4.19:
> root@intel-x86-64:~/bpf# ./test_verifier
> ...
> #664/p mov64 src == dst OK
> #665/p mov64 src != dst OK
> #666/u calls: ctx read at start of subprog OK
> #666/p calls: ctx read at start of subprog OK
> Summary: 932 PASSED, 0 SKIPPED, 0 FAILED
> 
> root@intel-x86-64:~/bpf# ./test_align
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
> Maxim Mikityanskiy (1):
>   bpf: Fix the off-by-two error in range markings
> 
> Stanislav Fomichev (1):
>   selftests/bpf: Fix test_align verifier log patterns
> 
>  tools/testing/selftests/bpf/test_align.c    | 27 ++++++++---------
>  tools/testing/selftests/bpf/test_verifier.c | 32 ++++++++++-----------
>  2 files changed, 30 insertions(+), 29 deletions(-)
> 
> -- 
> 2.37.2
> 

Now queued up, thanks!

greg k-h
