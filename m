Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B46E46B682
	for <lists+stable@lfdr.de>; Tue,  7 Dec 2021 09:59:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233230AbhLGJCz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Dec 2021 04:02:55 -0500
Received: from mail-ua1-f48.google.com ([209.85.222.48]:41805 "EHLO
        mail-ua1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231313AbhLGJCy (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Dec 2021 04:02:54 -0500
Received: by mail-ua1-f48.google.com with SMTP id p37so25077338uae.8;
        Tue, 07 Dec 2021 00:59:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lzwgy7wXN8Jjydn3ji6mL/biJ5JYjvPjWPkziik7m2Q=;
        b=rXAFC9Y6jwe9lHRa5PvYzJvh8gKcY2yCHBl9aahaZFexe5gbMe2KluDxDjzpcX3iN+
         BFplnsg2/CUVKH/WpVzCBpPvqqrwPjLSaid7s6ipEIPk8ipLjQULJbjTVOTn0gC6zsK2
         zmY7VjzUEaxFA/khRlct8ErcjwlX59EWTRJFG0PzvWwyNEtkvwULlMuGz5MFUlYNtiHK
         zIQ7Z/9cgBYLazIn00InHCgpIScqsN6mVEe7a4ICMVOtnN2ZjSEeTj7zcgpYRLaHYlcb
         Y3JctITP9akPtHYL4LsyJgPOQXHWDV80+lhX5wZJJYdWpHQzWp0mpEV9R3kfpw1xII8v
         fAzw==
X-Gm-Message-State: AOAM530alN5bTqmr4sEeb6/Cwc0el+eTKXWTazVbQmMVmDLy3/BEbNH+
        t0c0Tnc8QcKVlhOJKq/U0jZoACo1bZJ/zQ==
X-Google-Smtp-Source: ABdhPJyNknypxBEBvLXiYGLBYxxaP3WSWHm64oNCFMhCsvzDu4kufWeaExXh7tET8vS5nqASWwnXCw==
X-Received: by 2002:a67:c38f:: with SMTP id s15mr42323851vsj.50.1638867564152;
        Tue, 07 Dec 2021 00:59:24 -0800 (PST)
Received: from mail-vk1-f176.google.com (mail-vk1-f176.google.com. [209.85.221.176])
        by smtp.gmail.com with ESMTPSA id x21sm6021040ual.11.2021.12.07.00.59.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Dec 2021 00:59:23 -0800 (PST)
Received: by mail-vk1-f176.google.com with SMTP id q21so8786304vkn.2;
        Tue, 07 Dec 2021 00:59:23 -0800 (PST)
X-Received: by 2002:a05:6122:104f:: with SMTP id z15mr51606124vkn.39.1638867563566;
 Tue, 07 Dec 2021 00:59:23 -0800 (PST)
MIME-Version: 1.0
References: <8a27c986-4767-bd29-2073-6c4ffed49bba@jetfuse.net>
In-Reply-To: <8a27c986-4767-bd29-2073-6c4ffed49bba@jetfuse.net>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Tue, 7 Dec 2021 09:59:12 +0100
X-Gmail-Original-Message-ID: <CAMuHMdUep8xc3Ay5o6=KWsF8Hp7fUKdgPuW-_WOr1=KAxkou2Q@mail.gmail.com>
Message-ID: <CAMuHMdUep8xc3Ay5o6=KWsF8Hp7fUKdgPuW-_WOr1=KAxkou2Q@mail.gmail.com>
Subject: Re: [Bug Report] Desktop monitor sleep regression
To:     Brandon Nielsen <nielsenb@jetfuse.net>
Cc:     Peter Jones <pjones@redhat.com>,
        Linux Fbdev development list <linux-fbdev@vger.kernel.org>,
        Imre Deak <imre.deak@intel.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        stable <stable@vger.kernel.org>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Add CCs

On Tue, Dec 7, 2021 at 7:37 AM Brandon Nielsen <nielsenb@jetfuse.net> wrote:
> Monitors no longer sleep properly on my system (dual monitor connected
> via DP->DVI, amdgpu, x86_64). The monitors slept properly on 5.14, but
> stopped during the 5.15 series. I have also filed this bug on the kernel
> bugzilla[0] and downstream[1].
>
> I have performed a bisect, first "bad" commit to master is
> 55285e21f04517939480966164a33898c34b2af2[1], the same change made it
> into the 5.15 branch as e3b39825ed0813f787cb3ebdc5ecaa5131623647. I have
> verified the issue exists in latest master
> (a51e3ac43ddbad891c2b1a4f3aa52371d6939570).
>
>
> Steps to reproduce:
>
>    1. Boot system (Fedora Workstation 35 in this case)
>    2. Log in
>    3. Lock screen (after a few seconds, monitors will enter power save
> "sleep" state with backlight off)
>    4. Wait (usually no more than 30 seconds, sometimes up to a few minutes)
>    5. Observe monitor leaving "sleep" state (backlight comes back on),
> but nothing is displayed
>
>
> [0] - https://bugzilla.kernel.org/show_bug.cgi?id=215203
> [1] - https://bugzilla.redhat.com/show_bug.cgi?id=2028613
