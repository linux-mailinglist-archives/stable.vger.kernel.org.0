Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DAF4242AE8
	for <lists+stable@lfdr.de>; Wed, 12 Aug 2020 16:04:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726505AbgHLOE2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Aug 2020 10:04:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726485AbgHLOE1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Aug 2020 10:04:27 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6E88C061383
        for <stable@vger.kernel.org>; Wed, 12 Aug 2020 07:04:26 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id r4so2144144wrx.9
        for <stable@vger.kernel.org>; Wed, 12 Aug 2020 07:04:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=ftVAAXyYONm0MJ3piPSWsbbfc05lI/y89O7eQ1Ai4e4=;
        b=A0PvPyXbTludqG4EqauB8WQYvxHfmirC87kEUflcEP3VlIyugWn7YsWYhaQ60n8ys8
         boU9Ztj9rdyz9GuyRoVlfXN/p8oDSiH7JGPl75mmB1u6zrVe1XSFpEoIs0zZo/25n71i
         yg1IXThRUz5H1sjO2keNWxpcJhL+PNaQhGwJA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=ftVAAXyYONm0MJ3piPSWsbbfc05lI/y89O7eQ1Ai4e4=;
        b=DzaUoNidLbThtsv4k0rvQBsLQVdQPd8A28Bkygbepsq0fK8Kq2qIE1Xjb9fmYpH1Ia
         uZAZsz6s8nlQxYW9lj8lxvKwkePBpn3eZvEIpu1rdMgVGyGX7hANMTD8pETODyDdhRuW
         cQam3tPmJSx8fbOwgL0vGxEMkPF29xyhQQbhHNHbD2ZzkYsM3J1lxz0zjuyl74IvDi01
         tdSyLBF5iWgRm3aSmc0puMmBewddveo+WUdwmYb+NX0HOWSHl2kTLdR+ugMDodqvFTK/
         h5hpk4oMDQBTjcpKXvKR1/0CG9PprfwY1CJJVVLcmO5U85iEoEU3DRBJu1HhI2dsEvjt
         yUtg==
X-Gm-Message-State: AOAM531qtXRdPnO81uHYuI8czU5NmmsaLvzz525GhwQzkuIR8H7nZHtE
        UhM5pRL3f4Kb6GEcEXFFvBwJkw==
X-Google-Smtp-Source: ABdhPJz/hQ+Rh7GhlcUf+vgZ15DYCV+3J/cahlCVvCWx1tGEeOQhC0KCbbkV8fjx7+4nCNfsujt8LQ==
X-Received: by 2002:a05:6000:1152:: with SMTP id d18mr36297414wrx.357.1597241065621;
        Wed, 12 Aug 2020 07:04:25 -0700 (PDT)
Received: from phenom.ffwll.local ([2a02:168:57f4:0:efd0:b9e5:5ae6:c2fa])
        by smtp.gmail.com with ESMTPSA id h14sm3771424wml.30.2020.08.12.07.04.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Aug 2020 07:04:24 -0700 (PDT)
Date:   Wed, 12 Aug 2020 16:04:23 +0200
From:   Daniel Vetter <daniel@ffwll.ch>
To:     Thomas Zimmermann <tzimmermann@suse.de>
Cc:     daniel@ffwll.ch, Daniel Vetter <daniel.vetter@ffwll.ch>,
        emil.l.velikov@gmail.com, dri-devel@lists.freedesktop.org,
        kraxel@redhat.com, airlied@redhat.com, stable@vger.kernel.org,
        sam@ravnborg.org
Subject: Re: [PATCH v1 4/4] drm/ast: Disable planes while switching display
 modes
Message-ID: <20200812140423.GG2352366@phenom.ffwll.local>
References: <20200805105428.2590-1-tzimmermann@suse.de>
 <20200805105428.2590-5-tzimmermann@suse.de>
 <20200807085000.GO6419@phenom.ffwll.local>
 <890d87c0-195a-8d99-8132-417f2892eb8c@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <890d87c0-195a-8d99-8132-417f2892eb8c@suse.de>
X-Operating-System: Linux phenom 5.7.0-1-amd64 
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Aug 12, 2020 at 10:25:25AM +0200, Thomas Zimmermann wrote:
> Hi
> 
> Am 07.08.20 um 10:50 schrieb daniel@ffwll.ch:
> > On Wed, Aug 05, 2020 at 12:54:28PM +0200, Thomas Zimmermann wrote:
> >> The ast HW cursor requires the primary plane and CRTC to display at
> >> a valid mode and format. This is not the case while switching
> >> display modes, which can lead to the screen turing permanently dark.
> >>
> >> As a workaround, the ast driver now disables active planes while the
> >> mode or format switch takes place. It also synchronizes with the vertical
> >> refresh to give CRTC and planes some time to catch up on each other.
> >> The active planes planes (primary or cursor) will be re-enabled by
> >> each plane's atomic_update() function.
> >>
> >> v2:
> >> 	* move the logic into the commit-tail function
> >>
> >> Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
> >> Fixes: 4961eb60f145 ("drm/ast: Enable atomic modesetting")
> >> Cc: Thomas Zimmermann <tzimmermann@suse.de>
> >> Cc: Gerd Hoffmann <kraxel@redhat.com>
> >> Cc: Dave Airlie <airlied@redhat.com>
> >> Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
> >> Cc: Sam Ravnborg <sam@ravnborg.org>
> >> Cc: Emil Velikov <emil.l.velikov@gmail.com>
> >> Cc: "Y.C. Chen" <yc_chen@aspeedtech.com>
> >> Cc: <stable@vger.kernel.org> # v5.6+
> >> ---
> >>  drivers/gpu/drm/ast/ast_drv.h  |  2 +
> >>  drivers/gpu/drm/ast/ast_mode.c | 68 ++++++++++++++++++++++++++++++++--
> >>  2 files changed, 66 insertions(+), 4 deletions(-)
> >>
> >> diff --git a/drivers/gpu/drm/ast/ast_drv.h b/drivers/gpu/drm/ast/ast_drv.h
> >> index c1af6b725933..467049ca8430 100644
> >> --- a/drivers/gpu/drm/ast/ast_drv.h
> >> +++ b/drivers/gpu/drm/ast/ast_drv.h
> >> @@ -177,6 +177,8 @@ struct ast_private *ast_device_create(struct drm_driver *drv,
> >>  
> >>  #define AST_IO_MM_OFFSET		(0x380)
> >>  
> >> +#define AST_IO_VGAIR1_VREFRESH		BIT(3)
> >> +
> >>  #define __ast_read(x) \
> >>  static inline u##x ast_read##x(struct ast_private *ast, u32 reg) { \
> >>  u##x val = 0;\
> >> diff --git a/drivers/gpu/drm/ast/ast_mode.c b/drivers/gpu/drm/ast/ast_mode.c
> >> index ae5cb0a333f7..a379d51f3543 100644
> >> --- a/drivers/gpu/drm/ast/ast_mode.c
> >> +++ b/drivers/gpu/drm/ast/ast_mode.c
> >> @@ -514,6 +514,17 @@ static void ast_set_start_address_crt1(struct ast_private *ast,
> >>  
> >>  }
> >>  
> >> +static void ast_wait_for_vretrace(struct ast_private *ast)
> >> +{
> >> +	unsigned long timeout = jiffies + HZ;
> >> +	u8 vgair1;
> >> +
> >> +	do {
> >> +		vgair1 = ast_io_read8(ast, AST_IO_INPUT_STATUS1_READ);
> >> +	} while (!(vgair1 & AST_IO_VGAIR1_VREFRESH) &&
> >> +		 time_before(jiffies, timeout));
> >> +}
> >> +
> >>  /*
> >>   * Primary plane
> >>   */
> >> @@ -1043,23 +1054,72 @@ static int ast_connector_init(struct drm_device *dev)
> >>   * Mode config
> >>   */
> >>  
> >> +static bool
> >> +ast_crtc_needs_planes_disabled(struct drm_crtc_state *old_crtc_state,
> >> +			       struct drm_crtc_state *new_crtc_state)
> >> +{
> >> +	struct ast_crtc_state *old_ast_crtc_state, *new_ast_crtc_state;
> >> +
> >> +	if (drm_atomic_crtc_needs_modeset(new_crtc_state))
> >> +		return true;
> >> +
> >> +	old_ast_crtc_state = to_ast_crtc_state(old_crtc_state);
> >> +	new_ast_crtc_state = to_ast_crtc_state(new_crtc_state);
> >> +
> >> +	if (old_ast_crtc_state->format != new_ast_crtc_state->format)
> >> +		return true;
> >> +
> >> +	return false;
> >> +}
> >> +
> >>  static void
> >>  ast_mode_config_helper_commit_tail(struct drm_atomic_state *old_state)
> >>  {
> >>  	struct drm_device *dev = old_state->dev;
> >> +	struct ast_private *ast = to_ast_private(dev);
> >> +	struct drm_crtc_state *old_crtc_state, *new_crtc_state;
> >> +	struct drm_crtc *crtc;
> >> +	int i;
> >> +	bool wait_for_vretrace = false;
> >>  
> >>  	drm_atomic_helper_commit_modeset_disables(dev, old_state);
> >>  
> >> -	drm_atomic_helper_commit_planes(dev, old_state, 0);
> >> +	/*
> >> +	 * HW cursors require the underlying primary plane and CRTC to
> >> +	 * display a valid mode and image. This is not the case during
> >> +	 * full modeset operations. So we temporarily disable any active
> >> +	 * plane, including the HW cursor. Each plane's atomic_update()
> >> +	 * helper will re-enable it if necessary.
> >> +	 *
> >> +	 * We only do this during *full* modesets. It does not affect
> >> +	 * simple pageflips on the planes.
> >> +	 */
> >> +	for_each_oldnew_crtc_in_state(old_state, crtc,
> >> +				      old_crtc_state,
> >> +				      new_crtc_state, i) {
> >> +		if (!ast_crtc_needs_planes_disabled(old_crtc_state,
> >> +						    new_crtc_state))
> >> +			continue;
> >> +		drm_atomic_helper_disable_planes_on_crtc(old_crtc_state,
> >> +							 false);
> >> +		wait_for_vretrace = true;
> >> +	}
> > 
> > Hm this still feels like you're fighting the framework more than using it.
> > Comment here, but it's kinda review comments on the entire series.
> > 
> > - ast_crtc_needs_planes_disabled feels a bit strange, the usual way to
> >   handle this kind of stuff is to set crtc_state->needs_modeset from your
> >   plane's atomic_check function. You might need your own atomic_check
> >   implementation for that, so that after the plane checks you run the
> >   modeset checks again.
> > 
> > - with that you can put your call here to disable all planes into the crtc
> >   ->atomic_disable callback. You can then also put the
> >   ast_wait_for_retrace in there, at the end.
> 
> The CRTC's atomic_disable/enable only run if needs_modeset() is true.
> 
> I brought back support for fast format changes of the primary plane.
> Moving that code into atomic_disable/enable would require to set
> needs_modeset in atomic_check() for format changes. And later figure out
> in atomic_disable/enable if it's really a modeset or just a change of
> the format. That's not good either.

Hm so the uapi rules are somewhat quirky, but NEEDS_MODESET generally
means "no flickering". You can do transitions which take longer than 1
vblank (if resources need to be reallocated) without signalling a
NEEDS_MODESET. But going to black and back is not something that should be
done without signalling a modeset. Userspace would like to make that
distinction and avoid such flickering as much as possible.

Maybe not super relevant for ast, but still, needs_modeset should flag
true for this I think.

Not sure how to best model that with helpers tbh so you can keep the fast
format change. Clever drivers with tricks like this all have their own
modeset flow by now. Maybe just have ast state for whether you need a
modeset (before you overwrite that due to plane changes) and forced plane
disable (any time a modeset is indicated) and then call functions from
your commit_tail depending upon that directly.
-Daniel

> 
> Best regards
> Thomas
> 
> > 
> >> +
> >> +	/*
> >> +	 * Ensure that no scanout takes place before reprogramming mode
> >> +	 * and format registers.
> >> +	 */
> >> +	if (wait_for_vretrace)
> >> +		ast_wait_for_vretrace(ast);
> >> +
> >> +	drm_atomic_helper_commit_planes(dev, old_state,
> >> +					DRM_PLANE_COMMIT_ACTIVE_ONLY);
> > 
> > This order also feels a bit strange, especially with the first 2 patches
> > where you put the crtc modeset code into atomic_begin. It feels a bit like
> > if you do the plane commit _after_ modeset enables, then you could move
> > the crtc code into the crtc ->atomic_enable hook, and then let the plane
> > update stuff roll through all in commit_planes. Moving the modset code
> > into atomic_begin at least suggests you want modeset enables before plane
> > commit, and lots of drivers have that sequence in their commit_tail. It's
> > even a default implementation with drm_atomic_helper_commit_tail_rpm.
> > 
> > Sorry this is all dragging around so much, figuring out the best atomic
> > flow is occasionally a bit an endeavour :-/
> > 
> > Cheers, Daniel
> > 
> >>  
> >>  	drm_atomic_helper_commit_modeset_enables(dev, old_state);
> >>  
> >>  	drm_atomic_helper_fake_vblank(old_state);
> >> -
> >>  	drm_atomic_helper_commit_hw_done(old_state);
> >> -
> >>  	drm_atomic_helper_wait_for_vblanks(dev, old_state);
> >> -
> >>  	drm_atomic_helper_cleanup_planes(dev, old_state);
> >>  }
> >>  
> >> -- 
> >> 2.28.0
> >>
> > 
> 
> -- 
> Thomas Zimmermann
> Graphics Driver Developer
> SUSE Software Solutions Germany GmbH
> Maxfeldstr. 5, 90409 Nürnberg, Germany
> (HRB 36809, AG Nürnberg)
> Geschäftsführer: Felix Imendörffer
> 




-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
