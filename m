Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4336600ABC
	for <lists+stable@lfdr.de>; Mon, 17 Oct 2022 11:31:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230377AbiJQJbW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Oct 2022 05:31:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230171AbiJQJbV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Oct 2022 05:31:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF14D43AFF
        for <stable@vger.kernel.org>; Mon, 17 Oct 2022 02:31:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5B59460FEA
        for <stable@vger.kernel.org>; Mon, 17 Oct 2022 09:31:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EE63C433D6;
        Mon, 17 Oct 2022 09:31:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665999079;
        bh=h5OfqpTkK4BQEMxzBXK42XdmfPXSYa8WgK0sx0XIw+s=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MZBWsOH0uJ6nQRaYCznWi7znmlIoICpoUICYSdkqD9aAxz2ovLaWArlgEd43Jag1d
         a8LnWoIRIweeYsoCgbW/t8eFy4aJAt29OcIg3PyjADkgpS88aB8l3zcyqvNcXJ6Iwe
         wiS8FnSf21tWRFKgaIvwasVTBiXubuazss9+01jo=
Date:   Mon, 17 Oct 2022 11:32:06 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Sergey Shtylyov <s.shtylyov@omp.ru>
Cc:     Will Deacon <will@kernel.org>, stable@vger.kernel.org,
        lvc-project@linuxtesting.org, lvc-patches@linuxtesting.org
Subject: Re: [PATCH 5.10.y] arm64: topology: fix possible overflow in
 amu_fie_setup()
Message-ID: <Y00hFkO1dB+cLffB@kroah.com>
References: <012bfa47-1597-c0f8-b51a-6a927019b5a6@omp.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <012bfa47-1597-c0f8-b51a-6a927019b5a6@omp.ru>
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Oct 16, 2022 at 11:21:38PM +0300, Sergey Shtylyov wrote:
> Commit d4955c0ad77dbc684fc716387070ac24801b8bca upstream.
> 
> cpufreq_get_hw_max_freq() returns max frequency in kHz as *unsigned int*,
> while freq_inv_set_max_ratio() gets passed this frequency in Hz as 'u64'.
> Multiplying max frequency by 1000 can potentially result in overflow --
> multiplying by 1000ULL instead should avoid that...
> 
> Found by Linux Verification Center (linuxtesting.org) with the SVACE static
> analysis tool.
> 
> Fixes: cd0ed03a8903 ("arm64: use activity monitors for frequency invariance")
> Signed-off-by: Sergey Shtylyov <s.shtylyov@omp.ru>
> Link: https://lore.kernel.org/r/01493d64-2bce-d968-86dc-11a122a9c07d@omp.ru
> Signed-off-by: Will Deacon <will@kernel.org>

Now queued up, thanks.

greg k-h
