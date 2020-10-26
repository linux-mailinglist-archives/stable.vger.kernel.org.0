Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CB54298D8C
	for <lists+stable@lfdr.de>; Mon, 26 Oct 2020 14:13:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403805AbgJZNMy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Oct 2020 09:12:54 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:36010 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1734631AbgJZNLR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Oct 2020 09:11:17 -0400
Received: by mail-lj1-f195.google.com with SMTP id 134so8943790ljj.3;
        Mon, 26 Oct 2020 06:11:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Qixz5MZ8UvuVGnSzUYcMGABBBz62xcYc9zeA7e0GfQM=;
        b=Q48pgQhGX3TOn712PqBnY6XdJHZZ/ZMpAzvDI1Ra1pqW/cLDtSoR0s3SA8aHo2Kprt
         xKm0b2LRfh2iWjIqxc9L5Yn14xwKEENZc1CUu/J30DxvwCpwMgM4JyDp+7cniDONvf7F
         xLNcVohutpCbf4QHpzYV7BUSEkuI2pJKve/jDe41pbj2KNE6kBo8oDr3Xz/BGVdkrDul
         RYXE1AQ8ouONlvJ0aLF+bMlT+NMuj2OgzGvqmM8q36htpCv/26+LPdlnyz67HP+fCkRL
         dWxB0BmM9tCbo7hgOaRxfSKJifZsmLL8hfcHe9XPXlwydlJmxoqQJ5NfI5dE0kaTxA8N
         7B8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Qixz5MZ8UvuVGnSzUYcMGABBBz62xcYc9zeA7e0GfQM=;
        b=QvgPmPC3GJTDrYyRd243QivfhuY3hzq5NcAarA7rWJoydTnAEs0oP7nlHLRyYCOS0E
         LCAtDEHNvfKN51jTBvZIZuL2Kk89L1C3XYiJypsydxWjow74bneok1yiyogRIX/yK1rs
         cx05Lk/DmHOvUrtAd9vzLpBRYrmUO8SyPBNe432DBktpu8OFrec7LZ6iuh9GLRUVwkSs
         UgwKfRMdCQrr6lCqaE674XxBSnViK1dLzxf2Wyo5iCuznGaIvSTqnfu7bZknnVwyOVPd
         NlmH2RVXDHkeB/p7xRf3xPThp7/63FEW7nt0kkw2ovD5t+ZuARWNEkffIM02utCzpG5s
         AwOw==
X-Gm-Message-State: AOAM533UDtD4k9Yonu3Hb98tiFj4w9JJUPnJ2CuI954Day8gpfyk3Rh5
        LaZAYGthvFGX7nu7ATlyqJpHJl/Pk1nEPHQ/7tA=
X-Google-Smtp-Source: ABdhPJzfOSzdFejjwUyHTTfaeT9ZzI27JdQ31zEaJgwQbyhHs25/WWDf+pSyObqgiBccV5qmK7SR/EkYYQe2Z9kPar0=
X-Received: by 2002:a2e:7007:: with SMTP id l7mr6177004ljc.185.1603717874674;
 Mon, 26 Oct 2020 06:11:14 -0700 (PDT)
MIME-Version: 1.0
References: <20201023124804.11457-1-jandryuk@gmail.com>
In-Reply-To: <20201023124804.11457-1-jandryuk@gmail.com>
From:   Jason Andryuk <jandryuk@gmail.com>
Date:   Mon, 26 Oct 2020 09:11:03 -0400
Message-ID: <CAKf6xpt_S9WJ5dnhQoUH75QSPWXJA5-wiMym+e4EgR_BstgbHA@mail.gmail.com>
Subject: Re: [PATCH] i915: Add QUIRK_EDP_CHANNEL_EQ for Dell 7200 2-in-1
To:     Jani Nikula <jani.nikula@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>
Cc:     stable@vger.kernel.org, David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Oct 23, 2020 at 8:48 AM Jason Andryuk <jandryuk@gmail.com> wrote:
>
> We're seeing channel equalization "fail" consistently coming out of DPMS
> on the eDP of a Dell Latitude 7200 2-in-1.  When the display tries to
> come out of DPMS, it briefly flashes on before going dark.  This repeats
> once per second, and the system is unusable.  ssh-ing into the system,
> it also seems to be sluggish when in this state.  You have to reboot to
> get the display back.
>
> In intel_dp_link_training_channel_equalization, lane 0 can get to state
> 0x7 by the 3rd pattern, but lane 1 never gets further than 0x1.
> [drm] ln0_1:0x0 ln2_3:0x0 align:0x0 sink:0x0 adj_req0_1:0x0 adj_req2_3:0x0
> [drm] ln0_1:0x11 ln2_3:0x0 align:0x80 sink:0x0 adj_req0_1:0x44 adj_req2_3:0x0
> [drm] ln0_1:0x11 ln2_3:0x0 align:0x80 sink:0x0 adj_req0_1:0x88 adj_req2_3:0x0
> [drm] ln0_1:0x71 ln2_3:0x0 align:0x80 sink:0x0 adj_req0_1:0x84 adj_req2_3:0x0
> [drm] ln0_1:0x71 ln2_3:0x0 align:0x0 sink:0x0 adj_req0_1:0x84 adj_req2_3:0x0
> [drm] ln0_1:0x71 ln2_3:0x0 align:0x0 sink:0x0 adj_req0_1:0x84 adj_req2_3:0x0
>
> Narrow fast vs. wide slow is not an option because the max clock is
> 270000 and the 1920x1280 resolution requires 2x270000.
> [drm] DP link computation with lane count min/max 1/2 270000/270000 bpp
> min/max 18/24 pixel clock 164250KHz
>
> The display is functional even though lane 1 is in state 0x1, so just
> return success for channel equalization on eDP.
>
> Introduce QUIRK_EDP_CHANNEL_EQ and match the DMI for a Dell Latitude
> 7200 2-in-1.  This quirk allows channel equalization to succeed even
> though it failed.
>
> Workaround for https://gitlab.freedesktop.org/drm/intel/-/issues/1378

CI reported the patch doesn't apply to drm-tip.  It was developed
against 5.4 and forward ported to 5.10-rc1-ish when I submitted it.
It applied there but not to drm-tip.

5.4 & 5.6.6 is fine until DPMS.  Then when it tries to come out, it
fails link training and gives the flashing.
5.8.16 starts flashing during boot.  I guess the driver now runs link
training during boot?

drm-tip doesn't have the flashing issue.  I guess "drm/i915: Switch to
LTTPR non-transparent mode link training"  or some of the other link
training change lets the hardware succeed?

Oh, this is interesting:
kernel: i915 0000:00:02.0: [drm:hsw_set_signal_levels [i915]] Using
signal levels 02000000
kernel: [drm:intel_dp_link_train_phy [i915]] ln0_1:0x71 ln2_3:0x0
align:0x0 sink:0x0 adj_req0_1:0x84 adj_req2_3:0x0
kernel: i915 0000:00:02.0: [drm:intel_dp_link_train_phy [i915]]
Channel equalization failed 5 times
kernel: i915 0000:00:02.0: [drm:intel_dp_link_train_phy [i915]]
[CONNECTOR:95:eDP-1] Link Training failed at link rate = 270000, lane
count = 2, at DPRX
kernel: i915 0000:00:02.0: [drm:intel_enable_pipe [i915]] enabling pipe A

Note DPRX above, so not using LTTPR.

Looks like the link training logic is wrong. :

intel_dp_link_training_channel_equalization fails, so
intel_dp_link_train_phy fails, but:

intel_dp_link_train_all_phys(struct intel_dp *intel_dp,
                             const struct intel_crtc_state *crtc_state,
                             int lttpr_count)
{
        bool ret = true;
        int i;

        intel_dp_prepare_link_train(intel_dp, crtc_state);

        for (i = lttpr_count - 1; i >= 0; i--) {
                enum drm_dp_phy dp_phy = DP_PHY_LTTPR(i);

                ret = intel_dp_link_train_phy(intel_dp, crtc_state, dp_phy);
                intel_dp_disable_dpcd_training_pattern(intel_dp, dp_phy);

                if (!ret)
                        break;
        }

        if (ret)
                intel_dp_link_train_phy(intel_dp, crtc_state, DP_PHY_DPRX);

Here we don't update ret, so linking training "succeeds" for DPRX.

This does let the 7200 display "work", but it's probably not what you
want in general.

Regards,
Jason
