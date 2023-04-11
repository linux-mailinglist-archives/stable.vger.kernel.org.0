Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF5706DDD10
	for <lists+stable@lfdr.de>; Tue, 11 Apr 2023 15:59:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231193AbjDKN7a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Apr 2023 09:59:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231151AbjDKN70 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Apr 2023 09:59:26 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B77FC40CE;
        Tue, 11 Apr 2023 06:59:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681221554; x=1712757554;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=yexL/N1m4BbU3jFepRVc09D3Ftt41ycmTKQzelkjxfo=;
  b=eEqedvlnyUbjWlpg+Fu5jE96i/WefevCsqy2QJ5QQqWq7KVwJ4HYrAxm
   Ay/kuqIjIx76u6XUwF240cZ75rSD6fwcJ+CT84GDdhO6yfnmo+DCoAuMs
   1WjESU3cwwbmSFbGYJGhQ/kix9F5d/09toxAWUndX7fikSUYnDSvtjvmk
   bJGoiRiXbHz8ayxtWdb2K3DyM5wbgMfdMVuroScbxzJW9LTTSmQu0aw35
   ckah5ly4lbNtxVEccoyTFoKHNVCQ0ZRiR+aDhdBTFHqoXqvbjLNWnjdcZ
   9jvcSbmjukZz8ndc/kBYqj63/HV81S4Z8S+rcNgIG8qrK3CeHD+gSJjrU
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10677"; a="323982905"
X-IronPort-AV: E=Sophos;i="5.98,336,1673942400"; 
   d="scan'208";a="323982905"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Apr 2023 06:58:48 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10677"; a="777919862"
X-IronPort-AV: E=Sophos;i="5.98,336,1673942400"; 
   d="scan'208";a="777919862"
Received: from aburgsta-mobl.ger.corp.intel.com (HELO [10.252.45.152]) ([10.252.45.152])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Apr 2023 06:58:43 -0700
Message-ID: <8cef35ad-881e-3db3-5c7a-e27ff9968b77@linux.intel.com>
Date:   Tue, 11 Apr 2023 15:58:41 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.9.1
Subject: Re: [PATCH] fbmem: Reject FB_ACTIVATE_KD_TEXT from userspace
Content-Language: en-US
To:     Daniel Vetter <daniel@ffwll.ch>,
        Intel Graphics Development <intel-gfx@lists.freedesktop.org>
Cc:     Daniel Vetter <daniel.vetter@ffwll.ch>,
        Daniel Vetter <daniel.vetter@intel.com>,
        Alex Deucher <alexander.deucher@amd.com>, shlomo@fastmail.com,
        =?UTF-8?Q?Michel_D=c3=a4nzer?= <michel@daenzer.net>,
        =?UTF-8?Q?Noralf_Tr=c3=b8nnes?= <noralf@tronnes.org>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        Maxime Ripard <mripard@kernel.org>,
        David Airlie <airlied@linux.ie>,
        dri-devel@lists.freedesktop.org, stable@vger.kernel.org,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Qiujun Huang <hqjagain@gmail.com>,
        Peter Rosin <peda@axentia.se>, linux-fbdev@vger.kernel.org,
        Helge Deller <deller@gmx.de>, Sam Ravnborg <sam@ravnborg.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Samuel Thibault <samuel.thibault@ens-lyon.org>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Shigeru Yoshida <syoshida@redhat.com>
References: <20230404193934.472457-1-daniel.vetter@ffwll.ch>
 <ZDVkSaskEvwix8Bz@phenom.ffwll.local>
From:   Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
In-Reply-To: <ZDVkSaskEvwix8Bz@phenom.ffwll.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 2023-04-11 15:44, Daniel Vetter wrote:
> On Tue, Apr 04, 2023 at 09:39:34PM +0200, Daniel Vetter wrote:
>> This is an oversight from dc5bdb68b5b3 ("drm/fb-helper: Fix vt
>> restore") - I failed to realize that nasty userspace could set this.
>>
>> It's not pretty to mix up kernel-internal and userspace uapi flags
>> like this, but since the entire fb_var_screeninfo structure is uapi
>> we'd need to either add a new parameter to the ->fb_set_par callback
>> and fb_set_par() function, which has a _lot_ of users. Or some other
>> fairly ugly side-channel int fb_info. Neither is a pretty prospect.
>>
>> Instead just correct the issue at hand by filtering out this
>> kernel-internal flag in the ioctl handling code.
>>
>> Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
>> Fixes: dc5bdb68b5b3 ("drm/fb-helper: Fix vt restore")
>> Cc: Alex Deucher <alexander.deucher@amd.com>
>> Cc: shlomo@fastmail.com
>> Cc: Michel Dänzer <michel@daenzer.net>
>> Cc: Noralf Trønnes <noralf@tronnes.org>
>> Cc: Thomas Zimmermann <tzimmermann@suse.de>
>> Cc: Daniel Vetter <daniel.vetter@intel.com>
>> Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
>> Cc: Maxime Ripard <mripard@kernel.org>
>> Cc: David Airlie <airlied@linux.ie>
>> Cc: Daniel Vetter <daniel@ffwll.ch>
>> Cc: dri-devel@lists.freedesktop.org
>> Cc: <stable@vger.kernel.org> # v5.7+
>> Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
>> Cc: Geert Uytterhoeven <geert@linux-m68k.org>
>> Cc: Nathan Chancellor <natechancellor@gmail.com>
>> Cc: Qiujun Huang <hqjagain@gmail.com>
>> Cc: Peter Rosin <peda@axentia.se>
>> Cc: linux-fbdev@vger.kernel.org
>> Cc: Helge Deller <deller@gmx.de>
>> Cc: Sam Ravnborg <sam@ravnborg.org>
>> Cc: Geert Uytterhoeven <geert+renesas@glider.be>
>> Cc: Samuel Thibault <samuel.thibault@ens-lyon.org>
>> Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
>> Cc: Shigeru Yoshida <syoshida@redhat.com>
> An Ack on this (or a better idea) would be great, so I can stuff it into
> -fixes.
Acked-by: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
