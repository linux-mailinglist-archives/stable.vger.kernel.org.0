Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D22414D6D6
	for <lists+stable@lfdr.de>; Thu, 30 Jan 2020 07:54:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725869AbgA3Gyx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jan 2020 01:54:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:34638 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725865AbgA3Gyx (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Jan 2020 01:54:53 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A62CB206F0;
        Thu, 30 Jan 2020 06:54:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580367293;
        bh=LOqUso584/AMDozGRafxzcD0fj6VetI0LQQnKF40cSM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=p9CCHcEx4l+qR/SK0UrwG6EWtsr5gVrfACYJMysd+xBFjKFLMC4z9Mm4NiO/nn8ZB
         cd9cYCj1Ytv2UrH+AeExdTBBUgWIIMTCq10cSaS1H7XK1t/5O93knLA54SdWx1ZdzW
         Gyi28RC6DZNCqTmhb/dq3ITjkG5ihT/7K6oxcFz8=
Date:   Thu, 30 Jan 2020 07:54:50 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     =?iso-8859-1?Q?Fr=E9d=E9ric?= Pierret 
        <frederic.pierret@qubes-os.org>
Cc:     Ben Skeggs <bskeggs@redhat.com>, nouveau@lists.freedesktop.org,
        stable@vger.kernel.org
Subject: Re: nv50_disp_chan_mthd: ensure mthd is not NULL
Message-ID: <20200130065450.GA629439@kroah.com>
References: <8a82672e-1a8d-b08e-b387-11ffecd5ba07@qubes-os.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8a82672e-1a8d-b08e-b387-11ffecd5ba07@qubes-os.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jan 29, 2020 at 05:22:13PM +0100, Frédéric Pierret wrote:
> Dear Ben Skeggs,
> 
> Please find attached a patch solving a blocking issue I encountered:
> https://bugzilla.kernel.org/show_bug.cgi?id=206299
> 
> Basically, running at least a RTX2080TI on Xen makes a bad mmio error
> which causes having 'mthd' pointer to be NULL in 'channv50.c'. From the
> code, it's assumed to be not NULL by accessing directly 'mthd->data[0]'
> which is the reason of the kernel panic. I simply check if the pointer
> is not NULL before continuing.
> 
> Best regards,
> 
> Frédéric Pierret
> 

> From: =?UTF-8?q?Fr=C3=A9d=C3=A9ric=20Pierret=20=28fepitre=29?=
>  <frederic.pierret@qubes-os.org>
> Date: Sun, 26 Jan 2020 23:24:33 +0100
> Subject: [PATCH] nv50_disp_chan_mthd: ensure mthd is not NULL
> MIME-Version: 1.0
> Content-Type: text/plain; charset=UTF-8
> Content-Transfer-Encoding: 8bit
> 
> Pointer to structure array is assumed not NULL by default. It has
> the consequence to raise a kernel panic when it's not the case.
> 
> BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=206299
> Signed-off-by: Frédéric Pierret (fepitre) <frederic.pierret@qubes-os.org>
> ---
>  drivers/gpu/drm/nouveau/nvkm/engine/disp/channv50.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/gpu/drm/nouveau/nvkm/engine/disp/channv50.c b/drivers/gpu/drm/nouveau/nvkm/engine/disp/channv50.c
> index bcf32d92ee5a..50e3539f33d2 100644
> --- a/drivers/gpu/drm/nouveau/nvkm/engine/disp/channv50.c
> +++ b/drivers/gpu/drm/nouveau/nvkm/engine/disp/channv50.c
> @@ -74,6 +74,8 @@ nv50_disp_chan_mthd(struct nv50_disp_chan *chan, int debug)
>  
>  	if (debug > subdev->debug)
>  		return;
> +	if (!mthd)
> +		return;
>  
>  	for (i = 0; (list = mthd->data[i].mthd) != NULL; i++) {
>  		u32 base = chan->head * mthd->addr;
> -- 
> 2.21.0
> 




<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
