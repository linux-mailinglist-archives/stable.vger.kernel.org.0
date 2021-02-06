Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEF2B311942
	for <lists+stable@lfdr.de>; Sat,  6 Feb 2021 04:00:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232159AbhBFDAF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Feb 2021 22:00:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232174AbhBFCxh (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Feb 2021 21:53:37 -0500
Received: from mail-qk1-x72a.google.com (mail-qk1-x72a.google.com [IPv6:2607:f8b0:4864:20::72a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1414C033271
        for <stable@vger.kernel.org>; Fri,  5 Feb 2021 17:02:25 -0800 (PST)
Received: by mail-qk1-x72a.google.com with SMTP id a12so8834212qkh.10
        for <stable@vger.kernel.org>; Fri, 05 Feb 2021 17:02:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=FLppRaBxTaTBBqnUXgqhBfq/MXGjD2GePBnWu7V919s=;
        b=Hg8QkEjqcz56CXhXkp1Dh9Snx4WRELdVyJ1HGayaJXyEm9EtREpftEmuj8C8KYDVWK
         duiLaV84VItsT53GTqATLo39qU0ela1yL6ZhEq42LlNsjMMbsqjWuBvlzS0xWhBiw/ub
         xB3CZUsemutHXa+PJyVBPnVsJBkWBpnrSxKTshS6UllhQ0CE6PQkq8/L5iRjuRy3gEVF
         oSPCGXMjdR4DsFELb0c/t3f9o9/l1IK2EbmpIg8ykwy4w8Exj6ytk70ql4h5S3NxKmKD
         7sXYejDowxGiniXcr7aHZTwJrQLkfiBZ4LzVIyeXLN3sDduL/cuO3ywRMdyB14q8uiqR
         Lr5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=FLppRaBxTaTBBqnUXgqhBfq/MXGjD2GePBnWu7V919s=;
        b=UEELX8kcZbScogseDqIywiJjR9k7cNm8lDt55m52mkkjugXr/u0HI6l6Ei5oR1ofxh
         wsdNN9KYsxBHD3vy3p1z0ODGpyuajsd4G4csvJODJAXXNJmYHLwbJByREHa+6IK3jANk
         Ted43oZUZxJmc9QC/zRoOwZkDjqhDJoGgWbAGSFfk9CnxPf0xdykhZQ2UL9MnE4TdKXx
         aYkrMq+zeJ9vtX9iqUML/U6Gm0yJnFUa00DNqv8Oua+c4OYBOibr0v2YGDB2BjMF2v4u
         vBuCK2faa5tH14pgEXHpv6O7UaxDC170jNBGPdFNyZvHW9VIHUuCEunpxzgdxA+R8FU4
         3i+g==
X-Gm-Message-State: AOAM530gc+BJG+zvZj9helrlRgsjnMz3ryz9nvk5W4zPapWq4rKn2fVE
        zhnWv91aF5A/5KFUIc3tyKLfBQ==
X-Google-Smtp-Source: ABdhPJwVBr7etauHiCjhknPRB2gY/JQ/tVzQinXjOkvfahLLyY6HRmk6T/xCYpuxVmPJvC6gd44bQg==
X-Received: by 2002:a37:a3d0:: with SMTP id m199mr6795926qke.497.1612573344787;
        Fri, 05 Feb 2021 17:02:24 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-162-115-133.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.115.133])
        by smtp.gmail.com with ESMTPSA id d1sm7315887qtq.94.2021.02.05.17.02.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Feb 2021 17:02:24 -0800 (PST)
Received: from jgg by mlx with local (Exim 4.94)
        (envelope-from <jgg@ziepe.ca>)
        id 1l8BzT-004BbR-OL; Fri, 05 Feb 2021 21:02:23 -0400
Date:   Fri, 5 Feb 2021 21:02:23 -0400
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     James Bottomley <James.Bottomley@HansenPartnership.com>
Cc:     Jarkko Sakkinen <jarkko@kernel.org>,
        Lino Sanfilippo <LinoSanfilippo@gmx.de>, peterhuewe@gmx.de,
        stefanb@linux.vnet.ibm.com, stable@vger.kernel.org,
        linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lino Sanfilippo <l.sanfilippo@kunbus.com>
Subject: Re: [PATCH v3 2/2] tpm: in tpm2_del_space check if ops pointer is
 still valid
Message-ID: <20210206010223.GS4718@ziepe.ca>
References: <1612482643-11796-1-git-send-email-LinoSanfilippo@gmx.de>
 <1612482643-11796-3-git-send-email-LinoSanfilippo@gmx.de>
 <7308e5e9f51501bd92cced8f28ff6130c976b3ed.camel@HansenPartnership.com>
 <YByrCnswkIlz1w1t@kernel.org>
 <ee4adfbb99273e1bdceca210bc1fa5f16a50c415.camel@HansenPartnership.com>
 <20210205172528.GP4718@ziepe.ca>
 <89892a6152826e89276126fd2688b7c767484f41.camel@HansenPartnership.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <89892a6152826e89276126fd2688b7c767484f41.camel@HansenPartnership.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 05, 2021 at 09:54:29AM -0800, James Bottomley wrote:
> On Fri, 2021-02-05 at 13:25 -0400, Jason Gunthorpe wrote:
> > On Fri, Feb 05, 2021 at 08:48:11AM -0800, James Bottomley wrote:
> > > > Thanks for pointing this out. I'd strongly support Jason's
> > > > proposal:
> > > > 
> > > > https://lore.kernel.org/linux-integrity/20201215175624.GG5487@ziepe.ca/
> > > > 
> > > > It's the best long-term way to fix this.
> > > 
> > > Really, no it's not.  It introduces extra mechanism we don't need.
> > > To recap the issue: character devices already have an automatic
> > > mechanism which holds a reference to the struct device while the
> > > character node is open so the default is to release resources on
> > > final
> > > put of the struct device.
> > 
> > The refcount on the struct device only keeps the memory alive, it
> > doesn't say anything about the ops. We still need to lock and check
> > the ops each and every time they are used.
> 
> I think this is the crux of our disagreement: I think the ops doesn't
> matter because to call try_get_ops you have to have a chip structure
> and the only way you get a chip structure is if you hold a device
> containing it, in which case the device hold guarantees the chip can't
> be freed.  

The get_device() only guarentees the chip memory hasn't been kfree'd.

It doesn't mean tpm_chip_unregister() hasn't already run, completed
and set ops == NULL.

In the file path we have the get_device implicitly by the file's
i_cdev pointing to that chain of refcounts that ends on the chip's
main struct device. So we know the chip memory cannot be kfreed while
the struct file exists.

However, there is nothing preventing the struct file from living past
tpm_chip_unregister(). cdev_device_del() does not wait for all files's
to be closed, it only removes the ability to open new files. Open
files do prevent removal of the module, but it does not prevent
hot-unplug of the underling device, eg with sysfs unbind.

In fact, nothing about tpm_chip_unregister() excludes open files.

So it is perfectly legal for tpm_chip_unregister() to return, the devm
put_device to be called, and the refcount of the chip to still be
positive - held by open files.

In this situation ops will be NULL when file operations are called and
eg doing a tpm_chip_start will crash on:

	if (chip->ops->clk_enable)

To use the TPM driver, the rules are you must hold a get_device() on a
chip, and then upgrade it to a 'tpm_try_get_ops' before calling any
driver functions. 

Only the critical region formed by tpm_try_get_ops() will prevent
tpm_chip_unregister() from completing. It is the thing that ensures
the driver is actually present.

> In either case, I think you get returned a device to which you hold a
> reference.  Is there any other case where you can get a chip without
> also getting a device reference?

There should be no case where there is a struct chip pointer without
something owning a reference for that pointer.

> I'll answer the other point in a separate email, but I think the
> principle sounds OK: we could do the final put right after we del the
> char devices because that's called in the module release routine and
> thus not have to rely on the devm actions which, as you say, are an
> annoying complication.

I think tpm_alloc() should have an error unwind that is only
put_device(chip->dev), anything else breaks the basic programming
pattern of alloc/register.

Jason
