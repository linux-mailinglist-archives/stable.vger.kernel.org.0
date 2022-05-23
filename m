Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 279AF530BFC
	for <lists+stable@lfdr.de>; Mon, 23 May 2022 11:04:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231658AbiEWIVv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 May 2022 04:21:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231772AbiEWIVu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 May 2022 04:21:50 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BE91B1F1
        for <stable@vger.kernel.org>; Mon, 23 May 2022 01:21:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1653294109; x=1684830109;
  h=from:to:cc:subject:in-reply-to:references:date:
   message-id:mime-version:content-transfer-encoding;
  bh=Alf7bppXqCKKA5BP/GkDIvv5noKEZJfhbacpBTbLTrY=;
  b=DnVdUAPLTdVR0/m+3uMN1n+SfIDzXhVOLBP2kuI6N3zr3+hStfWvV9yC
   nRhHyGZU0rCWp3vYDWWPvyg6fZS8+xEOGvFyBc2XUP/ko1DJu2k16vk7W
   UfUo6TL6zLcOiCLT0H2CBRKTQe0NCBVD7TKDH9wv/49K8QUJE/Phaj8mi
   EMOhU/zVkLDT8U+WtOwyQu15RaqYVYbKUd6wG8zGHXbAOHYEiJKw1Binn
   UI/KwbKO4S33nBxzGF7mTGdR7MufXaSNRy0SRvaTsRch7XCuPgBe+RRxn
   oBoJmhMV0YPjUNyp9hxfT2v8P98gWM1UciEEDirj8LJrIi510j3G1K3+p
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10355"; a="336206014"
X-IronPort-AV: E=Sophos;i="5.91,246,1647327600"; 
   d="scan'208";a="336206014"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 May 2022 01:21:49 -0700
X-IronPort-AV: E=Sophos;i="5.91,246,1647327600"; 
   d="scan'208";a="744624827"
Received: from ksadlows-mobl.ger.corp.intel.com (HELO localhost) ([10.249.135.186])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 May 2022 01:21:47 -0700
From:   Jani Nikula <jani.nikula@intel.com>
To:     Ville =?utf-8?B?U3lyasOkbMOk?= <ville.syrjala@linux.intel.com>
Cc:     intel-gfx@lists.freedesktop.org, stable@vger.kernel.org
Subject: Re: [PATCH] drm/i915/dsi: fix VBT send packet port selection for ICL+
In-Reply-To: <YofEFRffsOdEcfRO@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
References: <20220520094600.2066945-1-jani.nikula@intel.com>
 <YofEFRffsOdEcfRO@intel.com>
Date:   Mon, 23 May 2022 11:21:44 +0300
Message-ID: <87v8twbqw7.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 20 May 2022, Ville Syrj=C3=A4l=C3=A4 <ville.syrjala@linux.intel.com=
> wrote:
> On Fri, May 20, 2022 at 12:46:00PM +0300, Jani Nikula wrote:
>> The VBT send packet port selection was never updated for ICL+ where the
>> 2nd link is on port B instead of port C as in VLV+ DSI.
>>=20
>> First, single link DSI needs to use the configured port instead of
>> relying on the VBT sequence block port. Remove the hard-coded port C
>> check here and make it generic. For reference, see commit f915084edc5a
>> ("drm/i915: Changes related to the sequence port no for") for the
>> original VLV specific fix.
>>=20
>> Second, the sequence block port number is either 0 or 1, where 1
>> indicates the 2nd link. Remove the hard-coded port C here for 2nd
>> link. (This could be a "find second set bit" on DSI ports, but just
>> check the two possible options.)
>>=20
>> Third, sanity check the result with a warning to avoid a NULL pointer
>> dereference.
>>=20
>> Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/5984
>> Cc: stable@vger.kernel.org # v4.19+
>> Cc: Ville Syrjala <ville.syrjala@linux.intel.com>
>> Signed-off-by: Jani Nikula <jani.nikula@intel.com>
>> ---
>>  drivers/gpu/drm/i915/display/intel_dsi_vbt.c | 33 +++++++++++++-------
>>  1 file changed, 22 insertions(+), 11 deletions(-)
>>=20
>> diff --git a/drivers/gpu/drm/i915/display/intel_dsi_vbt.c b/drivers/gpu/=
drm/i915/display/intel_dsi_vbt.c
>> index f370e9c4350d..dd24aef925f2 100644
>> --- a/drivers/gpu/drm/i915/display/intel_dsi_vbt.c
>> +++ b/drivers/gpu/drm/i915/display/intel_dsi_vbt.c
>> @@ -125,9 +125,25 @@ struct i2c_adapter_lookup {
>>  #define  ICL_GPIO_DDPA_CTRLCLK_2	8
>>  #define  ICL_GPIO_DDPA_CTRLDATA_2	9
>>=20=20
>> -static enum port intel_dsi_seq_port_to_port(u8 port)
>> +static enum port intel_dsi_seq_port_to_port(struct intel_dsi *intel_dsi,
>> +					    u8 seq_port)
>>  {
>> -	return port ? PORT_C : PORT_A;
>> +	/*
>> +	 * If single link DSI is being used on any port, the VBT sequence block
>> +	 * send packet apparently always has 0 for the port. Just use the port
>> +	 * we have configured, and ignore the sequence block port.
>> +	 */
>> +	if (hweight8(intel_dsi->ports) =3D=3D 1)
>> +		return ffs(intel_dsi->ports) - 1;
>> +
>> +	if (seq_port) {
>> +		if (intel_dsi->ports & PORT_B)
>> +			return PORT_B;
>> +		else if (intel_dsi->ports & PORT_C)
>> +			return PORT_C;
>> +	}
>> +
>> +	return PORT_A;
>
> Hmm. I guess a bit more generic way to express that could be
> to just pick the Nth set bit from intel_dsi->ports, where N=3D=3Dseq_port.
> Assuming seq_port is just an index. But I guess we're not really
> expecting to grow more DSI ports any time soon, so this seems
> sufficient for the current situation.
>
> Reviewed-by: Ville Syrj=C3=A4l=C3=A4 <ville.syrjala@linux.intel.com>

Thanks, pushed to drm-intel-next.

BR,
Jani.


>
>>  }
>>=20=20
>>  static const u8 *mipi_exec_send_packet(struct intel_dsi *intel_dsi,
>> @@ -149,15 +165,10 @@ static const u8 *mipi_exec_send_packet(struct inte=
l_dsi *intel_dsi,
>>=20=20
>>  	seq_port =3D (flags >> MIPI_PORT_SHIFT) & 3;
>>=20=20
>> -	/* For DSI single link on Port A & C, the seq_port value which is
>> -	 * parsed from Sequence Block#53 of VBT has been set to 0
>> -	 * Now, read/write of packets for the DSI single link on Port A and
>> -	 * Port C will based on the DVO port from VBT block 2.
>> -	 */
>> -	if (intel_dsi->ports =3D=3D (1 << PORT_C))
>> -		port =3D PORT_C;
>> -	else
>> -		port =3D intel_dsi_seq_port_to_port(seq_port);
>> +	port =3D intel_dsi_seq_port_to_port(intel_dsi, seq_port);
>> +
>> +	if (drm_WARN_ON(&dev_priv->drm, !intel_dsi->dsi_hosts[port]))
>> +		goto out;
>>=20=20
>>  	dsi_device =3D intel_dsi->dsi_hosts[port]->device;
>>  	if (!dsi_device) {
>> --=20
>> 2.30.2

--=20
Jani Nikula, Intel Open Source Graphics Center
