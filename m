Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5021C32B0E0
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 04:45:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237273AbhCCAkI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Mar 2021 19:40:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239789AbhCBPpr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Mar 2021 10:45:47 -0500
Received: from mail-lj1-x22a.google.com (mail-lj1-x22a.google.com [IPv6:2a00:1450:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0EDFC06121D
        for <stable@vger.kernel.org>; Tue,  2 Mar 2021 07:41:34 -0800 (PST)
Received: by mail-lj1-x22a.google.com with SMTP id r25so23500323ljk.11
        for <stable@vger.kernel.org>; Tue, 02 Mar 2021 07:41:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ybajfdG4+XkNN0Eukc7RPPGwhIH7By1tE7lla85kmJc=;
        b=x3uMqpuYYn8yTaEpHXoMeoMWgE0stXI0Wn3MLfP4xfjSObNN6BJL810H+i46bQxYTK
         oPOmAZqvh5L3ZRln/qeZLEMbvggkWh82bdWuKkzV1RKDngtKx+Tv2IxA3KKGdJh2COe0
         VXS6tZ6UEKVopM38XktErr33T0ntwCB2igeONXinb30ZgD92lCOu5OqCcFCruqNjymvA
         02ah+8RS+d3AKwNWm29lwvx4lncQ0r5T24GRW1kNuxnAnWuKzfiraGt1GRR/kxu8h8EF
         p2fJFfgAEWzCxdd9EtcU0MVgdAe2t5Y94uOZKyT+zrM8LCTgAr4kFpDmEVhiwtDF8rF7
         QJeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ybajfdG4+XkNN0Eukc7RPPGwhIH7By1tE7lla85kmJc=;
        b=gnawozFMTD5LabJd/fQp7NEFOWiwMh1T2Zk6oNoP0HCYuxX+7kQp2lgPgLYXu8GuZu
         b3t8QAp3h93hMUuUmiYL8UEmrm71WL0XMc1rh2jyOP8jF/C7poyRXte8dBD9qOj9sWOy
         Wy7WrzldRGyo3Gk4oTWWOYxCFvJqU6h3PM9+EBJ2xIoqlP1PtI53XjjaXGuhT2zWAvhD
         tKAMv2Sf/af8P2w2rmDM233E7pwvy51X0BzJG3pPk9ByxZd5Nl5N2JqrzBXULBpzSV9x
         D73WS1D6ok4hBcw4PcgHVU5BzMk+/io6f06Ygt4U2j+phIPHskcngdeSC8gPl42Iv4Bf
         8Xxw==
X-Gm-Message-State: AOAM532UbqHiw8mlC2PsMX5uN5N2WZGl46kc554Rtxyw7CiWEpptXHFI
        jnCUCNHFQZQxNxTpoRrJKOG/KNAYIBUrN064tsNd1g==
X-Google-Smtp-Source: ABdhPJyGRcal8oh4wEsKDXo3e1ko8oALR8+bEfijE+4OEhIOkd8cDG7rUgwD/FbX4GT+mVXJ1yOxbFeEp+72WpADCUA=
X-Received: by 2002:a2e:9754:: with SMTP id f20mr10146762ljj.200.1614699693457;
 Tue, 02 Mar 2021 07:41:33 -0800 (PST)
MIME-Version: 1.0
References: <20210301090519.26192-1-johan@kernel.org> <20210301090519.26192-3-johan@kernel.org>
In-Reply-To: <20210301090519.26192-3-johan@kernel.org>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Tue, 2 Mar 2021 16:41:21 +0100
Message-ID: <CACRpkda7HQf55r7=f2TVvetaV7KavD_Q43CT4P6z97MWM7VjLw@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] gpio: fix gpio-device list corruption
To:     Johan Hovold <johan@kernel.org>
Cc:     Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Saravana Kannan <saravanak@google.com>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 1, 2021 at 10:05 AM Johan Hovold <johan@kernel.org> wrote:

> Make sure to hold the gpio_lock when removing the gpio device from the
> gpio_devices list (when dropping the last reference) to avoid corrupting
> the list when there are concurrent accesses.
>
> Fixes: ff2b13592299 ("gpio: make the gpiochip a real device")
> Cc: stable@vger.kernel.org      # 4.6
> Reviewed-by: Saravana Kannan <saravanak@google.com>
> Signed-off-by: Johan Hovold <johan@kernel.org>

Excellent fix as well,
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
