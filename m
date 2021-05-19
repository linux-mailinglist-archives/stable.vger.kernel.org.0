Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEDBF389402
	for <lists+stable@lfdr.de>; Wed, 19 May 2021 18:42:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238184AbhESQoQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 May 2021 12:44:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237631AbhESQoP (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 May 2021 12:44:15 -0400
Received: from mail-oi1-x22e.google.com (mail-oi1-x22e.google.com [IPv6:2607:f8b0:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB72DC06175F
        for <stable@vger.kernel.org>; Wed, 19 May 2021 09:42:55 -0700 (PDT)
Received: by mail-oi1-x22e.google.com with SMTP id j75so13646008oih.10
        for <stable@vger.kernel.org>; Wed, 19 May 2021 09:42:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=07kxjuOM5YGV5y9ksKsbfrEbNUkDqxZpp6t2B4xCaXw=;
        b=ZxBZJmCy9knMmt+Oho4XCUdHOcrslt+BY/YaLfKtMSG5v4pdgGLXqzZft29xMw6Urx
         y+tggDqf7+BO4fmLNnE+e77d7rcKrC9gCcx0zraSju2xcmip+YM4oNAlwn9MjV3bo4nG
         dL4IoX8FfwfOM5XKLBUmC3sf+A7G2kQfQEnU1Zb05k/Bk39piPxxt9oF1+MXUAIhiopf
         l90OcOAtdZiF/wjtQ8/ILwtAqC55KIHflvkLtF5tTRm+lFqmfIsfSqMuIN9nu6/O3RZ5
         qa8CHIoMLEphEJ3gVeX1kyccdQ8/gudXetTpJjm3tr+2cgBpQEVo/dtuITKMa7H2TchV
         N8jQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=07kxjuOM5YGV5y9ksKsbfrEbNUkDqxZpp6t2B4xCaXw=;
        b=KM3SAHxxL4szAVRXSuBrF7k0JHBob7o8XbTHap6zdQpVRqRtytVq6rMGRFBY8wD8MS
         s7z8ykWKOGiOfXRHR6mhgzUYHSLSb0aJVmd0mQAQ97xU6UKWYQGwpoQb38dRFzuzKhRw
         PEyOXW0MVursDu3OnUUg9buMmLLAIPp3FXTHycOyprrOeyQL6lYTDQ2Myh0/mSSHRInc
         1dJaakEVSHe3NosSJR/fJ155V73GsYJU7WIcbZHOhlIoCzmws+K221d/4eMM4LutvSP/
         VIJV0OzkBCPh69xKGv9zD+whi+mjPnrrmpwbry8pGVNSkh4EBm5adb28l6F2u6lPpEpk
         GMAA==
X-Gm-Message-State: AOAM5300/ZQ/a3DESzw0bx4kaKb2Zr0hyWrEHJSuOXSbFO+mFPYwZ/xs
        WEDT78FgtJvyqf79RczAgJmiP3WXq0qpQKxdQljqv+dyoAk=
X-Google-Smtp-Source: ABdhPJzqMMiWHxY2aQz2e8Xw5mK+PoFDKf/hN5ospfuX8PLES62hzgICMUiBi5x1Rs9Gcp0fZZUz2dRvNWm7NgsQCVw=
X-Received: by 2002:aca:b5c4:: with SMTP id e187mr15814oif.149.1621442574969;
 Wed, 19 May 2021 09:42:54 -0700 (PDT)
MIME-Version: 1.0
References: <20210518221818.2963918-1-jxgao@google.com> <YKTIJsD2KmiV3mIb@kroah.com>
In-Reply-To: <YKTIJsD2KmiV3mIb@kroah.com>
From:   Jianxiong Gao <jxgao@google.com>
Date:   Wed, 19 May 2021 09:42:42 -0700
Message-ID: <CAMGD6P1FBwYBnVPPSFtn0qgHbs+y=stZXhnYHjX82H+vqei+AQ@mail.gmail.com>
Subject: Re: [PATCH 5.4 v2 0/9] preserve DMA offsets when using swiotlb
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Marc Orr <marcorr@google.com>, sashal@kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 19, 2021 at 1:11 AM Greg KH <gregkh@linuxfoundation.org> wrote:
>
> I still fail to understand why you can not just use the 5.10.y kernel or
> newer.  What is preventing you from doing this if you wish to use this
> type of hardware?  This is not a "regression" in that the 5.4.y kernel
> has never worked with this hardware before, it feels like a new feature.
>
NVMe + SWIOTLB is not a new feature. From my understanding it should
be supported by 5.4.y kernel correctly. Currently without the patch, any
NVMe device (along with some other devices that relies on offset to
work correctly), could be broken if the SWIOTLB is used on a 5.4.y kernel.

Neither NVMe driver nor the SWIOTLB is new on 5.4.y kernel.

If by new feature you mean SEV, then yes SEV relies on NVMe and SWIOTLB
to work correctly. But we can, and have reproduced the same bug without
SEV. So I believe this patch is necessary even without considering SEV.

Thanks
> Please, just use 5.10.y or newer, your life will be so much easier in
> the longrun.
>
> thanks,
>
> greg k-h



-- 
Jianxiong Gao
