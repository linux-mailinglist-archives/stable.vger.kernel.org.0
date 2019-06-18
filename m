Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C897C4A55E
	for <lists+stable@lfdr.de>; Tue, 18 Jun 2019 17:29:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729038AbfFRP30 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Jun 2019 11:29:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:55810 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729247AbfFRP30 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 18 Jun 2019 11:29:26 -0400
Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 22CE02147A
        for <stable@vger.kernel.org>; Tue, 18 Jun 2019 15:29:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560871765;
        bh=ZUn5t8oppJ5dPnyga+v1j8kW2zl2IawTdiWuxnDXTUY=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=XFu4TbQFnR1p7juiJj01PV1oYs25i5DKIQNQcwHgmIr5GH2zipDKke9gjaVOsz20Y
         AEy/p1ZoVTp5CCfnzQ6+VHPHEWwYMi61+U3kzOTKQVz4XPjBgNQYSDrThPuQrYRUrn
         WSZ9V+5WzywyQKyIc9TQ8YJL7eSKfNzI1+7HQJDg=
Received: by mail-qt1-f170.google.com with SMTP id h21so15764932qtn.13
        for <stable@vger.kernel.org>; Tue, 18 Jun 2019 08:29:25 -0700 (PDT)
X-Gm-Message-State: APjAAAW94WdwC9LjoTY2TTGdWVycRhl3+DLZ7cv453RFxU4M4mbqYRrp
        XmMcc9hUO9wtM7IKwmXAbMZBSgcW2TSccZw3lw==
X-Google-Smtp-Source: APXvYqwQLV9yhD27wiqU2ayDlYb+Dinv3QZgpL+V65HzTmR3zsCztH+j9vOvZmsViAmKkzezUA60MKSnOaZupaqcrwQ=
X-Received: by 2002:a05:6214:248:: with SMTP id k8mr27958718qvt.200.1560871764397;
 Tue, 18 Jun 2019 08:29:24 -0700 (PDT)
MIME-Version: 1.0
References: <20190618081343.16927-1-boris.brezillon@collabora.com>
In-Reply-To: <20190618081343.16927-1-boris.brezillon@collabora.com>
From:   Rob Herring <robh+dt@kernel.org>
Date:   Tue, 18 Jun 2019 09:29:12 -0600
X-Gmail-Original-Message-ID: <CAL_JsqJhUxtAjbwUDppA3opAK4h9ws0wVuFT66yYZ7NU1=GzPg@mail.gmail.com>
Message-ID: <CAL_JsqJhUxtAjbwUDppA3opAK4h9ws0wVuFT66yYZ7NU1=GzPg@mail.gmail.com>
Subject: Re: [PATCH v2] drm/panfrost: Make sure a BO is only unmapped when appropriate
To:     Boris Brezillon <boris.brezillon@collabora.com>
Cc:     Tomeu Vizoso <tomeu@tomeuvizoso.net>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 18, 2019 at 2:13 AM Boris Brezillon
<boris.brezillon@collabora.com> wrote:
>
> mmu_ops->unmap() will fail when called on a BO that has not been
> previously mapped, and the error path in panfrost_ioctl_create_bo()
> can call drm_gem_object_put_unlocked() (which in turn calls
> panfrost_mmu_unmap()) on a BO that has not been mapped yet.
>
> Keep track of the mapped/unmapped state to avoid such issues.
>
> Fixes: f3ba91228e8e ("drm/panfrost: Add initial panfrost driver")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Boris Brezillon <boris.brezillon@collabora.com>
> ---
> Changes in v2:
> * Check is_mapped val in the caller and add WARN_ON() in the mmu code
>   (suggested by Tomeu)
> ---
>  drivers/gpu/drm/panfrost/panfrost_gem.c | 3 ++-
>  drivers/gpu/drm/panfrost/panfrost_gem.h | 1 +
>  drivers/gpu/drm/panfrost/panfrost_mmu.c | 8 ++++++++
>  3 files changed, 11 insertions(+), 1 deletion(-)

Applied.

Rob
