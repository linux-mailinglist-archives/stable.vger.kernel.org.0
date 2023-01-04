Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1322B65D522
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 15:09:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239655AbjADOJn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 09:09:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239540AbjADOJY (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 09:09:24 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83FFF321BE;
        Wed,  4 Jan 2023 06:09:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1672841341; x=1704377341;
  h=from:to:cc:subject:in-reply-to:references:date:
   message-id:mime-version;
  bh=HCOvoASy+qbpDqBB8eBzzhSQ2v8lak3B7DRvotc2hZ4=;
  b=k5X1gNvN6uxi1ycaodF5u4MrDv9l9KHjpfx6BUf+8ajRxxncHa7YiOa9
   wPAGKu1H038FWiw7NPvlfqN262AuglqC4znSjvJmMCA7f9b+ZXA3uISin
   PEIqF46/TbHoQDayAR8Z9G3JlG+GwW9tqhvuA+kus+jeL2Prh3Rv4iTeK
   otC9Q2+AFWbX+LoDwLYP70rov2apYokKL4eGz/DWdH9Tuo/kv4wPc5jCZ
   Q9FYWYr/v1jK0joI9PGODPeWFu2++5NpGz4cez16udWp3wOUlxD4AveHw
   QEeYNjRXzuDV8xrcsV5Xj3/rJMzuMAh1EiayCS2TX/lSfbfJVM4JUHKEN
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10580"; a="302310103"
X-IronPort-AV: E=Sophos;i="5.96,300,1665471600"; 
   d="scan'208";a="302310103"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jan 2023 06:09:00 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10580"; a="983940643"
X-IronPort-AV: E=Sophos;i="5.96,300,1665471600"; 
   d="scan'208";a="983940643"
Received: from mkabdel-mobl.ger.corp.intel.com (HELO localhost) ([10.252.25.63])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jan 2023 06:08:57 -0800
From:   Jani Nikula <jani.nikula@linux.intel.com>
To:     Alexey Lukyachuk <skif@skif-web.ru>
Cc:     Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Daniel Vetter <daniel@ffwll.ch>,
        David Airlie <airlied@gmail.com>
Subject: Re: [Intel-gfx] [PATCH v2] drm/i915: dell wyse 3040 shutdown fix
In-Reply-To: <20230103132426.0c6d144f@alexey-Swift-SF314-42>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
References: <20221225184413.146916-1-skif@skif-web.ru>
 <20221225185507.149677-1-skif@skif-web.ru> <Y6sfvUJmrb73AeJh@intel.com>
 <20221227204003.6b0abe65@alexey-Swift-SF314-42>
 <20230102165649.2b8e69e3@alexey-Swift-SF314-42> <87a630ylg5.fsf@intel.com>
 <20230103132426.0c6d144f@alexey-Swift-SF314-42>
Date:   Wed, 04 Jan 2023 16:08:55 +0200
Message-ID: <87sfgqwfwo.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 03 Jan 2023, Alexey Lukyachuk <skif@skif-web.ru> wrote:
> On Tue, 03 Jan 2023 12:14:02 +0200
> Jani Nikula <jani.nikula@linux.intel.com> wrote:
>
>> On Mon, 02 Jan 2023, Alexey Lukyachuk <skif@skif-web.ru> wrote:
>> > Regarding to your question about fdo gitlab, I went to do it.
>> 
>> What's the URL for the issue?
>> 
>> BR,
>> Jani.
>> 
>
> I have not submited issue in bug tracker because I found solution in git.
> ("Before filing the bug, please try to reproduce your issue with the 
> latest kernel. Use the latest drm-tip branch from 
> http://cgit.freedesktop.org/drm-tip and build as instructed on 
> our Build Guide.")
>
> Should I do it?

Shot in the dark first, does snd_intel_dspcfg.dsp_driver=1 module
parameter help on the affected kernels? Should be easy enough to test.

BR,
Jani.


-- 
Jani Nikula, Intel Open Source Graphics Center
