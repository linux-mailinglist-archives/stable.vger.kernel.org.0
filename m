Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D1625BBEC3
	for <lists+stable@lfdr.de>; Sun, 18 Sep 2022 17:52:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229602AbiIRPwq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Sep 2022 11:52:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229553AbiIRPwp (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 18 Sep 2022 11:52:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 706A41E3EE;
        Sun, 18 Sep 2022 08:52:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 183A8B81054;
        Sun, 18 Sep 2022 15:52:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5937C433D6;
        Sun, 18 Sep 2022 15:52:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663516361;
        bh=SVK3Agc3LNoXUChFnh7QveTqHR+NtRh1+3bGbG8NVkc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=N0OGAnMxbckfHkBPRrvTlxyGZUNLlQhK6byDCTOvgq+GI25wge7Z//XrI1JBicbii
         kbvEWgd2VHMbe0Z9N7+7ezltBLCA+WpnQCdsaaPPmPrVMTLt8DETtQNbMoVZYrJaa8
         ZnFa8JYH4fA7y9WfVIM9MrkYWslHlY7fPX/xDV4mZDHFq2RDGMMAhZmDPfJQYBh2sE
         cCuCncaYqGH0bY1fRv02DSPp/tTAYVNZ2R7+rt5xAgu8WJauQw7T6UMx6Mve6La+Yx
         wos4YjygFZ9nKLzJToBOjkjHKTYL28JYuMM8G+kxI2gmOau2WVViRELHO23S5W4Ze0
         ZxNm52PkXLcsw==
Date:   Sun, 18 Sep 2022 16:52:45 +0100
From:   Jonathan Cameron <jic23@kernel.org>
To:     Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc:     Andy Shevchenko <andy.shevchenko@gmail.com>,
        Eddie James <eajames@linux.ibm.com>, <lars@metafoo.de>,
        <linux-iio@vger.kernel.org>, <joel@jms.id.au>,
        <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
Subject: Re: [PATCH v8 2/2] iio: pressure: dps310: Reset chip after timeout
Message-ID: <20220918165245.005c757a@jic23-huawei>
In-Reply-To: <20220916162535.00000cf6@huawei.com>
References: <20220915195719.136812-1-eajames@linux.ibm.com>
        <20220915195719.136812-3-eajames@linux.ibm.com>
        <CAHp75VfEktq10YcQMF9D9cQWtVsR+gx+3_PAq1YNoKUWEZaC1Q@mail.gmail.com>
        <20220916162535.00000cf6@huawei.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.34; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 16 Sep 2022 16:25:35 +0100
Jonathan Cameron <Jonathan.Cameron@huawei.com> wrote:

> On Fri, 16 Sep 2022 08:51:13 +0300
> Andy Shevchenko <andy.shevchenko@gmail.com> wrote:
> 
> > On Thu, Sep 15, 2022 at 10:57 PM Eddie James <eajames@linux.ibm.com> wrote:  
> > >
> > > The DPS310 chip has been observed to get "stuck" such that pressure
> > > and temperature measurements are never indicated as "ready" in the
> > > MEAS_CFG register. The only solution is to reset the device and try
> > > again. In order to avoid continual failures, use a boolean flag to
> > > only try the reset after timeout once if errors persist.    
> > 
> > ...
> >   
> > > +static int dps310_ready(struct dps310_data *data, int ready_bit, int timeout)
> > > +{
> > > +       int rc;
> > > +
> > > +       rc = dps310_ready_status(data, ready_bit, timeout);
> > > +       if (rc) {    
> >   
> > > +               if (rc == -ETIMEDOUT && !data->timeout_recovery_failed) {    
> > 
> > Here you compare rc with a certain error code...
> >   
> > > +                       /* Reset and reinitialize the chip. */
> > > +                       if (dps310_reset_reinit(data)) {
> > > +                               data->timeout_recovery_failed = true;
> > > +                       } else {
> > > +                               /* Try again to get sensor ready status. */    
> >   
> > > +                               if (dps310_ready_status(data, ready_bit, timeout))    
> > 
> > ...but here you assume that the only error code is -ETIMEDOUT. It's
> > kinda inconsistent (if you rely on internals of ready_status, then why
> > to check the certain error code, or otherwise why not to return a real
> > second error code). That's why I asked about re-using rc here.  
> 
> Hmm.
> 
> 1st time around, any other error code would result in us just returning directly
> which is fine.
> 2nd time around I'm not sure we care about what the error code is.  Even if
> something else went wrong we failed to recover and the first error
> that lead to that was -ETIMEDOUT.
> 
> So I think this is correct as is, be it a little unusual!

Given timing late in the cycle, I've queued this up for the next merge
window rather than rushing it in.

Applied to the togreg branch of iio.git and pushed out as testing.
Note I plan to rebase that branch shortly as I need some stuff that
is in upstream for other series.  Hence still time for this discussion to
continue if anyone wants to!

Thanks,

Jonathan

> 
> Jonathan
> 
> > 
> > In any case I don't think this justifies a v9, let's wait for your
> > answer and Jonathan's opinion.
> >   
> > > +                                       data->timeout_recovery_failed = true;
> > > +                               else
> > > +                                       return 0;
> > > +                       }
> > > +               }
> > > +
> > > +               return rc;
> > > +       }
> > > +
> > > +       data->timeout_recovery_failed = false;
> > > +       return 0;
> > > +}    
> >   
> 

