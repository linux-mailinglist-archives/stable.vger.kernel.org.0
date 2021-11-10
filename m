Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32EBD44BE24
	for <lists+stable@lfdr.de>; Wed, 10 Nov 2021 10:58:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230455AbhKJKBA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Nov 2021 05:01:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229653AbhKJKBA (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Nov 2021 05:01:00 -0500
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EB21C061766
        for <stable@vger.kernel.org>; Wed, 10 Nov 2021 01:58:12 -0800 (PST)
Received: by mail-wr1-x432.google.com with SMTP id c4so2953377wrd.9
        for <stable@vger.kernel.org>; Wed, 10 Nov 2021 01:58:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=3AbiBQH2HhvwDd/cmsVihdBdDFvYCYJXZoH8Ax426TA=;
        b=VTMuDSrJbZbjIZt8dDCsxg+7KySbWV8k4SzeeO3wirV1IvkgRt/u7zPs/EnQaMMobV
         qUXkVKpnP5lD1OkivTHqFw3S1fUBtKbuupqEG/O6awQBSmDMcJUCjaOngNk3z7iF7j7D
         fenSMNHZfkz8HWvr/Rp2HOf0VNTgMocqwJC7PVmW/ayX93E0gro9S51Ijw8FIUC8/teC
         yRV4dncjCdYEyKULeDoPA+ActfMC6UygutXq/U2q+G+0GdZE9wTyocvT7ObSH6UALUgz
         a4aJM5hsCmm0cSKVdfXMK3BxQupCnRrRBoBLqkkZDnt3YoRmHG1wBCU/VV8+WxXiSszt
         f1dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=3AbiBQH2HhvwDd/cmsVihdBdDFvYCYJXZoH8Ax426TA=;
        b=HtlVf++bIZUUspzU5wGVLgV5APv4JF6h/2gdzSWXu5y0zwmfJgxMEwcxeVZ3Hb8nC3
         PPWHxb/Go+xwcid5W2nMITk/onfX8stZ8AFIHEK8RWGCNGY5k4oo1pD9hHGE4LYSLJ7D
         F/8/meFeBRLoz2Dtm8dgJF8R4mnuP5uZy8XBDzWKUyeNDzYER1Saug92te/Vs3Erj/qt
         uMiOmpC9Jr9fCID3MxmMRDIEqaWkMOTsGtovnNICF4rjQY4oz2yfgnzFTJ/fWDxI/SNj
         jb3VJXXZHcdAPjjMYvdb5ppXhTOH5noCadPFnFUKcK5wmmXW7nHeo2dsBwAZthM8lNGl
         dq2w==
X-Gm-Message-State: AOAM5339/MvOOjoWyxPAFf0NrJos+DRYK1zL3CerxOlTKD/zTECeszeE
        qftBQQ7BFRChTtzh7KQaVIYn5w==
X-Google-Smtp-Source: ABdhPJxBNXK9ALzwPxILP5oIzJfssmCGJCQJWHw7+v593j8ZZy5c/gZK6PcEoJsvCfYey8wvsbo+Tw==
X-Received: by 2002:a5d:64ed:: with SMTP id g13mr18129715wri.222.1636538291167;
        Wed, 10 Nov 2021 01:58:11 -0800 (PST)
Received: from google.com ([95.148.6.174])
        by smtp.gmail.com with ESMTPSA id l16sm5376909wmq.46.2021.11.10.01.58.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Nov 2021 01:58:10 -0800 (PST)
Date:   Wed, 10 Nov 2021 09:58:03 +0000
From:   Lee Jones <lee.jones@linaro.org>
To:     Greg KH <greg@kroah.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Andreas Kemnade <andreas@kemnade.info>,
        "H . Nikolaus Schaller" <hns@goldelico.com>,
        Johan Hovold <johan@kernel.org>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH 4.9 1/2] net: hso: register netdev later to avoid a race
 condition
Message-ID: <YYuXq3wOdmWc+8lo@google.com>
References: <20211109093959.173885-1-lee.jones@linaro.org>
 <YYuCE9EoMu+4zsiF@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YYuCE9EoMu+4zsiF@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 10 Nov 2021, Greg KH wrote:

> On Tue, Nov 09, 2021 at 09:39:58AM +0000, Lee Jones wrote:
> > From: Andreas Kemnade <andreas@kemnade.info>
> > 
> > [ Upstream commit 4c761daf8bb9a2cbda9facf53ea85d9061f4281e ]
> 
> You already sent this for inclusion:
> 	https://lore.kernel.org/r/YYU1KqvnZLyPbFcb@google.com
> 
> Why send it again?

The real question is; why didn't I sent patch 2 at the same time!

> confused,

I feel ya! ;)

-- 
Lee Jones [李琼斯]
Senior Technical Lead - Developer Services
Linaro.org │ Open source software for Arm SoCs
Follow Linaro: Facebook | Twitter | Blog
