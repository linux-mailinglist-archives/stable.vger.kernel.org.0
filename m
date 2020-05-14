Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED8451D2812
	for <lists+stable@lfdr.de>; Thu, 14 May 2020 08:42:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726090AbgENGm0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 May 2020 02:42:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726088AbgENGm0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 May 2020 02:42:26 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22AA3C061A0C
        for <stable@vger.kernel.org>; Wed, 13 May 2020 23:42:26 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id z72so21480562wmc.2
        for <stable@vger.kernel.org>; Wed, 13 May 2020 23:42:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fooishbar-org.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Jx7qglq93rWDanidzQRtYPLYgQThofsEoYOfwLqQhc0=;
        b=vJsbUxRyyUlKCO7bodkCSLhazXXcrW2rlT5uXYdav7sHNPuukNCjoJCjKYeLd4pwiN
         RTDxD+R035RfhEmet5tCdwUlSGIoDOwduimQl3Yo7W5BWTOWWEoKrAq66TB6kpAkvMMF
         V1ot/YnQjf6tcXeZZs2OlGDvcAHRdlZQIs3J2/rLuUO4Pr8AlUfB5HA8jlTPItg32H7J
         Nd/TbIbnjVt6Fli8avZGrxwopAjLJobBOwhovnZ1gLgfUU8SzG1MEujiO2cOKDcS0Fwi
         wMEr5jmrHVK1GoT0hEZ2dtyL+9AK12VyyQqUIgiqDarMc+MoEhEg+PsEgQSO+OfrDmNa
         LgkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Jx7qglq93rWDanidzQRtYPLYgQThofsEoYOfwLqQhc0=;
        b=Gq1JfKw1vWZlZ56ETjqpwCCAxXYBf9qrbuQI/z8Rw6Taq4hLIqFZIzZDfCydduaIT4
         0JeWVB4eaER16Mvjk75FILOKs/0Zjv60P6aTfkkoKKK71geuXY6Ev+hEvg764meLYvui
         /i/xtCXC5ka79uBH1sBIGR8L/Gh6zZ+aDfl94VSw2T4xzJ+0pzLQV1CucJgQNBrGF3EA
         QtcQbevTWTlifQtoNSTiHdJYC07Sfoo8OHco1MVkSeVp6QvGDKkSmBAZgCbO7WofkY4V
         NgI8qRrFz0eEE5+PExZ+Y/bPr2HMvHombqz6P6OZAhkgOgXVo0c0ToCj6iARmsF1cvfq
         BSSg==
X-Gm-Message-State: AGi0PuZYst/TOV88IL9jRbYNK9B2pzWMCQf0RYEp0m7IE4VMkUpASsiS
        QLtM25HPVeD8OzsUV20++cG620XXoPBuoRL3vzlNCA==
X-Google-Smtp-Source: APiQypLH364lYxNqugtZIJWLLbIKFfVxH1Let0bIRxUi5KBU+tIytLWGafmeWA+xyDd9uh1HVWhThY+2FWEvWMxEX3Q=
X-Received: by 2002:a1c:2d02:: with SMTP id t2mr46616464wmt.98.1589438544740;
 Wed, 13 May 2020 23:42:24 -0700 (PDT)
MIME-Version: 1.0
References: <20200408162403.3616785-1-daniel.vetter@ffwll.ch>
In-Reply-To: <20200408162403.3616785-1-daniel.vetter@ffwll.ch>
From:   Daniel Stone <daniel@fooishbar.org>
Date:   Thu, 14 May 2020 07:40:47 +0100
Message-ID: <CAPj87rMJNwp0t4B0KxH7J_2__4eT7+ZJeG-=_juLSDhPc2hLHQ@mail.gmail.com>
Subject: Re: [PATCH] drm: avoid spurious EBUSY due to nonblocking atomic modesets
To:     Daniel Vetter <daniel.vetter@ffwll.ch>
Cc:     DRI Development <dri-devel@lists.freedesktop.org>,
        Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        Pekka Paalanen <pekka.paalanen@collabora.co.uk>,
        stable@vger.kernel.org, Daniel Stone <daniels@collabora.com>,
        =?UTF-8?B?VmlsbGUgU3lyasOkbMOk?= <ville.syrjala@linux.intel.com>,
        Daniel Vetter <daniel.vetter@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 8 Apr 2020 at 17:24, Daniel Vetter <daniel.vetter@ffwll.ch> wrote:
> Resending because last attempt failed CI and meanwhile the results are
> lost :-/

Did anything happen with this?

Cheers,
Daniel
