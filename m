Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 65904D0909
	for <lists+stable@lfdr.de>; Wed,  9 Oct 2019 10:03:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728429AbfJIIDF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Oct 2019 04:03:05 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:40711 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725440AbfJIIC5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Oct 2019 04:02:57 -0400
Received: by mail-lj1-f196.google.com with SMTP id 7so1483759ljw.7
        for <stable@vger.kernel.org>; Wed, 09 Oct 2019 01:02:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qIcuMqyribGNxdL5/KfaR/0W6xo7KhmFZDC62GSR9uw=;
        b=rwJgS7yXEf0+np6sEo73SubMwqxNdp4RcAX+jWJULZ3fSRrC1cOhANBPgDq/MHmTqc
         JFh13IiBSmC44y2+YQGvoQo1N9WvINr38BqrID75SDFU4ztKk4Cr6igNdJS4kJzI5+49
         pxW7/hEyoeoZF8AShMROjgLKBRoOpICQPs9jrfNOYkESk1LtzP17RhO8jHt8ZVd4xEuo
         CN60C2uE3+ThAkaX6W99cbN5hve3MQsxbrAf+8O43IfZNSz/tvXBanSJOxIGHnirbV4q
         8xSs0S8jpBpllANxVKbndvxTaBYdkIW0/xyno71RKh1Fo+8y10HchWjvn3s477Q/XYAE
         lXCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qIcuMqyribGNxdL5/KfaR/0W6xo7KhmFZDC62GSR9uw=;
        b=Tehw2QtRSORC2AXCqbVF75/Tk1YKDk+DeMHMsMpaPp6NpbYYELsdgECK5A5UTYWGos
         1up/3sQKCYdANWHuA87rISYZun9bqV04i8oZlTFMoAA7Vv7D302jUYvFyTFB6ZDTMRs3
         mZ9SOdQJ+hk2CteetSc+RLManjjGVI3ormMAAE8bGx4eYPAH2sOU1Ccj3xXlOFLNPgu4
         nExjpiYHrohTg3tNdsuqMwI61yae6nkTm0USN1Mqu/L1hlSfUNHNi8Bdaa2lxKMV+WgJ
         gEji8p09XxrTuHcA9JZ/vc9j6ViS/DjvUIl3mzkyQQUVRJLD2945/0D/Ze0+Ge77mtA2
         hvLw==
X-Gm-Message-State: APjAAAW5MREc6CZsDlrGeuzU5YEaXhVshcQyPl9YkXJ6Ia+qvcrieFJG
        KAEDzHiNk8+NakinYOxRdbtwQRIPG2tBn1OsVLHUwA==
X-Google-Smtp-Source: APXvYqzkxO27nVgr+ezF6wWyRFhgeKlah+nA5MKVsuIlBHud+OOcCa69nMnvbinUrxjWWXwcTj43OmtOXQIUqoB6N90=
X-Received: by 2002:a2e:a415:: with SMTP id p21mr1418505ljn.59.1570608175035;
 Wed, 09 Oct 2019 01:02:55 -0700 (PDT)
MIME-Version: 1.0
References: <20191001155154.99710-1-alpawi@amazon.com>
In-Reply-To: <20191001155154.99710-1-alpawi@amazon.com>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Wed, 9 Oct 2019 10:02:43 +0200
Message-ID: <CACRpkdah=ofrdEeYUbp6ea+2S+EuN_XhUCXpCbDgm7p5R-Z6_g@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: armada-37xx: swap polarity on LED group
To:     Patrick Williams <alpawi@amazon.com>
Cc:     Patrick Williams <patrick@stwcx.xyz>,
        stable <stable@vger.kernel.org>,
        Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@bootlin.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Oct 1, 2019 at 5:52 PM Patrick Williams <alpawi@amazon.com> wrote:

> The configuration registers for the LED group have inverted
> polarity, which puts the GPIO into open-drain state when used in
> GPIO mode.  Switch to '0' for GPIO and '1' for LED modes.
>
> Fixes: 87466ccd9401 ("pinctrl: armada-37xx: Add pin controller support for Armada 37xx")
> Signed-off-by: Patrick Williams <alpawi@amazon.com>
> Cc: <stable@vger.kernel.org>

Patch applied for fixes.

Linus Walleij
