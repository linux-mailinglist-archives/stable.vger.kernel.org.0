Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18C9024BE14
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 15:20:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729546AbgHTNUV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 09:20:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727941AbgHTJey (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Aug 2020 05:34:54 -0400
Received: from mail-vs1-xe41.google.com (mail-vs1-xe41.google.com [IPv6:2607:f8b0:4864:20::e41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F056C061757
        for <stable@vger.kernel.org>; Thu, 20 Aug 2020 02:34:54 -0700 (PDT)
Received: by mail-vs1-xe41.google.com with SMTP id q13so707758vsn.9
        for <stable@vger.kernel.org>; Thu, 20 Aug 2020 02:34:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=x72BSpaLx4ICN/srUgTQUCZpl4nW2TSwH+6+Yk5U/SY=;
        b=Ciy4l1QE3R5Tva0+UzjZbqYULUrEEYroWN4y4I2zA6sF/F53RuFhtIQPzvHO4rXaMS
         4aMooA6pjPutdy6j16A6weqklMltY3Ix4gRFwATxxryfm2nTdwtnD6dAxt9my4qRg8J/
         Ix+71jHxmH94opMZX280yLVV7ntTfhZf/ZKTro7ecP1RoZWnXggNoed/+VKpexQKlp6T
         vQzdquaHWDTl1YTakHoVxIXToL+lwgO97RTAGMx2MQFGeaeC9X9WBCrvxxON3eqvkr4s
         kNSzafJNsaxVkRdu+3IG7qTLNr7zRk24JS21Bxf9MWPrlBCCcgKlz65Wm6IpTWIaNgm8
         FsVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=x72BSpaLx4ICN/srUgTQUCZpl4nW2TSwH+6+Yk5U/SY=;
        b=dNpD2rHtmGCBMWeUkHS9hBjfImDhg4TlhubT9OPlOehFATl+1hDoJV19FKI94XEYcZ
         L8biK2Kx57W97xYXN52DPSNik5HpSdKk2lbtGu4yXJ1l/hFxC4o91NSxkr8qlef7oTQX
         w/Qb97Gbz02kMW4cdBlvsB+wRi+EzbpvQglvC9bhc7z6WfgTlNJlKWyi4rnpzRtu3ZBe
         gId8WcFrqPogTneH0qG0AQ9Qyzb9bWSp6tRUT3m1RH3LnCNqwkFJBqYcL+ohwTmytvVt
         gScE0crTKHVzH1TR0PJE6TTdJT61ltwv0xoilEl+D8bX09ab4bAbie23tayP5M3JvHWi
         yNog==
X-Gm-Message-State: AOAM533dbcrQWbBrj3h6iHaHwQpTVXH+NylYyI3bW7Qq94zoUlPn/Mth
        NN4Ctd4jN+sx96sYM+/eYvQlYcpNT8U937GU2uiFsu1+Rn8=
X-Google-Smtp-Source: ABdhPJyySQPWQsm294RUrVDwIrN24V53R92M+Nhm3BcFW2jBoykGvhhhhy9ChPqeBU4m976YKkfr4A7feaaljNuFCXU=
X-Received: by 2002:a67:f30e:: with SMTP id p14mr597976vsf.119.1597916093246;
 Thu, 20 Aug 2020 02:34:53 -0700 (PDT)
MIME-Version: 1.0
References: <20200819203153.16000-1-chris@chris-wilson.co.uk>
In-Reply-To: <20200819203153.16000-1-chris@chris-wilson.co.uk>
From:   Matthew Auld <matthew.william.auld@gmail.com>
Date:   Thu, 20 Aug 2020 10:34:26 +0100
Message-ID: <CAM0jSHPchm6wqpP9_sAZb70+3hLrFLUauNxcQPJHTpy1g-m_Bw@mail.gmail.com>
Subject: Re: [Intel-gfx] [PATCH] drm/i915/gem: Prevent using
 pgprot_writecombine() if PAT is not supported
To:     Chris Wilson <chris@chris-wilson.co.uk>
Cc:     Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 19 Aug 2020 at 21:32, Chris Wilson <chris@chris-wilson.co.uk> wrote:
>
> Let's not try and use PAT attributes for I915_MAP_WC is the CPU doesn't
> support PAT.
>
> Fixes: 6056e50033d9 ("drm/i915/gem: Support discontiguous lmem object maps")
> Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
> Cc: <stable@vger.kernel.org> # v5.6+
Reviewed-by: Matthew Auld <matthew.auld@intel.com>
