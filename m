Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 14F4A1306FF
	for <lists+stable@lfdr.de>; Sun,  5 Jan 2020 11:10:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726212AbgAEKKP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 Jan 2020 05:10:15 -0500
Received: from mail-ed1-f67.google.com ([209.85.208.67]:40889 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725535AbgAEKKO (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 5 Jan 2020 05:10:14 -0500
Received: by mail-ed1-f67.google.com with SMTP id b8so45121549edx.7;
        Sun, 05 Jan 2020 02:10:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DeNSIszea/zGeHHq8aQmeJJay/5gyv6kH5Cpx+kjq5I=;
        b=bP2BgDfsMuTpssKn4OCtQd3SINfX33IfokrImL1f+o9XTyECkDvUIu21BeaKeaci3s
         b2Obv1kVC/oKPaYCYXMKYY2vMT/DTHPq4/ARnxb8Ua/AxiZMlgJvpGxRzH/jaf9KeqmB
         cxr0+UqYQ5XCMtklAzripF5f7hL0ollO5yODblNv5gKFPJP33cEPk6vkoNIoBS3Gm+19
         L9swEnaCtd9/S2FafzsMwlafeb1dufQCcqXHJTM38w87vnKkxYKEs9hefbK+/5b3iRFb
         fvQEdq/QrmE+gQ2RWjQSEMwXnmLfbXeszygLAuGBmEypTjFF0bvqFjFYrMx7aHl4uEWw
         n8lw==
X-Gm-Message-State: APjAAAU7FheQS9bqtK5MgI21OMGTooog2sJ2VwKXc8ueepoAfCEoLLo5
        mGZBcamo/rYbvdQkzHxXqcvyD7Sid3A=
X-Google-Smtp-Source: APXvYqyL+pb9qbPx6Q30p3Qy/S76JNchpSRQ5ZB72SW8TuRixqyN1Cvm/7YAvEBjkDU2BmDnoSyojw==
X-Received: by 2002:a17:906:4556:: with SMTP id s22mr100442545ejq.165.1578219011938;
        Sun, 05 Jan 2020 02:10:11 -0800 (PST)
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com. [209.85.128.43])
        by smtp.gmail.com with ESMTPSA id t19sm7904472eju.10.2020.01.05.02.10.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 05 Jan 2020 02:10:11 -0800 (PST)
Received: by mail-wm1-f43.google.com with SMTP id p17so12376476wmb.0;
        Sun, 05 Jan 2020 02:10:11 -0800 (PST)
X-Received: by 2002:a05:600c:2409:: with SMTP id 9mr27042337wmp.109.1578219011126;
 Sun, 05 Jan 2020 02:10:11 -0800 (PST)
MIME-Version: 1.0
References: <20200105012416.23296-1-samuel@sholland.org> <20200105012416.23296-3-samuel@sholland.org>
In-Reply-To: <20200105012416.23296-3-samuel@sholland.org>
From:   Chen-Yu Tsai <wens@csie.org>
Date:   Sun, 5 Jan 2020 18:09:58 +0800
X-Gmail-Original-Message-ID: <CAGb2v67jgzhBKw+yiOLv5CGbuX2JVUXWpQtPVED9C1KFq49peA@mail.gmail.com>
Message-ID: <CAGb2v67jgzhBKw+yiOLv5CGbuX2JVUXWpQtPVED9C1KFq49peA@mail.gmail.com>
Subject: Re: [linux-sunxi] [PATCH v2 2/9] power: supply: axp20x_ac_power: Fix
 reporting online status
To:     Samuel Holland <samuel@sholland.org>
Cc:     Sebastian Reichel <sre@kernel.org>,
        Lee Jones <lee.jones@linaro.org>,
        Hans de Goede <hdegoede@redhat.com>,
        Oskari Lemmela <oskari@lemmela.net>,
        Quentin Schulz <quentin.schulz@bootlin.com>,
        "open list:THERMAL" <linux-pm@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-sunxi <linux-sunxi@googlegroups.com>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Jan 5, 2020 at 9:24 AM Samuel Holland <samuel@sholland.org> wrote:
>
> AXP803/AXP813 have a flag that enables/disables the AC power supply
> input. This flag does not affect the status bits in PWR_INPUT_STATUS.
> Its effect can be verified by checking the battery charge/discharge
> state (bit 2 of PWR_INPUT_STATUS), or by examining the current draw on
> the AC input.
>
> Take this flag into account when getting the ONLINE property of the AC
> input, on PMICs where this flag is present.
>
> Fixes: 7693b5643fd2 ("power: supply: add AC power supply driver for AXP813")
> Cc: stable@vger.kernel.org
> Signed-off-by: Samuel Holland <samuel@sholland.org>

Reviewed-by: Chen-Yu Tsai <wens@csie.org>
