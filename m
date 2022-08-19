Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E277599927
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 11:59:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347197AbiHSJwg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 05:52:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346618AbiHSJwe (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 05:52:34 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FDB047BB9
        for <stable@vger.kernel.org>; Fri, 19 Aug 2022 02:52:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660902754; x=1692438754;
  h=from:to:cc:subject:in-reply-to:references:date:
   message-id:mime-version;
  bh=QuFLoW+y1+7ivRir5oWacMxWiqStRt8Ah8mp4y2PI7A=;
  b=Eka4VFGir54Q5PmBRI22aa06r5X02cTEhceCXOj79n2ZHTeu3ck58zl4
   xaRLdplLIBYtVXFR3E2hm/HIyBWE5jQ3r+KXSrsz1QaGRkE/7r8H6fHTz
   00WI60e6wJKf57FTpkLh0mnwkMM9pm8WfB7RsQ1RLmGkvfl1UtfjE5Rxk
   A6jnYBuj9SOPv6wb5em3pVKy6rCEmRr3TG+moUe9ee1VaiJU7e9LJreSC
   szw9y1Z+bN3MZy5h9AeHsL87sp5IATc0QdI1xB/ZO/4tyjIGCUK9nFfFB
   MoC5aVFigOTyJix5iQOv+qP9n+ckFWt16C+UIbZpQn5lufph+lpstx+jm
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10443"; a="272751787"
X-IronPort-AV: E=Sophos;i="5.93,247,1654585200"; 
   d="scan'208";a="272751787"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Aug 2022 02:52:30 -0700
X-IronPort-AV: E=Sophos;i="5.93,247,1654585200"; 
   d="scan'208";a="637220713"
Received: from jastrom-mobl1.ger.corp.intel.com (HELO localhost) ([10.252.51.176])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Aug 2022 02:52:28 -0700
From:   Jani Nikula <jani.nikula@intel.com>
To:     "Lisovskiy, Stanislav" <stanislav.lisovskiy@intel.com>
Cc:     intel-gfx@lists.freedesktop.org, stable@vger.kernel.org
Subject: Re: [Intel-gfx] [RESEND 1/3] drm/i915/dsi: filter invalid backlight
 and CABC ports
In-Reply-To: <87mtc3p91d.fsf@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
References: <cover.1660664162.git.jani.nikula@intel.com>
 <b0f4f087866257d280eb97d6bcfcefd109cc5fa2.1660664162.git.jani.nikula@intel.com>
 <YvyjILz4bXhvPjdZ@intel.com> <87mtc3p91d.fsf@intel.com>
Date:   Fri, 19 Aug 2022 12:52:26 +0300
Message-ID: <87mtc0o90l.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 17 Aug 2022, Jani Nikula <jani.nikula@intel.com> wrote:
> On Wed, 17 Aug 2022, "Lisovskiy, Stanislav" <stanislav.lisovskiy@intel.com> wrote:
>> On Tue, Aug 16, 2022 at 06:37:20PM +0300, Jani Nikula wrote:
>>> Avoid using ports that aren't initialized in case the VBT backlight or
>>> CABC ports have invalid values. This fixes a NULL pointer dereference of
>>> intel_dsi->dsi_hosts[port] in such cases.
>>> 
>>> Cc: stable@vger.kernel.org
>>> Signed-off-by: Jani Nikula <jani.nikula@intel.com>
>>
>> Would be interesting to figure out which one of those actually fixed the
>> https://gitlab.freedesktop.org/drm/intel/-/issues/6476 issue, this one
>> or next one.
>
> I asked to test with patch 1 alone first, and it lets them boot without
> the oops. And it produces the warn added here. But this just filters
> port C out of bl_ports, and doesn't fix the root cause. Patch 2 should
> fix the root cause, get rid of the warn and give them functioning
> backlight. I hope. There was no test results with patches 2&3. :)
>
>> Reviewed-by: Stanislav Lisovskiy <stanislav.lisovskiy@intel.com>
>
> Thanks for the review!

Also, pushed the series to drm-intel-next yesterday.

BR,
Jani.


-- 
Jani Nikula, Intel Open Source Graphics Center
