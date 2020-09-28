Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44C4727A750
	for <lists+stable@lfdr.de>; Mon, 28 Sep 2020 08:18:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726590AbgI1GSQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Sep 2020 02:18:16 -0400
Received: from fanzine.igalia.com ([178.60.130.6]:38104 "EHLO
        fanzine.igalia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726412AbgI1GSQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Sep 2020 02:18:16 -0400
X-Greylist: delayed 1604 seconds by postgrey-1.27 at vger.kernel.org; Mon, 28 Sep 2020 02:18:14 EDT
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com; s=20170329;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID; bh=4BUxnoIB0r8HUDaE4/Jo26obqBQbLo8OHjg6VbSI9Wk=;
        b=FLCgjDZeAoJXJqiDVryNpQoU1x2OSLuFbFDu/f6fu1YJ67TwWbJ9wEV1pAZs0CC3Hjx3ixg2Q/aKXfCj+vi+A86ci7NbKQ1CCRdVwKCjKg+Dy7abzqqPjir9UTMQdJEMcFRgmWH3k+1WlNtuDEMQ4LNbXBX/pHg70AKZ0LvfTelhPysojF2CZsGLLgQvBJechmU2ou9Cs1GgDniHbRDxn1yMWJ9J/QQFuTNo3f+/qvLnnko4CSLjIgSHbBg54ujd1+/0WH+veZxg4l3m6N60ZaNLC/qFJB8f8wnYCnRYUncVBRw9Mxz5oW/rTzDrhuhV7FliYq+u+jLsXSYA6AcwTw==;
Received: from 7.51.165.83.dynamic.reverse-mundo-r.com ([83.165.51.7] helo=zeus)
        by fanzine.igalia.com with esmtpsa 
        (Cipher TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256) (Exim)
        id 1kMm4O-00015Y-88; Mon, 28 Sep 2020 07:51:28 +0200
Message-ID: <919c3c23bd220b283dbff8f60c56a63175f6c788.camel@igalia.com>
Subject: Re: Patch "drm/v3d: don't leak bin job if v3d_job_init fails." has
 been added to the 5.4-stable tree
From:   Iago Toral <itoral@igalia.com>
To:     Sasha Levin <sashal@kernel.org>
Cc:     stable-commits@vger.kernel.org, stable@vger.kernel.org,
        eric@anholt.net
Date:   Mon, 28 Sep 2020 07:51:17 +0200
In-Reply-To: <20200927175225.BA1DE23976@mail.kernel.org>
References: <20200927175225.BA1DE23976@mail.kernel.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.1-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

As Eric pointed out, this patch should not be applied. There were 2
patches addressing the very same leak and it seems one of them already
landed and this one is being applied on top of it, so in practice, this
patch is producing a double free.

Iago

On Sun, 2020-09-27 at 13:52 -0400, Sasha Levin wrote:
> This is a note to let you know that I've just added the patch titled
> 
>     drm/v3d: don't leak bin job if v3d_job_init fails.
> 
> to the 5.4-stable tree which can be found at:
>     
> http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary
> 
> The filename of the patch is:
>      drm-v3d-don-t-leak-bin-job-if-v3d_job_init-fails.patch
> and it can be found in the queue-5.4 subdirectory.
> 
> If you, or anyone else, feels it should not be added to the stable
> tree,
> please let <stable@vger.kernel.org> know about it.
> 
> 
> 
> commit cd0324f318e4447471e0bb01d4bea4f5de4aab1e
> Author: Iago Toral Quiroga <itoral@igalia.com>
> Date:   Mon Sep 16 09:11:25 2019 +0200
> 
>     drm/v3d: don't leak bin job if v3d_job_init fails.
>     
>     [ Upstream commit 0d352a3a8a1f26168d09f7073e61bb4b328e3bb9 ]
>     
>     If the initialization of the job fails we need to kfree() it
>     before returning.
>     
>     Signed-off-by: Iago Toral Quiroga <itoral@igalia.com>
>     Signed-off-by: Eric Anholt <eric@anholt.net>
>     Link: 
> https://patchwork.freedesktop.org/patch/msgid/20190916071125.5255-1-itoral@igalia.com
>     Fixes: a783a09ee76d ("drm/v3d: Refactor job management.")
>     Reviewed-by: Eric Anholt <eric@anholt.net>
>     Signed-off-by: Sasha Levin <sashal@kernel.org>
> 
> diff --git a/drivers/gpu/drm/v3d/v3d_gem.c
> b/drivers/gpu/drm/v3d/v3d_gem.c
> index 19c092d75266b..6316bf3646af5 100644
> --- a/drivers/gpu/drm/v3d/v3d_gem.c
> +++ b/drivers/gpu/drm/v3d/v3d_gem.c
> @@ -565,6 +565,7 @@ v3d_submit_cl_ioctl(struct drm_device *dev, void
> *data,
>  		ret = v3d_job_init(v3d, file_priv, &bin->base,
>  				   v3d_job_free, args->in_sync_bcl);
>  		if (ret) {
> +			kfree(bin);
>  			v3d_job_put(&render->base);
>  			kfree(bin);
>  			return ret;
> 

