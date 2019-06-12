Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 049B442300
	for <lists+stable@lfdr.de>; Wed, 12 Jun 2019 12:51:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407091AbfFLKuL convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Wed, 12 Jun 2019 06:50:11 -0400
Received: from mga05.intel.com ([192.55.52.43]:6481 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405794AbfFLKuL (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 Jun 2019 06:50:11 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 12 Jun 2019 03:50:10 -0700
X-ExtLoop1: 1
Received: from jnikula-mobl3.fi.intel.com (HELO localhost) ([10.237.66.150])
  by fmsmga001.fm.intel.com with ESMTP; 12 Jun 2019 03:50:08 -0700
From:   Jani Nikula <jani.nikula@intel.com>
To:     Paul Wise <pabs3@bonedaddy.net>, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Cc:     Daniel Vetter <daniel.vetter@ffwll.ch>, stable@vger.kernel.org,
        Ilpo =?utf-8?Q?J=C3=A4rvinen?= <ilpo.jarvinen@cs.helsinki.fi>,
        Ville =?utf-8?B?U3lyasOkbMOk?= <ville.syrjala@linux.intel.com>,
        Harish Chegondi <harish.chegondi@intel.com>
Subject: Re: [PATCH v2] drm: add fallback override/firmware EDID modes workaround
In-Reply-To: <08ffd10ecac7e684503ce55b0f929ac856b9b76b.camel@bonedaddy.net>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
References: <20190607110513.12072-2-jani.nikula@intel.com> <20190610093054.28445-1-jani.nikula@intel.com> <08ffd10ecac7e684503ce55b0f929ac856b9b76b.camel@bonedaddy.net>
Date:   Wed, 12 Jun 2019 13:53:08 +0300
Message-ID: <877e9rxegb.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 11 Jun 2019, Paul Wise <pabs3@bonedaddy.net> wrote:
> On Mon, 2019-06-10 at 12:30 +0300, Jani Nikula wrote:
>> We've moved the override and firmware EDID (simply "override EDID" from
>> now on) handling to the low level drm_do_get_edid() function in order to
>> transparently use the override throughout the stack. The idea is that
>> you get the override EDID via the ->get_modes() hook.
>> 
>> Unfortunately, there are scenarios where the DDC probe in drm_get_edid()
>> called via ->get_modes() fails, although the preceding ->detect()
>> succeeds.
>> 
>> In the case reported by Paul Wise, the ->detect() hook,
>> intel_crt_detect(), relies on hotplug detect, bypassing the DDC. In the
>> case reported by Ilpo Järvinen, there is no ->detect() hook, which is
>> interpreted as connected. The subsequent DDC probe reached via
>> ->get_modes() fails, and we don't even look at the override EDID,
>> resulting in no modes being added.
>> 
>> Because drm_get_edid() is used via ->detect() all over the place, we
>> can't trivially remove the DDC probe, as it leads to override EDID
>> effectively meaning connector forcing. The goal is that connector
>> forcing and override EDID remain orthogonal.
>> 
>> Generally, the underlying problem here is the conflation of ->detect()
>> and ->get_modes() via drm_get_edid(). The former should just detect, and
>> the latter should just get the modes, typically via reading the EDID. As
>> long as drm_get_edid() is used in ->detect(), it needs to retain the DDC
>> probe. Or such users need to have a separate DDC probe step first.
>> 
>> The EDID caching between ->detect() and ->get_modes() done by some
>> drivers is a further complication that prevents us from making
>> drm_do_get_edid() adapt to the two cases.
>> 
>> Work around the regression by falling back to a separate attempt at
>> getting the override EDID at drm_helper_probe_single_connector_modes()
>> level. With a working DDC and override EDID, it'll never be called; the
>> override EDID will come via ->get_modes(). There will still be a failing
>> DDC probe attempt in the cases that require the fallback.
>> 
>> v2:
>> - Call drm_connector_update_edid_property (Paul)
>> - Update commit message about EDID caching (Daniel)
>> 
>> Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=107583
>> Reported-by: Paul Wise <pabs3@bonedaddy.net>
>> Cc: Paul Wise <pabs3@bonedaddy.net>
>> References: http://mid.mail-archive.com/alpine.DEB.2.20.1905262211270.24390@whs-18.cs.helsinki.fi
>> Reported-by: Ilpo Järvinen <ilpo.jarvinen@cs.helsinki.fi>
>> Cc: Ilpo Järvinen <ilpo.jarvinen@cs.helsinki.fi>
>> Suggested-by: Daniel Vetter <daniel.vetter@ffwll.ch>
>> References: 15f080f08d48 ("drm/edid: respect connector force for drm_get_edid ddc probe")
>> Fixes: 53fd40a90f3c ("drm: handle override and firmware EDID at drm_do_get_edid() level")
>> Cc: <stable@vger.kernel.org> # v4.15+
>> Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
>> Cc: Ville Syrjälä <ville.syrjala@linux.intel.com>
>> Cc: Harish Chegondi <harish.chegondi@intel.com>
>> Signed-off-by: Jani Nikula <jani.nikula@intel.com>
>> ---
>>  drivers/gpu/drm/drm_edid.c         | 30 ++++++++++++++++++++++++++++++
>>  drivers/gpu/drm/drm_probe_helper.c |  7 +++++++
>>  include/drm/drm_edid.h             |  1 +
>>  3 files changed, 38 insertions(+)
>> 
>> diff --git a/drivers/gpu/drm/drm_edid.c b/drivers/gpu/drm/drm_edid.c
>> index c59a1e8c5ada..9d8f2b952004 100644
>> --- a/drivers/gpu/drm/drm_edid.c
>> +++ b/drivers/gpu/drm/drm_edid.c
>> @@ -1587,6 +1587,36 @@ static struct edid *drm_get_override_edid(struct drm_connector *connector)
>>  	return IS_ERR(override) ? NULL : override;
>>  }
>>  
>> +/**
>> + * drm_add_override_edid_modes - add modes from override/firmware EDID
>> + * @connector: connector we're probing
>> + *
>> + * Add modes from the override/firmware EDID, if available. Only to be used from
>> + * drm_helper_probe_single_connector_modes() as a fallback for when DDC probe
>> + * failed during drm_get_edid() and caused the override/firmware EDID to be
>> + * skipped.
>> + *
>> + * Return: The number of modes added or 0 if we couldn't find any.
>> + */
>> +int drm_add_override_edid_modes(struct drm_connector *connector)
>> +{
>> +	struct edid *override;
>> +	int num_modes = 0;
>> +
>> +	override = drm_get_override_edid(connector);
>> +	if (override) {
>> +		drm_connector_update_edid_property(connector, override);
>> +		num_modes = drm_add_edid_modes(connector, override);
>> +		kfree(override);
>> +
>> +		DRM_DEBUG_KMS("[CONNECTOR:%d:%s] adding %d modes via fallback override/firmware EDID\n",
>> +			      connector->base.id, connector->name, num_modes);
>> +	}
>> +
>> +	return num_modes;
>> +}
>> +EXPORT_SYMBOL(drm_add_override_edid_modes);
>> +
>>  /**
>>   * drm_do_get_edid - get EDID data using a custom EDID block read function
>>   * @connector: connector we're probing
>> diff --git a/drivers/gpu/drm/drm_probe_helper.c b/drivers/gpu/drm/drm_probe_helper.c
>> index 01e243f1ea94..ef2c468205a2 100644
>> --- a/drivers/gpu/drm/drm_probe_helper.c
>> +++ b/drivers/gpu/drm/drm_probe_helper.c
>> @@ -480,6 +480,13 @@ int drm_helper_probe_single_connector_modes(struct drm_connector *connector,
>>  
>>  	count = (*connector_funcs->get_modes)(connector);
>>  
>> +	/*
>> +	 * Fallback for when DDC probe failed in drm_get_edid() and thus skipped
>> +	 * override/firmware EDID.
>> +	 */
>> +	if (count == 0 && connector->status == connector_status_connected)
>> +		count = drm_add_override_edid_modes(connector);
>> +
>>  	if (count == 0 && connector->status == connector_status_connected)
>>  		count = drm_add_modes_noedid(connector, 1024, 768);
>>  	count += drm_helper_probe_add_cmdline_mode(connector);
>> diff --git a/include/drm/drm_edid.h b/include/drm/drm_edid.h
>> index 88b63801f9db..b9719418c3d2 100644
>> --- a/include/drm/drm_edid.h
>> +++ b/include/drm/drm_edid.h
>> @@ -478,6 +478,7 @@ struct edid *drm_get_edid_switcheroo(struct drm_connector *connector,
>>  				     struct i2c_adapter *adapter);
>>  struct edid *drm_edid_duplicate(const struct edid *edid);
>>  int drm_add_edid_modes(struct drm_connector *connector, struct edid *edid);
>> +int drm_add_override_edid_modes(struct drm_connector *connector);
>>  
>>  u8 drm_match_cea_mode(const struct drm_display_mode *to_match);
>>  enum hdmi_picture_aspect drm_get_cea_aspect_ratio(const u8 video_code);
>
> Tested-by: Paul Wise <pabs3@bonedaddy.net>
>
> This version looks good to me.
>
> Both the EDID override data and the resolution are fixed.

Thanks for testing and review, pushed both to drm-misc-fixes, cc: stable
v4.15.

BR,
Jani.


-- 
Jani Nikula, Intel Open Source Graphics Center
