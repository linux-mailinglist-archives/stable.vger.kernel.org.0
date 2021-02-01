Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 011D330B292
	for <lists+stable@lfdr.de>; Mon,  1 Feb 2021 23:09:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230365AbhBAWHk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Feb 2021 17:07:40 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:46480 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230256AbhBAWFz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Feb 2021 17:05:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612217067;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qfsnAlAu/McYcGw2KOXJYqmGsyF1QR4l7YGKSVjsOzo=;
        b=XTSfZdfB3aiKWNGou94r42ew9+C+Nqzu47Tx6mi1lIByKPnD4aJHqo9X4M5C8vNX1L08O7
        PIPrmEi45kQo0eCy8SEsyphC/hI16jPd3epBqGzSgeDmUjpKhwbBO85lovMfD0uPb2DrEs
        F7zKQY/oLwXyGUZwSWsgzXeXGgXrX+4=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-96-dYX3o8HtOManPnjfBdsDcA-1; Mon, 01 Feb 2021 17:04:21 -0500
X-MC-Unique: dYX3o8HtOManPnjfBdsDcA-1
Received: by mail-qt1-f198.google.com with SMTP id r18so11670064qta.19
        for <stable@vger.kernel.org>; Mon, 01 Feb 2021 14:04:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:reply-to:to:cc:date
         :in-reply-to:references:organization:user-agent:mime-version
         :content-transfer-encoding;
        bh=qfsnAlAu/McYcGw2KOXJYqmGsyF1QR4l7YGKSVjsOzo=;
        b=KmB9bmN/6htTZaM80quGdPFTnHYIrF04GLjp7b7GrwZ/CTeIn9fMX28wpXJpPK/zfr
         lOTCurlPymNjZQN4jvXmnc+HljROHG7kAUXzYAD4AM7s0FjU5bjzTj0qMEmffoStP/sg
         +NI3AlJA1/s91fpR4x8jdqsijpmqZnvDhgTyVlc8eaidNTibskbmJ4jYhBRhxnWzQvMM
         P315jDRoa5841E79NvZiMCzDVtaQvqwoy9Kxj/8Jw9KoZYWsiqP7rZtz5v0yv3yV9Nx8
         wbY9IooTq0+jI/JaFNvlVphlJxmGpvsEoQL8jbpDN4gk9VjnkAdMv27lMz/MB1iSLabz
         ON9g==
X-Gm-Message-State: AOAM532J/vVm+47s7OsFFDV36HHCCSpEUV6LrMin0o7MNn3gki3ueXv5
        pq1m8SC/jOMhy2yh6oQn0Z3IxI+BwDe07onKBkCKuefHZuSNshOgsN7LcN6wmxnmn1qg3poTHpG
        F8FkcnC6Ef7fSY7IF
X-Received: by 2002:a05:620a:9cc:: with SMTP id y12mr18096791qky.484.1612217061526;
        Mon, 01 Feb 2021 14:04:21 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxx/YAAPANhE5btY2ANJn+PQ9MAKqUA1ToMGepGc4545upibD3KSYzj+Fvtch0454gUx+De0w==
X-Received: by 2002:a05:620a:9cc:: with SMTP id y12mr18096783qky.484.1612217061352;
        Mon, 01 Feb 2021 14:04:21 -0800 (PST)
Received: from Whitewolf.lyude.net (pool-108-49-102-102.bstnma.fios.verizon.net. [108.49.102.102])
        by smtp.gmail.com with ESMTPSA id b17sm1613323qkh.57.2021.02.01.14.04.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Feb 2021 14:04:20 -0800 (PST)
Message-ID: <6d9dfeddd11ebe548b70898457452167af75e1ad.camel@redhat.com>
Subject: Re: [PATCH 1/4] drm/dp_mst: Don't report ports connected if nothing
 is attached to them
From:   Lyude Paul <lyude@redhat.com>
Reply-To: lyude@redhat.com
To:     Imre Deak <imre.deak@intel.com>, dri-devel@lists.freedesktop.org
Cc:     Wayne Lin <Wayne.Lin@amd.com>, stable@vger.kernel.org,
        intel-gfx@lists.freedesktop.org
Date:   Mon, 01 Feb 2021 17:04:19 -0500
In-Reply-To: <20210201120145.350258-1-imre.deak@intel.com>
References: <20210201120145.350258-1-imre.deak@intel.com>
Organization: Red Hat
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.3 (3.38.3-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

For the whole series:

Reviewed-by: Lyude Paul <lyude@redhat.com>

On Mon, 2021-02-01 at 14:01 +0200, Imre Deak wrote:
> Reporting a port as connected if nothing is attached to them leads to
> any i2c transactions on this port trying to use an uninitialized i2c
> adapter, fix this.
> 
> Let's account for this case even if branch devices have no good reason
> to report a port as unplugged with their peer device type set to 'none'.
> 
> Fixes: db1a07956968 ("drm/dp_mst: Handle SST-only branch device case")
> References: https://gitlab.freedesktop.org/drm/intel/-/issues/2987
> References: https://gitlab.freedesktop.org/drm/intel/-/issues/1963
> Cc: Wayne Lin <Wayne.Lin@amd.com>
> Cc: Lyude Paul <lyude@redhat.com>
> Cc: <stable@vger.kernel.org> # v5.5+
> Cc: intel-gfx@lists.freedesktop.org
> Signed-off-by: Imre Deak <imre.deak@intel.com>
> ---
>  drivers/gpu/drm/drm_dp_mst_topology.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/gpu/drm/drm_dp_mst_topology.c
> b/drivers/gpu/drm/drm_dp_mst_topology.c
> index e82b596d646c..deb7995f42fa 100644
> --- a/drivers/gpu/drm/drm_dp_mst_topology.c
> +++ b/drivers/gpu/drm/drm_dp_mst_topology.c
> @@ -4224,6 +4224,7 @@ drm_dp_mst_detect_port(struct drm_connector *connector,
>  
>         switch (port->pdt) {
>         case DP_PEER_DEVICE_NONE:
> +               break;
>         case DP_PEER_DEVICE_MST_BRANCHING:
>                 if (!port->mcs)
>                         ret = connector_status_connected;

-- 
Sincerely,
   Lyude Paul (she/her)
   Software Engineer at Red Hat
   
Note: I deal with a lot of emails and have a lot of bugs on my plate. If you've
asked me a question, are waiting for a review/merge on a patch, etc. and I
haven't responded in a while, please feel free to send me another email to check
on my status. I don't bite!

