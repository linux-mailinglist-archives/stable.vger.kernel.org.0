Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35C6444B8F6
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 23:48:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344719AbhKIWu5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Nov 2021 17:50:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345040AbhKIWuF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Nov 2021 17:50:05 -0500
Received: from mail-ot1-x329.google.com (mail-ot1-x329.google.com [IPv6:2607:f8b0:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DB80C00EB3E
        for <stable@vger.kernel.org>; Tue,  9 Nov 2021 14:21:24 -0800 (PST)
Received: by mail-ot1-x329.google.com with SMTP id h19-20020a9d3e53000000b0056547b797b2so64066otg.4
        for <stable@vger.kernel.org>; Tue, 09 Nov 2021 14:21:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qLsRex488etMkJyCCFaXLtgPzZ6BB/J9dKWw8UO3KF8=;
        b=HiVLib1yZobRnuW7sMIDMYgEiV7yhcNYV53azWFi6aSYW4Hu++8xN0MqgT9ZBTBPe1
         tHfuZJW+x3zpArXVhEztoQURqBgNNAqvkhrpdok2c1CYScgbTEkk3toWbsXGaEsMPhBc
         pobpQ2rMClAZp0i0TvDBo0SZAGTrza1mdUUSgjugkU2oA7tzpHVZSIZWY2OOOlvRabpj
         xPBPjmrQZd9Z6fxEVq7BWnagN67ohxQ3kkVDeE0cZHQkykxoJzisjtym0erskVnhIOYl
         BxQABSwHk0vmOC8j2uq7gypLmELd9QUegVybgm3hF2dKB/JaBQMP0LD29ohzDV3YG8Wz
         hM9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qLsRex488etMkJyCCFaXLtgPzZ6BB/J9dKWw8UO3KF8=;
        b=yEUVw1eXKLyW7Z683ZMqjQE4p2OCae+4W5Dd9LfrOFZYAN1fIFgBhLS8osr1xeHK0Q
         egnbkvt5IbFdIgyi+WssH29V0nisPe69XnWwSAYwkr1IrAxgJ3LkOSPLSz1gj+O9Zii7
         swtzxaRSSAMJDo/QTFiJJLJsSAJ9jvImHRG8/RcLtzRXwju8BNmlXudu23+9iLqXveRc
         issyib9z4n+MRvx2d30ZnLJopATLrP5m2wnDBGgShUNx/Y/+y4TvxyRsGNy25Hbr/6Vs
         g+LYOvThSzLU2okUxyo6Rn8jJXnka66knbO/SGUufWB3VtYFJfXhxEjtN7odgMy2ZAiR
         C4mA==
X-Gm-Message-State: AOAM530MDIkrCfon37FD6MGvcXEy+DYlzLGI47t8IPNjTF6ScF/oykzi
        2HjZyAxopzJzDyQulFshfPBYvcOADwu8U2z0+35nvA==
X-Google-Smtp-Source: ABdhPJxnGCMwPBzOn0vDnUGZChUhsq9PbhUnrHTyTVpdBpkdT5/1fxR/EpRTVr/sEUcMpLzruQlZhgh3IK5H9XIVdOU=
X-Received: by 2002:a9d:ed6:: with SMTP id 80mr8689832otj.35.1636496484311;
 Tue, 09 Nov 2021 14:21:24 -0800 (PST)
MIME-Version: 1.0
References: <20211109164650.2233507-1-robh@kernel.org> <20211109164650.2233507-3-robh@kernel.org>
In-Reply-To: <20211109164650.2233507-3-robh@kernel.org>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Tue, 9 Nov 2021 23:21:12 +0100
Message-ID: <CACRpkdaY9VQcUCNe4ZFKFyRd7HSFh1FX8yOT-AFqjJ6wc56Ehw@mail.gmail.com>
Subject: Re: [PATCH 2/2] clk: versatile: clk-icst: Ensure clock names are unique
To:     Rob Herring <robh@kernel.org>
Cc:     Stephen Boyd <sboyd@kernel.org>,
        Sudeep Holla <Sudeep.Holla@arm.com>,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Guenter Roeck <linux@roeck-us.net>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        linux-clk@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 9, 2021 at 5:46 PM Rob Herring <robh@kernel.org> wrote:

> Commit 2d3de197a818 ("ARM: dts: arm: Update ICST clock nodes 'reg' and
> node names") moved to using generic node names. That results in trying
> to register multiple clocks with the same name. Fix this by including
> the unit-address in the clock name.
>
> Fixes: 2d3de197a818 ("ARM: dts: arm: Update ICST clock nodes 'reg' and node names")
> Cc: stable@vger.kernel.org
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Cc: Stephen Boyd <sboyd@kernel.org>
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-clk@vger.kernel.org
> Signed-off-by: Rob Herring <robh@kernel.org>

Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
