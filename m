Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E34E8BB8B5
	for <lists+stable@lfdr.de>; Mon, 23 Sep 2019 17:54:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732880AbfIWPys (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Sep 2019 11:54:48 -0400
Received: from mga06.intel.com ([134.134.136.31]:22871 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728464AbfIWPys (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Sep 2019 11:54:48 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 23 Sep 2019 08:54:45 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,541,1559545200"; 
   d="scan'208";a="363669759"
Received: from labuser-z97x-ud5h.jf.intel.com (HELO intel.com) ([10.54.75.49])
  by orsmga005.jf.intel.com with ESMTP; 23 Sep 2019 08:54:45 -0700
Date:   Mon, 23 Sep 2019 08:56:12 -0700
From:   Manasi Navare <manasi.d.navare@intel.com>
To:     Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>
Cc:     Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        intel-gfx@lists.freedesktop.org, stable@vger.kernel.org
Subject: Re: [PATCH] drm/i915/dp: Fix dsc bpp calculations, v4.
Message-ID: <20190923155612.GB17911@intel.com>
References: <20190923130307.GK1208@intel.com>
 <20190923144947.18588-1-maarten.lankhorst@linux.intel.com>
 <20190923145757.GM1208@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190923145757.GM1208@intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Sep 23, 2019 at 05:57:57PM +0300, Ville Syrj�l� wrote:
> On Mon, Sep 23, 2019 at 04:49:47PM +0200, Maarten Lankhorst wrote:
> > There was a integer wraparound when mode_clock became too high,
> > and we didn't correct for the FEC overhead factor when dividing,
> > with the calculations breaking at HBR3.
> > 
> > As a result our calculated bpp was way too high, and the link width
> > limitation never came into effect.
> > 
> > Print out the resulting bpp calcululations as a sanity check, just
> > in case we ever have to debug it later on again.
> > 
> > We also used the wrong factor for FEC. While bspec mentions 2.4%,
> > all the calculations use 1/0.972261, and the same ratio should be
> > applied to data M/N as well, so use it there when FEC is enabled.
> > 
> > Make sure we don't break hw readout, and read out FEC enable state
> > and correct the DDI clock readout for the new values.
> > 
> > This fixes the FIFO underrun we are seeing with FEC enabled.
> > 
> > Changes since v2:
> > - Handle fec_enable in intel_link_compute_m_n, so only data M/N is adjusted. (Ville)
> > - Fix initial hardware readout for FEC. (Ville)
> > Changes since v3:
> > - Remove bogus fec_to_mode_clock. (Ville)
> > 
> > Signed-off-by: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
> > Fixes: d9218c8f6cf4 ("drm/i915/dp: Add helpers for Compressed BPP and Slice Count for DSC")
> > Cc: <stable@vger.kernel.org> # v5.0+
> > Cc: Manasi Navare <manasi.d.navare@intel.com>
> > ---
> >  drivers/gpu/drm/i915/display/intel_ddi.c     |  17 ++
> >  drivers/gpu/drm/i915/display/intel_display.c |  13 +-
> >  drivers/gpu/drm/i915/display/intel_display.h |   2 +-
> >  drivers/gpu/drm/i915/display/intel_dp.c      | 184 ++++++++++---------
> >  drivers/gpu/drm/i915/display/intel_dp.h      |   6 +-
> >  drivers/gpu/drm/i915/display/intel_dp_mst.c  |   2 +-
> >  6 files changed, 125 insertions(+), 99 deletions(-)
> > 
> > diff --git a/drivers/gpu/drm/i915/display/intel_ddi.c b/drivers/gpu/drm/i915/display/intel_ddi.c
> > index 0c0da9f6c2e8..1cb297abd111 100644
> > --- a/drivers/gpu/drm/i915/display/intel_ddi.c
> > +++ b/drivers/gpu/drm/i915/display/intel_ddi.c
> > @@ -4045,6 +4045,23 @@ void intel_ddi_get_config(struct intel_encoder *encoder,
> >  		pipe_config->lane_count =
> >  			((temp & DDI_PORT_WIDTH_MASK) >> DDI_PORT_WIDTH_SHIFT) + 1;
> >  		intel_dp_get_m_n(intel_crtc, pipe_config);
> > +
> > +		if (INTEL_GEN(dev_priv) >= 11) {
> > +			i915_reg_t dp_tp_ctl;
> > +
> > +			if (IS_GEN(dev_priv, 11))
> > +				dp_tp_ctl = DP_TP_CTL(pipe_config->cpu_transcoder);
> > +			else
> > +				dp_tp_ctl = TGL_DP_TP_CTL(pipe_config->cpu_transcoder);
> > +
> > +			pipe_config->fec_enable =
> > +				I915_READ(dp_tp_ctl) & DP_TP_CTL_FEC_ENABLE;
> 
> Can you split the fec_enable readout/state check into a separate
> patch?
> 
> I wonder how the lack of this stuff was missed when FEC was adeed...
> 

We never had any FEC DP panel when this initial FEC enabling stuff was added,
Anusha did test it with the FPGA based emulator that had FEC but we still missed the m_n
correction as there were no underruns reported that time.

Thanks Ville and Maarten for catching this and fixing it.

Manasi

> > +
> > +			DRM_DEBUG_KMS("[ENCODER:%d:%s] Fec status: %u\n",
> > +				      encoder->base.base.id, encoder->base.name,
> > +				      pipe_config->fec_enable);
> 
> I'd just include it as part of the normal state dump.
> 
> > +		}
> > +
> >  		break;
> >  	case TRANS_DDI_MODE_SELECT_DP_MST:
> >  		pipe_config->output_types |= BIT(INTEL_OUTPUT_DP_MST);
> > diff --git a/drivers/gpu/drm/i915/display/intel_display.c b/drivers/gpu/drm/i915/display/intel_display.c
> > index 5ecf54270181..31698a57773f 100644
> > --- a/drivers/gpu/drm/i915/display/intel_display.c
> > +++ b/drivers/gpu/drm/i915/display/intel_display.c
> > @@ -7291,7 +7291,7 @@ static int ironlake_fdi_compute_config(struct intel_crtc *intel_crtc,
> >  	pipe_config->fdi_lanes = lane;
> >  
> >  	intel_link_compute_m_n(pipe_config->pipe_bpp, lane, fdi_dotclock,
> > -			       link_bw, &pipe_config->fdi_m_n, false);
> > +			       link_bw, &pipe_config->fdi_m_n, false, false);
> >  
> >  	ret = ironlake_check_fdi_lanes(dev, intel_crtc->pipe, pipe_config);
> >  	if (ret == -EDEADLK)
> > @@ -7538,11 +7538,15 @@ void
> >  intel_link_compute_m_n(u16 bits_per_pixel, int nlanes,
> >  		       int pixel_clock, int link_clock,
> >  		       struct intel_link_m_n *m_n,
> > -		       bool constant_n)
> > +		       bool constant_n, bool fec_enable)
> >  {
> > -	m_n->tu = 64;
> > +	u32 data_clock = bits_per_pixel * pixel_clock;
> > +
> > +	if (fec_enable)
> > +		data_clock = intel_dp_mode_to_fec_clock(data_clock);
> >  
> > -	compute_m_n(bits_per_pixel * pixel_clock,
> > +	m_n->tu = 64;
> > +	compute_m_n(data_clock,
> >  		    link_clock * nlanes * 8,
> >  		    &m_n->gmch_m, &m_n->gmch_n,
> >  		    constant_n);
> > @@ -12832,6 +12836,7 @@ intel_pipe_config_compare(const struct intel_crtc_state *current_config,
> >  	PIPE_CONF_CHECK_BOOL(hdmi_scrambling);
> >  	PIPE_CONF_CHECK_BOOL(hdmi_high_tmds_clock_ratio);
> >  	PIPE_CONF_CHECK_BOOL(has_infoframe);
> > +	PIPE_CONF_CHECK_BOOL(fec_enable);
> >  
> >  	PIPE_CONF_CHECK_BOOL_INCOMPLETE(has_audio);
> >  
> > diff --git a/drivers/gpu/drm/i915/display/intel_display.h b/drivers/gpu/drm/i915/display/intel_display.h
> > index 5cea6f8e107a..4b9e18e5a263 100644
> > --- a/drivers/gpu/drm/i915/display/intel_display.h
> > +++ b/drivers/gpu/drm/i915/display/intel_display.h
> > @@ -443,7 +443,7 @@ enum phy_fia {
> >  void intel_link_compute_m_n(u16 bpp, int nlanes,
> >  			    int pixel_clock, int link_clock,
> >  			    struct intel_link_m_n *m_n,
> > -			    bool constant_n);
> > +			    bool constant_n, bool fec_enable);
> >  bool is_ccs_modifier(u64 modifier);
> >  void lpt_disable_clkout_dp(struct drm_i915_private *dev_priv);
> >  u32 intel_plane_fb_max_stride(struct drm_i915_private *dev_priv,
> > diff --git a/drivers/gpu/drm/i915/display/intel_dp.c b/drivers/gpu/drm/i915/display/intel_dp.c
> > index 829559f97440..2b1e71f992b0 100644
> > --- a/drivers/gpu/drm/i915/display/intel_dp.c
> > +++ b/drivers/gpu/drm/i915/display/intel_dp.c
> > @@ -76,8 +76,8 @@
> >  #define DP_DSC_MAX_ENC_THROUGHPUT_0		340000
> >  #define DP_DSC_MAX_ENC_THROUGHPUT_1		400000
> >  
> > -/* DP DSC FEC Overhead factor = (100 - 2.4)/100 */
> > -#define DP_DSC_FEC_OVERHEAD_FACTOR		976
> > +/* DP DSC FEC Overhead factor = 1/(0.972261) */
> > +#define DP_DSC_FEC_OVERHEAD_FACTOR		972261
> >  
> >  /* Compliance test status bits  */
> >  #define INTEL_DP_RESOLUTION_SHIFT_MASK	0
> > @@ -492,6 +492,97 @@ int intel_dp_get_link_train_fallback_values(struct intel_dp *intel_dp,
> >  	return 0;
> >  }
> >  
> > +u32 intel_dp_mode_to_fec_clock(u32 mode_clock)
> > +{
> > +	return div_u64(mul_u32_u32(mode_clock, 1000000U),
> > +		       DP_DSC_FEC_OVERHEAD_FACTOR);
> > +}
> > +
> > +static u16 intel_dp_dsc_get_output_bpp(u32 link_clock, u32 lane_count,
> > +				       u32 mode_clock, u32 mode_hdisplay)
> > +{
> > +	u32 bits_per_pixel, max_bpp_small_joiner_ram;
> > +	int i;
> > +
> > +	/*
> > +	 * Available Link Bandwidth(Kbits/sec) = (NumberOfLanes)*
> > +	 * (LinkSymbolClock)* 8 * (TimeSlotsPerMTP)
> > +	 * for SST -> TimeSlotsPerMTP is 1,
> > +	 * for MST -> TimeSlotsPerMTP has to be calculated
> > +	 */
> > +	bits_per_pixel = (link_clock * lane_count * 8) /
> > +			 intel_dp_mode_to_fec_clock(mode_clock);
> > +	DRM_DEBUG_KMS("Max link bpp: %u\n", bits_per_pixel);
> > +
> > +	/* Small Joiner Check: output bpp <= joiner RAM (bits) / Horiz. width */
> > +	max_bpp_small_joiner_ram = DP_DSC_MAX_SMALL_JOINER_RAM_BUFFER / mode_hdisplay;
> > +	DRM_DEBUG_KMS("Max small joiner bpp: %u\n", max_bpp_small_joiner_ram);
> > +
> > +	/*
> > +	 * Greatest allowed DSC BPP = MIN (output BPP from available Link BW
> > +	 * check, output bpp from small joiner RAM check)
> > +	 */
> > +	bits_per_pixel = min(bits_per_pixel, max_bpp_small_joiner_ram);
> > +
> > +	/* Error out if the max bpp is less than smallest allowed valid bpp */
> > +	if (bits_per_pixel < valid_dsc_bpp[0]) {
> > +		DRM_DEBUG_KMS("Unsupported BPP %u, min %u\n",
> > +			      bits_per_pixel, valid_dsc_bpp[0]);
> > +		return 0;
> > +	}
> > +
> > +	/* Find the nearest match in the array of known BPPs from VESA */
> > +	for (i = 0; i < ARRAY_SIZE(valid_dsc_bpp) - 1; i++) {
> > +		if (bits_per_pixel < valid_dsc_bpp[i + 1])
> > +			break;
> > +	}
> > +	bits_per_pixel = valid_dsc_bpp[i];
> > +
> > +	/*
> > +	 * Compressed BPP in U6.4 format so multiply by 16, for Gen 11,
> > +	 * fractional part is 0
> > +	 */
> > +	return bits_per_pixel << 4;
> > +}
> > +
> > +static u8 intel_dp_dsc_get_slice_count(struct intel_dp *intel_dp,
> > +				       int mode_clock, int mode_hdisplay)
> > +{
> > +	u8 min_slice_count, i;
> > +	int max_slice_width;
> > +
> > +	if (mode_clock <= DP_DSC_PEAK_PIXEL_RATE)
> > +		min_slice_count = DIV_ROUND_UP(mode_clock,
> > +					       DP_DSC_MAX_ENC_THROUGHPUT_0);
> > +	else
> > +		min_slice_count = DIV_ROUND_UP(mode_clock,
> > +					       DP_DSC_MAX_ENC_THROUGHPUT_1);
> > +
> > +	max_slice_width = drm_dp_dsc_sink_max_slice_width(intel_dp->dsc_dpcd);
> > +	if (max_slice_width < DP_DSC_MIN_SLICE_WIDTH_VALUE) {
> > +		DRM_DEBUG_KMS("Unsupported slice width %d by DP DSC Sink device\n",
> > +			      max_slice_width);
> > +		return 0;
> > +	}
> > +	/* Also take into account max slice width */
> > +	min_slice_count = min_t(u8, min_slice_count,
> > +				DIV_ROUND_UP(mode_hdisplay,
> > +					     max_slice_width));
> > +
> > +	/* Find the closest match to the valid slice count values */
> > +	for (i = 0; i < ARRAY_SIZE(valid_dsc_slicecount); i++) {
> > +		if (valid_dsc_slicecount[i] >
> > +		    drm_dp_dsc_sink_max_slice_count(intel_dp->dsc_dpcd,
> > +						    false))
> > +			break;
> > +		if (min_slice_count  <= valid_dsc_slicecount[i])
> > +			return valid_dsc_slicecount[i];
> > +	}
> > +
> > +	DRM_DEBUG_KMS("Unsupported Slice Count %d\n", min_slice_count);
> > +	return 0;
> > +}
> > +
> >  static enum drm_mode_status
> >  intel_dp_mode_valid(struct drm_connector *connector,
> >  		    struct drm_display_mode *mode)
> > @@ -2259,7 +2350,7 @@ intel_dp_compute_config(struct intel_encoder *encoder,
> >  			       adjusted_mode->crtc_clock,
> >  			       pipe_config->port_clock,
> >  			       &pipe_config->dp_m_n,
> > -			       constant_n);
> > +			       constant_n, pipe_config->fec_enable);
> >  
> >  	if (intel_connector->panel.downclock_mode != NULL &&
> >  		dev_priv->drrs.type == SEAMLESS_DRRS_SUPPORT) {
> > @@ -2269,7 +2360,7 @@ intel_dp_compute_config(struct intel_encoder *encoder,
> >  					       intel_connector->panel.downclock_mode->clock,
> >  					       pipe_config->port_clock,
> >  					       &pipe_config->dp_m2_n2,
> > -					       constant_n);
> > +					       constant_n, pipe_config->fec_enable);
> >  	}
> >  
> >  	if (!HAS_DDI(dev_priv))
> > @@ -4373,91 +4464,6 @@ intel_dp_get_sink_irq_esi(struct intel_dp *intel_dp, u8 *sink_irq_vector)
> >  		DP_DPRX_ESI_LEN;
> >  }
> >  
> > -u16 intel_dp_dsc_get_output_bpp(int link_clock, u8 lane_count,
> > -				int mode_clock, int mode_hdisplay)
> > -{
> > -	u16 bits_per_pixel, max_bpp_small_joiner_ram;
> > -	int i;
> > -
> > -	/*
> > -	 * Available Link Bandwidth(Kbits/sec) = (NumberOfLanes)*
> > -	 * (LinkSymbolClock)* 8 * ((100-FECOverhead)/100)*(TimeSlotsPerMTP)
> > -	 * FECOverhead = 2.4%, for SST -> TimeSlotsPerMTP is 1,
> > -	 * for MST -> TimeSlotsPerMTP has to be calculated
> > -	 */
> > -	bits_per_pixel = (link_clock * lane_count * 8 *
> > -			  DP_DSC_FEC_OVERHEAD_FACTOR) /
> > -		mode_clock;
> > -
> > -	/* Small Joiner Check: output bpp <= joiner RAM (bits) / Horiz. width */
> > -	max_bpp_small_joiner_ram = DP_DSC_MAX_SMALL_JOINER_RAM_BUFFER /
> > -		mode_hdisplay;
> > -
> > -	/*
> > -	 * Greatest allowed DSC BPP = MIN (output BPP from avaialble Link BW
> > -	 * check, output bpp from small joiner RAM check)
> > -	 */
> > -	bits_per_pixel = min(bits_per_pixel, max_bpp_small_joiner_ram);
> > -
> > -	/* Error out if the max bpp is less than smallest allowed valid bpp */
> > -	if (bits_per_pixel < valid_dsc_bpp[0]) {
> > -		DRM_DEBUG_KMS("Unsupported BPP %d\n", bits_per_pixel);
> > -		return 0;
> > -	}
> > -
> > -	/* Find the nearest match in the array of known BPPs from VESA */
> > -	for (i = 0; i < ARRAY_SIZE(valid_dsc_bpp) - 1; i++) {
> > -		if (bits_per_pixel < valid_dsc_bpp[i + 1])
> > -			break;
> > -	}
> > -	bits_per_pixel = valid_dsc_bpp[i];
> > -
> > -	/*
> > -	 * Compressed BPP in U6.4 format so multiply by 16, for Gen 11,
> > -	 * fractional part is 0
> > -	 */
> > -	return bits_per_pixel << 4;
> > -}
> > -
> > -u8 intel_dp_dsc_get_slice_count(struct intel_dp *intel_dp,
> > -				int mode_clock,
> > -				int mode_hdisplay)
> > -{
> > -	u8 min_slice_count, i;
> > -	int max_slice_width;
> > -
> > -	if (mode_clock <= DP_DSC_PEAK_PIXEL_RATE)
> > -		min_slice_count = DIV_ROUND_UP(mode_clock,
> > -					       DP_DSC_MAX_ENC_THROUGHPUT_0);
> > -	else
> > -		min_slice_count = DIV_ROUND_UP(mode_clock,
> > -					       DP_DSC_MAX_ENC_THROUGHPUT_1);
> > -
> > -	max_slice_width = drm_dp_dsc_sink_max_slice_width(intel_dp->dsc_dpcd);
> > -	if (max_slice_width < DP_DSC_MIN_SLICE_WIDTH_VALUE) {
> > -		DRM_DEBUG_KMS("Unsupported slice width %d by DP DSC Sink device\n",
> > -			      max_slice_width);
> > -		return 0;
> > -	}
> > -	/* Also take into account max slice width */
> > -	min_slice_count = min_t(u8, min_slice_count,
> > -				DIV_ROUND_UP(mode_hdisplay,
> > -					     max_slice_width));
> > -
> > -	/* Find the closest match to the valid slice count values */
> > -	for (i = 0; i < ARRAY_SIZE(valid_dsc_slicecount); i++) {
> > -		if (valid_dsc_slicecount[i] >
> > -		    drm_dp_dsc_sink_max_slice_count(intel_dp->dsc_dpcd,
> > -						    false))
> > -			break;
> > -		if (min_slice_count  <= valid_dsc_slicecount[i])
> > -			return valid_dsc_slicecount[i];
> > -	}
> > -
> > -	DRM_DEBUG_KMS("Unsupported Slice Count %d\n", min_slice_count);
> > -	return 0;
> > -}
> > -
> >  static void
> >  intel_pixel_encoding_setup_vsc(struct intel_dp *intel_dp,
> >  			       const struct intel_crtc_state *crtc_state)
> > diff --git a/drivers/gpu/drm/i915/display/intel_dp.h b/drivers/gpu/drm/i915/display/intel_dp.h
> > index e01d1f89409d..a194b5b6da05 100644
> > --- a/drivers/gpu/drm/i915/display/intel_dp.h
> > +++ b/drivers/gpu/drm/i915/display/intel_dp.h
> > @@ -103,10 +103,6 @@ bool intel_dp_source_supports_hbr2(struct intel_dp *intel_dp);
> >  bool intel_dp_source_supports_hbr3(struct intel_dp *intel_dp);
> >  bool
> >  intel_dp_get_link_status(struct intel_dp *intel_dp, u8 *link_status);
> > -u16 intel_dp_dsc_get_output_bpp(int link_clock, u8 lane_count,
> > -				int mode_clock, int mode_hdisplay);
> > -u8 intel_dp_dsc_get_slice_count(struct intel_dp *intel_dp, int mode_clock,
> > -				int mode_hdisplay);
> >  
> >  bool intel_dp_read_dpcd(struct intel_dp *intel_dp);
> >  bool intel_dp_get_colorimetry_status(struct intel_dp *intel_dp);
> > @@ -119,4 +115,6 @@ static inline unsigned int intel_dp_unused_lane_mask(int lane_count)
> >  	return ~((1 << lane_count) - 1) & 0xf;
> >  }
> >  
> > +u32 intel_dp_mode_to_fec_clock(u32 mode_clock);
> > +
> >  #endif /* __INTEL_DP_H__ */
> > diff --git a/drivers/gpu/drm/i915/display/intel_dp_mst.c b/drivers/gpu/drm/i915/display/intel_dp_mst.c
> > index eeeb3f933aa4..cf4d851a5139 100644
> > --- a/drivers/gpu/drm/i915/display/intel_dp_mst.c
> > +++ b/drivers/gpu/drm/i915/display/intel_dp_mst.c
> > @@ -81,7 +81,7 @@ static int intel_dp_mst_compute_link_config(struct intel_encoder *encoder,
> >  			       adjusted_mode->crtc_clock,
> >  			       crtc_state->port_clock,
> >  			       &crtc_state->dp_m_n,
> > -			       constant_n);
> > +			       constant_n, crtc_state->fec_enable);
> >  	crtc_state->dp_m_n.tu = slots;
> >  
> >  	return 0;
> > -- 
> > 2.20.1
> 
> -- 
> Ville Syrj�l�
> Intel
