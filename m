Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1E5C421154
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 16:30:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234037AbhJDOcI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 10:32:08 -0400
Received: from mail-ot1-f50.google.com ([209.85.210.50]:43670 "EHLO
        mail-ot1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233516AbhJDOcH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Oct 2021 10:32:07 -0400
Received: by mail-ot1-f50.google.com with SMTP id x33-20020a9d37a4000000b0054733a85462so21706322otb.10;
        Mon, 04 Oct 2021 07:30:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=SLFNb0jE1KqZcw34T0ekxvFU1KOHuqn55xfMpzfL7sU=;
        b=Gzi6wgpGq10pNQPzDzvrmnYotEr4B4bD7LNiSUIXyu1iFehMDB7oCer7G3gchaQfAo
         oEgmlqQyjnoLCFnXcPkkU9TZkr3+p9QP5YWhJjTmRE+2KA4k0fmxFWdGiYJl9BXyZuO0
         bdEcptY0cyORFWcRl/PpxYPjuD0BMM9aRiaZhUXSmF7eIV2rLsGSS2wq0rrINUWiAcT4
         9FTfu/n9cI8gYi1ODLCZwLpT5F9zz7B7thLIOjNDSYdfHS/3FwUUMR113vz5dGWX2lkC
         fUp3PiQCxjfWbYxzDm4H8jaqcSYMjNXk1mlZ/RFx+Jsj9RAnf71qdIVWh74bPsLgnVZE
         US+Q==
X-Gm-Message-State: AOAM5326Pt5jRY9X4rv+wWG6RUHcm8nYL+PmtP0H8QML7r9bWLTL9me3
        3XCTJREbHu7q3TCuf9fHVw==
X-Google-Smtp-Source: ABdhPJzviAfyC6EqMoZVDSeGqY/3W4gTshEoXVMVuK6PL5nVCuYzELA43fSzi1QcJB8AyOQyE6iZ2A==
X-Received: by 2002:a05:6830:358:: with SMTP id h24mr9321760ote.159.1633357817713;
        Mon, 04 Oct 2021 07:30:17 -0700 (PDT)
Received: from robh.at.kernel.org (66-90-148-213.dyn.grandenetworks.net. [66.90.148.213])
        by smtp.gmail.com with ESMTPSA id r4sm2743984oiw.36.2021.10.04.07.30.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Oct 2021 07:30:17 -0700 (PDT)
Received: (nullmailer pid 1245074 invoked by uid 1000);
        Mon, 04 Oct 2021 14:30:15 -0000
Date:   Mon, 4 Oct 2021 09:30:15 -0500
From:   Rob Herring <robh@kernel.org>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Cc:     linux-clk@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Mark Brown <broonie@kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>, stable@vger.kernel.org,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        linux-samsung-soc@vger.kernel.org,
        Michael Turquette <mturquette@baylibre.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Lee Jones <lee.jones@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Stephen Boyd <sboyd@kernel.org>, devicetree@vger.kernel.org
Subject: Re: [PATCH v2 01/10] regulator: s5m8767: do not use reset value as
 DVS voltage if GPIO DVS is disabled
Message-ID: <YVsP96GK9SJFRDkI@robh.at.kernel.org>
References: <20211001094106.52412-1-krzysztof.kozlowski@canonical.com>
 <20211001094106.52412-2-krzysztof.kozlowski@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211001094106.52412-2-krzysztof.kozlowski@canonical.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 01 Oct 2021 11:40:57 +0200, Krzysztof Kozlowski wrote:
> The driver and its bindings, before commit 04f9f068a619 ("regulator:
> s5m8767: Modify parsing method of the voltage table of buck2/3/4") were
> requiring to provide at least one safe/default voltage for DVS registers
> if DVS GPIO is not being enabled.
> 
> IOW, if s5m8767,pmic-buck2-uses-gpio-dvs is missing, the
> s5m8767,pmic-buck2-dvs-voltage should still be present and contain one
> voltage.
> 
> This requirement was coming from driver behavior matching this condition
> (none of DVS GPIO is enabled): it was always initializing the DVS
> selector pins to 0 and keeping the DVS enable setting at reset value
> (enabled).  Therefore if none of DVS GPIO is enabled in devicetree,
> driver was configuring the first DVS voltage for buck[234].
> 
> Mentioned commit 04f9f068a619 ("regulator: s5m8767: Modify parsing
> method of the voltage table of buck2/3/4") broke it because DVS voltage
> won't be parsed from devicetree if DVS GPIO is not enabled.  After the
> change, driver will configure bucks to use the register reset value as
> voltage which might have unpleasant effects.
> 
> Fix this by relaxing the bindings constrain: if DVS GPIO is not enabled
> in devicetree (therefore DVS voltage is also not parsed), explicitly
> disable it.
> 
> Cc: <stable@vger.kernel.org>
> Fixes: 04f9f068a619 ("regulator: s5m8767: Modify parsing method of the voltage table of buck2/3/4")
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
> ---
>  .../bindings/regulator/samsung,s5m8767.txt    | 21 +++++++------------
>  drivers/regulator/s5m8767.c                   | 21 ++++++++-----------
>  2 files changed, 17 insertions(+), 25 deletions(-)
> 

Acked-by: Rob Herring <robh@kernel.org>
