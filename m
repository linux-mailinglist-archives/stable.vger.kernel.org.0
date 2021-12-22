Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14F2547D5C1
	for <lists+stable@lfdr.de>; Wed, 22 Dec 2021 18:21:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230378AbhLVRVX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Dec 2021 12:21:23 -0500
Received: from mga14.intel.com ([192.55.52.115]:37167 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230222AbhLVRVX (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Dec 2021 12:21:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1640193683; x=1671729683;
  h=date:from:to:cc:subject:in-reply-to:message-id:
   references:mime-version;
  bh=5dL73oot1k/+QQ0q/bKmbJFyU8YokyOQ7yIYy2CvGYU=;
  b=ejnNt5/lIvRAn2jvyCMFHcVeXS61tOjEzJ5k549rgzqExafD/az/akSy
   R3C+9bpF4A3BUq7iT6rLshdnFUXLIbwYyUw8RcdwEek3PID9oBNVvvp/1
   7aUy4ZItnfC69gpD+cjtDkarrXIU5Km1sV02qCXYJsgaANrE7dogo6srw
   gcx7JRhxpHqz0AL7UI88EEpQmWVdikRqLfHJB81EJmMOI8fWn/F6f0KC0
   1NninBbvkDmDZpXLBwB6dV2i4QKh4B8qwI5BOHjIyFQEdzKkTs4gcrsF7
   hscb6QO88Ty8xJOiGBpNnrMhW2barVa/rlBiouh8U52y/1cUrwxpOsIz/
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10206"; a="240890748"
X-IronPort-AV: E=Sophos;i="5.88,227,1635231600"; 
   d="scan'208";a="240890748"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Dec 2021 09:05:45 -0800
X-IronPort-AV: E=Sophos;i="5.88,227,1635231600"; 
   d="scan'208";a="468233654"
Received: from eliteleevi.tm.intel.com ([10.237.54.20])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Dec 2021 09:05:43 -0800
Date:   Wed, 22 Dec 2021 18:57:43 +0200 (EET)
From:   Kai Vehmanen <kai.vehmanen@linux.intel.com>
X-X-Sender: kvehmane@eliteleevi.tm.intel.com
To:     Ville Syrjala <ville.syrjala@linux.intel.com>
cc:     alsa-devel@alsa-project.org, intel-gfx@lists.freedesktop.org,
        stable@vger.kernel.org, Harsha Priya <harshapriya.n@intel.com>,
        Emmanuel Jillela <emmanuel.jillela@intel.com>,
        Kai Vehmanen <kai.vehmanen@linux.intel.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: Re: [PATCH] ALSA: hda/hdmi: Disable silent stream on GLK
In-Reply-To: <20211222145350.24342-1-ville.syrjala@linux.intel.com>
Message-ID: <alpine.DEB.2.22.394.2112221851510.1661468@eliteleevi.tm.intel.com>
References: <20211222145350.24342-1-ville.syrjala@linux.intel.com>
User-Agent: Alpine 2.22 (DEB 394 2020-01-19)
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7 02160 Espoo
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On Wed, 22 Dec 2021, Ville Syrjala wrote:

> The silent stream stuff recurses back into i915 audio
> component .get_power() from the .pin_eld_notify() hook.
> On GLK this will deadlock as i915 may already be holding
> the relevant modeset locks during .pin_eld_notify() and
> the GLK audio vs. CDCLK workaround will try to grab the
> same locks from .get_power().
>
> Until someone comes up with a better fix just disable the
> silent stream support on GLK.

decoupling the call to get_power() is a non-trivial change
(especially as it's done from generic hda_codec.c code),
so I'd say let's go with this patch for GLK:

Reviewed-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>

Br, Kai
