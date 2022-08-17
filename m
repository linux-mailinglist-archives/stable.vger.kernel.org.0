Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47C45596B5C
	for <lists+stable@lfdr.de>; Wed, 17 Aug 2022 10:31:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233203AbiHQI36 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Aug 2022 04:29:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232952AbiHQI34 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Aug 2022 04:29:56 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E7B070E4B
        for <stable@vger.kernel.org>; Wed, 17 Aug 2022 01:29:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660724995; x=1692260995;
  h=from:to:cc:subject:in-reply-to:references:date:
   message-id:mime-version;
  bh=TA5jz4IeKRRCsnjwAi+NismvFOuA/4YilVmMjStNAoE=;
  b=U8dUfVr4BzpBaBCKAPZvWJRXMSNkfHOtZ4sLFjsMNjK6+K094juZqaw9
   KNh2ssg6T+coGJApJYnhGuYca2VGNH0EmErp9eHRE7pd89gVUbt1cF45R
   6ctMGpPW3ydQxtAbyIwngArtGjVtrsaKJhpkVX56zgjZYhOQ1TjvARMt/
   qDH7m3ySlJh9cuZGfII9X/px/X6GNFLE/ffJ25HJmmZwBjuSbNHl+NFuP
   7zNY/nQ3GSg77Unp/nJBz9FdX7a/pNlt9JpZ2ILvi6QAr8C5jgW8zRmyJ
   kfllhUz8kPfg1R+2TgAeM3ZInjqmp8q3HzgDPyN3DSIGquUvhv0zSrr9Z
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10441"; a="291191217"
X-IronPort-AV: E=Sophos;i="5.93,242,1654585200"; 
   d="scan'208";a="291191217"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Aug 2022 01:29:54 -0700
X-IronPort-AV: E=Sophos;i="5.93,242,1654585200"; 
   d="scan'208";a="667509466"
Received: from sbammi-mobl.amr.corp.intel.com (HELO localhost) ([10.252.49.167])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Aug 2022 01:29:52 -0700
From:   Jani Nikula <jani.nikula@intel.com>
To:     "Lisovskiy, Stanislav" <stanislav.lisovskiy@intel.com>
Cc:     intel-gfx@lists.freedesktop.org, stable@vger.kernel.org
Subject: Re: [Intel-gfx] [RESEND 1/3] drm/i915/dsi: filter invalid backlight
 and CABC ports
In-Reply-To: <YvyjILz4bXhvPjdZ@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
References: <cover.1660664162.git.jani.nikula@intel.com>
 <b0f4f087866257d280eb97d6bcfcefd109cc5fa2.1660664162.git.jani.nikula@intel.com>
 <YvyjILz4bXhvPjdZ@intel.com>
Date:   Wed, 17 Aug 2022 11:29:50 +0300
Message-ID: <87mtc3p91d.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 17 Aug 2022, "Lisovskiy, Stanislav" <stanislav.lisovskiy@intel.com> wrote:
> On Tue, Aug 16, 2022 at 06:37:20PM +0300, Jani Nikula wrote:
>> Avoid using ports that aren't initialized in case the VBT backlight or
>> CABC ports have invalid values. This fixes a NULL pointer dereference of
>> intel_dsi->dsi_hosts[port] in such cases.
>> 
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Jani Nikula <jani.nikula@intel.com>
>
> Would be interesting to figure out which one of those actually fixed the
> https://gitlab.freedesktop.org/drm/intel/-/issues/6476 issue, this one
> or next one.

I asked to test with patch 1 alone first, and it lets them boot without
the oops. And it produces the warn added here. But this just filters
port C out of bl_ports, and doesn't fix the root cause. Patch 2 should
fix the root cause, get rid of the warn and give them functioning
backlight. I hope. There was no test results with patches 2&3. :)

> Reviewed-by: Stanislav Lisovskiy <stanislav.lisovskiy@intel.com>

Thanks for the review!

BR,
Jani.

>
>> ---
>>  drivers/gpu/drm/i915/display/icl_dsi.c | 7 +++++++
>>  drivers/gpu/drm/i915/display/vlv_dsi.c | 7 +++++++
>>  2 files changed, 14 insertions(+)
>> 
>> diff --git a/drivers/gpu/drm/i915/display/icl_dsi.c b/drivers/gpu/drm/i915/display/icl_dsi.c
>> index 5dcfa7feffa9..885c74f60366 100644
>> --- a/drivers/gpu/drm/i915/display/icl_dsi.c
>> +++ b/drivers/gpu/drm/i915/display/icl_dsi.c
>> @@ -2070,7 +2070,14 @@ void icl_dsi_init(struct drm_i915_private *dev_priv)
>>  	else
>>  		intel_dsi->ports = BIT(port);
>>  
>> +	if (drm_WARN_ON(&dev_priv->drm, intel_connector->panel.vbt.dsi.bl_ports & ~intel_dsi->ports))
>> +		intel_connector->panel.vbt.dsi.bl_ports &= intel_dsi->ports;
>> +
>>  	intel_dsi->dcs_backlight_ports = intel_connector->panel.vbt.dsi.bl_ports;
>> +
>> +	if (drm_WARN_ON(&dev_priv->drm, intel_connector->panel.vbt.dsi.cabc_ports & ~intel_dsi->ports))
>> +		intel_connector->panel.vbt.dsi.cabc_ports &= intel_dsi->ports;
>> +
>>  	intel_dsi->dcs_cabc_ports = intel_connector->panel.vbt.dsi.cabc_ports;
>>  
>>  	for_each_dsi_port(port, intel_dsi->ports) {
>> diff --git a/drivers/gpu/drm/i915/display/vlv_dsi.c b/drivers/gpu/drm/i915/display/vlv_dsi.c
>> index b9b1fed99874..35136d26e517 100644
>> --- a/drivers/gpu/drm/i915/display/vlv_dsi.c
>> +++ b/drivers/gpu/drm/i915/display/vlv_dsi.c
>> @@ -1933,7 +1933,14 @@ void vlv_dsi_init(struct drm_i915_private *dev_priv)
>>  	else
>>  		intel_dsi->ports = BIT(port);
>>  
>> +	if (drm_WARN_ON(&dev_priv->drm, intel_connector->panel.vbt.dsi.bl_ports & ~intel_dsi->ports))
>> +		intel_connector->panel.vbt.dsi.bl_ports &= intel_dsi->ports;
>> +
>>  	intel_dsi->dcs_backlight_ports = intel_connector->panel.vbt.dsi.bl_ports;
>> +
>> +	if (drm_WARN_ON(&dev_priv->drm, intel_connector->panel.vbt.dsi.cabc_ports & ~intel_dsi->ports))
>> +		intel_connector->panel.vbt.dsi.cabc_ports &= intel_dsi->ports;
>> +
>>  	intel_dsi->dcs_cabc_ports = intel_connector->panel.vbt.dsi.cabc_ports;
>>  
>>  	/* Create a DSI host (and a device) for each port. */
>> -- 
>> 2.34.1
>> 

-- 
Jani Nikula, Intel Open Source Graphics Center
