Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FAD024A5D1
	for <lists+stable@lfdr.de>; Wed, 19 Aug 2020 20:18:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726697AbgHSSSg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Aug 2020 14:18:36 -0400
Received: from mail-ej1-f66.google.com ([209.85.218.66]:40922 "EHLO
        mail-ej1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726211AbgHSSSe (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Aug 2020 14:18:34 -0400
Received: by mail-ej1-f66.google.com with SMTP id o18so27415590eje.7;
        Wed, 19 Aug 2020 11:18:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=wnUg3p/rkzEg7r5c/DTFnIBFdODWMiQLm/bvg10pJj4=;
        b=lfBI0Y7XjyoRqPM//x6zAuavRa5q+XbI8w7QLgQkIhqyMfIKVmdKkgyzl7rURNejsF
         YpIcHIIK9gFFtyn7uPe7l5i15yqixWwJElmT0S7l4Pa9pC0ikV5yHbo8WO7BSdDKmRND
         wV1cjfPNO4lWyD5kVzmCi/SxkM0KlteLjRzKbkMt4FZc8m0wFxdFrSG436tO4nMXQYky
         7vpbiv3lXzmJjT6w/erpCZDoGbgUezlSqDP1wVrnmyhc+FXqF7uTiEQFB6Fp5W5BE8Zi
         95xRKc1RcsxLo711IkecguxqAdhL/sGT8Pl1Jnl/SxaIyaLqpEV7dI4WOaX3wvh+o9dy
         Td6w==
X-Gm-Message-State: AOAM533Xle120cNVtjC/zMgkbpdT/Um617cWl49W6IEd/YMLqzCcdUZB
        0rqXj/Axc1rvCGbNvsxUjQU=
X-Google-Smtp-Source: ABdhPJwhe7v/Ue1xFghexM9wTspolT/ZMLwUsVvmESFPXE05UaS1MOTnbDUeHiPOeM2GGznnOamAJg==
X-Received: by 2002:a17:906:2717:: with SMTP id z23mr5615021ejc.19.1597861111871;
        Wed, 19 Aug 2020 11:18:31 -0700 (PDT)
Received: from kozik-lap ([194.230.155.216])
        by smtp.googlemail.com with ESMTPSA id x10sm17923412eds.21.2020.08.19.11.18.29
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 19 Aug 2020 11:18:31 -0700 (PDT)
Date:   Wed, 19 Aug 2020 20:18:28 +0200
From:   Krzysztof Kozlowski <krzk@kernel.org>
To:     Russell King <linux@armlinux.org.uk>,
        Kukjin Kim <kgene@kernel.org>,
        Simtec Linux Team <linux@simtec.co.uk>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Michael Turquette <mturquette@baylibre.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        patches@opensource.cirrus.com, linux-clk@vger.kernel.org,
        linux-watchdog@vger.kernel.org
Cc:     Sergio Prado <sergio.prado@e-labworks.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Sylwester Nawrocki <snawrocki@kernel.org>,
        Cedric Roux <sed@free.fr>, Lihua Yao <ylhuajnu@outlook.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH v2 08/13] ARM: s3c24xx: fix missing system reset
Message-ID: <20200819181828.GC21298@kozik-lap>
References: <20200804192654.12783-1-krzk@kernel.org>
 <20200804192654.12783-9-krzk@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200804192654.12783-9-krzk@kernel.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 04, 2020 at 09:26:49PM +0200, Krzysztof Kozlowski wrote:
> Commit f6361c6b3880 ("ARM: S3C24XX: remove separate restart code")
> removed usage of the watchdog reset platform code in favor of the
> Samsung SoC watchdog driver.  However the latter was not selected thus
> S3C24xx platforms lost reset abilities.
> 
> Cc: <stable@vger.kernel.org>
> Fixes: f6361c6b3880 ("ARM: S3C24XX: remove separate restart code")
> Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
> ---
>  arch/arm/Kconfig | 2 ++

Applied.

Best regards,
Krzysztof

