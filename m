Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B2F85A0FAD
	for <lists+stable@lfdr.de>; Thu, 25 Aug 2022 13:57:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239725AbiHYL5q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Aug 2022 07:57:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236914AbiHYL5n (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Aug 2022 07:57:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B37FBA50E8
        for <stable@vger.kernel.org>; Thu, 25 Aug 2022 04:57:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 70A12B828F3
        for <stable@vger.kernel.org>; Thu, 25 Aug 2022 11:57:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8E68C433C1;
        Thu, 25 Aug 2022 11:57:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661428660;
        bh=36W6aA9xUgOkEVfBcJlRoSJ7Vt2ETGa0oJ0UVTcy8wY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=EDqtedL7KIwNJSSJGCAlwzimQHjepDQW5x6wOMYoFNmSukeNzXbvfTcR49r3inHTt
         mwhN6laWsEeAHo/QzsWCdZm+mXOkkctQWtbzzZeIx6WIZBT00y/CMAIt6pGhu9hCYa
         C6KEQFLvoKLmIzGsRA2X6jTiCvl5czuO5J5tLi3g=
Date:   Thu, 25 Aug 2022 13:57:37 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jean-Philippe Brucker <jean-philippe@linaro.org>
Cc:     stable@vger.kernel.org, raajeshdasari@gmail.com,
        ovidiu.panait@windriver.com
Subject: Re: [PATCH 5.4 0/2] Revert BPF selftest fixes in 5.4.y
Message-ID: <YwdjsTYdkS69AFvt@kroah.com>
References: <20220824144327.277365-1-jean-philippe@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220824144327.277365-1-jean-philippe@linaro.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Aug 24, 2022 at 03:43:26PM +0100, Jean-Philippe Brucker wrote:
> Rajesh reports [1] that the test_align BPF selftest is broken in
> 5.4.210. Three patches were added since 5.4.209:
> 
> (A) 7c1134c7da99 ("bpf: Verifer, adjust_scalar_min_max_vals to always call update_reg_bounds()")
> (B) 6a9b3f0f3bad ("selftests/bpf: Fix test_align verifier log patterns")
> (C) 6098562ed9df ("selftests/bpf: Fix "dubious pointer arithmetic" test")
> 
> (A) fixes an issue in the BPF verifier, which changes the verifier trace
> output. (B) fixes those trace changes in the selftests.
> 
> Unfortunately (B) also address changes to the verifier output from other
> patches that weren't backported to v5.4, so the test now fails.
> (C) also addresses a different verifier change that is not in v5.4.
> 
> Therefore revert (C), and partially revert (B).
> 
> [1] https://lore.kernel.org/all/CAPXMrf-C5XEUfOJd3GCtgtHOkc8DxDGbLxE5=GFmr+Py0zKxJA@mail.gmail.com/
> 
> Jean-Philippe Brucker (2):
>   Revert "selftests/bpf: Fix "dubious pointer arithmetic" test"
>   Revert "selftests/bpf: Fix test_align verifier log patterns"
> 
>  tools/testing/selftests/bpf/test_align.c | 14 +++++++-------
>  1 file changed, 7 insertions(+), 7 deletions(-)
> 
> -- 
> 2.37.1
> 

Now queued up, thanks.

greg k-h
