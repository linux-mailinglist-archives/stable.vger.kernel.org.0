Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4129C2C7427
	for <lists+stable@lfdr.de>; Sat, 28 Nov 2020 23:18:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388984AbgK1Vts (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 28 Nov 2020 16:49:48 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:40397 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733260AbgK1SOz (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 28 Nov 2020 13:14:55 -0500
Received: by mail-wm1-f66.google.com with SMTP id a3so9996792wmb.5;
        Sat, 28 Nov 2020 10:14:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Pg/nt8j3UsZLPLuK400Pi+qxlfumMxN5pMJ4xzsHKD0=;
        b=C4DZWlgYO5BMiHy2j75e5hBXaieD6pWYNGLV6hqIPpVOdZACjPqVTWqiiDoN78y+eJ
         14h/x9XxWX5WzIOUdjbIAdRAUu6u8D236w9XprO+LiK67wfrImach1NSg3exjCtMEuBh
         LAKrfvW8kUT6+ofzye8GDdtE6fRHT7vY8QlsPf+M39XuukQw/sh0nyVARm/8v0tTyur4
         YCfowVmS/mbCma5bguSTs3VIyraRUw3k1sFyCIlMrFHUAMtd+sV4Q9x+goqGQGcaNVuL
         MGb2rWWt6dDS7Ur6TDzNxAZbtTKNjlRGVKcz+HO9DOhyGRIcb1P/PnXexjkoztARe8XN
         btKg==
X-Gm-Message-State: AOAM531TQ/Vn89oGX7L/ldQbqxFKdba+0lh0xFDoyAhBsYEt4R192gxi
        O31Zw4GYekS65wXH9rGWkkDzS4v0Xkw=
X-Google-Smtp-Source: ABdhPJz/PCvfia1c/gUxPgGhj8H8KA5LOUSuktM0+eZN4vEtuQ7jVxt3+ndRTOX5Y8UnjqAfaT6NUA==
X-Received: by 2002:a7b:c0c9:: with SMTP id s9mr1761933wmh.175.1606563134029;
        Sat, 28 Nov 2020 03:32:14 -0800 (PST)
Received: from kozik-lap (adsl-84-226-167-205.adslplus.ch. [84.226.167.205])
        by smtp.googlemail.com with ESMTPSA id o4sm16925991wmh.33.2020.11.28.03.32.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Nov 2020 03:32:12 -0800 (PST)
Date:   Sat, 28 Nov 2020 12:32:11 +0100
From:   Krzysztof Kozlowski <krzk@kernel.org>
To:     Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Cc:     Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Jiri Kosina <trivial@kernel.org>,
        Mark Brown <broonie@kernel.org>,
        linux-renesas-soc@vger.kernel.org, Pavel Machek <pavel@denx.de>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        linux-kernel@vger.kernel.org,
        Prabhakar <prabhakar.csengg@gmail.com>, stable@vger.kernel.org
Subject: Re: [PATCH v2 1/5] memory: renesas-rpc-if: Return correct value to
 the caller of rpcif_manual_xfer()
Message-ID: <20201128113211.GA4761@kozik-lap>
References: <20201126191146.8753-1-prabhakar.mahadev-lad.rj@bp.renesas.com>
 <20201126191146.8753-2-prabhakar.mahadev-lad.rj@bp.renesas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20201126191146.8753-2-prabhakar.mahadev-lad.rj@bp.renesas.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Nov 26, 2020 at 07:11:42PM +0000, Lad Prabhakar wrote:
> In the error path of rpcif_manual_xfer() the value of ret is overwritten
> by value returned by reset_control_reset() function and thus returning
> incorrect value to the caller.
> 
> This patch makes sure the correct value is returned to the caller of
> rpcif_manual_xfer() by dropping the overwrite of ret in error path.
> Also now we ignore the value returned by reset_control_reset() in the
> error path and instead print a error message when it fails.
> 
> Fixes: ca7d8b980b67f ("memory: add Renesas RPC-IF driver")
> Reported-by: Pavel Machek <pavel@denx.de>
> Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
> Cc: stable@vger.kernel.org
> Reviewed-by: Sergei Shtylyov <sergei.shtylyov@gmail.com>
> ---
>  drivers/memory/renesas-rpc-if.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)

Thanks, applied to mem-ctrl tree.

Best regards,
Krzysztof

