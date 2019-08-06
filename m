Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 931EC833E1
	for <lists+stable@lfdr.de>; Tue,  6 Aug 2019 16:24:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731826AbfHFOYL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Aug 2019 10:24:11 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:38422 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730869AbfHFOYL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Aug 2019 10:24:11 -0400
Received: by mail-lf1-f68.google.com with SMTP id h28so61250797lfj.5
        for <stable@vger.kernel.org>; Tue, 06 Aug 2019 07:24:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/KGG719xZSycBl1aYVzQyMnG/L43I/ijsETlyDRRcYc=;
        b=yTIiTkxCvQFirZoL2g4NxWxSfeFOfSnpWZMRidamnND+iAdhGzIbYEkAnOu35NJ/+q
         vcIXYVXPFin5bg8EinvGE7meb+lgl/5Q7mGF7ZMO0ypdz2e0/cN+EPC2fjoC0LX1LZef
         jqXUUuAhKDPm5QHsb1JuM1g9TckmUyRG59RUS6H4ZjsD0/UcPnCj7XyAEMC2svFyA23V
         Xnr+aL0HgAVkW358ylJUu5ZpnZg65x9X5NCRz5IFbGOjzBXinPtcsfTJ8m76RzJfmCHe
         zx2BGACg2jcONC63ODETKPaF/2nXAme+M7DYaJFNCwvNxjCcR2GP+UHFdyorGwPUiYD+
         awHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/KGG719xZSycBl1aYVzQyMnG/L43I/ijsETlyDRRcYc=;
        b=AinE8ZFWwHG4xgRsXSdDYKzNqOqC/NMET4swQh/XVcgeJ8u0Fyi6jNJd65WiICQBnx
         wbZBsmWt1BwZNNv4U1rMqL17R8OO1sIhyF8XFIdJDsu2q2f7AJGVvTAAvXYfAyoqqWu1
         ejy+OGQSkv+uCsJ0eHEN239dJgKPhdZRTJ5/5KKr/TdDPVQzk/ihkkAaQLUdD7F2pjEv
         gVdEohwow5yXOXm5Fnb3d4rwvkqYaiXrFfTT0mCX18DHd9ixbGsSOH800/yGPGmxNno/
         USPYMjRShLyyD/HxlW4r0+3iNxmeW9SSRtT3zl2/fA0tVT8hQM1eUnw7I6fRuEyc/SoU
         5dZQ==
X-Gm-Message-State: APjAAAWdeZh8gb4Cprc2bkZv/c3ks8KuoCus7Dlsb1K+BnYiZFlrTmvZ
        XvPIkMe426QvBWYxCxGmcb0J1r50sMWpkKSTOClfRA==
X-Google-Smtp-Source: APXvYqxqUtbC+Q7kC70bhYhYPCnMDetkHk8OUMT/4x4VUQhSCJ8j/U+NOYQNmhER8KejXrU7Y0oN8CVqjEaLDvR+dSc=
X-Received: by 2002:ac2:5dd6:: with SMTP id x22mr2628851lfq.92.1565101449387;
 Tue, 06 Aug 2019 07:24:09 -0700 (PDT)
MIME-Version: 1.0
References: <20190806114151.17652-1-brgl@bgdev.pl>
In-Reply-To: <20190806114151.17652-1-brgl@bgdev.pl>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Tue, 6 Aug 2019 16:23:57 +0200
Message-ID: <CACRpkdZq-AURpgjoXpZ4_w-_8K9KenUh8Bk8JVM0-MsmMy9+dw@mail.gmail.com>
Subject: Re: [PATCH] gpiolib: never report open-drain/source lines as 'input'
 to user-space
To:     Bartosz Golaszewski <brgl@bgdev.pl>
Cc:     "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 6, 2019 at 1:41 PM Bartosz Golaszewski <brgl@bgdev.pl> wrote:

> From: Bartosz Golaszewski <bgolaszewski@baylibre.com>
>
> If the driver doesn't support open-drain/source config options, we
> emulate this behavior when setting the direction by calling
> gpiod_direction_input() if the default value is 0 (open-source) or
> 1 (open-drain), thus not actively driving the line in those cases.
>
> This however clears the FLAG_IS_OUT bit for the GPIO line descriptor
> and makes the LINEINFO ioctl() incorrectly report this line's mode as
> 'input' to user-space.
>
> This commit modifies the ioctl() to always set the GPIOLINE_FLAG_IS_OUT
> bit in the lineinfo structure's flags field. Since it's impossible to
> use the input mode and open-drain/source options at the same time, we
> can be sure the reported information will be correct.
>
> Fixes: 521a2ad6f862 ("gpio: add userspace ABI for GPIO line information")
> Cc: stable <stable@vger.kernel.org>
> Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>

Patch applied for fixes!
Good catch.

Yours,
Linus Walleij
