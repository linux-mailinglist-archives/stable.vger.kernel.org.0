Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3ECE196893
	for <lists+stable@lfdr.de>; Sat, 28 Mar 2020 19:36:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726265AbgC1Sgz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 28 Mar 2020 14:36:55 -0400
Received: from mail-il1-f195.google.com ([209.85.166.195]:36136 "EHLO
        mail-il1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725882AbgC1Sgz (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 28 Mar 2020 14:36:55 -0400
Received: by mail-il1-f195.google.com with SMTP id p13so11910901ilp.3;
        Sat, 28 Mar 2020 11:36:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0HI24KR/yCjlJFsLLO6kOQCApuZY67HrR4f/HELwj00=;
        b=Bjn3/ZMSjI5MgkcB5gKK6N4zFjMVoFTSxcltL3PA99UZvBgXDgAOataat0yBdZVoqE
         NH/0OggUWvfgrio+/Usro0z9coMiVVo64z+Ln5aQgcxfw4feFgn+HtkwH7mrWJCnPGE2
         HKqmsQoZGerQe6AjWMGTP1n8+SNzk6IVEChHV39pY8GLRUYnLiJwMUAZxqCourq0RyLY
         pCPSDwMaFYSKYZfU+gkFh+BeUED8m5CfdGuTbfJazHFg5insTKlELMAZGfCPaPk0Aqk9
         NYm6bxxNZc3SqBkQRE300iLkiF0BDCxKz1y/Kd2Stf2b1/BQQJeA1JOGYlS/PLRrlncv
         0qzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0HI24KR/yCjlJFsLLO6kOQCApuZY67HrR4f/HELwj00=;
        b=lx26CZDDaML69rm41uVuGH7igx2oQdBRE729WG+s4SyP3PetmO8v5YxJfbJP/wlX1s
         yIJQGHwRK1/xr48KpCfh56rzCPKIZ2lpX2A+P9aqLmePRfDgJtvHActpu15urhU8D/QE
         Bjy7ZIajen0HhTtEKPo8431KmoYJcTH2F9obnxPeHffw522OMHbOpcJzDOaCxihDKH0E
         4i2xEKWCegmEQmtTj53XfTz6WlzRgdKoXzKwq93zx+IUrLaKk2zeGhcIXiIpVqpD2OCu
         /5phwqTTRDYVbsjUmjE4I1aBUSF8QUgStUuYeitVLLIpn155MVUxWX4gP2PsOnGdne0t
         kbcw==
X-Gm-Message-State: ANhLgQ1Y8YFkpd8WOpjDv7I9SmraoLxTmxtVjei006DeWBgcjn4MW823
        wgl0XUgS+teLAeS0tuI+5mivLeIFROq39sSOy44=
X-Google-Smtp-Source: ADFU+vvj7xBW8YgzYefpKHgpnS8IasnPvFs7tQ1xw3iG07/FjIZop9WE6ytmhD+MGsO5JAtYB+aIgp90MlIPv8WqjKo=
X-Received: by 2002:a92:cb49:: with SMTP id f9mr4613117ilq.193.1585420613730;
 Sat, 28 Mar 2020 11:36:53 -0700 (PDT)
MIME-Version: 1.0
References: <CGME20200327162330eucas1p1b0413e0e9887aa76d3048f86d2166dcd@eucas1p1.samsung.com>
 <20200327162126.29705-1-m.szyprowski@samsung.com> <14063C7AD467DE4B82DEDB5C278E8663FFFBFCE1@fmsmsx107.amr.corp.intel.com>
In-Reply-To: <14063C7AD467DE4B82DEDB5C278E8663FFFBFCE1@fmsmsx107.amr.corp.intel.com>
From:   Shane Francis <bigbeeshane@gmail.com>
Date:   Sat, 28 Mar 2020 18:36:42 +0000
Message-ID: <CABnpCuBLkk2RQovNmcx1U9+oou18cmrd71eQ8=O=ELOM_NcjSA@mail.gmail.com>
Subject: Re: [PATCH v2] drm/prime: fix extracting of the DMA addresses from a scatterlist
To:     "Ruhl, Michael J" <michael.j.ruhl@intel.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Cc:     "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-samsung-soc@vger.kernel.org" 
        <linux-samsung-soc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <mripard@kernel.org>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Alex Deucher <alexander.deucher@amd.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Mar 27, 2020 at 6:31 PM Ruhl, Michael J
<michael.j.ruhl@intel.com> wrote:
> Is there an example of what the scatterlist would look like in this case?
>
> Does each SG entry always have the page and dma info? or could you have
> entries that have page information only, and entries that have dma info only?
>
> If the same entry has different size info (page_len = PAGE_SIZE,
> dma_len = 4 * PAGE_SIZE?), are we guaranteed that the arrays (page and addrs) have
> been sized correctly?
>
> Just trying to get my head wrapped around this.
>
> Thanks,
>
> Mike
>

My understanding is that page_len and dma_len in this case could have
different values (looking at iommu_dma_map_sg within dma-iommu.c),
this seems to add some padding calculated by using the device iova
domain to s_length but sg_dma_len is set to the original length

The scatterlists table can also get reduced down within
"__finalise_sg" possibly causing (if reduced) the dma_len of the last
table elements to be 0 (page_len would not be 0 in this case).

Documentation around looping & accessing scatterlists in DMA-API.txt
states that  sg_dma_address() and sg_dma_len() should be used when
accessing addr and len rather than sg->address and sg->length.

Maybe it would be worth splitting this out into 2 functions to avoid
potential issues with the above use case ?

Regards,

Shane Francis
