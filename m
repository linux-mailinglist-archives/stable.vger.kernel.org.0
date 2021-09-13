Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0E7E4096CA
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 17:11:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345200AbhIMPM1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 11:12:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343506AbhIMPMQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Sep 2021 11:12:16 -0400
Received: from mail-il1-x134.google.com (mail-il1-x134.google.com [IPv6:2607:f8b0:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BB97C0363C6
        for <stable@vger.kernel.org>; Mon, 13 Sep 2021 06:57:36 -0700 (PDT)
Received: by mail-il1-x134.google.com with SMTP id x2so2047888ila.11
        for <stable@vger.kernel.org>; Mon, 13 Sep 2021 06:57:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=G5deGsT3nJX0X65tl3F4gUIvU782rSRTDWU6VWVQe4g=;
        b=fS1AnpCoxosa7oAvFzhyd4+cyolyU+vo1ou2L22cDtu6o2Nzh97cBLtDuup6JE0Yi3
         lkXFG06Z7C6m89vuieNBVrIaa66pOrMyN2hsObY8vo3QIjQYdi5OwbdnGeoBICdV1tQP
         25DQHJ4HUS+WXZV4AewwTAvgQT99DOdmWe5VI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=G5deGsT3nJX0X65tl3F4gUIvU782rSRTDWU6VWVQe4g=;
        b=b+4QHMA6cCWKokfYKLDkJXYJ1P3EgdrdGX8EUvs9WvCL7E/OHD1dqDscDTEeOjP4Y/
         kPSn2OQC0vgNxxLrF9Kb7Qz5K4Cz2sR1SKrdLe++mLGe82h3CR6GDLeJuesPIFY90kTC
         94EXd+k+qc0yLkrA3f4eikupEWJ9jwl/LLpIC7YNCs72ljnM19pxSYIcgkgTnnOd1Z0+
         0sWKSZ2HpEH3QStcD666fyAuOF0jCRQybI3MC0XdqAJCgMf3a1jZ6ukcsOWsFZvIJavF
         2gK3rLLd6zIyo7Btp5IQIrhcXXLkD3sbgc5x7C6Fj4AjisJe8SeGfvhFVgDVMEF5t1FR
         +QBg==
X-Gm-Message-State: AOAM531AKUyVEzrR37TBSmMGq26ztliWce+bquqekBbkHn0hmhkDb8uC
        nE4wK8wIMbar2FalLWmLf9gnIoUcZT7gXQ==
X-Google-Smtp-Source: ABdhPJzqZHul7Dw1/YgJOR3H/tTjumKM/2wkKeOIFktiA4vo8OXFtiGgNBKUhrfiviBcV1ET8ujatQ==
X-Received: by 2002:a05:6e02:6c9:: with SMTP id p9mr8532404ils.198.1631541455242;
        Mon, 13 Sep 2021 06:57:35 -0700 (PDT)
Received: from mail-io1-f52.google.com (mail-io1-f52.google.com. [209.85.166.52])
        by smtp.gmail.com with ESMTPSA id p11sm2668455ilh.38.2021.09.13.06.57.34
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Sep 2021 06:57:35 -0700 (PDT)
Received: by mail-io1-f52.google.com with SMTP id y18so12209402ioc.1
        for <stable@vger.kernel.org>; Mon, 13 Sep 2021 06:57:34 -0700 (PDT)
X-Received: by 2002:a02:3b15:: with SMTP id c21mr10044237jaa.54.1631541454478;
 Mon, 13 Sep 2021 06:57:34 -0700 (PDT)
MIME-Version: 1.0
References: <20210913131113.390368911@linuxfoundation.org> <20210913131118.330293390@linuxfoundation.org>
In-Reply-To: <20210913131118.330293390@linuxfoundation.org>
From:   Doug Anderson <dianders@chromium.org>
Date:   Mon, 13 Sep 2021 06:57:20 -0700
X-Gmail-Original-Message-ID: <CAD=FV=UhovUSmvbpc3q9=J_NSU0mcvQ3Fv8r4hi1ZNO=cMteuA@mail.gmail.com>
Message-ID: <CAD=FV=UhovUSmvbpc3q9=J_NSU0mcvQ3Fv8r4hi1ZNO=cMteuA@mail.gmail.com>
Subject: Re: [PATCH 5.14 147/334] drm/bridge: ti-sn65dsi86: Dont read EDID
 blob over DDC
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        "# 4.0+" <stable@vger.kernel.org>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On Mon, Sep 13, 2021 at 6:51 AM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> From: Douglas Anderson <dianders@chromium.org>
>
> [ Upstream commit a70e558c151043ce46a5e5999f4310e0b3551f57 ]
>
> This is really just a revert of commit 58074b08c04a ("drm/bridge:
> ti-sn65dsi86: Read EDID blob over DDC"), resolving conflicts.
>
> The old code failed to read the EDID properly in a very important
> case: before the bridge's pre_enable() was called. The way things need
> to work:
> 1. Read the EDID.
> 2. Based on the EDID, decide on video settings and pixel clock.
> 3. Enable the bridge w/ the desired settings.
>
> The way things were working:
> 1. Try to read the EDID but fail; fall back to hardcoded values.
> 2. Based on hardcoded values, decide on video settings and pixel clock.
> 3. Enable the bridge w/ the desired settings.
> 4. Try again to read the EDID, it works now!
> 5. Realize that the hardcoded settings weren't quite right.
> 6. Disable / reenable the bridge w/ the right settings.
>
> The reasons for the failures were twofold:
> a) Since we never ran the bridge chip's pre-enable then we never set
>    the bit to ignore HPD. This meant the bridge chip didn't even _try_
>    to go out on the bus and communicate with the panel.
> b) Even if we fixed things to ignore HPD, the EDID still wouldn't read
>    if the panel wasn't on.
>
> Instead of reverting the code, we could fix it to set the HPD bit and
> also power on the panel. However, it also works nicely to just let the
> panel code read the EDID. Now that we've split the driver up we can
> expose the DDC AUX channel bus to the panel node. The panel can take
> charge of reading the EDID.
>
> NOTE: in order for things to work, anyone that needs to read the EDID
> will need to instantiate their panel using the new DP AUX bus (AKA by
> listing their panel under the "aux-bus" node of the bridge chip in the
> device tree).
>
> In the future if we want to use the bridge chip to provide a full
> external DP port (which won't have a panel) then we will have to
> conditinally add EDID reading back in.
>
> Suggested-by: Andrzej Hajda <a.hajda@samsung.com>
> Signed-off-by: Douglas Anderson <dianders@chromium.org>
> Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>
> Link: https://patchwork.freedesktop.org/patch/msgid/20210611101711.v10.9.I9330684c25f65bb318eff57f0616500f83eac3cc@changeid
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  drivers/gpu/drm/bridge/ti-sn65dsi86.c | 22 ----------------------
>  1 file changed, 22 deletions(-)

I guess it's not a huge deal, but I did respond to Sasha and request
that this patch be dropped from the stable queue unless the whole big
pile of patches was being backported. See:

https://lore.kernel.org/lkml/CAD=FV=U2dGjeEzp+K1vnLTj8oPJ-GKBTTKz2XQ1OZ7QF_sTHuw@mail.gmail.com/

I said:

> I would suggest against backporting this one unless you're going to
> backport the whole pile of DP AUX bus patches, which probably doesn't
> make sense for stable. Even though the old EDID reading was broken for
> the first read, it still worked for later reads. ...and the first read
. didn't crash or anything--it just timed out.


-Doug
