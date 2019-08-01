Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA6287D3BF
	for <lists+stable@lfdr.de>; Thu,  1 Aug 2019 05:38:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727283AbfHADib (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 31 Jul 2019 23:38:31 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:46164 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727000AbfHADib (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 31 Jul 2019 23:38:31 -0400
Received: by mail-pf1-f195.google.com with SMTP id c3so10004907pfa.13
        for <stable@vger.kernel.org>; Wed, 31 Jul 2019 20:38:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=HUAGFQAnsK0ltuLrxJcYqZcxSumtJzlQvJKJd2VykRE=;
        b=f2+FeexuMHIVFz7J1KgaYN2PSAEsfxAGCZHQtPsRXqy8nkBFa/1JRk4lUuh5Sh8HwM
         KTrXZoJfxbnVIbK+2dKF925fE0bOUCbp4T8VHQbnpiyHAvkROzJCzzsTkomdVsGJzZy2
         JbrfU17ZhC6hw3Z/LsHKMav+48o1RMiyFCem90Ax9AAz24Hue2iaNDZbvQFv7/i1YWCg
         ZKtOexqIW6AYvMRd9CfoWkMuBOeZqZRrHXN7txBwnGWQawE2PMRZPp2eQ8l5ON/Rzuhf
         8oQGRRCLBntWU5nVUac9FGgNmw3HIBb4jJY9KRs/vP/OV0UHizBz9XPoUVYsR5z65nMa
         uJ+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=HUAGFQAnsK0ltuLrxJcYqZcxSumtJzlQvJKJd2VykRE=;
        b=QhxeMLt3F31kzuYI7/zso7tVYmudf1qMmEMeidM3fdFhfDxzA5EE69NSGnlD6Gm/Ho
         gyVccSvbwvP0VbemOGuOQxprskvQTAMQJKByvlAFvq7pbo+UBghx1vUUZb5cP0qa2Tw+
         jBS9qSfIx3YGaCtUMnRyzxmWaJL4OXldHUhenXtBwubn5ea7CgSOn96cSuqiw2QMCPWA
         KEjdGldYw+SF2VFr8Y1e2Z5iASdsUUd9g4AEKXFsHSOfc0ShlZ43taCm9JwOdEIZGwDc
         QnyXuYYhIsTX5C7DzjkpxgdKR7SsEKDLrGq3EzWHRb0J9UJAalLsFiMS6lxdYmU4ImNv
         mYYw==
X-Gm-Message-State: APjAAAWJr0mCCJd8hq9KXY0oe0Qc2P3ifK2DbNVg/a3z0yV3ybyPtWpo
        flaAH9FrFoaaoGlg7iO0j67n+g==
X-Google-Smtp-Source: APXvYqxMmvgctv9eNr1FoxklWI9fGHj76piuwk2dDyVLqt2aXh89oHLmf0Y98yP3mORrvE84RBWLjw==
X-Received: by 2002:a17:90a:d996:: with SMTP id d22mr6271335pjv.86.1564630710863;
        Wed, 31 Jul 2019 20:38:30 -0700 (PDT)
Received: from localhost ([122.172.28.117])
        by smtp.gmail.com with ESMTPSA id f19sm102004331pfk.180.2019.07.31.20.38.29
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 31 Jul 2019 20:38:30 -0700 (PDT)
Date:   Thu, 1 Aug 2019 09:08:28 +0530
From:   Viresh Kumar <viresh.kumar@linaro.org>
To:     Mark Rutland <mark.rutland@arm.com>
Cc:     stable@vger.kernel.org, Julien Thierry <Julien.Thierry@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        mark.brown@arm.com
Subject: Re: [PATCH v4.4 V2 11/43] arm64: uaccess: Mask __user pointers for
 __arch_{clear, copy_*}_user
Message-ID: <20190801033828.bfec6k2pln5dva26@vireshk-i7>
References: <cover.1562908074.git.viresh.kumar@linaro.org>
 <7d56c56af2f883958d5e74fa3178a1f774b9fd94.1562908075.git.viresh.kumar@linaro.org>
 <20190731123711.GB39768@lakrids.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190731123711.GB39768@lakrids.cambridge.arm.com>
User-Agent: NeoMutt/20180716-391-311a52
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 31-07-19, 13:37, Mark Rutland wrote:
> On Fri, Jul 12, 2019 at 10:57:59AM +0530, Viresh Kumar wrote:
> > From: Will Deacon <will.deacon@arm.com>
> > 
> > commit f71c2ffcb20dd8626880747557014bb9a61eb90e upstream.
> > 
> > Like we've done for get_user and put_user, ensure that user pointers
> > are masked before invoking the underlying __arch_{clear,copy_*}_user
> > operations.
> > 
> > Signed-off-by: Will Deacon <will.deacon@arm.com>
> > Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> > [ v4.4: fixup for v4.4 style uaccess primitives ]
> > Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> 
> [...]
> 
> >  static inline unsigned long __must_check __copy_from_user(void *to, const void __user *from, unsigned long n)
> >  {
> >  	kasan_check_write(to, n);
> > -	return  __arch_copy_from_user(to, from, n);
> > +	return __arch_copy_from_user(to, __uaccess_mask_ptr(from), n);
> > +
> >  }
> >  
> >  static inline unsigned long __must_check __copy_to_user(void __user *to, const void *from, unsigned long n)
> >  {
> >  	kasan_check_read(from, n);
> > -	return  __arch_copy_to_user(to, from, n);
> > +	return __arch_copy_to_user(__uaccess_mask_ptr(to), from, n);
> > +
> >  }
> 
> Can we please drop the trailing whitespace from each of these? That
> wasn't in the upstreadm commit or v4.9.y.

That was a mistake on my end it seems. Fixed now. Thanks.

-- 
viresh
