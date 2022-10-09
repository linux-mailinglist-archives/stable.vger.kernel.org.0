Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F15705F8D0E
	for <lists+stable@lfdr.de>; Sun,  9 Oct 2022 20:18:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229935AbiJISSB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Oct 2022 14:18:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229996AbiJISRh (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 Oct 2022 14:17:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8639CE1A;
        Sun,  9 Oct 2022 11:17:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C35D9B80D13;
        Sun,  9 Oct 2022 18:17:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 093F1C433D6;
        Sun,  9 Oct 2022 18:17:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665339428;
        bh=WlUVYWcv0RSfNrnisKDi/OW/RV7h0cjuQQ19bFBOoog=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Rw38q9pBwLqsPyZDDYNCUJVBM/wQdBpInwfKXrazRDvratMB1+6APuHPbMdcHL+tR
         alh1uFrcM2QaDGYEEa9Ik0BNxthXgmQq9lBiv8sDxOxB4YOspqrAFf70S0yVAsH5yg
         DoiwdVTyLl225YVSwhFR/J3E6MuPtUqjH3skq9iE=
Date:   Sun, 9 Oct 2022 20:17:51 +0200
From:   'Greg Kroah-Hartman' <gregkh@linuxfoundation.org>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc:     David Laight <David.Laight@aculab.com>,
        Andrew Chernyakov <acherniakov@astralinux.ru>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@somainline.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-remoteproc@vger.kernel.org" <linux-remoteproc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "lvc-project@linuxtesting.org" <lvc-project@linuxtesting.org>,
        Stephen Boyd <sboyd@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>
Subject: Re: [PATCH 5.10 1/1] rpmsg: qcom: glink: replace strncpy() with
 strscpy_pad()
Message-ID: <Y0MQT2z+nc8+0WPY@kroah.com>
References: <20221007132931.123755-1-acherniakov@astralinux.ru>
 <20221007132931.123755-2-acherniakov@astralinux.ru>
 <Y0BWc6A8C++M9TWP@kroah.com>
 <36f776cbc16f4e988d96b7bcb77cd559@AcuMS.aculab.com>
 <e829329e-ac55-e04a-c8ab-4eeeec6217ab@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e829329e-ac55-e04a-c8ab-4eeeec6217ab@linaro.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Oct 09, 2022 at 05:23:06PM +0200, Krzysztof Kozlowski wrote:
> On 08/10/2022 23:11, David Laight wrote:
> >>> ---
> >>>  drivers/rpmsg/qcom_glink_native.c | 2 +-
> >>>  drivers/rpmsg/qcom_smd.c          | 4 ++--
> >>>  2 files changed, 3 insertions(+), 3 deletions(-)
> >>
> >> Why just this specific kernel branch?  We can't add patches to an older
> >> tree and have someone upgrade to a newer one and hit the same issue.
> >>
> >> So please provide backports for all active versions.  In this case that
> >> would be 5.15.y and 5.19.y.
> > 
> > If it is only fixing a compile warning is it even stable material?
> > The generic commit message doesn't say whether the old code was
> > actually right or wrong.
> > 
> > At least one of these 'replace strncpy()' changes was definitely
> > broken (the copy needed to be equivalent to memcpy()).
> > 
> > So applying ANY of them to stable unless they actually fix
> > a real bug seems dubious.
> 
> Except the warning from GCC, there was no bug to fix. The warning is
> about discouraged and risky practice, but no actual real risk was
> identified, so for me it matches stable rules poorly.
> 
> It's basically backporting to silence automated code checkers...

Are you sure?  Look at the code path here, there might be a way to
overflow the string, from the virtio interface, but I might be wrong...

Anyway, I need all the backports before I can take this one, sorry.

greg k-h
