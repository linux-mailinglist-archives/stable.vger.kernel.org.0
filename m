Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6052603E2E
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 11:11:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232786AbiJSJLO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 05:11:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233153AbiJSJKQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 05:10:16 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A70B4C2CAD
        for <stable@vger.kernel.org>; Wed, 19 Oct 2022 02:02:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666170125; x=1697706125;
  h=from:to:cc:subject:in-reply-to:references:date:
   message-id:mime-version:content-transfer-encoding;
  bh=BYKm0/YyTzBHhNuQUuji8JRtNzY4nNT1fi51l0avNgg=;
  b=kSMNggm5R+atOm2Kt5cO+y+/M6nMzu4BGQ3JzFlPn2GaB2yTlip0VvXG
   Hsa7ct/s7ckhl38RMyQSiVibtvojH0lh7whRyV+eI9JnINyfYkY6y7i0Q
   zd9cCTi546JM2BACwYRKmHpwklzSQHJeQrkpNBnuH8TL0Q2y8xifzulHj
   GDtbCdgYUaB4VJHeGUcej3njsDcaTNpjAr1ucrR3JwTOUWyQnfvwMlmR+
   QONKfKQbVa+RIS2MPiFwBx9/eIJ7Tf3ODZMBp/z7XCPdN7RjnC2CeHJIE
   tkK7u4Is1UdJteLi/teQMYtwcOLjT1KecdCOxUjFHaD7rXvAt71n077qu
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10504"; a="306340294"
X-IronPort-AV: E=Sophos;i="5.95,195,1661842800"; 
   d="scan'208";a="306340294"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2022 02:00:06 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10504"; a="580239322"
X-IronPort-AV: E=Sophos;i="5.95,195,1661842800"; 
   d="scan'208";a="580239322"
Received: from mosermix-mobl2.ger.corp.intel.com (HELO localhost) ([10.252.50.2])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2022 02:00:04 -0700
From:   Jani Nikula <jani.nikula@linux.intel.com>
To:     Imre Deak <imre.deak@intel.com>, intel-gfx@lists.freedesktop.org
Cc:     stable@vger.kernel.org
Subject: Re: [Intel-gfx] [PATCH 1/3] drm/i915/tgl+: Add locking around DKL
 PHY register accesses
In-Reply-To: <20221018172042.1449885-1-imre.deak@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
References: <20221018172042.1449885-1-imre.deak@intel.com>
Date:   Wed, 19 Oct 2022 12:00:02 +0300
Message-ID: <87bkq8i3xp.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 18 Oct 2022, Imre Deak <imre.deak@intel.com> wrote:
> Accessing the TypeC DKL PHY registers during modeset-commit,
> -verification, DP link-retraining and AUX power well toggling is racy
> due to these code paths being concurrent and the PHY register bank
> selection register (HIP_INDEX_REG) being shared between PHY instances
> (aka TC ports) and the bank selection being not atomic wrt. the actual
> PHY register access.
>
> Add the required locking around each PHY register bank selection->
> register access sequence.

I honestly think the abstraction here is at a too low level.

Too many places are doing DKL PHY register access to begin with. IMO the
solution should be to abstract DKL PHY better, not to provide low level
DKL PHY register accessors.

Indeed, this level of granularity leads to a lot of unnecessary
lock/unlock that could have a longer span otherwise, and the interface
does not lend itself for that. Also requires separate bank selection for
every write, nearly doubling the MMIO writes.

I think the choice of intel_tc.c is indicative of the problems in
abstraction. That file has zero DKL PHY register access currently, but
becomes the focal point of DKL PHY.

I'd aim at adding intel_dkl_phy.c which is the only place that includes
intel_dkl_phy_regs.h and only place that directly uses the DKL PHY
registers. And with that, maybe you don't need to add any DKL PHY
specific register accessors.

BR,
Jani.



>
> Kudos to Ville for noticing the race conditions.
>
> Cc: Ville Syrj=C3=A4l=C3=A4 <ville.syrjala@linux.intel.com>
> Cc: <stable@vger.kernel.org> # v5.5+
> Signed-off-by: Imre Deak <imre.deak@intel.com>
> ---
>  drivers/gpu/drm/i915/display/intel_ddi.c      | 67 ++++++-------
>  drivers/gpu/drm/i915/display/intel_display.c  |  2 +
>  .../gpu/drm/i915/display/intel_display_core.h |  4 +
>  .../i915/display/intel_display_power_well.c   |  6 +-
>  drivers/gpu/drm/i915/display/intel_dpll_mgr.c | 58 +++++-------
>  drivers/gpu/drm/i915/display/intel_tc.c       | 94 +++++++++++++++++++
>  drivers/gpu/drm/i915/display/intel_tc.h       |  9 ++
>  drivers/gpu/drm/i915/i915_reg.h               |  3 +
>  8 files changed, 167 insertions(+), 76 deletions(-)
>
> diff --git a/drivers/gpu/drm/i915/display/intel_ddi.c b/drivers/gpu/drm/i=
915/display/intel_ddi.c
> index 971356237eca3..8e2b338883858 100644
> --- a/drivers/gpu/drm/i915/display/intel_ddi.c
> +++ b/drivers/gpu/drm/i915/display/intel_ddi.c
> @@ -1262,33 +1262,30 @@ static void tgl_dkl_phy_set_signal_levels(struct =
intel_encoder *encoder,
>  	for (ln =3D 0; ln < 2; ln++) {
>  		int level;
>=20=20
> -		intel_de_write(dev_priv, HIP_INDEX_REG(tc_port),
> -			       HIP_INDEX_VAL(tc_port, ln));
> -
> -		intel_de_write(dev_priv, DKL_TX_PMD_LANE_SUS(tc_port), 0);
> +		intel_tc_dkl_write(dev_priv, DKL_TX_PMD_LANE_SUS(tc_port), ln, 0);
>=20=20
>  		level =3D intel_ddi_level(encoder, crtc_state, 2*ln+0);
>=20=20
> -		intel_de_rmw(dev_priv, DKL_TX_DPCNTL0(tc_port),
> -			     DKL_TX_PRESHOOT_COEFF_MASK |
> -			     DKL_TX_DE_EMPAHSIS_COEFF_MASK |
> -			     DKL_TX_VSWING_CONTROL_MASK,
> -			     DKL_TX_PRESHOOT_COEFF(trans->entries[level].dkl.preshoot) |
> -			     DKL_TX_DE_EMPHASIS_COEFF(trans->entries[level].dkl.de_emphasis) |
> -			     DKL_TX_VSWING_CONTROL(trans->entries[level].dkl.vswing));
> +		intel_tc_dkl_rmw(dev_priv, DKL_TX_DPCNTL0(tc_port), ln,
> +				 DKL_TX_PRESHOOT_COEFF_MASK |
> +				 DKL_TX_DE_EMPAHSIS_COEFF_MASK |
> +				 DKL_TX_VSWING_CONTROL_MASK,
> +				 DKL_TX_PRESHOOT_COEFF(trans->entries[level].dkl.preshoot) |
> +				 DKL_TX_DE_EMPHASIS_COEFF(trans->entries[level].dkl.de_emphasis) |
> +				 DKL_TX_VSWING_CONTROL(trans->entries[level].dkl.vswing));
>=20=20
>  		level =3D intel_ddi_level(encoder, crtc_state, 2*ln+1);
>=20=20
> -		intel_de_rmw(dev_priv, DKL_TX_DPCNTL1(tc_port),
> -			     DKL_TX_PRESHOOT_COEFF_MASK |
> -			     DKL_TX_DE_EMPAHSIS_COEFF_MASK |
> -			     DKL_TX_VSWING_CONTROL_MASK,
> -			     DKL_TX_PRESHOOT_COEFF(trans->entries[level].dkl.preshoot) |
> -			     DKL_TX_DE_EMPHASIS_COEFF(trans->entries[level].dkl.de_emphasis) |
> -			     DKL_TX_VSWING_CONTROL(trans->entries[level].dkl.vswing));
> +		intel_tc_dkl_rmw(dev_priv, DKL_TX_DPCNTL1(tc_port), ln,
> +				 DKL_TX_PRESHOOT_COEFF_MASK |
> +				 DKL_TX_DE_EMPAHSIS_COEFF_MASK |
> +				 DKL_TX_VSWING_CONTROL_MASK,
> +				 DKL_TX_PRESHOOT_COEFF(trans->entries[level].dkl.preshoot) |
> +				 DKL_TX_DE_EMPHASIS_COEFF(trans->entries[level].dkl.de_emphasis) |
> +				 DKL_TX_VSWING_CONTROL(trans->entries[level].dkl.vswing));
>=20=20
> -		intel_de_rmw(dev_priv, DKL_TX_DPCNTL2(tc_port),
> -			     DKL_TX_DP20BITMODE, 0);
> +		intel_tc_dkl_rmw(dev_priv, DKL_TX_DPCNTL2(tc_port), ln,
> +				 DKL_TX_DP20BITMODE, 0);
>=20=20
>  		if (IS_ALDERLAKE_P(dev_priv)) {
>  			u32 val;
> @@ -1306,10 +1303,10 @@ static void tgl_dkl_phy_set_signal_levels(struct =
intel_encoder *encoder,
>  				val |=3D DKL_TX_DPCNTL2_CFG_LOADGENSELECT_TX2(0);
>  			}
>=20=20
> -			intel_de_rmw(dev_priv, DKL_TX_DPCNTL2(tc_port),
> -				     DKL_TX_DPCNTL2_CFG_LOADGENSELECT_TX1_MASK |
> -				     DKL_TX_DPCNTL2_CFG_LOADGENSELECT_TX2_MASK,
> -				     val);
> +			intel_tc_dkl_rmw(dev_priv, DKL_TX_DPCNTL2(tc_port), ln,
> +					 DKL_TX_DPCNTL2_CFG_LOADGENSELECT_TX1_MASK |
> +					 DKL_TX_DPCNTL2_CFG_LOADGENSELECT_TX2_MASK,
> +					 val);
>  		}
>  	}
>  }
> @@ -2019,12 +2016,8 @@ icl_program_mg_dp_mode(struct intel_digital_port *=
dig_port,
>  		return;
>=20=20
>  	if (DISPLAY_VER(dev_priv) >=3D 12) {
> -		intel_de_write(dev_priv, HIP_INDEX_REG(tc_port),
> -			       HIP_INDEX_VAL(tc_port, 0x0));
> -		ln0 =3D intel_de_read(dev_priv, DKL_DP_MODE(tc_port));
> -		intel_de_write(dev_priv, HIP_INDEX_REG(tc_port),
> -			       HIP_INDEX_VAL(tc_port, 0x1));
> -		ln1 =3D intel_de_read(dev_priv, DKL_DP_MODE(tc_port));
> +		ln0 =3D intel_tc_dkl_read(dev_priv, DKL_DP_MODE(tc_port), 0);
> +		ln1 =3D intel_tc_dkl_read(dev_priv, DKL_DP_MODE(tc_port), 1);
>  	} else {
>  		ln0 =3D intel_de_read(dev_priv, MG_DP_MODE(0, tc_port));
>  		ln1 =3D intel_de_read(dev_priv, MG_DP_MODE(1, tc_port));
> @@ -2085,12 +2078,8 @@ icl_program_mg_dp_mode(struct intel_digital_port *=
dig_port,
>  	}
>=20=20
>  	if (DISPLAY_VER(dev_priv) >=3D 12) {
> -		intel_de_write(dev_priv, HIP_INDEX_REG(tc_port),
> -			       HIP_INDEX_VAL(tc_port, 0x0));
> -		intel_de_write(dev_priv, DKL_DP_MODE(tc_port), ln0);
> -		intel_de_write(dev_priv, HIP_INDEX_REG(tc_port),
> -			       HIP_INDEX_VAL(tc_port, 0x1));
> -		intel_de_write(dev_priv, DKL_DP_MODE(tc_port), ln1);
> +		intel_tc_dkl_write(dev_priv, DKL_DP_MODE(tc_port), 0, ln0);
> +		intel_tc_dkl_write(dev_priv, DKL_DP_MODE(tc_port), 1, ln1);
>  	} else {
>  		intel_de_write(dev_priv, MG_DP_MODE(0, tc_port), ln0);
>  		intel_de_write(dev_priv, MG_DP_MODE(1, tc_port), ln1);
> @@ -3094,10 +3083,8 @@ static void adlp_tbt_to_dp_alt_switch_wa(struct in=
tel_encoder *encoder)
>  	enum tc_port tc_port =3D intel_port_to_tc(i915, encoder->port);
>  	int ln;
>=20=20
> -	for (ln =3D 0; ln < 2; ln++) {
> -		intel_de_write(i915, HIP_INDEX_REG(tc_port), HIP_INDEX_VAL(tc_port, ln=
));
> -		intel_de_rmw(i915, DKL_PCS_DW5(tc_port), DKL_PCS_DW5_CORE_SOFTRESET, 0=
);
> -	}
> +	for (ln =3D 0; ln < 2; ln++)
> +		intel_tc_dkl_rmw(i915, DKL_PCS_DW5(tc_port), ln, DKL_PCS_DW5_CORE_SOFT=
RESET, 0);
>  }
>=20=20
>  static void intel_ddi_prepare_link_retrain(struct intel_dp *intel_dp,
> diff --git a/drivers/gpu/drm/i915/display/intel_display.c b/drivers/gpu/d=
rm/i915/display/intel_display.c
> index 606f9140d024f..68ebf49e6fdbd 100644
> --- a/drivers/gpu/drm/i915/display/intel_display.c
> +++ b/drivers/gpu/drm/i915/display/intel_display.c
> @@ -7907,6 +7907,8 @@ static void intel_setup_outputs(struct drm_i915_pri=
vate *dev_priv)
>=20=20
>  	intel_pps_unlock_regs_wa(dev_priv);
>=20=20
> +	spin_lock_init(&dev_priv->display.tc.dkl_lock);
> +
>  	if (!HAS_DISPLAY(dev_priv))
>  		return;
>=20=20
> diff --git a/drivers/gpu/drm/i915/display/intel_display_core.h b/drivers/=
gpu/drm/i915/display/intel_display_core.h
> index 96cf994b0ad1f..6e8371e8ebdb6 100644
> --- a/drivers/gpu/drm/i915/display/intel_display_core.h
> +++ b/drivers/gpu/drm/i915/display/intel_display_core.h
> @@ -394,6 +394,10 @@ struct intel_display {
>  		u32 block_time_us;
>  	} sagv;
>=20=20
> +	struct {
> +		spinlock_t dkl_lock;
> +	} tc;
> +
>  	struct {
>  		/* ordered wq for modesets */
>  		struct workqueue_struct *modeset;
> diff --git a/drivers/gpu/drm/i915/display/intel_display_power_well.c b/dr=
ivers/gpu/drm/i915/display/intel_display_power_well.c
> index df7ee4969ef17..c37d2d5bbd983 100644
> --- a/drivers/gpu/drm/i915/display/intel_display_power_well.c
> +++ b/drivers/gpu/drm/i915/display/intel_display_power_well.c
> @@ -529,11 +529,9 @@ icl_tc_phy_aux_power_well_enable(struct drm_i915_pri=
vate *dev_priv,
>  		enum tc_port tc_port;
>=20=20
>  		tc_port =3D TGL_AUX_PW_TO_TC_PORT(i915_power_well_instance(power_well)=
->hsw.idx);
> -		intel_de_write(dev_priv, HIP_INDEX_REG(tc_port),
> -			       HIP_INDEX_VAL(tc_port, 0x2));
>=20=20
> -		if (intel_de_wait_for_set(dev_priv, DKL_CMN_UC_DW_27(tc_port),
> -					  DKL_CMN_UC_DW27_UC_HEALTH, 1))
> +		if (wait_for(intel_tc_dkl_read(dev_priv, DKL_CMN_UC_DW_27(tc_port), 2)=
 &
> +			     DKL_CMN_UC_DW27_UC_HEALTH, 1))
>  			drm_warn(&dev_priv->drm,
>  				 "Timeout waiting TC uC health\n");
>  	}
> diff --git a/drivers/gpu/drm/i915/display/intel_dpll_mgr.c b/drivers/gpu/=
drm/i915/display/intel_dpll_mgr.c
> index b63600d8ebeb0..28895e51c9c21 100644
> --- a/drivers/gpu/drm/i915/display/intel_dpll_mgr.c
> +++ b/drivers/gpu/drm/i915/display/intel_dpll_mgr.c
> @@ -3486,15 +3486,12 @@ static bool dkl_pll_get_hw_state(struct drm_i915_=
private *dev_priv,
>  	 * All registers read here have the same HIP_INDEX_REG even though
>  	 * they are on different building blocks
>  	 */
> -	intel_de_write(dev_priv, HIP_INDEX_REG(tc_port),
> -		       HIP_INDEX_VAL(tc_port, 0x2));
> -
> -	hw_state->mg_refclkin_ctl =3D intel_de_read(dev_priv,
> -						  DKL_REFCLKIN_CTL(tc_port));
> +	hw_state->mg_refclkin_ctl =3D intel_tc_dkl_read(dev_priv,
> +						      DKL_REFCLKIN_CTL(tc_port), 2);
>  	hw_state->mg_refclkin_ctl &=3D MG_REFCLKIN_CTL_OD_2_MUX_MASK;
>=20=20
>  	hw_state->mg_clktop2_hsclkctl =3D
> -		intel_de_read(dev_priv, DKL_CLKTOP2_HSCLKCTL(tc_port));
> +		intel_tc_dkl_read(dev_priv, DKL_CLKTOP2_HSCLKCTL(tc_port), 2);
>  	hw_state->mg_clktop2_hsclkctl &=3D
>  		MG_CLKTOP2_HSCLKCTL_TLINEDRV_CLKSEL_MASK |
>  		MG_CLKTOP2_HSCLKCTL_CORE_INPUTSEL_MASK |
> @@ -3502,32 +3499,32 @@ static bool dkl_pll_get_hw_state(struct drm_i915_=
private *dev_priv,
>  		MG_CLKTOP2_HSCLKCTL_DSDIV_RATIO_MASK;
>=20=20
>  	hw_state->mg_clktop2_coreclkctl1 =3D
> -		intel_de_read(dev_priv, DKL_CLKTOP2_CORECLKCTL1(tc_port));
> +		intel_tc_dkl_read(dev_priv, DKL_CLKTOP2_CORECLKCTL1(tc_port), 2);
>  	hw_state->mg_clktop2_coreclkctl1 &=3D
>  		MG_CLKTOP2_CORECLKCTL1_A_DIVRATIO_MASK;
>=20=20
> -	hw_state->mg_pll_div0 =3D intel_de_read(dev_priv, DKL_PLL_DIV0(tc_port)=
);
> +	hw_state->mg_pll_div0 =3D intel_tc_dkl_read(dev_priv, DKL_PLL_DIV0(tc_p=
ort), 2);
>  	val =3D DKL_PLL_DIV0_MASK;
>  	if (dev_priv->display.vbt.override_afc_startup)
>  		val |=3D DKL_PLL_DIV0_AFC_STARTUP_MASK;
>  	hw_state->mg_pll_div0 &=3D val;
>=20=20
> -	hw_state->mg_pll_div1 =3D intel_de_read(dev_priv, DKL_PLL_DIV1(tc_port)=
);
> +	hw_state->mg_pll_div1 =3D intel_tc_dkl_read(dev_priv, DKL_PLL_DIV1(tc_p=
ort), 2);
>  	hw_state->mg_pll_div1 &=3D (DKL_PLL_DIV1_IREF_TRIM_MASK |
>  				  DKL_PLL_DIV1_TDC_TARGET_CNT_MASK);
>=20=20
> -	hw_state->mg_pll_ssc =3D intel_de_read(dev_priv, DKL_PLL_SSC(tc_port));
> +	hw_state->mg_pll_ssc =3D intel_tc_dkl_read(dev_priv, DKL_PLL_SSC(tc_por=
t), 2);
>  	hw_state->mg_pll_ssc &=3D (DKL_PLL_SSC_IREF_NDIV_RATIO_MASK |
>  				 DKL_PLL_SSC_STEP_LEN_MASK |
>  				 DKL_PLL_SSC_STEP_NUM_MASK |
>  				 DKL_PLL_SSC_EN);
>=20=20
> -	hw_state->mg_pll_bias =3D intel_de_read(dev_priv, DKL_PLL_BIAS(tc_port)=
);
> +	hw_state->mg_pll_bias =3D intel_tc_dkl_read(dev_priv, DKL_PLL_BIAS(tc_p=
ort), 2);
>  	hw_state->mg_pll_bias &=3D (DKL_PLL_BIAS_FRAC_EN_H |
>  				  DKL_PLL_BIAS_FBDIV_FRAC_MASK);
>=20=20
>  	hw_state->mg_pll_tdc_coldst_bias =3D
> -		intel_de_read(dev_priv, DKL_PLL_TDC_COLDST_BIAS(tc_port));
> +		intel_tc_dkl_read(dev_priv, DKL_PLL_TDC_COLDST_BIAS(tc_port), 2);
>  	hw_state->mg_pll_tdc_coldst_bias &=3D (DKL_PLL_TDC_SSC_STEP_SIZE_MASK |
>  					     DKL_PLL_TDC_FEED_FWD_GAIN_MASK);
>=20=20
> @@ -3715,61 +3712,58 @@ static void dkl_pll_write(struct drm_i915_private=
 *dev_priv,
>  	 * All registers programmed here have the same HIP_INDEX_REG even
>  	 * though on different building block
>  	 */
> -	intel_de_write(dev_priv, HIP_INDEX_REG(tc_port),
> -		       HIP_INDEX_VAL(tc_port, 0x2));
> -
>  	/* All the registers are RMW */
> -	val =3D intel_de_read(dev_priv, DKL_REFCLKIN_CTL(tc_port));
> +	val =3D intel_tc_dkl_read(dev_priv, DKL_REFCLKIN_CTL(tc_port), 2);
>  	val &=3D ~MG_REFCLKIN_CTL_OD_2_MUX_MASK;
>  	val |=3D hw_state->mg_refclkin_ctl;
> -	intel_de_write(dev_priv, DKL_REFCLKIN_CTL(tc_port), val);
> +	intel_tc_dkl_write(dev_priv, DKL_REFCLKIN_CTL(tc_port), 2, val);
>=20=20
> -	val =3D intel_de_read(dev_priv, DKL_CLKTOP2_CORECLKCTL1(tc_port));
> +	val =3D intel_tc_dkl_read(dev_priv, DKL_CLKTOP2_CORECLKCTL1(tc_port), 2=
);
>  	val &=3D ~MG_CLKTOP2_CORECLKCTL1_A_DIVRATIO_MASK;
>  	val |=3D hw_state->mg_clktop2_coreclkctl1;
> -	intel_de_write(dev_priv, DKL_CLKTOP2_CORECLKCTL1(tc_port), val);
> +	intel_tc_dkl_write(dev_priv, DKL_CLKTOP2_CORECLKCTL1(tc_port), 2, val);
>=20=20
> -	val =3D intel_de_read(dev_priv, DKL_CLKTOP2_HSCLKCTL(tc_port));
> +	val =3D intel_tc_dkl_read(dev_priv, DKL_CLKTOP2_HSCLKCTL(tc_port), 2);
>  	val &=3D ~(MG_CLKTOP2_HSCLKCTL_TLINEDRV_CLKSEL_MASK |
>  		 MG_CLKTOP2_HSCLKCTL_CORE_INPUTSEL_MASK |
>  		 MG_CLKTOP2_HSCLKCTL_HSDIV_RATIO_MASK |
>  		 MG_CLKTOP2_HSCLKCTL_DSDIV_RATIO_MASK);
>  	val |=3D hw_state->mg_clktop2_hsclkctl;
> -	intel_de_write(dev_priv, DKL_CLKTOP2_HSCLKCTL(tc_port), val);
> +	intel_tc_dkl_write(dev_priv, DKL_CLKTOP2_HSCLKCTL(tc_port), 2, val);
>=20=20
>  	val =3D DKL_PLL_DIV0_MASK;
>  	if (dev_priv->display.vbt.override_afc_startup)
>  		val |=3D DKL_PLL_DIV0_AFC_STARTUP_MASK;
> -	intel_de_rmw(dev_priv, DKL_PLL_DIV0(tc_port), val,
> -		     hw_state->mg_pll_div0);
> +	intel_tc_dkl_rmw(dev_priv, DKL_PLL_DIV0(tc_port), 2, val,
> +			 hw_state->mg_pll_div0);
>=20=20
> -	val =3D intel_de_read(dev_priv, DKL_PLL_DIV1(tc_port));
> +	val =3D intel_tc_dkl_read(dev_priv, DKL_PLL_DIV1(tc_port), 2);
>  	val &=3D ~(DKL_PLL_DIV1_IREF_TRIM_MASK |
>  		 DKL_PLL_DIV1_TDC_TARGET_CNT_MASK);
>  	val |=3D hw_state->mg_pll_div1;
> -	intel_de_write(dev_priv, DKL_PLL_DIV1(tc_port), val);
> +	intel_tc_dkl_write(dev_priv, DKL_PLL_DIV1(tc_port), 2, val);
>=20=20
> -	val =3D intel_de_read(dev_priv, DKL_PLL_SSC(tc_port));
> +	val =3D intel_tc_dkl_read(dev_priv, DKL_PLL_SSC(tc_port), 2);
>  	val &=3D ~(DKL_PLL_SSC_IREF_NDIV_RATIO_MASK |
>  		 DKL_PLL_SSC_STEP_LEN_MASK |
>  		 DKL_PLL_SSC_STEP_NUM_MASK |
>  		 DKL_PLL_SSC_EN);
>  	val |=3D hw_state->mg_pll_ssc;
> -	intel_de_write(dev_priv, DKL_PLL_SSC(tc_port), val);
> +	intel_tc_dkl_write(dev_priv, DKL_PLL_SSC(tc_port), 2, val);
>=20=20
> -	val =3D intel_de_read(dev_priv, DKL_PLL_BIAS(tc_port));
> +	val =3D intel_tc_dkl_read(dev_priv, DKL_PLL_BIAS(tc_port), 2);
>  	val &=3D ~(DKL_PLL_BIAS_FRAC_EN_H |
>  		 DKL_PLL_BIAS_FBDIV_FRAC_MASK);
>  	val |=3D hw_state->mg_pll_bias;
> -	intel_de_write(dev_priv, DKL_PLL_BIAS(tc_port), val);
> +	intel_tc_dkl_write(dev_priv, DKL_PLL_BIAS(tc_port), 2, val);
>=20=20
> -	val =3D intel_de_read(dev_priv, DKL_PLL_TDC_COLDST_BIAS(tc_port));
> +	val =3D intel_tc_dkl_read(dev_priv, DKL_PLL_TDC_COLDST_BIAS(tc_port), 2=
);
>  	val &=3D ~(DKL_PLL_TDC_SSC_STEP_SIZE_MASK |
>  		 DKL_PLL_TDC_FEED_FWD_GAIN_MASK);
>  	val |=3D hw_state->mg_pll_tdc_coldst_bias;
> -	intel_de_write(dev_priv, DKL_PLL_TDC_COLDST_BIAS(tc_port), val);
> +	intel_tc_dkl_write(dev_priv, DKL_PLL_TDC_COLDST_BIAS(tc_port), 2, val);
>=20=20
> -	intel_de_posting_read(dev_priv, DKL_PLL_TDC_COLDST_BIAS(tc_port));
> +	intel_tc_dkl_posting_read(dev_priv, DKL_PLL_TDC_COLDST_BIAS(tc_port), 2=
);
>  }
>=20=20
>  static void icl_pll_power_enable(struct drm_i915_private *dev_priv,
> diff --git a/drivers/gpu/drm/i915/display/intel_tc.c b/drivers/gpu/drm/i9=
15/display/intel_tc.c
> index 8cecd41ed0033..8123699d3dbfb 100644
> --- a/drivers/gpu/drm/i915/display/intel_tc.c
> +++ b/drivers/gpu/drm/i915/display/intel_tc.c
> @@ -5,6 +5,7 @@
>=20=20
>  #include "i915_drv.h"
>  #include "i915_reg.h"
> +#include "intel_de.h"
>  #include "intel_display.h"
>  #include "intel_display_power_map.h"
>  #include "intel_display_types.h"
> @@ -894,6 +895,99 @@ void intel_tc_port_put_link(struct intel_digital_por=
t *dig_port)
>  	intel_tc_port_flush_work(dig_port);
>  }
>=20=20
> +static void dkl_set_hip_idx(struct drm_i915_private *i915, i915_reg_t re=
g, int idx)
> +{
> +	enum tc_port tc_port =3D DKL_REG_TC_PORT(reg);
> +
> +	drm_WARN_ON(&i915->drm, tc_port < TC_PORT_1 || tc_port >=3D I915_MAX_TC=
_PORTS);
> +
> +	intel_de_write(i915,
> +		       HIP_INDEX_REG(tc_port),
> +		       HIP_INDEX_VAL(tc_port, idx));
> +}
> +
> +/**
> + * intel_tc_dkl_read - read a Dekel PHY register
> + * @i915: i915 device instance
> + * @reg: Dekel PHY register
> + * @ln: lane instance of @reg
> + *
> + * Read the @reg Dekel PHY register.
> + *
> + * Returns the read value.
> + */
> +u32 intel_tc_dkl_read(struct drm_i915_private *i915, i915_reg_t reg, int=
 ln)
> +{
> +	u32 val;
> +
> +	spin_lock(&i915->display.tc.dkl_lock);
> +
> +	dkl_set_hip_idx(i915, reg, ln);
> +	val =3D intel_de_read(i915, reg);
> +
> +	spin_unlock(&i915->display.tc.dkl_lock);
> +
> +	return val;
> +}
> +
> +/**
> + * intel_tc_dkl_write - write a Dekel PHY register
> + * @i915: i915 device instance
> + * @reg: Dekel PHY register
> + * @ln: lane instance of @reg
> + * @val: value to write
> + *
> + * Write @val to the @reg Dekel PHY register.
> + */
> +void intel_tc_dkl_write(struct drm_i915_private *i915, i915_reg_t reg, i=
nt ln, u32 val)
> +{
> +	spin_lock(&i915->display.tc.dkl_lock);
> +
> +	dkl_set_hip_idx(i915, reg, ln);
> +	intel_de_write(i915, reg, val);
> +
> +	spin_unlock(&i915->display.tc.dkl_lock);
> +}
> +
> +/**
> + * intel_tc_dkl_rmw - read-modify-write a Dekel PHY register
> + * @i915: i915 device instance
> + * @reg: Dekel PHY register
> + * @ln: lane instance of @reg
> + * @clear: mask to clear
> + * @set: mask to set
> + *
> + * Read the @reg Dekel PHY register, clearing then setting the @clear/@s=
et bits in it, and writing
> + * this value back to the register if the value differs from the read on=
e.
> + */
> +void intel_tc_dkl_rmw(struct drm_i915_private *i915, i915_reg_t reg, int=
 ln, u32 clear, u32 set)
> +{
> +	spin_lock(&i915->display.tc.dkl_lock);
> +
> +	dkl_set_hip_idx(i915, reg, ln);
> +	intel_de_rmw(i915, reg, clear, set);
> +
> +	spin_unlock(&i915->display.tc.dkl_lock);
> +}
> +
> +/**
> + * intel_tc_dkl_posting_read - do a posting read from a Dekel PHY regist=
er
> + * @i915: i915 device instance
> + * @reg: Dekel PHY register
> + * @ln: lane instance of @reg
> + *
> + * Read the @reg Dekel PHY register without returning the read value.
> + */
> +void intel_tc_dkl_posting_read(struct drm_i915_private *i915, i915_reg_t=
 reg, int ln)
> +{
> +	spin_lock(&i915->display.tc.dkl_lock);
> +
> +	dkl_set_hip_idx(i915, reg, ln);
> +	intel_de_posting_read(i915, reg);
> +
> +	spin_unlock(&i915->display.tc.dkl_lock);
> +}
> +
>  static bool
>  tc_has_modular_fia(struct drm_i915_private *i915, struct intel_digital_p=
ort *dig_port)
>  {
> diff --git a/drivers/gpu/drm/i915/display/intel_tc.h b/drivers/gpu/drm/i9=
15/display/intel_tc.h
> index d54082e2d5e8d..330ff0fb12f16 100644
> --- a/drivers/gpu/drm/i915/display/intel_tc.h
> +++ b/drivers/gpu/drm/i915/display/intel_tc.h
> @@ -9,6 +9,10 @@
>  #include <linux/mutex.h>
>  #include <linux/types.h>
>=20=20
> +#include "i915_reg_defs.h"
> +
> +struct drm_i915_private;
> +
>  struct intel_digital_port;
>  struct intel_encoder;
>=20=20
> @@ -34,6 +38,11 @@ void intel_tc_port_get_link(struct intel_digital_port =
*dig_port,
>  void intel_tc_port_put_link(struct intel_digital_port *dig_port);
>  bool intel_tc_port_ref_held(struct intel_digital_port *dig_port);
>=20=20
> +u32 intel_tc_dkl_read(struct drm_i915_private *i915, i915_reg_t reg, int=
 ln);
> +void intel_tc_dkl_write(struct drm_i915_private *i915, i915_reg_t reg, i=
nt ln, u32 val);
> +void intel_tc_dkl_rmw(struct drm_i915_private *i915, i915_reg_t reg, int=
 ln, u32 clear, u32 set);
> +void intel_tc_dkl_posting_read(struct drm_i915_private *i915, i915_reg_t=
 reg, int ln);
> +
>  void intel_tc_port_init(struct intel_digital_port *dig_port, bool is_leg=
acy);
>=20=20
>  bool intel_tc_cold_requires_aux_pw(struct intel_digital_port *dig_port);
> diff --git a/drivers/gpu/drm/i915/i915_reg.h b/drivers/gpu/drm/i915/i915_=
reg.h
> index 99a8535193957..2b7c019725462 100644
> --- a/drivers/gpu/drm/i915/i915_reg.h
> +++ b/drivers/gpu/drm/i915/i915_reg.h
> @@ -7442,6 +7442,9 @@ enum skl_power_gate {
>  #define _DKL_PHY5_BASE			0x16C000
>  #define _DKL_PHY6_BASE			0x16D000
>=20=20
> +#define _DKL_BANK_SHIFT			12
> +#define DKL_REG_TC_PORT(reg)		(((reg).reg - _DKL_PHY1_BASE) >> _DKL_BANK=
_SHIFT)
> +
>  /* DEKEL PHY MMIO Address =3D Phy base + (internal address & ~index_mask=
) */
>  #define _DKL_PCS_DW5			0x14
>  #define DKL_PCS_DW5(tc_port)		_MMIO(_PORT(tc_port, _DKL_PHY1_BASE, \

--=20
Jani Nikula, Intel Open Source Graphics Center
