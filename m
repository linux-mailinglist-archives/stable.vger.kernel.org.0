Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25BCF29405B
	for <lists+stable@lfdr.de>; Tue, 20 Oct 2020 18:19:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394562AbgJTQTu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Oct 2020 12:19:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2394561AbgJTQTt (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Oct 2020 12:19:49 -0400
Received: from mail-vk1-xa43.google.com (mail-vk1-xa43.google.com [IPv6:2607:f8b0:4864:20::a43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 885C5C0613CE
        for <stable@vger.kernel.org>; Tue, 20 Oct 2020 09:19:49 -0700 (PDT)
Received: by mail-vk1-xa43.google.com with SMTP id h74so624012vkh.6
        for <stable@vger.kernel.org>; Tue, 20 Oct 2020 09:19:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=3lEkWk4hDtrA0FvKgtww2/CP5HBM7XF6B3q3l34Bzpk=;
        b=uGBeIW9h66nliEyO4vUKQ6uqetN3E6VgbZFGxr6qxYLtOzl9RdSmpoHzZOQ5jw/elq
         hZ4WffnZMjYG69L97NX86wVi2MeigsrM6fHQHHbPCpeeVBZTnpcZTki/c4L4dP1atQc5
         eYea4pEOGSFOuhzDURPM9Dl+hCbYXuF1fJt9B23Nshl4wK/Wjz3/TFxrV8kENMb4s6DO
         oshjyMieUFDRYcZHNPIU8/pVzKpimoB5xDZRM+iWS81dDtGQOj3AKesIVg0QCoBg7e5E
         lFoqH5HZoVCPybgJ1tIy6t7Zb6fomuuUvTS+nKzYdxmGsTF4VB28ijBvfVfhT6cRoxKR
         lmVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=3lEkWk4hDtrA0FvKgtww2/CP5HBM7XF6B3q3l34Bzpk=;
        b=Nq7rL325UlLxWRzz+8Zq9URiHj7c6TEYdApiHC38z4pq/y8cXPBT8H0CmBneWkIhA+
         1AoG+T4VztNQeARYc6ZgBFTllAp5emjsSkX7YTH1VoECaNeNtORw1BsRn8oZy3zrtM5K
         VJAXN6esOOC06CpZPvfvwpCLrrZmDhtAPxkS0Z2n8sDfh5YtpofnJ8/KpawJ8q8JPTT2
         ceOuXfot7qgmoyx8tRTqxONfn8y5GJ5xOXW6Zc9onfOhFYVX6hFO3mN8XAAiPvHceTEP
         CQ+9YjIOv5eHfAMTOPypGTgYOXNFTUb0zu0qNGDdrL6T6OU0fkfgbcOiuVFIaPaE8/aY
         BT3Q==
X-Gm-Message-State: AOAM530u969x++TZMF0+fNnfWedIwdP9mdy/Ek4FEHvg8+wTd90buWYo
        tSLnKtR/kmj/J0Mqm5U0l8HaUNN36e1gmQgJdfY=
X-Google-Smtp-Source: ABdhPJysZLLXIWPhLbtfbk+TY4ChzjorZCghIeX+riXkf6sBHDJJr/KYIxKF6FVkSazqltD1PcpTfvuIRwcvtq+lK5o=
X-Received: by 2002:a1f:6082:: with SMTP id u124mr2401619vkb.19.1603210788612;
 Tue, 20 Oct 2020 09:19:48 -0700 (PDT)
MIME-Version: 1.0
References: <20201019203825.10966-1-chris@chris-wilson.co.uk>
In-Reply-To: <20201019203825.10966-1-chris@chris-wilson.co.uk>
From:   Matthew Auld <matthew.william.auld@gmail.com>
Date:   Tue, 20 Oct 2020 17:19:22 +0100
Message-ID: <CAM0jSHPYzNtUV4pU3TVeFEWGV3S9GRzS9O32NTjDm51G6hfcFw@mail.gmail.com>
Subject: Re: [PATCH] drm/i915/gem: Flush coherency domains on first set-domain-ioctl
To:     Chris Wilson <chris@chris-wilson.co.uk>
Cc:     Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        =?UTF-8?Q?Zbigniew_Kempczy=C5=84ski?= 
        <zbigniew.kempczynski@intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 19 Oct 2020 at 21:38, Chris Wilson <chris@chris-wilson.co.uk> wrote=
:
>
> Avoid skipping what appears to be a no-op set-domain-ioctl if the cache
> coherency state is inconsistent with our target domain. This also has
> the utility of using the population of the pages to validate the backing
> store.
>
> The danger in skipping the first set-domain is leaving the cache
> inconsistent and submitting stale data, or worse leaving the clean data
> in the cache and not flushing it to the GPU. The impact should be small
> as it requires a no-op set-domain as the very first ioctl in a
> particular sequence not found in typical userspace.
>
> Reported-by: Zbigniew Kempczy=C5=84ski <zbigniew.kempczynski@intel.com>
> Fixes: 754a25442705 ("drm/i915: Skip object locking around a no-op set-do=
main ioctl")
> Testcase: igt/gem_mmap_offset/blt-coherency
> Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
> Cc: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
> Cc: Matthew Auld <matthew.william.auld@gmail.com>
> Cc: Zbigniew Kempczy=C5=84ski <zbigniew.kempczynski@intel.com>
> Cc: <stable@vger.kernel.org> # v5.2+
Reviewed-by: Matthew Auld <matthew.auld@intel.com>
