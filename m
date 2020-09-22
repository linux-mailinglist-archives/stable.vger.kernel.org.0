Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0553327442C
	for <lists+stable@lfdr.de>; Tue, 22 Sep 2020 16:25:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726720AbgIVOZf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Sep 2020 10:25:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:59042 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726579AbgIVOZe (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Sep 2020 10:25:34 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D3F7E2073A;
        Tue, 22 Sep 2020 14:25:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600784734;
        bh=wQx7HRd1PEMCjgO+IIjRBfqRQ/i8QsVPVrEKxApVDCY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=0GDOmErSh9Jgj+/3Vk7j0+x7Lp2zRADZFYttC95BZnGyB6R44l7r1m8K6t4ne0KDO
         yjFVo7r7PwQN6hAXU6UmFCvrE4zaFqoPhnEA/Vry7VSuntc+4Ck8BYziSEF++uxYdU
         ihnCKZgD8HyAyy8/c4aY1Fo2XZCXTbXhr7S4cf+o=
Date:   Tue, 22 Sep 2020 10:25:32 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Michel =?iso-8859-1?Q?D=E4nzer?= <michel@daenzer.net>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        Alex Deucher <alexander.deucher@amd.com>,
        Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Subject: Re: [PATCH AUTOSEL 5.4 13/15] drm/amdgpu/dc: Require primary plane
 to be enabled whenever the CRTC is
Message-ID: <20200922142532.GO2431@sasha-vm>
References: <20200921144054.2135602-1-sashal@kernel.org>
 <20200921144054.2135602-13-sashal@kernel.org>
 <1ee666b4-f1af-a19f-e03a-fdfc00698d2f@daenzer.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1ee666b4-f1af-a19f-e03a-fdfc00698d2f@daenzer.net>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Sep 21, 2020 at 04:48:05PM +0200, Michel Dänzer wrote:
>On 2020-09-21 4:40 p.m., Sasha Levin wrote:
>>From: Michel Dänzer <mdaenzer@redhat.com>
>>
>>[ Upstream commit 2f228aab21bbc74e90e267a721215ec8be51daf7 ]
>>
>>Don't check drm_crtc_state::active for this either, per its
>>documentation in include/drm/drm_crtc.h:
>>
>>  * Hence drivers must not consult @active in their various
>>  * &drm_mode_config_funcs.atomic_check callback to reject an atomic
>>  * commit.
>>
>>atomic_remove_fb disables the CRTC as needed for disabling the primary
>>plane.
>>
>>This prevents at least the following problems if the primary plane gets
>>disabled (e.g. due to destroying the FB assigned to the primary plane,
>>as happens e.g. with mutter in Wayland mode):
>>
>>* The legacy cursor ioctl returned EINVAL for a non-0 cursor FB ID
>>   (which enables the cursor plane).
>>* If the cursor plane was enabled, changing the legacy DPMS property
>>   value from off to on returned EINVAL.
>>
>>v2:
>>* Minor changes to code comment and commit log, per review feedback.
>>
>>GitLab: https://gitlab.gnome.org/GNOME/mutter/-/issues/1108
>>GitLab: https://gitlab.gnome.org/GNOME/mutter/-/issues/1165
>>GitLab: https://gitlab.gnome.org/GNOME/mutter/-/issues/1344
>>Suggested-by: Daniel Vetter <daniel.vetter@ffwll.ch>
>>Acked-by: Daniel Vetter <daniel.vetter@ffwll.ch>
>>Reviewed-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
>>Signed-off-by: Michel Dänzer <mdaenzer@redhat.com>
>>Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
>>Signed-off-by: Sasha Levin <sashal@kernel.org>
>
>I'm a bit nervous about this getting backported so far back so 
>quickly. I'd prefer waiting for 5.9 final first at least.

Will drop it for now, thanks.

-- 
Thanks,
Sasha
