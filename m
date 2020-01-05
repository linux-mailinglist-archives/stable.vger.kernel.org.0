Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4AF001306FE
	for <lists+stable@lfdr.de>; Sun,  5 Jan 2020 11:07:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725897AbgAEKHl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 Jan 2020 05:07:41 -0500
Received: from mail-ed1-f65.google.com ([209.85.208.65]:43224 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725535AbgAEKHk (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 5 Jan 2020 05:07:40 -0500
Received: by mail-ed1-f65.google.com with SMTP id dc19so45089907edb.10;
        Sun, 05 Jan 2020 02:07:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lXoVX40Qa4uYJ9euesw9zLE6CuIBV0aAx0m8O7XMmu4=;
        b=XlTjZHTA0c2gDF/RqFhPswRgHLi6YX3fIIjv2m6TVKriwiQua9r98/zTb2u+Cn/cZ1
         j2Jm7mDdjoKYKr9EfhUM1tiz0IpOLLTSNoZ7ioBL8BSL0oNvlXka+JOpro2FwlDYyK2w
         miztYfr0zTGJ1UQapuFO1z2X+VD2XEfvz+1iXjZD+DO7L9jsKlpRWs8j1PBahd8zKQqR
         3qFwp9C7mjKlG/cjXYKvsgnMKxnT09MVRlbKGfvYi9REZZsLgFtOiygtp6m0PIFF5Ogt
         qLwAvkjHrkbjxvI3W1H6qD2zKT7NCPBV1uGKcUCUUsVhblhGn0WB7BrL9/aEG6uoAHu5
         3Qjg==
X-Gm-Message-State: APjAAAXvDyvOQZv0/LfUuJmTDm25CzmURIngxe7bcIPrYJB41t1tluek
        hx9nsFn/NL3O6lbANpcibqAqR/S7Aug=
X-Google-Smtp-Source: APXvYqwWdP3Sfo1XkLWFYd5xinLA7fedSe9yksF4h63cGGjfhB4xDt9r8eIQ654MV2gL2W1NJcHEUg==
X-Received: by 2002:a50:d0d0:: with SMTP id g16mr99590929edf.75.1578218858373;
        Sun, 05 Jan 2020 02:07:38 -0800 (PST)
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com. [209.85.221.46])
        by smtp.gmail.com with ESMTPSA id qh19sm8127412ejb.55.2020.01.05.02.07.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 05 Jan 2020 02:07:38 -0800 (PST)
Received: by mail-wr1-f46.google.com with SMTP id q10so7494727wrm.11;
        Sun, 05 Jan 2020 02:07:37 -0800 (PST)
X-Received: by 2002:adf:ef4e:: with SMTP id c14mr98822527wrp.142.1578218857514;
 Sun, 05 Jan 2020 02:07:37 -0800 (PST)
MIME-Version: 1.0
References: <20200105012416.23296-1-samuel@sholland.org> <20200105012416.23296-2-samuel@sholland.org>
In-Reply-To: <20200105012416.23296-2-samuel@sholland.org>
From:   Chen-Yu Tsai <wens@csie.org>
Date:   Sun, 5 Jan 2020 18:07:25 +0800
X-Gmail-Original-Message-ID: <CAGb2v64Cep6CdTxi3nMXG71N+DydY99Y8WN0VyM3ZqK9e_EfGQ@mail.gmail.com>
Message-ID: <CAGb2v64Cep6CdTxi3nMXG71N+DydY99Y8WN0VyM3ZqK9e_EfGQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/9] mfd: axp20x: Mark AXP20X_VBUS_IPSOUT_MGMT as volatile
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
> On AXP288 and newer PMICs, bit 7 of AXP20X_VBUS_IPSOUT_MGMT can be set
> to prevent using the VBUS input. However, when the VBUS unplugged and
> plugged back in, the bit automatically resets to zero.
>
> We need to set the register as volatile to prevent regmap from caching
> that bit. Otherwise, regcache will think the bit is already set and not
> write the register.
>
> Fixes: cd53216625a0 ("mfd: axp20x: Fix axp288 volatile ranges")
> Cc: stable@vger.kernel.org
> Signed-off-by: Samuel Holland <samuel@sholland.org>

Reviewed-by: Chen-Yu Tsai <wens@csie.org>
