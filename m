Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDD0D65B318
	for <lists+stable@lfdr.de>; Mon,  2 Jan 2023 15:03:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232975AbjABODb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Jan 2023 09:03:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231795AbjABODa (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Jan 2023 09:03:30 -0500
X-Greylist: delayed 384 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 02 Jan 2023 06:03:27 PST
Received: from forward500b.mail.yandex.net (forward500b.mail.yandex.net [178.154.239.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B7FE6566;
        Mon,  2 Jan 2023 06:03:27 -0800 (PST)
Received: from sas1-71299a9d5a62.qloud-c.yandex.net (sas1-71299a9d5a62.qloud-c.yandex.net [IPv6:2a02:6b8:c08:210e:0:640:7129:9a9d])
        by forward500b.mail.yandex.net (Yandex) with ESMTP id 1002A5E8C9;
        Mon,  2 Jan 2023 16:56:52 +0300 (MSK)
Received: by sas1-71299a9d5a62.qloud-c.yandex.net (smtp/Yandex) with ESMTPSA id ouVAbIqZ8Cg1-e94d45Fz;
        Mon, 02 Jan 2023 16:56:51 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=skif-web.ru; s=mail; t=1672667811;
        bh=lGacC5MkhD7BWsnyWz+1qtivhjq/cOTw8abLlj/6x+8=;
        h=Message-ID:Subject:References:To:From:In-Reply-To:Cc:Date;
        b=ROR9YkJq+lynJNyvgEDtVlF4dY5OkqAhHFkSgftvb2KGmPrnRXvXUny0DDcOs6L/F
         mEJouqqHxNYNKsW9pvQoH3ra9W4hEhvCvU1Jlzxv+B6ymUKLo7mwF+RAgBSEbGYM/j
         EqhILqSZNoYFnB93wJqgQKyNI17R7EWD8jz5gSd8=
Authentication-Results: sas1-71299a9d5a62.qloud-c.yandex.net; dkim=pass header.i=@skif-web.ru
Date:   Mon, 2 Jan 2023 16:56:49 +0300
From:   Alexey Lukyachuk <skif@skif-web.ru>
To:     Rodrigo Vivi <rodrigo.vivi@intel.com>
Cc:     <tvrtko.ursulin@linux.intel.com>,
        <dri-devel@lists.freedesktop.org>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        <intel-gfx@lists.freedesktop.org>, <linux-kernel@vger.kernel.org>,
        <stable@vger.kernel.org>, Daniel Vetter <daniel@ffwll.ch>,
        David Airlie <airlied@gmail.com>
Subject: Re: [Intel-gfx] [PATCH v2] drm/i915: dell wyse 3040 shutdown fix
Message-ID: <20230102165649.2b8e69e3@alexey-Swift-SF314-42>
In-Reply-To: <20221227204003.6b0abe65@alexey-Swift-SF314-42>
References: <20221225184413.146916-1-skif@skif-web.ru>
        <20221225185507.149677-1-skif@skif-web.ru>
        <Y6sfvUJmrb73AeJh@intel.com>
        <20221227204003.6b0abe65@alexey-Swift-SF314-42>
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

On Tue, 27 Dec 2022 20:40:03 +0300
Alexey Lukyachuk <skif@skif-web.ru> wrote:

> On Tue, 27 Dec 2022 11:39:25 -0500
> Rodrigo Vivi <rodrigo.vivi@intel.com> wrote:
>=20
> > On Sun, Dec 25, 2022 at 09:55:08PM +0300, Alexey Lukyanchuk wrote:
> > > dell wyse 3040 doesn't peform poweroff properly, but instead remains =
in=20
> > > turned power on state.
> >=20
> > okay, the motivation is explained in the commit msg..
> >=20
> > > Additional mutex_lock and=20
> > > intel_crtc_wait_for_next_vblank=20
> > > feature 6.2 kernel resolve this trouble.
> >=20
> > but this why is not very clear... seems that by magic it was found,
> > without explaining what race we are really protecting here.
> >=20
> > but even worse is:
> > what about those many random vblank waits in the code? what's the
> > reasoning?
> >=20
> > >=20
> > > cc: stable@vger.kernel.org
> > > original commit Link: https://patchwork.freedesktop.org/patch/508926/
> > > fixes: fe0f1e3bfdfeb53e18f1206aea4f40b9bd1f291c
> > > Signed-off-by: Alexey Lukyanchuk <skif@skif-web.ru>
> > > ---
> > > I got some troubles with this device (dell wyse 3040) since kernel 5.=
11
> > > started to use i915_driver_shutdown function. I found solution here:
> > >=20
> > > https://lore.kernel.org/dri-devel/Y1wd6ZJ8LdJpCfZL@intel.com/#r
> > >=20
> > > ---
> > >  drivers/gpu/drm/i915/display/intel_audio.c | 37 +++++++++++++++-----=
--
> > >  1 file changed, 25 insertions(+), 12 deletions(-)
> > >=20
> > > diff --git a/drivers/gpu/drm/i915/display/intel_audio.c b/drivers/gpu=
/drm/i915/display/intel_audio.c
> > > index aacbc6da8..44344ecdf 100644
> > > --- a/drivers/gpu/drm/i915/display/intel_audio.c
> > > +++ b/drivers/gpu/drm/i915/display/intel_audio.c
> > > @@ -336,6 +336,7 @@ static void g4x_audio_codec_disable(struct intel_=
encoder *encoder,
> > >  				    const struct drm_connector_state *old_conn_state)
> > >  {
> > >  	struct drm_i915_private *dev_priv =3D to_i915(encoder->base.dev);
> > > +	struct intel_crtc *crtc =3D to_intel_crtc(old_crtc_state->uapi.crtc=
);
> > >  	u32 eldv, tmp;
> > > =20
> > >  	tmp =3D intel_de_read(dev_priv, G4X_AUD_VID_DID);
> > > @@ -348,6 +349,9 @@ static void g4x_audio_codec_disable(struct intel_=
encoder *encoder,
> > >  	tmp =3D intel_de_read(dev_priv, G4X_AUD_CNTL_ST);
> > >  	tmp &=3D ~eldv;
> > >  	intel_de_write(dev_priv, G4X_AUD_CNTL_ST, tmp);
> > > +
> > > +	intel_crtc_wait_for_next_vblank(crtc);
> > > +	intel_crtc_wait_for_next_vblank(crtc);
> > >  }
> > > =20
> > >  static void g4x_audio_codec_enable(struct intel_encoder *encoder,
> > > @@ -355,12 +359,15 @@ static void g4x_audio_codec_enable(struct intel=
_encoder *encoder,
> > >  				   const struct drm_connector_state *conn_state)
> > >  {
> > >  	struct drm_i915_private *dev_priv =3D to_i915(encoder->base.dev);
> > > +	struct intel_crtc *crtc =3D to_intel_crtc(crtc_state->uapi.crtc);
> > >  	struct drm_connector *connector =3D conn_state->connector;
> > >  	const u8 *eld =3D connector->eld;
> > >  	u32 eldv;
> > >  	u32 tmp;
> > >  	int len, i;
> > > =20
> > > +	intel_crtc_wait_for_next_vblank(crtc);
> > > +
> > >  	tmp =3D intel_de_read(dev_priv, G4X_AUD_VID_DID);
> > >  	if (tmp =3D=3D INTEL_AUDIO_DEVBLC || tmp =3D=3D INTEL_AUDIO_DEVCL)
> > >  		eldv =3D G4X_ELDV_DEVCL_DEVBLC;
> > > @@ -493,6 +500,7 @@ static void hsw_audio_codec_disable(struct intel_=
encoder *encoder,
> > >  				    const struct drm_connector_state *old_conn_state)
> > >  {
> > >  	struct drm_i915_private *dev_priv =3D to_i915(encoder->base.dev);
> > > +	struct intel_crtc *crtc =3D to_intel_crtc(old_crtc_state->uapi.crtc=
);
> > >  	enum transcoder cpu_transcoder =3D old_crtc_state->cpu_transcoder;
> > >  	u32 tmp;
> > > =20
> > > @@ -508,6 +516,10 @@ static void hsw_audio_codec_disable(struct intel=
_encoder *encoder,
> > >  		tmp |=3D AUD_CONFIG_N_VALUE_INDEX;
> > >  	intel_de_write(dev_priv, HSW_AUD_CFG(cpu_transcoder), tmp);
> > > =20
> > > +
> > > +	intel_crtc_wait_for_next_vblank(crtc);
> > > +	intel_crtc_wait_for_next_vblank(crtc);
> > > +
> > >  	/* Invalidate ELD */
> > >  	tmp =3D intel_de_read(dev_priv, HSW_AUD_PIN_ELD_CP_VLD);
> > >  	tmp &=3D ~AUDIO_ELD_VALID(cpu_transcoder);
> > > @@ -633,6 +645,7 @@ static void hsw_audio_codec_enable(struct intel_e=
ncoder *encoder,
> > >  				   const struct drm_connector_state *conn_state)
> > >  {
> > >  	struct drm_i915_private *dev_priv =3D to_i915(encoder->base.dev);
> > > +	struct intel_crtc *crtc =3D to_intel_crtc(crtc_state->uapi.crtc);
> > >  	struct drm_connector *connector =3D conn_state->connector;
> > >  	enum transcoder cpu_transcoder =3D crtc_state->cpu_transcoder;
> > >  	const u8 *eld =3D connector->eld;
> > > @@ -651,12 +664,7 @@ static void hsw_audio_codec_enable(struct intel_=
encoder *encoder,
> > >  	tmp &=3D ~AUDIO_ELD_VALID(cpu_transcoder);
> > >  	intel_de_write(dev_priv, HSW_AUD_PIN_ELD_CP_VLD, tmp);
> > > =20
> > > -	/*
> > > -	 * FIXME: We're supposed to wait for vblank here, but we have vblan=
ks
> > > -	 * disabled during the mode set. The proper fix would be to push the
> > > -	 * rest of the setup into a vblank work item, queued here, but the
> > > -	 * infrastructure is not there yet.
> > > -	 */
> > > +	intel_crtc_wait_for_next_vblank(crtc);
> > > =20
> > >  	/* Reset ELD write address */
> > >  	tmp =3D intel_de_read(dev_priv, HSW_AUD_DIP_ELD_CTRL(cpu_transcoder=
));
> > > @@ -705,6 +713,8 @@ static void ilk_audio_codec_disable(struct intel_=
encoder *encoder,
> > >  		aud_cntrl_st2 =3D CPT_AUD_CNTRL_ST2;
> > >  	}
> > > =20
> > > +	mutex_lock(&dev_priv->display.audio.mutex);
> > > +
> > >  	/* Disable timestamps */
> > >  	tmp =3D intel_de_read(dev_priv, aud_config);
> > >  	tmp &=3D ~AUD_CONFIG_N_VALUE_INDEX;
> > > @@ -721,6 +731,10 @@ static void ilk_audio_codec_disable(struct intel=
_encoder *encoder,
> > >  	tmp =3D intel_de_read(dev_priv, aud_cntrl_st2);
> > >  	tmp &=3D ~eldv;
> > >  	intel_de_write(dev_priv, aud_cntrl_st2, tmp);
> > > +	mutex_unlock(&dev_priv->display.audio.mutex);
> > > +
> > > +	intel_crtc_wait_for_next_vblank(crtc);
> > > +	intel_crtc_wait_for_next_vblank(crtc);
> > >  }
> > > =20
> > >  static void ilk_audio_codec_enable(struct intel_encoder *encoder,
> > > @@ -740,12 +754,7 @@ static void ilk_audio_codec_enable(struct intel_=
encoder *encoder,
> > >  	if (drm_WARN_ON(&dev_priv->drm, port =3D=3D PORT_A))
> > >  		return;
> > > =20
> > > -	/*
> > > -	 * FIXME: We're supposed to wait for vblank here, but we have vblan=
ks
> > > -	 * disabled during the mode set. The proper fix would be to push the
> > > -	 * rest of the setup into a vblank work item, queued here, but the
> > > -	 * infrastructure is not there yet.
> > > -	 */
> > > +	intel_crtc_wait_for_next_vblank(crtc);
> > > =20
> > >  	if (HAS_PCH_IBX(dev_priv)) {
> > >  		hdmiw_hdmiedid =3D IBX_HDMIW_HDMIEDID(pipe);
> > > @@ -767,6 +776,8 @@ static void ilk_audio_codec_enable(struct intel_e=
ncoder *encoder,
> > > =20
> > >  	eldv =3D IBX_ELD_VALID(port);
> > > =20
> > > +	mutex_lock(&dev_priv->display.audio.mutex);
> > > +
> > >  	/* Invalidate ELD */
> > >  	tmp =3D intel_de_read(dev_priv, aud_cntrl_st2);
> > >  	tmp &=3D ~eldv;
> > > @@ -798,6 +809,8 @@ static void ilk_audio_codec_enable(struct intel_e=
ncoder *encoder,
> > >  	else
> > >  		tmp |=3D audio_config_hdmi_pixel_clock(crtc_state);
> > >  	intel_de_write(dev_priv, aud_config, tmp);
> > > +
> > > +	mutex_unlock(&dev_priv->display.audio.mutex);
> > >  }
> > > =20
> > >  /**
> > > --=20
> > > 2.25.1
> > >=20
>=20
>=20
> I would like to say, that this solution was found in drm-tip repository:
> link: git://anongit.freedesktop.org/drm-tip
> I will quotate original commit message from Ville Syrj=C3=A4l=C3=A4=20
> <ville.syrjala@linux.intel.com>: "The spec tells us to do a bunch of=20
> vblank waits in the audio enable/disable sequences. Make it so."
> So it's just a backport of accepted patch.
> Which i wanna to propagate to stable versions


Yes, I have checked 6.2-rc2 and everything work fine. I want to backport
this commit to 6.0 and 6.1 because my company going to use these versions.
Maybe it will be useful for 5.15, companies and vendors are passionate about
LTS kernel ( I am edge to make special version of this patch for 5.15
because hank 3 will be failed with it.).
I am fully supportive with you that trouble is in timings/ locking changes.
Early in detecting process I made some sleeps and it's help but not reliabl=
e.
Regarding to your question about fdo gitlab, I went to do it. And in process
 ("Before filing the bug, please try to reproduce your issue with the latest
 kernel. Use the latest drm-tip branch") I found that trouble is resolves.
Using bisect and tests, I got needed commit.

Also I add log (by netconsole) from 5.15 kernel

[   60.031680] ------------[ cut here ]------------
[   60.031709] i915 0000:00:02.0: drm_WARN_ON(!intel_irqs_enabled(dev_priv))
[   60.031766] WARNING: CPU: 1 PID: 1964 at drivers/gpu/drm/i915/i915_irq.c=
:527 i915_enable_pipestat+0x1b9/0x230 [i915]
[   60.032016] Modules linked in: snd_soc_sst_cht_bsw_rt5672 snd_hdmi_lpe_a=
udio mei_hdcp intel_rapl_msr intel_powerclamp coretemp kvm_intel kvm punit_=
atom_debug crct10dif_pclmul ghash_clmulni_intel joydev input_leds aesni_int=
el crypto_simd cryptd snd_sof_acpi_intel_byt intel_cstate snd_sof_intel_ipc=
 snd_sof_acpi snd_sof_intel_atom dell_wmi snd_sof_xtensa_dsp snd_sof dell_s=
mbios ledtrig_audio dcdbas snd_intel_sst_acpi nls_iso8859_1 snd_soc_acpi_in=
tel_match sparse_keymap snd_soc_acpi i915 efi_pstore snd_intel_sst_core wmi=
_bmof dell_wmi_descriptor snd_soc_sst_atom_hifi2_platform snd_soc_rt5670 sn=
d_intel_dspcfg intel_chtdc_ti_pwrbtn snd_soc_rl6231 snd_intel_sdw_acpi ttm =
drm_kms_helper snd_soc_core cec snd_compress ac97_bus rc_core processor_the=
rmal_device_pci_legacy snd_pcm_dmaengine i2c_algo_bit processor_thermal_dev=
ice fb_sys_fops processor_thermal_rfim snd_pcm snd_seq_midi syscopyarea pro=
cessor_thermal_mbox sysfillrect processor_thermal_rapl intel_rapl_common me=
i_txe intel_soc_dts_iosf
[   60.032231]  snd_seq_midi_event mei intel_xhci_usb_role_switch sysimgblt=
 snd_rawmidi snd_seq snd_seq_device snd_timer snd soundcore 8250_dw int3406=
_thermal mac_hid int3403_thermal int340x_thermal_zone int3400_thermal acpi_=
pad intel_int0002_vgpio acpi_thermal_rel sch_fq_codel ipmi_devintf ipmi_msg=
handler msr parport_pc ppdev lp parport drm ip_tables x_tables autofs4 over=
lay hid_logitech_hidpp hid_logitech_dj hid_generic usbhid hid netconsole mm=
c_block crc32_pclmul r8169 realtek lpc_ich sdhci_pci xhci_pci cqhci xhci_pc=
i_renesas dw_dmac wmi sdhci_acpi video dw_dmac_core intel_soc_pmic_chtdc_ti=
 sdhci
[   60.032427] CPU: 1 PID: 1964 Comm: plymouthd Not tainted 5.15.0-57-gener=
ic #63~20.04.1-Ubuntu
[   60.032440] Hardware name: Dell Inc. Wyse 3040 Thin Client/0G56C0, BIOS =
1.2.4 01/18/2018
[   60.032450] RIP: 0010:i915_enable_pipestat+0x1b9/0x230 [i915]
[   60.032669] Code: 89 55 cc 44 89 5d d0 44 89 4d d4 e8 c1 15 ae d8 48 8b =
55 c0 48 c7 c1 a8 72 b5 c0 48 c7 c7 54 b5 b8 c0 48 89 c6 e8 0e 21 f5 d8 <0f=
> 0b 44 8b 55 cc 44 8b 5d d0 44 8b 4d d4 e9 9d fe ff ff 4c 89 f6
[   60.032682] RSP: 0018:ffffaaa50070b878 EFLAGS: 00010086
[   60.032694] RAX: 0000000000000000 RBX: ffff980ec8080000 RCX: ffffffff9ab=
7a748
[   60.032703] RDX: 00000000ffffdfff RSI: ffffaaa50070b6b8 RDI: 00000000000=
00001
[   60.032713] RBP: ffffaaa50070b8c0 R08: 0000000000000003 R09: 00000000000=
00001
[   60.032721] R10: ffffffff9b21f3b6 R11: 000000009b21f38a R12: 00000000000=
00004
[   60.032730] R13: 0000000000000000 R14: 0000000000000000 R15: ffff980ec80=
80000
[   60.032740] FS:  00007f0967eec740(0000) GS:ffff980f34280000(0000) knlGS:=
0000000000000000
[   60.032752] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   60.032762] CR2: 00007f7f5f21eaa4 CR3: 000000000a34a000 CR4: 00000000001=
006e0
[   60.032772] Call Trace:
[   60.032781]  <TASK>
[   60.032793]  ? drm_crtc_vblank_helper_get_vblank_timestamp_internal+0xe0=
/0x370 [drm]
[   60.032899]  i965_enable_vblank+0x3d/0x60 [i915]
[   60.033139]  drm_vblank_enable+0xfd/0x1a0 [drm]
[   60.033240]  drm_vblank_get+0xaf/0x100 [drm]
[   60.033335]  drm_crtc_vblank_get+0x17/0x20 [drm]
[   60.033426]  intel_pipe_update_start+0x128/0x2f0 [i915]
[   60.033689]  ? wait_woken+0x60/0x60
[   60.033710]  intel_update_crtc+0xd2/0x420 [i915]
[   60.033969]  intel_commit_modeset_enables+0x74/0xa0 [i915]
[   60.034228]  intel_atomic_commit_tail+0x587/0x14e0 [i915]
[   60.034488]  intel_atomic_commit+0x3a6/0x410 [i915]
[   60.034746]  drm_atomic_commit+0x4a/0x60 [drm]
[   60.034849]  drm_atomic_helper_set_config+0x80/0xc0 [drm_kms_helper]
[   60.034921]  drm_mode_setcrtc+0x1ff/0x7d0 [drm]
[   60.035011]  ? drm_mode_getcrtc+0x1e0/0x1e0 [drm]
[   60.035098]  drm_ioctl_kernel+0xb2/0x100 [drm]
[   60.035182]  drm_ioctl+0x275/0x4a0 [drm]
[   60.035265]  ? drm_mode_getcrtc+0x1e0/0x1e0 [drm]
[   60.035354]  __x64_sys_ioctl+0x95/0xd0
[   60.035372]  do_syscall_64+0x5c/0xc0
[   60.035388]  ? exit_to_user_mode_prepare+0x3d/0x1c0
[   60.035404]  ? syscall_exit_to_user_mode+0x27/0x50
[   60.035418]  ? do_syscall_64+0x69/0xc0
[   60.035431]  ? syscall_exit_to_user_mode+0x27/0x50
[   60.035445]  ? do_syscall_64+0x69/0xc0
[   60.035459]  ? syscall_exit_to_user_mode+0x27/0x50
[   60.035474]  ? do_syscall_64+0x69/0xc0
[   60.035487]  ? do_syscall_64+0x69/0xc0
[   60.035501]  ? do_syscall_64+0x69/0xc0
[   60.035514]  entry_SYSCALL_64_after_hwframe+0x61/0xcb
[   60.035528] RIP: 0033:0x7f09681aa3ab
[   60.035542] Code: 0f 1e fa 48 8b 05 e5 7a 0d 00 64 c7 00 26 00 00 00 48 =
c7 c0 ff ff ff ff c3 66 0f 1f 44 00 00 f3 0f 1e fa b8 10 00 00 00 0f 05 <48=
> 3d 01 f0 ff ff 73 01 c3 48 8b 0d b5 7a 0d 00 f7 d8 64 89 01 48
[   60.035554] RSP: 002b:00007fff40931638 EFLAGS: 00000246 ORIG_RAX: 000000=
0000000010
[   60.035567] RAX: ffffffffffffffda RBX: 00007fff40931670 RCX: 00007f09681=
aa3ab
[   60.035576] RDX: 00007fff40931670 RSI: 00000000c06864a2 RDI: 00000000000=
00009
[   60.035584] RBP: 00000000c06864a2 R08: 0000000000000000 R09: 00005560dd4=
10090
[   60.035592] R10: 0000000000000000 R11: 0000000000000246 R12: 00000000000=
0007f
[   60.035601] R13: 0000000000000009 R14: 00005560dd40ffe0 R15: 00005560dd4=
10020
[   60.035613]  </TASK>
[   60.035622] ---[ end trace a700e85625cc752d ]---
