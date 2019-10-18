Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6BA5DBC1F
	for <lists+stable@lfdr.de>; Fri, 18 Oct 2019 06:55:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409485AbfJREzz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Oct 2019 00:55:55 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:33282 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392808AbfJREzz (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Oct 2019 00:55:55 -0400
Received: by mail-io1-f68.google.com with SMTP id z19so5947178ior.0;
        Thu, 17 Oct 2019 21:55:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3ehKOW/N+FTLF+YoAGhVTdIuexN5qbQUY1mLWAZQXhU=;
        b=Rn0xH2r9CfVldbfAXR7dSTkpYMinTskC7GYU6kajDgPXiOplHYv2cNAhOEVnSzJXDA
         F3tzNodRaDbkqwWcXSYR2sBad8nlbqIlHcGBnB+uCNHls3MTX3mA0oU/RXvbUx1L8Xmk
         kSQ0C21flTDCxiO8tBAPxNTZA5f+DMilVkHmkvdvZREOnlxyec446GobkM2/Xtoc0gTK
         L4dK+WyJLJ8f8o1TvjoqJI/DS3CtErgMAPfo8SFJtWOzlCHUhnHjK+ZBut9abgqMVCaC
         HJalSa+BV8SiaTeRYOLhIms9VBsLmkRN1h+4aGwm5Xw85RU6GjRi+L+aC3CWcPmWlTJC
         viAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3ehKOW/N+FTLF+YoAGhVTdIuexN5qbQUY1mLWAZQXhU=;
        b=l43R3y3d8YA++QGShbVbLt5YJ3NLpltk0UDWF7MbiKuMlN/4MkwSB0F4tnyKKNICMM
         YF1ollKBKNtvbIUMJ5SEJUFUbj6pHLPYJ6Wi86bLBR7/e+M3TKx/D0GIOLboILfCsB3S
         h9v+skFZ7GHw/pil7BEsIqtfSfKtJGY82aGWbAwKM78vgCvewIE5l4lb6f9xq8D2u8V1
         zBi4TEIXotRtrAEkeYiQeSvU6Da6qBO6SsoI08Eb16zAlqGiU9i1VdbfNahf4oNJaPlm
         Yp/d7GavStWllhZmQ+KBE6RfKXgbjBi/a5rLsGQz1FuRMJCXBBjxc5IRepxcR4lrvKlF
         cmHg==
X-Gm-Message-State: APjAAAXVKNk0BTtr+ncuDIdtdwrTS2gmV7oFiyUEQJU4+UCzTNwyHDG/
        JWqPAi5n4Fgxp59lqvYUA0BP60jm/AcCUKGHvCQ9Iagx
X-Google-Smtp-Source: APXvYqxgS5ct0v8h7EZnQaxNd7n2Gy9Yn06F3wrKDNTFF1bjL6NRVgvhUFG8RaKqVn3zR8oyEpdCL+wHTr4gIP47/3Y=
X-Received: by 2002:a5e:db46:: with SMTP id r6mr4668633iop.287.1571372761181;
 Thu, 17 Oct 2019 21:26:01 -0700 (PDT)
MIME-Version: 1.0
References: <20191016182935.5616-4-andrew.smirnov@gmail.com> <20191017143149.449AA21D7C@mail.kernel.org>
In-Reply-To: <20191017143149.449AA21D7C@mail.kernel.org>
From:   Andrey Smirnov <andrew.smirnov@gmail.com>
Date:   Thu, 17 Oct 2019 21:25:49 -0700
Message-ID: <CAHQ1cqHF+3S1xYCVs19U7Hr+SjMp+z3QhW-KsKDSa00VMGN8FA@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] HID: logitech-hidpp: do all FF cleanup in hidpp_ff_destroy()
To:     Sasha Levin <sashal@kernel.org>
Cc:     "open list:HID CORE LAYER" <linux-input@vger.kernel.org>,
        Jiri Kosina <jikos@kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Henrik Rydberg <rydberg@bitmath.org>,
        "Pierre-Loup A. Griffais" <pgriffais@valvesoftware.com>,
        Austin Palmer <austinp@valvesoftware.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 17, 2019 at 7:31 AM Sasha Levin <sashal@kernel.org> wrote:
>
> Hi,
>
> [This is an automated email]
>
> This commit has been processed because it contains a "Fixes:" tag,
> fixing commit: ff21a635dd1a9 HID: logitech-hidpp: Force feedback support for the Logitech G920.
>
> The bot has tested the following trees: v5.3.6, v4.19.79, v4.14.149, v4.9.196.
>
> v5.3.6: Build OK!
> v4.19.79: Failed to apply! Possible dependencies:
>     91cf9a98ae412 ("HID: logitech-hidpp: make .probe usbhid capable")
>
> v4.14.149: Failed to apply! Possible dependencies:
>     91cf9a98ae412 ("HID: logitech-hidpp: make .probe usbhid capable")
>
> v4.9.196: Failed to apply! Possible dependencies:
>     6bd4e65d521f9 ("HID: logitech-hidpp: remove HIDPP_QUIRK_CONNECT_EVENTS")
>     91cf9a98ae412 ("HID: logitech-hidpp: make .probe usbhid capable")
>     a4bf6153b3177 ("HID: logitech-hidpp: add a sysfs file to tell we support power_supply")
>
>
> NOTE: The patch will not be queued to stable trees until it is upstream.
>
> How should we proceed with this patch?

Looks like I'd have to mark this one as 5.2+ as well. Please disregard
this series in favor of v3 that will be sent out shortly.

Thanks,
Andrey Smirnov
