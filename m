Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2ADF5656DB3
	for <lists+stable@lfdr.de>; Tue, 27 Dec 2022 18:48:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232206AbiL0Rr3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Dec 2022 12:47:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232229AbiL0Rqm (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Dec 2022 12:46:42 -0500
X-Greylist: delayed 370 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 27 Dec 2022 09:46:30 PST
Received: from forward501c.mail.yandex.net (forward501c.mail.yandex.net [IPv6:2a02:6b8:c03:500:1:45:d181:d501])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2002FCE15;
        Tue, 27 Dec 2022 09:46:30 -0800 (PST)
Received: from myt6-1289f562e823.qloud-c.yandex.net (myt6-1289f562e823.qloud-c.yandex.net [IPv6:2a02:6b8:c12:259d:0:640:1289:f562])
        by forward501c.mail.yandex.net (Yandex) with ESMTP id CB03E5F1A8;
        Tue, 27 Dec 2022 20:40:11 +0300 (MSK)
Received: by myt6-1289f562e823.qloud-c.yandex.net (smtp/Yandex) with ESMTPSA id 4eTgJY4Y8mI1-9YvFUjgN;
        Tue, 27 Dec 2022 20:40:11 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=skif-web.ru; s=mail; t=1672162811;
        bh=O3IfD2rnmuqDpbg0u7OKsWKBEPTwptgRXaYL7QMT/Co=;
        h=Message-ID:Subject:References:To:From:In-Reply-To:Cc:Date;
        b=N4GGP21FyopxUJO5DtsV4VvXufE4Cod1Zj8k5HTI2xZ+tEflHpwC5KGJ+Ng4WrEdK
         3axIsX8urQUSAPmXwpZ+jGCIVB+3tHbaHbwybvWWm/5bycsQsv2US+3F+wYPgag6V5
         shGCDtQzsIkmIVw/gnpcSWyM1GhCPp92bEc7Ex/A=
Authentication-Results: myt6-1289f562e823.qloud-c.yandex.net; dkim=pass header.i=@skif-web.ru
Date:   Tue, 27 Dec 2022 20:40:03 +0300
From:   Alexey Lukyachuk <skif@skif-web.ru>
To:     Rodrigo Vivi <rodrigo.vivi@intel.com>
Cc:     <tvrtko.ursulin@linux.intel.com>,
        <dri-devel@lists.freedesktop.org>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        <intel-gfx@lists.freedesktop.org>, <linux-kernel@vger.kernel.org>,
        <stable@vger.kernel.org>, Daniel Vetter <daniel@ffwll.ch>,
        David Airlie <airlied@gmail.com>
Subject: Re: [Intel-gfx] [PATCH v2] drm/i915: dell wyse 3040 shutdown fix
Message-ID: <20221227204003.6b0abe65@alexey-Swift-SF314-42>
In-Reply-To: <Y6sfvUJmrb73AeJh@intel.com>
References: <20221225184413.146916-1-skif@skif-web.ru>
        <20221225185507.149677-1-skif@skif-web.ru>
        <Y6sfvUJmrb73AeJh@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NO_DNS_FOR_FROM,SPF_HELO_NONE,
        T_SPF_PERMERROR autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 27 Dec 2022 11:39:25 -0500
Rodrigo Vivi <rodrigo.vivi@intel.com> wrote:

> On Sun, Dec 25, 2022 at 09:55:08PM +0300, Alexey Lukyanchuk wrote:
> > dell wyse 3040 doesn't peform poweroff properly, but instead remains in=
=20
> > turned power on state.
>=20
> okay, the motivation is explained in the commit msg..
>=20
> > Additional mutex_lock and=20
> > intel_crtc_wait_for_next_vblank=20
> > feature 6.2 kernel resolve this trouble.
>=20
> but this why is not very clear... seems that by magic it was found,
> without explaining what race we are really protecting here.
>=20
> but even worse is:
> what about those many random vblank waits in the code? what's the
> reasoning?
>=20
> >=20
> > cc: stable@vger.kernel.org
> > original commit Link: https://patchwork.freedesktop.org/patch/508926/
> > fixes: fe0f1e3bfdfeb53e18f1206aea4f40b9bd1f291c
> > Signed-off-by: Alexey Lukyanchuk <skif@skif-web.ru>
> > ---
> > I got some troubles with this device (dell wyse 3040) since kernel 5.11
> > started to use i915_driver_shutdown function. I found solution here:
> >=20
> > https://lore.kernel.org/dri-devel/Y1wd6ZJ8LdJpCfZL@intel.com/#r
> >=20
> > ---
> >  drivers/gpu/drm/i915/display/intel_audio.c | 37 +++++++++++++++-------
> >  1 file changed, 25 insertions(+), 12 deletions(-)
> >=20
> > diff --git a/drivers/gpu/drm/i915/display/intel_audio.c b/drivers/gpu/d=
rm/i915/display/intel_audio.c
> > index aacbc6da8..44344ecdf 100644
> > --- a/drivers/gpu/drm/i915/display/intel_audio.c
> > +++ b/drivers/gpu/drm/i915/display/intel_audio.c
> > @@ -336,6 +336,7 @@ static void g4x_audio_codec_disable(struct intel_en=
coder *encoder,
> >  				    const struct drm_connector_state *old_conn_state)
> >  {
> >  	struct drm_i915_private *dev_priv =3D to_i915(encoder->base.dev);
> > +	struct intel_crtc *crtc =3D to_intel_crtc(old_crtc_state->uapi.crtc);
> >  	u32 eldv, tmp;
> > =20
> >  	tmp =3D intel_de_read(dev_priv, G4X_AUD_VID_DID);
> > @@ -348,6 +349,9 @@ static void g4x_audio_codec_disable(struct intel_en=
coder *encoder,
> >  	tmp =3D intel_de_read(dev_priv, G4X_AUD_CNTL_ST);
> >  	tmp &=3D ~eldv;
> >  	intel_de_write(dev_priv, G4X_AUD_CNTL_ST, tmp);
> > +
> > +	intel_crtc_wait_for_next_vblank(crtc);
> > +	intel_crtc_wait_for_next_vblank(crtc);
> >  }
> > =20
> >  static void g4x_audio_codec_enable(struct intel_encoder *encoder,
> > @@ -355,12 +359,15 @@ static void g4x_audio_codec_enable(struct intel_e=
ncoder *encoder,
> >  				   const struct drm_connector_state *conn_state)
> >  {
> >  	struct drm_i915_private *dev_priv =3D to_i915(encoder->base.dev);
> > +	struct intel_crtc *crtc =3D to_intel_crtc(crtc_state->uapi.crtc);
> >  	struct drm_connector *connector =3D conn_state->connector;
> >  	const u8 *eld =3D connector->eld;
> >  	u32 eldv;
> >  	u32 tmp;
> >  	int len, i;
> > =20
> > +	intel_crtc_wait_for_next_vblank(crtc);
> > +
> >  	tmp =3D intel_de_read(dev_priv, G4X_AUD_VID_DID);
> >  	if (tmp =3D=3D INTEL_AUDIO_DEVBLC || tmp =3D=3D INTEL_AUDIO_DEVCL)
> >  		eldv =3D G4X_ELDV_DEVCL_DEVBLC;
> > @@ -493,6 +500,7 @@ static void hsw_audio_codec_disable(struct intel_en=
coder *encoder,
> >  				    const struct drm_connector_state *old_conn_state)
> >  {
> >  	struct drm_i915_private *dev_priv =3D to_i915(encoder->base.dev);
> > +	struct intel_crtc *crtc =3D to_intel_crtc(old_crtc_state->uapi.crtc);
> >  	enum transcoder cpu_transcoder =3D old_crtc_state->cpu_transcoder;
> >  	u32 tmp;
> > =20
> > @@ -508,6 +516,10 @@ static void hsw_audio_codec_disable(struct intel_e=
ncoder *encoder,
> >  		tmp |=3D AUD_CONFIG_N_VALUE_INDEX;
> >  	intel_de_write(dev_priv, HSW_AUD_CFG(cpu_transcoder), tmp);
> > =20
> > +
> > +	intel_crtc_wait_for_next_vblank(crtc);
> > +	intel_crtc_wait_for_next_vblank(crtc);
> > +
> >  	/* Invalidate ELD */
> >  	tmp =3D intel_de_read(dev_priv, HSW_AUD_PIN_ELD_CP_VLD);
> >  	tmp &=3D ~AUDIO_ELD_VALID(cpu_transcoder);
> > @@ -633,6 +645,7 @@ static void hsw_audio_codec_enable(struct intel_enc=
oder *encoder,
> >  				   const struct drm_connector_state *conn_state)
> >  {
> >  	struct drm_i915_private *dev_priv =3D to_i915(encoder->base.dev);
> > +	struct intel_crtc *crtc =3D to_intel_crtc(crtc_state->uapi.crtc);
> >  	struct drm_connector *connector =3D conn_state->connector;
> >  	enum transcoder cpu_transcoder =3D crtc_state->cpu_transcoder;
> >  	const u8 *eld =3D connector->eld;
> > @@ -651,12 +664,7 @@ static void hsw_audio_codec_enable(struct intel_en=
coder *encoder,
> >  	tmp &=3D ~AUDIO_ELD_VALID(cpu_transcoder);
> >  	intel_de_write(dev_priv, HSW_AUD_PIN_ELD_CP_VLD, tmp);
> > =20
> > -	/*
> > -	 * FIXME: We're supposed to wait for vblank here, but we have vblanks
> > -	 * disabled during the mode set. The proper fix would be to push the
> > -	 * rest of the setup into a vblank work item, queued here, but the
> > -	 * infrastructure is not there yet.
> > -	 */
> > +	intel_crtc_wait_for_next_vblank(crtc);
> > =20
> >  	/* Reset ELD write address */
> >  	tmp =3D intel_de_read(dev_priv, HSW_AUD_DIP_ELD_CTRL(cpu_transcoder));
> > @@ -705,6 +713,8 @@ static void ilk_audio_codec_disable(struct intel_en=
coder *encoder,
> >  		aud_cntrl_st2 =3D CPT_AUD_CNTRL_ST2;
> >  	}
> > =20
> > +	mutex_lock(&dev_priv->display.audio.mutex);
> > +
> >  	/* Disable timestamps */
> >  	tmp =3D intel_de_read(dev_priv, aud_config);
> >  	tmp &=3D ~AUD_CONFIG_N_VALUE_INDEX;
> > @@ -721,6 +731,10 @@ static void ilk_audio_codec_disable(struct intel_e=
ncoder *encoder,
> >  	tmp =3D intel_de_read(dev_priv, aud_cntrl_st2);
> >  	tmp &=3D ~eldv;
> >  	intel_de_write(dev_priv, aud_cntrl_st2, tmp);
> > +	mutex_unlock(&dev_priv->display.audio.mutex);
> > +
> > +	intel_crtc_wait_for_next_vblank(crtc);
> > +	intel_crtc_wait_for_next_vblank(crtc);
> >  }
> > =20
> >  static void ilk_audio_codec_enable(struct intel_encoder *encoder,
> > @@ -740,12 +754,7 @@ static void ilk_audio_codec_enable(struct intel_en=
coder *encoder,
> >  	if (drm_WARN_ON(&dev_priv->drm, port =3D=3D PORT_A))
> >  		return;
> > =20
> > -	/*
> > -	 * FIXME: We're supposed to wait for vblank here, but we have vblanks
> > -	 * disabled during the mode set. The proper fix would be to push the
> > -	 * rest of the setup into a vblank work item, queued here, but the
> > -	 * infrastructure is not there yet.
> > -	 */
> > +	intel_crtc_wait_for_next_vblank(crtc);
> > =20
> >  	if (HAS_PCH_IBX(dev_priv)) {
> >  		hdmiw_hdmiedid =3D IBX_HDMIW_HDMIEDID(pipe);
> > @@ -767,6 +776,8 @@ static void ilk_audio_codec_enable(struct intel_enc=
oder *encoder,
> > =20
> >  	eldv =3D IBX_ELD_VALID(port);
> > =20
> > +	mutex_lock(&dev_priv->display.audio.mutex);
> > +
> >  	/* Invalidate ELD */
> >  	tmp =3D intel_de_read(dev_priv, aud_cntrl_st2);
> >  	tmp &=3D ~eldv;
> > @@ -798,6 +809,8 @@ static void ilk_audio_codec_enable(struct intel_enc=
oder *encoder,
> >  	else
> >  		tmp |=3D audio_config_hdmi_pixel_clock(crtc_state);
> >  	intel_de_write(dev_priv, aud_config, tmp);
> > +
> > +	mutex_unlock(&dev_priv->display.audio.mutex);
> >  }
> > =20
> >  /**
> > --=20
> > 2.25.1
> >=20


I would like to say, that this solution was found in drm-tip repository:
link: git://anongit.freedesktop.org/drm-tip
I will quotate original commit message from Ville Syrj=C3=A4l=C3=A4=20
<ville.syrjala@linux.intel.com>: "The spec tells us to do a bunch of=20
vblank waits in the audio enable/disable sequences. Make it so."
So it's just a backport of accepted patch.
Which i wanna to propagate to stable versions
