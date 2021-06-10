Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 016E73A33F1
	for <lists+stable@lfdr.de>; Thu, 10 Jun 2021 21:24:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231164AbhFJT0Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Jun 2021 15:26:16 -0400
Received: from mail-yb1-f180.google.com ([209.85.219.180]:47065 "EHLO
        mail-yb1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230130AbhFJT0N (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Jun 2021 15:26:13 -0400
Received: by mail-yb1-f180.google.com with SMTP id h15so830842ybm.13
        for <stable@vger.kernel.org>; Thu, 10 Jun 2021 12:24:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gQphGNrsQVc6Q0YYwVGOzKhEd2TXPeimqt9/SG3ENbM=;
        b=HNu/tkELvJ4a+B1TPnYPtjuhEgzqchyygmwkUc+Ymu22PrIS+ipMTC8zKeNCPw+Tke
         HMQsW4UPGIft+MTxbgSZe1ibjbsMXoIwgIzufHSNmuOTbuqaBMYk3O3n41stEumqPGAm
         x4o2XP6D88vN0OtadvrvsyAavFEChIAIXw4UKL8InnSHLYQsqZs9lqkpktmZyl1U67xj
         6W+MNevFWRQKRBby0JMVXbG2gaR24C+ynr0dafEDsgpFvo3QfJku0Uvw4INyju85XMcV
         hkEwcFdzCrE3iZdM6+LCk/KiOwkQVJgBebynywFhpqU5Ji9IAViMk5huG2vHDz/t9Ygy
         U7ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gQphGNrsQVc6Q0YYwVGOzKhEd2TXPeimqt9/SG3ENbM=;
        b=N3IftmcCWcVEsdsw+CRmDp7ECWM8McemrumOXJgWBrkXYpHwhKaOFqwCqOWff4CKUC
         lSSjPox3NT0mue6sWdSo5X5kDzrmbzi6IuNRtOJMfijWec0TbYjHTLsFW+EFYEtSF3Oh
         EZE9M5zwLxRdEGwetMoZ4p9K7Vpu5bbAnoTg3UOsL7fY4CJRXylFZdie6ruestdl6ssJ
         flxtQuL/DRj/nzkLNlhMGJCy/UfhdAK1JEoj9u/yj3cDBipyYd3mNTAtuazbnJtzlXVu
         Rk83NKVgHY9eo/sv1VXUUuphsHvY4LcDAaRV9Vza4mUhlzV8jWt2ut+8krxn/pHJVLRq
         bSmA==
X-Gm-Message-State: AOAM530vN1GqkOvPlO1xI5RjmrxGIFHsy/0o+MR4glWpQG16/be02Sq7
        /ERgOfN556vsXBj+GKg4LESkjW81K0NsUj06o728bA==
X-Google-Smtp-Source: ABdhPJz5PsyiXF7cgGWZ3EBGO76+X9MNLhn4t5cRchMebYKoKVfX75PgrLQlhxIda1GWq/ONRadC1BDt/nGdYRaw3oA=
X-Received: by 2002:a25:3f47:: with SMTP id m68mr512340yba.228.1623352996603;
 Thu, 10 Jun 2021 12:23:16 -0700 (PDT)
MIME-Version: 1.0
References: <20210603170734.3168284-1-sashal@kernel.org> <20210603170734.3168284-3-sashal@kernel.org>
 <20210606111028.GA20948@wunner.de> <YMJR/FNCwDllHIDG@sashalap>
In-Reply-To: <YMJR/FNCwDllHIDG@sashalap>
From:   Saravana Kannan <saravanak@google.com>
Date:   Thu, 10 Jun 2021 12:22:40 -0700
Message-ID: <CAGETcx_w8pHs3OXQyVXYWV1CY4qGTWrZ9QNEwz=TL8SLbyq1bA@mail.gmail.com>
Subject: Re: [PATCH AUTOSEL 5.12 03/43] spi: Fix spi device unregister flow
To:     Sasha Levin <sashal@kernel.org>
Cc:     Lukas Wunner <lukas@wunner.de>,
        LKML <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>, Mark Brown <broonie@kernel.org>,
        linux-spi <linux-spi@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jun 10, 2021 at 10:55 AM Sasha Levin <sashal@kernel.org> wrote:
>
> On Sun, Jun 06, 2021 at 01:10:28PM +0200, Lukas Wunner wrote:
> >On Thu, Jun 03, 2021 at 01:06:53PM -0400, Sasha Levin wrote:
> >> From: Saravana Kannan <saravanak@google.com>
> >>
> >> [ Upstream commit c7299fea67696db5bd09d924d1f1080d894f92ef ]
> >
> >This commit shouldn't be backported to stable by itself, it requires
> >that the following fixups are applied on top of it:
> >
> >* Upstream commit 27e7db56cf3d ("spi: Don't have controller clean up spi
> >  device before driver unbind")
> >
> >* spi.git commit 2ec6f20b33eb ("spi: Cleanup on failure of initial setup")
> >  https://git.kernel.org/broonie/spi/c/2ec6f20b33eb
> >
> >Note that the latter is queued for v5.13, but hasn't landed there yet.
> >So you probably need to back out c7299fea6769 from the stable queue and
> >wait for 2ec6f20b33eb to land in upstream.
> >
> >Since you've applied c7299fea6769 to v5.12, v5.10, v5.4, v4.14 and v4.19
> >stable trees, the two fixups listed above need to be backported to all
> >of them.
>
> I took those two patches into 5.12-5.4, but as they needed a more
> complex backport for 4.14 and 4.19, I've dropped c7299fea67 from those
> trees.

Sounds good. Also, there was a subsequent "Fixes" for this patch and I
think another "Fixes" for the "Fixes". So, before picking this up,
maybe make sure those Fixes patches are pickable too?

-Saravana
