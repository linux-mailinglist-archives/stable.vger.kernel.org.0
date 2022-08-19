Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43568599A3F
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 13:03:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348457AbiHSK7s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 06:59:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348452AbiHSK7o (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 06:59:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2005FE3437
        for <stable@vger.kernel.org>; Fri, 19 Aug 2022 03:59:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B09DF6171A
        for <stable@vger.kernel.org>; Fri, 19 Aug 2022 10:59:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEEA2C433D6;
        Fri, 19 Aug 2022 10:59:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660906783;
        bh=n/6mDRxoySbtV/WRQ70q3Fy9Tqdf5C76YqNFdDSORDs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ETTvgszjCmkP/K2JO4eb9OVT84uiLvU6JReZ6jkvFa/aXCE8MKWvvPRrCKfVO5df0
         pkdE/Krb+KVLOGTvNmZuxSP3Uw/qQN8q3Xx+XTJRZa9Pqv/FvZ1ywVOsjIC5kzIe/Y
         4f/RvuLUswP+kWmxJ/fTd5jYAt5yhDLvrC1Gz5eo=
Date:   Fri, 19 Aug 2022 12:59:40 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Ovidiu Panait <ovidiu.panait@windriver.com>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 4.19 v2 1/1] selftests/bpf: add selftest part of "bpf:
 Fix the off-by-two error in range markings"
Message-ID: <Yv9tHCv94OLc/MhE@kroah.com>
References: <20220816102653.1038200-1-ovidiu.panait@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220816102653.1038200-1-ovidiu.panait@windriver.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 16, 2022 at 01:26:53PM +0300, Ovidiu Panait wrote:
> Cherry-pick selftest changes from upstream commit 2fa7d94afc1a ("bpf: Fix the
> off-by-two error in range markings") to fix the following verifier selftest
> failures:
>  # root@intel-x86-64:~# ./test_verifier
>  ...
>  #495/p XDP pkt read, pkt_end > pkt_data', bad access 1 FAIL
>  #498/p XDP pkt read, pkt_data' < pkt_end, bad access 1 FAIL
>  #504/p XDP pkt read, pkt_data' >= pkt_end, bad access 1 FAIL
>  #513/p XDP pkt read, pkt_end <= pkt_data', bad access 1 FAIL
>  #519/p XDP pkt read, pkt_data > pkt_meta', bad access 1 FAIL
>  #522/p XDP pkt read, pkt_meta' < pkt_data, bad access 1 FAIL
>  #528/p XDP pkt read, pkt_meta' >= pkt_data, bad access 1 FAIL
>  #537/p XDP pkt read, pkt_data <= pkt_meta', bad access 1 FAIL
>  Summary: 924 PASSED, 0 SKIPPED, 8 FAILED
> 
> Fixes: c315bd962528 ("bpf: Fix the off-by-two error in range markings")
> Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
> ---
>  tools/testing/selftests/bpf/test_verifier.c | 32 ++++++++++-----------
>  1 file changed, 16 insertions(+), 16 deletions(-)

You lost the authorship information of the original commit, as well as
all of the people on it and the needed information.  And you did not cc:
anyone involved in that work at all :(

Just backport that patch again with the correct tests added, and skip
the non-test portion.

thanks,

greg k-h
