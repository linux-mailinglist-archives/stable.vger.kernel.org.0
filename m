Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 25D1F792DB
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 20:11:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727993AbfG2SLE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 14:11:04 -0400
Received: from mail-vs1-f67.google.com ([209.85.217.67]:34364 "EHLO
        mail-vs1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727326AbfG2SLE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Jul 2019 14:11:04 -0400
Received: by mail-vs1-f67.google.com with SMTP id m23so41545161vso.1
        for <stable@vger.kernel.org>; Mon, 29 Jul 2019 11:11:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:reply-to:to:date
         :in-reply-to:references:organization:user-agent:mime-version
         :content-transfer-encoding;
        bh=bUfMTPgx9WjAuO9WgICdJPmYrEQAtDvBX73B3OSaH0o=;
        b=EEqUC1fQybETpVTVVY6ZtCsUiW0mJ4cWCAImX0XQkzOOzWDO0k4odj7fpNoeuerG7C
         /b9Xq3LNvVdoyfy/719zvqSEISGXCXo9MSBkZvQPKh0PfRZNrXiwuiX2kaGyg3qstkva
         sHYuhThY0eqFtRpx1vAVgcbQLYP45CkfuH5nQHBANhV4EA4YXWfC2nET+LnIg9BoZapM
         fI+cul7qJmBkg8zSFMXJB11eZdgPi1uzRuYRztBEuLJ24SSgF2B+Y24lmBQc535hyY3i
         0uRSubC9ar0qBjVSwIG0maJV4/x4wriwToXQuyYtlc/zWWtlZb26baGg6OykdJwkypiK
         kPCw==
X-Gm-Message-State: APjAAAVPVap6INe+3C9qHqRoJmOlTmbig5NKfMYy5QmnwiukGUHByM4P
        LRR91ikjP+T3pRTDYGSqQYC0DA==
X-Google-Smtp-Source: APXvYqz6W4xcPCRb/LcxxS+0tsRD6XNCs/tU/GcX6Q6GS6hOy7eZGE3SDwio2RJY6Gz2pPRc2JDFXg==
X-Received: by 2002:a67:dd85:: with SMTP id i5mr68533733vsk.220.1564423862921;
        Mon, 29 Jul 2019 11:11:02 -0700 (PDT)
Received: from whitewolf.lyude.net (static-173-76-190-23.bstnma.ftas.verizon.net. [173.76.190.23])
        by smtp.gmail.com with ESMTPSA id d67sm17744995vkd.25.2019.07.29.11.11.01
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 29 Jul 2019 11:11:02 -0700 (PDT)
Message-ID: <9b014c2d95328fb0dc2751178a516a713884e12a.camel@redhat.com>
Subject: Re: FAILED: patch "[PATCH] drm/amdgpu: Don't skip display settings
 in hwmgr_resume()" failed to apply to 5.2-stable tree
From:   Lyude Paul <lyude@redhat.com>
Reply-To: lyude@redhat.com
To:     gregkh@linuxfoundation.org, Likun.Gao@amd.com, Rex.Zhu@amd.com,
        alexander.deucher@amd.com, evan.quan@amd.com, ray.huang@amd.com,
        stable@vger.kernel.org
Date:   Mon, 29 Jul 2019 14:11:00 -0400
In-Reply-To: <1564416461175229@kroah.com>
References: <1564416461175229@kroah.com>
Organization: Red Hat
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.4 (3.32.4-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Looks like this patch managed to make it in before 5.2 was finalized, so we
won't need a stable backport for this. Cheers

On Mon, 2019-07-29 at 18:07 +0200, gregkh@linuxfoundation.org wrote:
> The patch below does not apply to the 5.2-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.
> 
> thanks,
> 
> greg k-h
> 
> ------------------ original commit in Linus's tree ------------------
> 
> From ee006eb00a00198d21dad60696318fd443a59f88 Mon Sep 17 00:00:00 2001
> From: Lyude Paul <lyude@redhat.com>
> Date: Thu, 20 Jun 2019 19:21:26 -0400
> Subject: [PATCH] drm/amdgpu: Don't skip display settings in hwmgr_resume()
> 
> I'm not entirely sure why this is, but for some reason:
> 
> 921935dc6404 ("drm/amd/powerplay: enforce display related settings only on
> needed")
> 
> Breaks runtime PM resume on the Radeon PRO WX 3100 (Lexa) in one the
> pre-production laptops I have. The issue manifests as the following
> messages in dmesg:
> 
> [drm] UVD and UVD ENC initialized successfully.
> amdgpu 0000:3b:00.0: [drm:amdgpu_ring_test_helper [amdgpu]] *ERROR* ring vce1
> test failed (-110)
> [drm:amdgpu_device_ip_resume_phase2 [amdgpu]] *ERROR* resume of IP block
> <vce_v3_0> failed -110
> [drm:amdgpu_device_resume [amdgpu]] *ERROR* amdgpu_device_ip_resume failed (-
> 110).
> 
> And happens after about 6-10 runtime PM suspend/resume cycles (sometimes
> sooner, if you're lucky!). Unfortunately I can't seem to pin down
> precisely which part in psm_adjust_power_state_dynamic that is causing
> the issue, but not skipping the display setting setup seems to fix it.
> Hopefully if there is a better fix for this, this patch will spark
> discussion around it.
> 
> Fixes: 921935dc6404 ("drm/amd/powerplay: enforce display related settings only
> on needed")
> Cc: Evan Quan <evan.quan@amd.com>
> Cc: Alex Deucher <alexander.deucher@amd.com>
> Cc: Huang Rui <ray.huang@amd.com>
> Cc: Rex Zhu <Rex.Zhu@amd.com>
> Cc: Likun Gao <Likun.Gao@amd.com>
> Cc: <stable@vger.kernel.org> # v5.1+
> Signed-off-by: Lyude Paul <lyude@redhat.com>
> Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
> 
> diff --git a/drivers/gpu/drm/amd/powerplay/hwmgr/hwmgr.c
> b/drivers/gpu/drm/amd/powerplay/hwmgr/hwmgr.c
> index 0b0d83c2a678..a24beaa4fb01 100644
> --- a/drivers/gpu/drm/amd/powerplay/hwmgr/hwmgr.c
> +++ b/drivers/gpu/drm/amd/powerplay/hwmgr/hwmgr.c
> @@ -327,7 +327,7 @@ int hwmgr_resume(struct pp_hwmgr *hwmgr)
>  	if (ret)
>  		return ret;
>  
> -	ret = psm_adjust_power_state_dynamic(hwmgr, true, NULL);
> +	ret = psm_adjust_power_state_dynamic(hwmgr, false, NULL);
>  
>  	return ret;
>  }
> 

