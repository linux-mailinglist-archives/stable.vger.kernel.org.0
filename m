Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F64A3EF1B3
	for <lists+stable@lfdr.de>; Tue, 17 Aug 2021 20:20:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232693AbhHQSVT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Aug 2021 14:21:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229850AbhHQSVS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Aug 2021 14:21:18 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18F51C0613C1
        for <stable@vger.kernel.org>; Tue, 17 Aug 2021 11:20:45 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id bo19so32743019edb.9
        for <stable@vger.kernel.org>; Tue, 17 Aug 2021 11:20:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=essensium.com; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=JxMZknPb38LEML/Zrl22ADbZSOPinCE/VRi5nWGWDAk=;
        b=PA0YPSPT/zjM5bEyc//9e/LK7/9ORKt+R0DfSzP2LM1QT9rCEMTMm/8yggAlOSiQNe
         P6Vb2m2vXpSGRgiIFaX4UtvsfmAstlOMNQkMhSX9UKoTc7AwLb2KlwWPw6WKu/5jYrv/
         KiPtkO53kzroV+bjaJi7FCDY/pWOKVkqi7od/aLINjO/5Cy02Jq5X1qabP4g178wjYd8
         OEz5+k2yYdKilKtoU7l0dNdbo2VY5rR9aNtkrlqIq1k1NLVctLaI1e1jLJkSfdYuGZDW
         ddrU9e5EvQQLLwMLEBs84gvbaAnrglNoGz2Dh7Wx3L/2Jazh3h59wXKY2ob6YTN6dPB+
         7VNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=JxMZknPb38LEML/Zrl22ADbZSOPinCE/VRi5nWGWDAk=;
        b=RiZN6oot2ktyvcEsFAsBSeUrEzuxu9m7Oqyq/zZiqHBbu3nN6KN3lT+TQMjU6SPk5w
         UFJLtOmRgjiYNMNNBxb3D5dheqbASwiOnWmzTJ09FzcmKodll91edgMl7ECuvXcrOit9
         dsD11scVHj1GLejF8Rn9XFXsQd4rBJtJkkakPLNGkacprRZG4w1Lkwwvp5iG9w2HpnZ8
         Lengg4EOPO3wRhG8YgF35V07HyiplDmn37PrBRVbvwLj4lu9n12XkxMgEezz5Ke/Ab6k
         2urQ2pN80LUKtggf6YLdKIIIrHImWTGjl5lZDSf/lv7egxomNR/yGLLA9uLAwrpnzrdI
         2pAg==
X-Gm-Message-State: AOAM530jKNtlNBB8VdilSsErPYAkYx1/L91jUB8vb5XAwCBgMJJ9C2lP
        +Z/o7nwDEN4tY3UHdU/A0nkfTR5j2Gdi3g==
X-Google-Smtp-Source: ABdhPJyt9pFQrE5UrvhBLr0r70/BhVJQomD3436RtSvk4JV8WfSrQHji5uEfWOJfMVdBalL2I2DriA==
X-Received: by 2002:a05:6402:8da:: with SMTP id d26mr5460218edz.109.1629224442987;
        Tue, 17 Aug 2021 11:20:42 -0700 (PDT)
Received: from cephalopod (168.7-181-91.adsl-dyn.isp.belgacom.be. [91.181.7.168])
        by smtp.gmail.com with ESMTPSA id cr9sm1409545edb.17.2021.08.17.11.20.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Aug 2021 11:20:42 -0700 (PDT)
Date:   Tue, 17 Aug 2021 20:20:40 +0200
From:   Ben Hutchings <ben.hutchings@essensium.com>
To:     Pavel Machek <pavel@denx.de>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 51/96] net: dsa: microchip: Fix ksz_read64()
Message-ID: <20210817182040.GA12678@cephalopod>
References: <20210816125434.948010115@linuxfoundation.org>
 <20210816125436.659359567@linuxfoundation.org>
 <20210817175630.GB30136@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210817175630.GB30136@amd>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 17, 2021 at 07:56:30PM +0200, Pavel Machek wrote:
> Hi!
> 
> > [ Upstream commit c34f674c8875235725c3ef86147a627f165d23b4 ]
> > 
> > ksz_read64() currently does some dubious byte-swapping on the two
> > halves of a 64-bit register, and then only returns the high bits.
> > Replace this with a straightforward expression.
> 
> The code indeed is very strange, but there are just 2 users, and they
> will now receive byteswapped values, right? If it worked before, it
> will be broken.

The old code swaps the bytes within each 32-bit word, attempts to
concatenate them into a 64-bit word, then swaps the bytes within the
64-bit word.  There is no need for byte-swapping, only (on little-
endian platforms) a word-swap, which is what the new code does.

> Did this get enough testing for -stable?

Yes, I actually developed and tested all the ksz8795 changes in 5.10
before forward-porting to mainline.

> Is hw little endian or high endian or...?

The hardware is big-endian and regmap handles any necessary
byte-swapping for values up to 32 bits.

> Note that ksz_write64() still contains the strange code, at least in
> 5.10.

It's unnecessarily complex, but it does work.

Ben.

> 
> Best regards,
> 							Pavel
> 							
> > +++ b/drivers/net/dsa/microchip/ksz_common.h
> > @@ -210,12 +210,8 @@ static inline int ksz_read64(struct ksz_device *dev, u32 reg, u64 *val)
> >  	int ret;
> >  
> >  	ret = regmap_bulk_read(dev->regmap[2], reg, value, 2);
> > -	if (!ret) {
> > -		/* Ick! ToDo: Add 64bit R/W to regmap on 32bit systems */
> > -		value[0] = swab32(value[0]);
> > -		value[1] = swab32(value[1]);
> > -		*val = swab64((u64)*value);
> > -	}
> > +	if (!ret)
> > +		*val = (u64)value[0] << 32 | value[1];
> >  
> >  	return ret;
> >  }
> 
> -- 
> DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
> HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany



-- 
Ben Hutchings · Senior Embedded Software Engineer, Essensium-Mind · mind.be
