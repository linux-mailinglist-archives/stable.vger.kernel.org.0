Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1312049B00A
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 10:40:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380048AbiAYJZc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jan 2022 04:25:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1456497AbiAYJW3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Jan 2022 04:22:29 -0500
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A89A1C06174E
        for <stable@vger.kernel.org>; Tue, 25 Jan 2022 01:21:28 -0800 (PST)
Received: by mail-wr1-x435.google.com with SMTP id s9so2755801wrb.6
        for <stable@vger.kernel.org>; Tue, 25 Jan 2022 01:21:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=SVSlaIF6YHAoCUkLnBF0Z1qTbQr8zt2wggp4k29RGCE=;
        b=yyJ7Cu9B8yVyphGP2ltvi5fdHJtZrLi/Dkweh7MGqKWMjb2nrkonxjlExzilSi7ur+
         Df5nNDmzsBprjiimLrgEWrFrcoXeN8mFoiKBJM3EMUxmkZkpzpl3TSUnBERjZHRE0tCr
         fQe0iSJf4LDUR3ZgrcNkBGijiAEimhFhlke5w0ZY4GqRrYAfTX6gzsr4udxu1strluQJ
         OhZhgULXy4nFd5tSuealQfZf7ZLkcXwMunYg13iSQiR/Zbretdh2NQ629yKAqx/C+SbX
         YRVASWi6c1k01TDPuiMx2Dweo/bNtN4vUOQ6K38m55H36poQvgCCZ57l+4QLr4hraC6b
         8aDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=SVSlaIF6YHAoCUkLnBF0Z1qTbQr8zt2wggp4k29RGCE=;
        b=KOKmqhqc8vjqn1YNo89SATFXBCZmA5tYvlUn4yDjw3L0pWwPzg83iPW7tgHDH91vJT
         lAMbNwKxNvN/DRMj2CmuXApoa3twBDnFvBHWyGAgwt8qHHGMEVoLrGvuPGWL+5d64d63
         fkj7bu0Ekb8lfz6bPiliZuoM/xBNoUOoYwe5AbWNwYaREDp3o9QALoFyEo0X6SBA7YjR
         JrbUxTaPCiViIFol7NhwLwyKiYWGrs6bg2B0GmS3P1o5OSTipHCs+EBI7OplFPm0Osi0
         K024FazeEZaUqkJZDL02crW8fnf417+vWgZnz3gswgiMH7zSDW58C7SN/hixZIBPk/8m
         NVog==
X-Gm-Message-State: AOAM533qNIE4uShVErpRM02d10068jXQPXceSLVtr++CRMx7qHXC3sSq
        tstW+vOyqUZX7QkjLYqV1KjnCjqZQQ7E5g==
X-Google-Smtp-Source: ABdhPJxk68NXvFU880acmVC1e4kre7Lfy4IfgSZZLbe8uRtWCktKDuPtu4144ZTB26wdPlw2yfRD3Q==
X-Received: by 2002:adf:eac3:: with SMTP id o3mr13274657wrn.27.1643102486761;
        Tue, 25 Jan 2022 01:21:26 -0800 (PST)
Received: from google.com (cpc106310-bagu17-2-0-cust853.1-3.cable.virginm.net. [86.15.223.86])
        by smtp.gmail.com with ESMTPSA id d4sm110372wri.39.2022.01.25.01.21.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Jan 2022 01:21:26 -0800 (PST)
Date:   Tue, 25 Jan 2022 09:21:24 +0000
From:   Lee Jones <lee.jones@linaro.org>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, Daniel Rosenberg <drosen@google.com>,
        Dennis Cagle <d-cagle@codeaurora.org>,
        Patrick Daly <pdaly@codeaurora.org>
Subject: Re: [PATCH 4.9 1/3] ion: Fix use after free during ION_IOC_ALLOC
Message-ID: <Ye/BFKrUP/nLSGJC@google.com>
References: <20220124161243.1029417-1-lee.jones@linaro.org>
 <Ye7wcqssa5RuvwQe@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Ye7wcqssa5RuvwQe@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 24 Jan 2022, Greg KH wrote:

> On Mon, Jan 24, 2022 at 04:12:41PM +0000, Lee Jones wrote:
> > From: Daniel Rosenberg <drosen@google.com>
> > 
> > If a user happens to call ION_IOC_FREE during an ION_IOC_ALLOC
> > on the just allocated id, and the copy_to_user fails, the cleanup
> > code will attempt to free an already freed handle.
> > 
> > This adds a wrapper for ion_alloc that adds an ion_handle_get to
> > avoid this.
> > 
> > Signed-off-by: Daniel Rosenberg <drosen@google.com>
> > Signed-off-by: Dennis Cagle <d-cagle@codeaurora.org>
> > Signed-off-by: Patrick Daly <pdaly@codeaurora.org>
> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> > ---
> >  drivers/staging/android/ion/ion-ioctl.c | 14 +++++++++-----
> >  drivers/staging/android/ion/ion.c       | 15 ++++++++++++---
> >  drivers/staging/android/ion/ion.h       |  4 ++++
> >  3 files changed, 25 insertions(+), 8 deletions(-)
> 
> What is the git commit id of this in Linus's tree (same for the other
> 2)?

They are not in Linus' tree.

These fixes only made it into Android for some reason.

> And why just 4.9?  What about 4.14 and newer kernels?

The troublesome code was refactored before v4.14.

-- 
Lee Jones [李琼斯]
Principal Technical Lead - Developer Services
Linaro.org │ Open source software for Arm SoCs
Follow Linaro: Facebook | Twitter | Blog
