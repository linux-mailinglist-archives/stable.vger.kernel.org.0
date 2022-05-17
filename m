Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DAE7529EDA
	for <lists+stable@lfdr.de>; Tue, 17 May 2022 12:08:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245632AbiEQKIC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 May 2022 06:08:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343797AbiEQKG4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 May 2022 06:06:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB71213D6C;
        Tue, 17 May 2022 03:06:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 668B961517;
        Tue, 17 May 2022 10:06:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FF4FC385B8;
        Tue, 17 May 2022 10:06:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652782012;
        bh=NMoilscLmc4PgSYU3AERGYXDODbll8nGlk8mFWQ/E+Q=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VDBl6/O+U+ffk25lnOuexCCDsFAZIusrbJup1PFWyJtlhRwaXWmv+h5JNiHWdoJpT
         XNddlZSGY0izGxPw45GFl9BAJkwVN8bhlBpOEwq+jIQfC3f/0ooWEUZNxvGTtoIoqP
         Oj8ffsrSXAsvmqwRzSwcO8aDd7iW46/PfQ0x/NGc=
Date:   Tue, 17 May 2022 12:06:47 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Yuanjun Gong <ruc_gongyuanjun@163.com>
Cc:     Alex Deucher <alexander.deucher@amd.com>,
        Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
        amd-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 1/1] radeon: fix a possible null pointer dereference
Message-ID: <YoNzt4jkENOakdYF@kroah.com>
References: <20220517095700.7291-1-ruc_gongyuanjun@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220517095700.7291-1-ruc_gongyuanjun@163.com>
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 17, 2022 at 05:57:00PM +0800, Yuanjun Gong wrote:
> From: Gong Yuanjun <ruc_gongyuanjun@163.com>
> 
> In radeon_fp_native_mode(), the return value of drm_mode_duplicate()
> is assigned to mode, which will lead to a NULL pointer dereference
> on failure of drm_mode_duplicate(). Add a check to avoid npd.
> 
> The failure status of drm_cvt_mode() on the other path is checked too.
> 
> Signed-off-by: Gong Yuanjun <ruc_gongyuanjun@163.com>
> ---
>  drivers/gpu/drm/radeon/radeon_connectors.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/gpu/drm/radeon/radeon_connectors.c b/drivers/gpu/drm/radeon/radeon_connectors.c
> index 0cb1345c6ba4..fabe4f4ca124 100644
> --- a/drivers/gpu/drm/radeon/radeon_connectors.c
> +++ b/drivers/gpu/drm/radeon/radeon_connectors.c
> @@ -473,6 +473,8 @@ static struct drm_display_mode *radeon_fp_native_mode(struct drm_encoder *encode
>  	    native_mode->vdisplay != 0 &&
>  	    native_mode->clock != 0) {
>  		mode = drm_mode_duplicate(dev, native_mode);
> +		if (!mode)
> +			return NULL;
>  		mode->type = DRM_MODE_TYPE_PREFERRED | DRM_MODE_TYPE_DRIVER;
>  		drm_mode_set_name(mode);
>  
> @@ -487,6 +489,8 @@ static struct drm_display_mode *radeon_fp_native_mode(struct drm_encoder *encode
>  		 * simpler.
>  		 */
>  		mode = drm_cvt_mode(dev, native_mode->hdisplay, native_mode->vdisplay, 60, true, false, false);
> +		if (!mode)
> +			return NULL;
>  		mode->type = DRM_MODE_TYPE_PREFERRED | DRM_MODE_TYPE_DRIVER;
>  		DRM_DEBUG_KMS("Adding cvt approximation of native panel mode %s\n", mode->name);
>  	}
> -- 
> 2.17.1
> 

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
