Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 810191E62A1
	for <lists+stable@lfdr.de>; Thu, 28 May 2020 15:46:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390399AbgE1NqT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 May 2020 09:46:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390486AbgE1NqS (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 May 2020 09:46:18 -0400
Received: from mail-lf1-x142.google.com (mail-lf1-x142.google.com [IPv6:2a00:1450:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2079C08C5C6
        for <stable@vger.kernel.org>; Thu, 28 May 2020 06:46:17 -0700 (PDT)
Received: by mail-lf1-x142.google.com with SMTP id c21so16609919lfb.3
        for <stable@vger.kernel.org>; Thu, 28 May 2020 06:46:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=a5cB0NbuDsxv1LE6rwuUS39uCXX4xdBTOu6HLynTTas=;
        b=Qt98mT5/AOP+AfWfkc+cELybWsFxMDdr1feaA0rFBtYRz02IVmBtfKCI/Jsaf052BM
         uTFMcHNGUutwp3hKVYoMeSHb/opGOciVnTc8Go4TA5NwiG6tjZsvYj2Q6ygHct5Xyye0
         f+Rm8jGxm+1bVc3FthRmhuDmin+doIggWs98MJdgRV5ALC7UzGcEtigPZkZ6rggXRRdn
         vfI7KhrY1Qv8NhGZU4Nr78tz0h9YOnRfH/Wp+cjhYA6DtSoiLlTd/mmRChQoUYAfHuEB
         2tdHrKe083DAevC3Aeidzt4HZNSYQgsKyYHKLH3THg4PRK1WTV3+QPJbtRYigEAHQh/6
         Dr8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=a5cB0NbuDsxv1LE6rwuUS39uCXX4xdBTOu6HLynTTas=;
        b=KZr4CLMa3enXDSXM6X66kaZdsUYdZpEB+IGlkxLyc124JpkeWsqBSoX/9MjBEY+1qh
         Y+asgHKtwttE+xmWWWe1F5P4DLmh7Z7vN+f9xSbqzNqyfgHDqVxzsekRuxjnYr/lU0Vp
         QRTzRQq0mthKz72dtnf1tSQkqw7DAuV54yGtWJri1qMXAyqRjELkkshIfdisH70dUwgR
         LWQxA5ibLajTWveG7JRguntEz1QIDHO9sbHJNBfY7FLGXRUrwy6yTwAP3x5pbGz6H1Rz
         AsDvcfM+F9ENOxMY6ngb1TU1D32B84VAGLpuw5AB3qy6Hq+hLcZPT2Wf3wxUADD7OCK2
         Wodg==
X-Gm-Message-State: AOAM533M8BZ78j5/wp+BZYRjaYXCCWGxfboT/TV+NyyuUBFa76lgNcKN
        JntQwQtDZGxaYqIh3GF/3ByddpE6XHPhUxYiYUa0hw==
X-Google-Smtp-Source: ABdhPJyk9xAp+CpqjeydaKkAnmtPe+DWC21Luks26S6xTsBghpxHKp5CwMPajqaQuY3W5kwNQQ45FS4twhaG7Elxf10=
X-Received: by 2002:ac2:5473:: with SMTP id e19mr1730336lfn.21.1590673576010;
 Thu, 28 May 2020 06:46:16 -0700 (PDT)
MIME-Version: 1.0
References: <20200527140758.162280-1-linus.walleij@linaro.org> <20200527141807.GQ1551@shell.armlinux.org.uk>
In-Reply-To: <20200527141807.GQ1551@shell.armlinux.org.uk>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Thu, 28 May 2020 15:46:04 +0200
Message-ID: <CACRpkdbnLS2G6UH3L5u71RvP-heDqoOk+k9cW=9_4pJ_u3w0zg@mail.gmail.com>
Subject: Re: [PATCH] gpio: fix locking open drain IRQ lines
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 27, 2020 at 4:18 PM Russell King - ARM Linux admin
<linux@armlinux.org.uk> wrote:
> On Wed, May 27, 2020 at 04:07:58PM +0200, Linus Walleij wrote:

> > We provided the right semantics on open drain lines being
> > by definition output but incidentally the irq set up function
> > would only allow IRQs on lines that were "not output".
> >
> > Fix the semantics to allow output open drain lines to be used
> > for IRQs.
> >
> > Reported-by: Hans Verkuil <hverkuil@xs4all.nl>
> > Cc: Russell King <linux@armlinux.org.uk>
> > Cc: stable@vger.kernel.org
> > Fixes: 256efaea1fdc ("gpiolib: fix up emulated open drain outputs")
>
> As I've pointed out in the reporting thread, I don't think it can be
> justified as a regression - it's a bug in its own right that has been
> discovered by unifying the gpiolib semantics, since the cec-gpio code
> will fail on hardware that can provide real open-drain outputs
> irrespective of that commit.
>
> So, you're really fixing a deeper problem that was never discovered
> until gpiolib's semantics were fixed to be more uniform.

You're right, I was thinking of Fixes: as more of a mechanical
instruction to the stable kernel maintainers administrative machinery.

I will use the other way to signal to stable where to apply this.

Yours,
Linus Walleij
