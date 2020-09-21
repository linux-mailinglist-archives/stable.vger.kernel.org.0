Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 151BE27292E
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 16:54:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727314AbgIUOyr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 10:54:47 -0400
Received: from mail.netline.ch ([148.251.143.178]:45749 "EHLO
        netline-mail3.netline.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727285AbgIUOyr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Sep 2020 10:54:47 -0400
X-Greylist: delayed 396 seconds by postgrey-1.27 at vger.kernel.org; Mon, 21 Sep 2020 10:54:45 EDT
Received: from localhost (localhost [127.0.0.1])
        by netline-mail3.netline.ch (Postfix) with ESMTP id CDC412A6045;
        Mon, 21 Sep 2020 16:48:07 +0200 (CEST)
X-Virus-Scanned: Debian amavisd-new at netline-mail3.netline.ch
Received: from netline-mail3.netline.ch ([127.0.0.1])
        by localhost (netline-mail3.netline.ch [127.0.0.1]) (amavisd-new, port 10024)
        with LMTP id n-6O19CCSCnF; Mon, 21 Sep 2020 16:48:07 +0200 (CEST)
Received: from thor (212.174.63.188.dynamic.wline.res.cust.swisscom.ch [188.63.174.212])
        by netline-mail3.netline.ch (Postfix) with ESMTPSA id 192B92A6016;
        Mon, 21 Sep 2020 16:48:06 +0200 (CEST)
Received: from localhost ([::1])
        by thor with esmtp (Exim 4.94)
        (envelope-from <michel@daenzer.net>)
        id 1kKN6w-000aC1-Sy; Mon, 21 Sep 2020 16:48:05 +0200
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     Daniel Vetter <daniel.vetter@ffwll.ch>,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        Alex Deucher <alexander.deucher@amd.com>,
        Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
References: <20200921144054.2135602-1-sashal@kernel.org>
 <20200921144054.2135602-13-sashal@kernel.org>
From:   =?UTF-8?Q?Michel_D=c3=a4nzer?= <michel@daenzer.net>
Subject: Re: [PATCH AUTOSEL 5.4 13/15] drm/amdgpu/dc: Require primary plane to
 be enabled whenever the CRTC is
Message-ID: <1ee666b4-f1af-a19f-e03a-fdfc00698d2f@daenzer.net>
Date:   Mon, 21 Sep 2020 16:48:05 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.2.2
MIME-Version: 1.0
In-Reply-To: <20200921144054.2135602-13-sashal@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-CA
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2020-09-21 4:40 p.m., Sasha Levin wrote:
> From: Michel Dänzer <mdaenzer@redhat.com>
> 
> [ Upstream commit 2f228aab21bbc74e90e267a721215ec8be51daf7 ]
> 
> Don't check drm_crtc_state::active for this either, per its
> documentation in include/drm/drm_crtc.h:
> 
>   * Hence drivers must not consult @active in their various
>   * &drm_mode_config_funcs.atomic_check callback to reject an atomic
>   * commit.
> 
> atomic_remove_fb disables the CRTC as needed for disabling the primary
> plane.
> 
> This prevents at least the following problems if the primary plane gets
> disabled (e.g. due to destroying the FB assigned to the primary plane,
> as happens e.g. with mutter in Wayland mode):
> 
> * The legacy cursor ioctl returned EINVAL for a non-0 cursor FB ID
>    (which enables the cursor plane).
> * If the cursor plane was enabled, changing the legacy DPMS property
>    value from off to on returned EINVAL.
> 
> v2:
> * Minor changes to code comment and commit log, per review feedback.
> 
> GitLab: https://gitlab.gnome.org/GNOME/mutter/-/issues/1108
> GitLab: https://gitlab.gnome.org/GNOME/mutter/-/issues/1165
> GitLab: https://gitlab.gnome.org/GNOME/mutter/-/issues/1344
> Suggested-by: Daniel Vetter <daniel.vetter@ffwll.ch>
> Acked-by: Daniel Vetter <daniel.vetter@ffwll.ch>
> Reviewed-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
> Signed-off-by: Michel Dänzer <mdaenzer@redhat.com>
> Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>

I'm a bit nervous about this getting backported so far back so quickly. 
I'd prefer waiting for 5.9 final first at least.


-- 
Earthling Michel Dänzer               |               https://redhat.com
Libre software enthusiast             |             Mesa and X developer
