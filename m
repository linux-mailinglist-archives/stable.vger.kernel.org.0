Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB351A21C6
	for <lists+stable@lfdr.de>; Thu, 29 Aug 2019 19:07:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726739AbfH2RHC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Aug 2019 13:07:02 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34278 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726661AbfH2RHB (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 29 Aug 2019 13:07:01 -0400
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com [209.85.222.199])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 8CE0C2CE90A
        for <stable@vger.kernel.org>; Thu, 29 Aug 2019 17:07:01 +0000 (UTC)
Received: by mail-qk1-f199.google.com with SMTP id m2so4228976qkk.10
        for <stable@vger.kernel.org>; Thu, 29 Aug 2019 10:07:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:organization:user-agent:mime-version
         :content-transfer-encoding;
        bh=KpaKBQvzLpG9KqBr01yVnQX/M7rpnfov/U+0afjVNGM=;
        b=OTDQlUJvLYgqDlcJydJhKPTj0UpHOaiy7hdJvm0/VXrvguRWh4punbzrJL+du9+zzF
         wD3lY03MUEL6ROyryAauueDp87h335MYadEF+ZfIns2/1dsN+gChBBh1JMAvLgWkwHuG
         Np9COpgS7IHK5QRBT0uLTNjoGm0wwmjh9cs9Js8gOBbhxyxo2C8xEDDEekLqucbOe4Zq
         unbxlIuPA6Q45Nb2uWKsKR1tIwX+pSpUBZlZnZkaQ79iYnB1mN1WmX6JvJYuUat2lKIY
         HGwqF9kSNbR5uk0FqLrV8SeQB4nsGVPyUNmEFByO6KO6SJphw+d0OvDalZWLSTjoP3bx
         XKyA==
X-Gm-Message-State: APjAAAUyXsDbPSf36DK5fSH73TNkw2fdDKLYPoHK3kCdr78T5TmWIdmg
        +zFizww2d27ieoPq2B0zKVAzeIT1Mj6EyA1faQcdsIXtJCz/HH6hW3rVMgMSmD0m1qPqeyaCHKJ
        vT6kV3dU/QvFBBeqE
X-Received: by 2002:ac8:73c7:: with SMTP id v7mr11039773qtp.9.1567098420633;
        Thu, 29 Aug 2019 10:07:00 -0700 (PDT)
X-Google-Smtp-Source: APXvYqySnAmJD972UE5D4SPQYuunb3ayy3uKj3F2Wmm1K7rPh/8PeVLff00Q5E5OQ+gtUvslFoUsyA==
X-Received: by 2002:ac8:73c7:: with SMTP id v7mr11039741qtp.9.1567098420385;
        Thu, 29 Aug 2019 10:07:00 -0700 (PDT)
Received: from dhcp-10-20-1-11.bss.redhat.com ([144.121.20.162])
        by smtp.gmail.com with ESMTPSA id c13sm1591981qtg.3.2019.08.29.10.06.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Aug 2019 10:06:59 -0700 (PDT)
Message-ID: <9927a099fc5f0140ea92e34f017186d9ffe0bb13.camel@redhat.com>
Subject: Re: [PATCH] drm: mst: Fix query_payload ack reply struct
From:   Lyude Paul <lyude@redhat.com>
To:     Sean Paul <sean@poorly.run>, dri-devel@lists.freedesktop.org
Cc:     Sean Paul <seanpaul@chromium.org>,
        Todd Previte <tprevite@gmail.com>,
        Dave Airlie <airlied@redhat.com>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>, stable@vger.kernel.org
Date:   Thu, 29 Aug 2019 13:06:58 -0400
In-Reply-To: <20190829165223.129662-1-sean@poorly.run>
References: <20190829165223.129662-1-sean@poorly.run>
Organization: Red Hat
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.4 (3.32.4-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Is it worth actually CCing stable on this? This patch is certainly correct but
I don't think we use this struct for anything quite yet.

Otherwise: Reviewed-by: Lyude Paul <lyude@redhat.com>

On Thu, 2019-08-29 at 12:52 -0400, Sean Paul wrote:
> From: Sean Paul <seanpaul@chromium.org>
> 
> Spec says[1] Allocated_PBN is 16 bits
> 
> [1]- DisplayPort 1.2 Spec, Section 2.11.9.8, Table 2-98
> 
> Fixes: ad7f8a1f9ced ("drm/helper: add Displayport multi-stream helper
> (v0.6)")
> Cc: Lyude Paul <lyude@redhat.com>
> Cc: Todd Previte <tprevite@gmail.com>
> Cc: Dave Airlie <airlied@redhat.com>
> Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
> Cc: Maxime Ripard <maxime.ripard@bootlin.com>
> Cc: Sean Paul <sean@poorly.run>
> Cc: David Airlie <airlied@linux.ie>
> Cc: Daniel Vetter <daniel@ffwll.ch>
> Cc: dri-devel@lists.freedesktop.org
> Cc: <stable@vger.kernel.org> # v3.17+
> Signed-off-by: Sean Paul <seanpaul@chromium.org>
> ---
>  include/drm/drm_dp_mst_helper.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/include/drm/drm_dp_mst_helper.h
> b/include/drm/drm_dp_mst_helper.h
> index 2ba6253ea6d3..fc349204a71b 100644
> --- a/include/drm/drm_dp_mst_helper.h
> +++ b/include/drm/drm_dp_mst_helper.h
> @@ -334,7 +334,7 @@ struct drm_dp_resource_status_notify {
>  
>  struct drm_dp_query_payload_ack_reply {
>  	u8 port_number;
> -	u8 allocated_pbn;
> +	u16 allocated_pbn;
>  };
>  
>  struct drm_dp_sideband_msg_req_body {
-- 
Cheers,
	Lyude Paul

