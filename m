Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 931434B86BD
	for <lists+stable@lfdr.de>; Wed, 16 Feb 2022 12:34:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229904AbiBPLeS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Feb 2022 06:34:18 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:49978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231660AbiBPLeR (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Feb 2022 06:34:17 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF8A51F8C9D;
        Wed, 16 Feb 2022 03:34:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4CDE8B81E9B;
        Wed, 16 Feb 2022 11:34:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E7F4C004E1;
        Wed, 16 Feb 2022 11:33:57 +0000 (UTC)
Date:   Wed, 16 Feb 2022 17:03:53 +0530
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To:     Alex Elder <elder@linaro.org>
Cc:     mhi@lists.linux.dev, quic_hemantk@quicinc.com,
        quic_bbhatt@quicinc.com, quic_jhugo@quicinc.com,
        vinod.koul@linaro.org, bjorn.andersson@linaro.org,
        dmitry.baryshkov@linaro.org, quic_vbadigan@quicinc.com,
        quic_cang@quicinc.com, quic_skananth@quicinc.com,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paul Davey <paul.davey@alliedtelesis.co.nz>,
        Hemant Kumar <hemantk@codeaurora.org>, stable@vger.kernel.org
Subject: Re: [PATCH v3 01/25] bus: mhi: Fix pm_state conversion to string
Message-ID: <20220216113353.GB6225@workstation>
References: <20220212182117.49438-1-manivannan.sadhasivam@linaro.org>
 <20220212182117.49438-2-manivannan.sadhasivam@linaro.org>
 <0c95c9a5-cf66-dcec-bfde-0ca201206c8b@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0c95c9a5-cf66-dcec-bfde-0ca201206c8b@linaro.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 15, 2022 at 02:01:54PM -0600, Alex Elder wrote:
> On 2/12/22 12:20 PM, Manivannan Sadhasivam wrote:
> > From: Paul Davey <paul.davey@alliedtelesis.co.nz>
> > 
> > On big endian architectures the mhi debugfs files which report pm state
> > give "Invalid State" for all states.  This is caused by using
> > find_last_bit which takes an unsigned long* while the state is passed in
> > as an enum mhi_pm_state which will be of int size.
> 
> I think this would have fixed it too, but your fix is better.
> 
> 	int index = find_last_bit(&(unsigned long)state, 32);
> 
> > Fix by using __fls to pass the value of state instead of find_last_bit.
> > 
> > Fixes: a6e2e3522f29 ("bus: mhi: core: Add support for PM state transitions")
> > Signed-off-by: Paul Davey <paul.davey@alliedtelesis.co.nz>
> > Reviewed-by: Manivannan Sadhasivam <mani@kernel.org>
> > Reviewed-by: Hemant Kumar <hemantk@codeaurora.org>
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
> > ---
> >   drivers/bus/mhi/core/init.c | 8 +++++---
> >   1 file changed, 5 insertions(+), 3 deletions(-)
> > 
> > diff --git a/drivers/bus/mhi/core/init.c b/drivers/bus/mhi/core/init.c
> > index 046f407dc5d6..af484b03558a 100644
> > --- a/drivers/bus/mhi/core/init.c
> > +++ b/drivers/bus/mhi/core/init.c
> > @@ -79,10 +79,12 @@ static const char * const mhi_pm_state_str[] = {
> >   const char *to_mhi_pm_state_str(enum mhi_pm_state state)
> 
> The mhi_pm_state enumerated type is an enumerated sequence, not
> a bit mask.  So knowing what the last (most significant) set bit
> is not meaningful.  Or normally it shouldn't be.
> 
> If mhi_pm_state really were a bit mask, then its values should
> be defined that way, i.e.,
> 
> 	MHI_PM_STATE_DISABLE	= 1 << 0,
> 	MHI_PM_STATE_DISABLE	= 1 << 1,
> 	. . .
> 
> What's really going on is that the state value passed here
> *is* a bitmask, whose bit positions are those mhi_pm_state
> values.  So the state argument should have type u32.
> 

I agree with you. It should be u32.

> This is a *separate* bug/issue.  It could be fixed separately
> (before this patch), but I'd be OK with just explaining why
> this change would occur as part of this modified patch.
> 

It makes sense to do it in the same patch itself as the change is
minimal and moreover this patch will also get backported to stable.

> >   {
> > -	unsigned long pm_state = state;
> > -	int index = find_last_bit(&pm_state, 32);
> > +	int index;
> > -	if (index >= ARRAY_SIZE(mhi_pm_state_str))
> > +	if (state)
> > +		index = __fls(state);
> > +
> > +	if (!state || index >= ARRAY_SIZE(mhi_pm_state_str))
> >   		return "Invalid State";
> 
> Do this test and return first, and skip the additional
> check for "if (state)".
> 

We need to calculate index for the second check, so I guess the current
code is fine.

Thanks,
Mani

> 					-Alex
> 
> >   	return mhi_pm_state_str[index];
> 
