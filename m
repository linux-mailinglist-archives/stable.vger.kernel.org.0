Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD47F2952C5
	for <lists+stable@lfdr.de>; Wed, 21 Oct 2020 21:11:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409014AbgJUTLW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Oct 2020 15:11:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2409009AbgJUTLW (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Oct 2020 15:11:22 -0400
Received: from mail-lf1-x141.google.com (mail-lf1-x141.google.com [IPv6:2a00:1450:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF818C0613CE;
        Wed, 21 Oct 2020 12:11:21 -0700 (PDT)
Received: by mail-lf1-x141.google.com with SMTP id a7so4469944lfk.9;
        Wed, 21 Oct 2020 12:11:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RCshK3M4udSA0kpWWZPjCFazMoUFiZb71kFWv+5y9v8=;
        b=ubX1axnYMdBQbOxOqFsPd4Ij95x5LYE09iUx3I/KyZjjJLGGgndmXabyt/7rvqdmiQ
         dJb1V8skO+QLh7IAOWyI2XajqSsn36nBE1lxWGzcWM5zVx//cg+imwggm4baYKqUXjjn
         pjlVltvfc2ud2jvFeo7VzdzA4d531saIqV9fbKz/h4D/UqWr3BhdDrHAy2ICC77SnWvd
         5Y5A4Ped/zrRY1KQN+0iE7hJ1nlFxxhlglTDtbTHiEB3z0/o4NyFNMDME88reOuu+nz/
         TZN4BX+EPQ4QxN/GyFokS1ClQNsqjdGPnUrvYSlxvrSCtVCoS2NuunkT5YqQYP2wqgEt
         C/kQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RCshK3M4udSA0kpWWZPjCFazMoUFiZb71kFWv+5y9v8=;
        b=KCWsKXIKZuDGdI4JYOl160FL+LoDqfElcR3Qzf4JuK2c4jhaKWJMUfWxyzMzRAFfgU
         gxq+Je9o5Bua6gzQMAsVwMM7F7muzSnxMpvnJVLacNwMW6LpWvnHnKkt+pimjqeR7hAx
         q3f/3mey7z4rvUoQEg4SBFT6IuXCILF+AupT+jzP29X1q4w7dhvyjL0/hMv8zgoTX9qB
         QHmZLjMjnz8Rkk5ZH4YbhA3Uu1kw4QClgQKrECMtWLxKZhjB7d23Sv9U2hhKiPqJ2ZR4
         xsYZf31GO4Cy5K/ULuZAN2ZTNTuIDNqGvuI3ZDXKM/hPrRSRNbjCIM/k87JFAaCZc3Ac
         xa5w==
X-Gm-Message-State: AOAM53218dqiUON3rDauWH6VkihfuYfzGxAF0pwFWDAykmCTYwHFuXSC
        qQ0+NS6ZlkN8uwSPZEQSkl1KIoLL6tYXDCIgLoI=
X-Google-Smtp-Source: ABdhPJwJeuIx13ndXi6SItY4Tf2f4ob7L0nOMpL8/Dkwxx7ppk/31oDfLYa21E4D7Rtdez4WzQ3rBSgufTnUo1Me7kU=
X-Received: by 2002:ac2:44a4:: with SMTP id c4mr1833700lfm.365.1603307480086;
 Wed, 21 Oct 2020 12:11:20 -0700 (PDT)
MIME-Version: 1.0
References: <20201019130532.19959-1-jandryuk@gmail.com>
In-Reply-To: <20201019130532.19959-1-jandryuk@gmail.com>
From:   Jason Andryuk <jandryuk@gmail.com>
Date:   Wed, 21 Oct 2020 15:11:07 -0400
Message-ID: <CAKf6xptMj9VdS8oo_pQcJT1zRPZ2fXJR7_ifiSXo=TqtBgnc2Q@mail.gmail.com>
Subject: Re: [PATCH] hid-mt: Fix Cirque 121f touch release
To:     Jiri Kosina <jikos@kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Henrik Rydberg <rydberg@bitmath.org>
Cc:     stable@vger.kernel.org, linux-input@vger.kernel.org,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 19, 2020 at 9:05 AM Jason Andryuk <jandryuk@gmail.com> wrote:
>
> We're seeing the touchpad not send all the touch release events.  This
> can result in the cursor getting stuck generating scroll events instead
> of cursor movement for single finger motion.  With the cursor not
> moving, users think the trackpad is broken.  With libinput-record, you
> can see that it doesn't always get to a neutral state when there are no
> fingers on the touchpad.
>
> MT_QUIRK_STICKY_FINGERS was insufficient alone.  The timer often didn't
> fire to release all the contacts.  MT_QUIRK_NOT_SEEN_MEANS_UP seems to
> help with tracking the touches, and allows the timer to fire properly
> when needed.
>
> You can reproduce by touching the trackpad with 4 fingers spread out,
> then pulling them all together and removing from the track pad.

<snip>

> ---
> This is developed and tested against 5.4 and forward ported to latest
> upstream.

I installed Fedora 32 with kernel 5.6.6 to test out some other stuff,
and it is not reproducing with the steps above.  Is there some other
change that may have fixed the release tracking?  I was definitely
seeing it with 5.4.72.

Regards,
Jason
