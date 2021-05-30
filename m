Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4129D3950E8
	for <lists+stable@lfdr.de>; Sun, 30 May 2021 14:24:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229640AbhE3M0F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 30 May 2021 08:26:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:36882 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229500AbhE3M0F (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 30 May 2021 08:26:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8227961107;
        Sun, 30 May 2021 12:24:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622377466;
        bh=Y7lNocIn/BCMh47Yn6PwgaLRocCG40wEYwJ/D9ual1U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FlbszUmz5zC9DYvZfSKYiFZl+4kSljI02sB5q+WCLo5FLPYb6UHhCTsVgURubEFuI
         7XIGxizeKGZ0HhhsE9xQ9O6k063vGIzcUPXyDxItNd+6eQ3HTTVAFg5piTfOP+oAR8
         SK4JToluCl7Dd1LS3JAHVlj1sVwlnbGpJn84zQmI=
Date:   Sun, 30 May 2021 14:24:23 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Amit Pundir <amit.pundir@linaro.org>
Cc:     Stable <stable@vger.kernel.org>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Rob Clark <robdclark@chromium.org>
Subject: Re: [PATCH for-5.10.y] drm/msm/dpu: always use mdp device to scale
 bandwidth
Message-ID: <YLOD9+JjgfH9TB1T@kroah.com>
References: <20210528113102.655950-1-amit.pundir@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210528113102.655950-1-amit.pundir@linaro.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, May 28, 2021 at 05:01:02PM +0530, Amit Pundir wrote:
> From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
> 
> [ Upstream commit a670ff578f1fb855fedc7931fa5bbc06b567af22 ]
> 
> Currently DPU driver scales bandwidth and core clock for sc7180 only,
> while the rest of chips get static bandwidth votes. Make all chipsets
> scale bandwidth and clock per composition requirements like sc7180 does.
> Drop old voting path completely.
> 
> Tested on RB3 (SDM845) and RB5 (SM8250).
> 
> Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
> Link: https://lore.kernel.org/r/20210401020533.3956787-2-dmitry.baryshkov@linaro.org
> Signed-off-by: Rob Clark <robdclark@chromium.org>
> Signed-off-by: Amit Pundir <amit.pundir@linaro.org>
> ---
> Fixes dpu_runtime_resume() WARN_ON on db845c/RB3 (sdm845),
> introduced by the backport of upstream commit 627dc55c273d
> ("drm/msm/disp/dpu1: icc path needs to be set before dpu
> runtime resume") on v5.10.y.
> 
>  drivers/gpu/drm/msm/disp/dpu1/dpu_kms.c  |  3 +-
>  drivers/gpu/drm/msm/disp/dpu1/dpu_mdss.c | 51 +-----------------------
>  2 files changed, 2 insertions(+), 52 deletions(-)

What about a version of this for 5.12?  I can't take one for 5.10 and
not a newer kernel, right?

thanks,

greg k-h
