Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBEDB6E5DAF
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 11:42:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231417AbjDRJmA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 05:42:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231407AbjDRJlf (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 05:41:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07D9A76A2;
        Tue, 18 Apr 2023 02:41:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7582662CFB;
        Tue, 18 Apr 2023 09:41:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F5D4C433EF;
        Tue, 18 Apr 2023 09:41:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681810891;
        bh=T7+yT2pUreBDqbXZDE2c2Eq03kSJu9kHFQ2uyasQtNo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=InrJp0SHl8sfq+QUs8insdG7q7IbfNCEmtZJKl7pc3+S+sZjQ1BBgoA9AyS498MHe
         l2xzrQwYkI/kxslAewBsLUY42ICSvTvD5+hRwlbNxlp+wGRTuLb3dt8PeDd/Pzo1Zs
         ich6Z15IXvvY3G5TBtFL4uSeRC5m4yhKqydY/GQM=
Date:   Tue, 18 Apr 2023 11:41:29 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     William Breathitt Gray <william.gray@linaro.org>
Cc:     linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jonathan Cameron <jic23@kernel.org>, stable@vger.kernel.org
Subject: Re: [RESEND PATCH 5.15 v3 5/5] counter: 104-quad-8: Fix race
 condition between FLAG and CNTR reads
Message-ID: <2023041849-nursing-cling-8729@gregkh>
References: <20230411155220.9754-1-william.gray@linaro.org>
 <20230411155220.9754-5-william.gray@linaro.org>
 <ZD1MZO3KpRmuzy42@fedora>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZD1MZO3KpRmuzy42@fedora>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 17, 2023 at 09:40:52AM -0400, William Breathitt Gray wrote:
> On Tue, Apr 11, 2023 at 11:52:20AM -0400, William Breathitt Gray wrote:
> > commit 4aa3b75c74603c3374877d5fd18ad9cc3a9a62ed upstream.
> > 
> > The Counter (CNTR) register is 24 bits wide, but we can have an
> > effective 25-bit count value by setting bit 24 to the XOR of the Borrow
> > flag and Carry flag. The flags can be read from the FLAG register, but a
> > race condition exists: the Borrow flag and Carry flag are instantaneous
> > and could change by the time the count value is read from the CNTR
> > register.
> > 
> > Since the race condition could result in an incorrect 25-bit count
> > value, remove support for 25-bit count values from this driver.
> > 
> > Fixes: 28e5d3bb0325 ("iio: 104-quad-8: Add IIO support for the ACCES 104-QUAD-8")
> > Cc: <stable@vger.kernel.org> # 5.15.x
> > Signed-off-by: William Breathitt Gray <william.gray@linaro.org>
> > ---
> >  drivers/counter/104-quad-8.c | 18 +++---------------
> >  1 file changed, 3 insertions(+), 15 deletions(-)
> > 
> > diff --git a/drivers/counter/104-quad-8.c b/drivers/counter/104-quad-8.c
> > index 0caa60537b..643aae0c9f 100644
> > --- a/drivers/counter/104-quad-8.c
> > +++ b/drivers/counter/104-quad-8.c
> > @@ -61,10 +61,6 @@ struct quad8 {
> >  #define QUAD8_REG_CHAN_OP 0x11
> >  #define QUAD8_REG_INDEX_INPUT_LEVELS 0x16
> >  #define QUAD8_DIFF_ENCODER_CABLE_STATUS 0x17
> > -/* Borrow Toggle flip-flop */
> > -#define QUAD8_FLAG_BT BIT(0)
> > -/* Carry Toggle flip-flop */
> > -#define QUAD8_FLAG_CT BIT(1)
> >  /* Error flag */
> >  #define QUAD8_FLAG_E BIT(4)
> >  /* Up/Down flag */
> > @@ -121,17 +117,9 @@ static int quad8_count_read(struct counter_device *counter,
> >  {
> >  	struct quad8 *const priv = counter->priv;
> >  	const int base_offset = priv->base + 2 * count->id;
> > -	unsigned int flags;
> > -	unsigned int borrow;
> > -	unsigned int carry;
> >  	int i;
> >  
> > -	flags = inb(base_offset + 1);
> > -	borrow = flags & QUAD8_FLAG_BT;
> > -	carry = !!(flags & QUAD8_FLAG_CT);
> > -
> > -	/* Borrow XOR Carry effectively doubles count range */
> > -	*val = (unsigned long)(borrow ^ carry) << 24;
> > +	*val = 0;
> >  
> >  	mutex_lock(&priv->lock);
> >  
> > @@ -699,8 +687,8 @@ static ssize_t quad8_count_ceiling_read(struct counter_device *counter,
> >  
> >  	mutex_unlock(&priv->lock);
> >  
> > -	/* By default 0x1FFFFFF (25 bits unsigned) is maximum count */
> > -	return sprintf(buf, "33554431\n");
> > +	/* By default 0xFFFFFF (24 bits unsigned) is maximum count */
> > +	return sprintf(buf, "16777215\n");
> >  }
> >  
> >  static ssize_t quad8_count_ceiling_write(struct counter_device *counter,
> > 
> > base-commit: d86dfc4d95cd218246b10ca7adf22c8626547599
> > -- 
> > 2.39.2
> 
> Greg,
> 
> This patch will no longer apply to 5.15.x when the "counter: Internalize
> sysfs interface code" patch in the stable-queue tree is merged [0].
> However, I believe the 6.1 backport [1] will apply instead at that
> point. What is the best way to handle this situation? Should I resend
> the 6.1 backport with the stable list Cc tag adjusted for 5.15.x, or are
> you able to apply the 6.1 backport patch directly to the 5.15.x tree?

The 6.1.y backport didn't apply either :(

Can you resend all of these rebased against the next round of stable
releases when they are released later this week?

thanks,

greg k-h
