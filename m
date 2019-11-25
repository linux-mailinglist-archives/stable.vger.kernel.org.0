Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 69CC7109048
	for <lists+stable@lfdr.de>; Mon, 25 Nov 2019 15:44:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728071AbfKYOos (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Nov 2019 09:44:48 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:34580 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728040AbfKYOos (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Nov 2019 09:44:48 -0500
Received: by mail-wr1-f65.google.com with SMTP id t2so18374777wrr.1
        for <stable@vger.kernel.org>; Mon, 25 Nov 2019 06:44:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=khe/dfoPMKhaf3PxkPvOwwNcBhD8fASQAgj+tzlS8W4=;
        b=uAnJ8STu7tmpUP8ErFcyZT20GB0M0Iyup3frEtXBREMYIkRJLNqF+TjzUCOsX+MXSA
         SAJd6ttTnvC/onz/wl5ZSsdjzqJlV7lBYzvO6Go+72pAJjzfvstpuk+qiLO2xiqLzXpV
         xJsv6KLe8Dibfibf0SrRzFJCDAq8CySNv8RQgWlCVHrIlU0cWguTOtGCKLbg9Qth+nMO
         KYSFDPSvZsHbgtgPqVQz0eZX9k/PoPk5QYx+vJkK4TcRpj4AAf8UGG4y3LO7fCnZ2aiW
         +4h2zspExVbGenx8ylmeHgNOhRFEYtVJpo2unSrra86MG3gLLLSG3KBC6whs94pdsb03
         +EXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=khe/dfoPMKhaf3PxkPvOwwNcBhD8fASQAgj+tzlS8W4=;
        b=b0VZwv04jRrqYZ684MTw3839FHKiYHkgswI1HKyrDbj3x2WNWDea5w6ui8vqSP24jm
         mHom+9Zr5YBFxmAAl8HhKyBFc2VZ09kEcnj1AWCHy/vDfuIuWGsMyLocNGBRfTwgczRZ
         nGquQU3E5Los/cdtbhUs5QkxPiA1zyBfQu1CbRkJ5nlNWwMAPqIx3LfWoaS3Dogul/g8
         H53xGrbvsVxtXfkz9/NL5Ld6h0t6UbCTHeIOsTYL1IjGd500MQjIcalu8f5/v5rMuzbJ
         7ed2doyZn9lfXXbsp+u2uM60YKsPNczMvq1fKPSb3FZP/HSX5+SNJQZvHSzpwsqGSzvG
         wNgg==
X-Gm-Message-State: APjAAAUOiVc3dfljEmtoXQtw2LRIfv+bG2ZwmXNSVtcR6NV0sgrUcWJ/
        rtpMA1+OspDoxhHmYEYqNmTOwX55Njc=
X-Google-Smtp-Source: APXvYqx0qYWa8ijHQreAb3u3sNbKEtPlsdV5upCoDbByr71Xe5JZmESaaH+7WM1exylROvZ3cuCFHw==
X-Received: by 2002:adf:f50b:: with SMTP id q11mr32114387wro.343.1574693084731;
        Mon, 25 Nov 2019 06:44:44 -0800 (PST)
Received: from dell ([95.149.164.72])
        by smtp.gmail.com with ESMTPSA id s11sm11060259wrr.43.2019.11.25.06.44.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Nov 2019 06:44:43 -0800 (PST)
Date:   Mon, 25 Nov 2019 14:44:29 +0000
From:   Lee Jones <lee.jones@linaro.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     gregkh@google.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.9 3/8] arm64: fix for bad_mode() handler to always
 result in panic
Message-ID: <20191125144429.GF3296@dell>
References: <20191122105253.11375-1-lee.jones@linaro.org>
 <20191122105253.11375-3-lee.jones@linaro.org>
 <20191125134700.GA5861@sasha-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20191125134700.GA5861@sasha-vm>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 25 Nov 2019, Sasha Levin wrote:

> On Fri, Nov 22, 2019 at 10:52:48AM +0000, Lee Jones wrote:
> > From: Hari Vyas <hari.vyas@broadcom.com>
> > 
> > [ Upstream commit e4ba15debcfd27f60d43da940a58108783bff2a6 ]
> > 
> > The bad_mode() handler is called if we encounter an uunknown exception,
> > with the expectation that the subsequent call to panic() will halt the
> > system. Unfortunately, if the exception calling bad_mode() is taken from
> > EL0, then the call to die() can end up killing the current user task and
> > calling schedule() instead of falling through to panic().
> > 
> > Remove the die() call altogether, since we really want to bring down the
> > machine in this "impossible" case.
> 
> Should this be in newer LTS kernels too? I don't see it in 4.14. We
> can't take anything into older kernels if it's not in newer ones - we
> don't want to break users who update their kernels.

Only; 3.18, 4.4, 4.9 and 5.3 were studied.

I can look at others if it helps.

-- 
Lee Jones [李琼斯]
Linaro Services Technical Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
