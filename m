Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 99F71BDC36
	for <lists+stable@lfdr.de>; Wed, 25 Sep 2019 12:34:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390004AbfIYKeU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 Sep 2019 06:34:20 -0400
Received: from mga07.intel.com ([134.134.136.100]:31063 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389655AbfIYKeU (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 25 Sep 2019 06:34:20 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 25 Sep 2019 03:34:19 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,547,1559545200"; 
   d="scan'208";a="183216196"
Received: from timmpete-desk1.ger.corp.intel.com (HELO [10.252.55.52]) ([10.252.55.52])
  by orsmga008.jf.intel.com with ESMTP; 25 Sep 2019 03:34:18 -0700
Subject: Re: [Intel-gfx] [PATCH 1/2] drm/i915/dp: Fix dsc bpp calculations,
 v5.
To:     =?UTF-8?B?VmlsbGUgU3lyasOkbMOk?= <ville.syrjala@linux.intel.com>
Cc:     intel-gfx@lists.freedesktop.org, stable@vger.kernel.org
References: <20190925082110.17439-1-maarten.lankhorst@linux.intel.com>
 <20190925102657.GW1208@intel.com>
From:   Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Message-ID: <f544f200-4062-4911-6a8d-8bdf51772a6f@linux.intel.com>
Date:   Wed, 25 Sep 2019 12:34:17 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190925102657.GW1208@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Op 25-09-2019 om 12:26 schreef Ville Syrjälä:
> On Wed, Sep 25, 2019 at 10:21:09AM +0200, Maarten Lankhorst wrote:
>> There was a integer wraparound when mode_clock became too high,
>> and we didn't correct for the FEC overhead factor when dividing,
>> with the calculations breaking at HBR3.
>>
>> As a result our calculated bpp was way too high, and the link width
>> limitation never came into effect.
>>
>> Print out the resulting bpp calcululations as a sanity check, just
>> in case we ever have to debug it later on again.
>>
>> We also used the wrong factor for FEC. While bspec mentions 2.4%,
>> all the calculations use 1/0.972261, and the same ratio should be
>> applied to data M/N as well, so use it there when FEC is enabled.
>>
>> This fixes the FIFO underrun we are seeing with FEC enabled.
>>
>> Changes since v2:
>> - Handle fec_enable in intel_link_compute_m_n, so only data M/N is adjusted. (Ville)
>> - Fix initial hardware readout for FEC. (Ville)
>> Changes since v3:
>> - Remove bogus fec_to_mode_clock. (Ville)
>> Changes since v4:
>> - Use the correct register for icl. (Ville)
>> - Split hw readout to a separate patch.
>>
>> Signed-off-by: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
>> Fixes: d9218c8f6cf4 ("drm/i915/dp: Add helpers for Compressed BPP and Slice Count for DSC")
>> Cc: <stable@vger.kernel.org> # v5.0+
>> Cc: Manasi Navare <manasi.d.navare@intel.com>
>> ---
>>  drivers/gpu/drm/i915/display/intel_display.c |  12 +-
>>  drivers/gpu/drm/i915/display/intel_display.h |   2 +-
>>  drivers/gpu/drm/i915/display/intel_dp.c      | 184 ++++++++++---------
>>  drivers/gpu/drm/i915/display/intel_dp.h      |   6 +-
>>  drivers/gpu/drm/i915/display/intel_dp_mst.c  |   2 +-
>>  5 files changed, 107 insertions(+), 99 deletions(-)
>>
>> diff --git a/drivers/gpu/drm/i915/display/intel_display.c b/drivers/gpu/drm/i915/display/intel_display.c
>> index 5ecf54270181..c4c9286be987 100644
>> --- a/drivers/gpu/drm/i915/display/intel_display.c
>> +++ b/drivers/gpu/drm/i915/display/intel_display.c
>> @@ -7291,7 +7291,7 @@ static int ironlake_fdi_compute_config(struct intel_crtc *intel_crtc,
>>  	pipe_config->fdi_lanes = lane;
>>  
>>  	intel_link_compute_m_n(pipe_config->pipe_bpp, lane, fdi_dotclock,
>> -			       link_bw, &pipe_config->fdi_m_n, false);
>> +			       link_bw, &pipe_config->fdi_m_n, false, false);
>>  
>>  	ret = ironlake_check_fdi_lanes(dev, intel_crtc->pipe, pipe_config);
>>  	if (ret == -EDEADLK)
>> @@ -7538,11 +7538,15 @@ void
>>  intel_link_compute_m_n(u16 bits_per_pixel, int nlanes,
>>  		       int pixel_clock, int link_clock,
>>  		       struct intel_link_m_n *m_n,
>> -		       bool constant_n)
>> +		       bool constant_n, bool fec_enable)
>>  {
>> -	m_n->tu = 64;
>> +	u32 data_clock = bits_per_pixel * pixel_clock;
>> +
>> +	if (fec_enable)
>> +		data_clock = intel_dp_mode_to_fec_clock(data_clock);
>>  
>> -	compute_m_n(bits_per_pixel * pixel_clock,
>> +	m_n->tu = 64;
>> +	compute_m_n(data_clock,
>>  		    link_clock * nlanes * 8,
>>  		    &m_n->gmch_m, &m_n->gmch_n,
>>  		    constant_n);
>> diff --git a/drivers/gpu/drm/i915/display/intel_display.h b/drivers/gpu/drm/i915/display/intel_display.h
>> index 5cea6f8e107a..4b9e18e5a263 100644
>> --- a/drivers/gpu/drm/i915/display/intel_display.h
>> +++ b/drivers/gpu/drm/i915/display/intel_display.h
>> @@ -443,7 +443,7 @@ enum phy_fia {
>>  void intel_link_compute_m_n(u16 bpp, int nlanes,
>>  			    int pixel_clock, int link_clock,
>>  			    struct intel_link_m_n *m_n,
>> -			    bool constant_n);
>> +			    bool constant_n, bool fec_enable);
>>  bool is_ccs_modifier(u64 modifier);
>>  void lpt_disable_clkout_dp(struct drm_i915_private *dev_priv);
>>  u32 intel_plane_fb_max_stride(struct drm_i915_private *dev_priv,
>> diff --git a/drivers/gpu/drm/i915/display/intel_dp.c b/drivers/gpu/drm/i915/display/intel_dp.c
>> index 829559f97440..2b1e71f992b0 100644
>> --- a/drivers/gpu/drm/i915/display/intel_dp.c
>> +++ b/drivers/gpu/drm/i915/display/intel_dp.c
>> @@ -76,8 +76,8 @@
>>  #define DP_DSC_MAX_ENC_THROUGHPUT_0		340000
>>  #define DP_DSC_MAX_ENC_THROUGHPUT_1		400000
>>  
>> -/* DP DSC FEC Overhead factor = (100 - 2.4)/100 */
>> -#define DP_DSC_FEC_OVERHEAD_FACTOR		976
>> +/* DP DSC FEC Overhead factor = 1/(0.972261) */
>> +#define DP_DSC_FEC_OVERHEAD_FACTOR		972261
>>  
>>  /* Compliance test status bits  */
>>  #define INTEL_DP_RESOLUTION_SHIFT_MASK	0
>> @@ -492,6 +492,97 @@ int intel_dp_get_link_train_fallback_values(struct intel_dp *intel_dp,
>>  	return 0;
>>  }
>>  
>> +u32 intel_dp_mode_to_fec_clock(u32 mode_clock)
>> +{
>> +	return div_u64(mul_u32_u32(mode_clock, 1000000U),
>> +		       DP_DSC_FEC_OVERHEAD_FACTOR);
>> +}
>> +
>> +static u16 intel_dp_dsc_get_output_bpp(u32 link_clock, u32 lane_count,
>> +				       u32 mode_clock, u32 mode_hdisplay)
>> +{
>> +	u32 bits_per_pixel, max_bpp_small_joiner_ram;
>> +	int i;
>> +
>> +	/*
>> +	 * Available Link Bandwidth(Kbits/sec) = (NumberOfLanes)*
>> +	 * (LinkSymbolClock)* 8 * (TimeSlotsPerMTP)
>> +	 * for SST -> TimeSlotsPerMTP is 1,
>> +	 * for MST -> TimeSlotsPerMTP has to be calculated
>> +	 */
>> +	bits_per_pixel = (link_clock * lane_count * 8) /
>> +			 intel_dp_mode_to_fec_clock(mode_clock);
> Hmm. Aren't we adding the FEC overhead twice now when DSC is also
> enabled?

No? This is calculating the maximum bpp that can be used for DSC.

"For cases where FEC is enabled, pixel clock is replaced by pixel clock/0.972261 in the above calculations."

This bpp check here is to ensure that data M <= N.

~Maarten

