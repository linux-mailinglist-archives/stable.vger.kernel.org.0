Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20277660B7B
	for <lists+stable@lfdr.de>; Sat,  7 Jan 2023 02:27:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229985AbjAGB1t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Jan 2023 20:27:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229521AbjAGB1s (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 6 Jan 2023 20:27:48 -0500
Received: from mail-qt1-x829.google.com (mail-qt1-x829.google.com [IPv6:2607:f8b0:4864:20::829])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B03B6245
        for <stable@vger.kernel.org>; Fri,  6 Jan 2023 17:27:47 -0800 (PST)
Received: by mail-qt1-x829.google.com with SMTP id a16so3579991qtw.10
        for <stable@vger.kernel.org>; Fri, 06 Jan 2023 17:27:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=YZmW57ZvRkRR4S/DXyoGDrnsp4/+X8umxttq9HRE8mw=;
        b=ZT39AOGH4oWdTOUwUMNz1C/sCmOKV8oI3/I+ZIQIT65hOVRjnbTbx/NqCGL+AD/Mmy
         sQkvFtaeUPVtoEvyIZClUSmQaI+xyqEBUWRiMC+ooXyWWVt6mZDnEw2yBYnZYKjn0OY3
         FxETHbWF0lc/oVngvKSRSXim4a5bVSRjedJ+A=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YZmW57ZvRkRR4S/DXyoGDrnsp4/+X8umxttq9HRE8mw=;
        b=eP2OTZbKR5AoF7o2VbDwebOibYTFMqCBE/nL2gGs2fKx1PGG1f/CrINKb/lUeUobGY
         QM1JG008HDNE6Kuw10q1N6w5rJQ97Z1yxg4kUfbMwmyuSI2TztfRQ9UxBvlbRUIqShtY
         PG/fyUI7AqEhSW+UTE6XANTWwXhb9WuFQvmek2xCT/OyG8eHa1gI0y/9QzxPJOdYbCfM
         Rq7uMJtG3pIfae2noqyAdMdCdhYqaab9aeA+Kkvra99c5icfxLmtKjliEm6MFSNtwcix
         Re8oSUmhaJhVhKdcI7zHE4tpJghzHf0HI0GmgRYVapuqB12sKXc+UpucQ986rMl6BNsB
         sOSA==
X-Gm-Message-State: AFqh2kowGUjFi+AhBMtAcVWKDKMa7xteouaxIxdYXMbac5vXvMfvNC7y
        yxn+udtGgbqXVu5nwvf0f8bcCMsKpvTr7drJ
X-Google-Smtp-Source: AMrXdXvcU7NYT28ojZHPJ2POK/xyfypny34McQvikCxXWGzxr8X3xqiErw04fpujPlmlr/YN2MHchQ==
X-Received: by 2002:ac8:51c8:0:b0:3a8:1d3c:47e9 with SMTP id d8-20020ac851c8000000b003a81d3c47e9mr75550828qtn.48.1673054866635;
        Fri, 06 Jan 2023 17:27:46 -0800 (PST)
Received: from mail-yw1-f179.google.com (mail-yw1-f179.google.com. [209.85.128.179])
        by smtp.gmail.com with ESMTPSA id z2-20020ac86b82000000b003a5c6ad428asm1248566qts.92.2023.01.06.17.27.45
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Jan 2023 17:27:45 -0800 (PST)
Received: by mail-yw1-f179.google.com with SMTP id 00721157ae682-4b6255ce5baso43778837b3.11
        for <stable@vger.kernel.org>; Fri, 06 Jan 2023 17:27:45 -0800 (PST)
X-Received: by 2002:a0d:d912:0:b0:36a:d4df:c6b6 with SMTP id
 b18-20020a0dd912000000b0036ad4dfc6b6mr752702ywe.18.1673054864827; Fri, 06 Jan
 2023 17:27:44 -0800 (PST)
MIME-Version: 1.0
References: <20230106172310.v2.1.I3904f697863649eb1be540ecca147a66e42bfad7@changeid>
In-Reply-To: <20230106172310.v2.1.I3904f697863649eb1be540ecca147a66e42bfad7@changeid>
From:   Brian Norris <briannorris@chromium.org>
Date:   Fri, 6 Jan 2023 17:27:33 -0800
X-Gmail-Original-Message-ID: <CA+ASDXNBDkzz_xRDbE9gNZZN5kSfxksh0EN01_CxNgyog_BZOg@mail.gmail.com>
Message-ID: <CA+ASDXNBDkzz_xRDbE9gNZZN5kSfxksh0EN01_CxNgyog_BZOg@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] drm/atomic: Allow vblank-enabled + self-refresh "disable"
To:     =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>,
        Daniel Vetter <daniel@ffwll.ch>,
        Sean Paul <seanpaul@chromium.org>
Cc:     =?UTF-8?Q?Michel_D=C3=A4nzer?= <michel.daenzer@mailbox.org>,
        Sandy Huang <hjc@rock-chips.com>,
        linux-rockchip@lists.infradead.org,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jan 6, 2023 at 5:23 PM Brian Norris <briannorris@chromium.org> wrote:
> v2:
>  * add 'ret != 0' warning case for self-refresh
>  * describe failing test case and relation to drm/rockchip patch better

Ugh, there's always something you remember right after you hit send: I
forgot to better summarize some of the other discussion from v1, and
alternatives we didn't entertain. I'll write that up now (not sure
whether in patch 1 or 2) and plan on sending a v3 for next week, in
case there are any other comments I should address at the same time.

Sorry for the noise,
Brian
