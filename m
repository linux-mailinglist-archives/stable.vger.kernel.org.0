Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C857E5091C
	for <lists+stable@lfdr.de>; Mon, 24 Jun 2019 12:41:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729337AbfFXKld (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jun 2019 06:41:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:36402 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728824AbfFXKld (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Jun 2019 06:41:33 -0400
Received: from mail-lj1-f174.google.com (mail-lj1-f174.google.com [209.85.208.174])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7A9B1208E4
        for <stable@vger.kernel.org>; Mon, 24 Jun 2019 10:41:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561372891;
        bh=1naeWVosEdPiDy4L14fHum1p9Nm0KZILpQ653wm0n/g=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=0VaFggCX/ax64Z+VBQm5vOlTm3enYYOLb8CkmxiBt5diXBJ/3MOWcLt5GoRRy4IqZ
         U76xytvBm3QptHxN3afCBcRCiKrBY0RjeqyQQvZt+nXS9GcDHhUlAtu/OCmBmzG6mo
         hm1MyuuCoy289MBPdLrBCR1A1aW3Ihe3scYAs2vM=
Received: by mail-lj1-f174.google.com with SMTP id p17so12139930ljg.1
        for <stable@vger.kernel.org>; Mon, 24 Jun 2019 03:41:31 -0700 (PDT)
X-Gm-Message-State: APjAAAUIM2O24rGo1XTRsuHzQcIxhaufmI5igkPbBOe4QoM4a19bRp/X
        qeNzMz+gpuh9z7jeMwHtU1QrmMjF+d5BPhCA708=
X-Google-Smtp-Source: APXvYqzaIT+wBn7y/PLo19OowWJyWT3V/OhsBVCooSsVzj6CLB6UxtmC0w8GZe562VAZ1YkVXxOh/Zorib/E7fswTio=
X-Received: by 2002:a2e:8155:: with SMTP id t21mr28579634ljg.80.1561372889787;
 Mon, 24 Jun 2019 03:41:29 -0700 (PDT)
MIME-Version: 1.0
References: <1560948159-21926-1-git-send-email-krzk@kernel.org>
 <20190622181347.3BFC52070B@mail.kernel.org> <CAJKOXPeZH+jiXxsm_cpWsfuju=vhAd2GDoj_aH811pv17C6YOQ@mail.gmail.com>
 <20190624101129.GQ2226@sasha-vm>
In-Reply-To: <20190624101129.GQ2226@sasha-vm>
From:   Krzysztof Kozlowski <krzk@kernel.org>
Date:   Mon, 24 Jun 2019 12:41:18 +0200
X-Gmail-Original-Message-ID: <CAJKOXPdCyhE8FDjc_XFkqPTPK-7k8bhnu5WEg+EOebaC3O6K+g@mail.gmail.com>
Message-ID: <CAJKOXPdCyhE8FDjc_XFkqPTPK-7k8bhnu5WEg+EOebaC3O6K+g@mail.gmail.com>
Subject: Re: [PATCH] regulator: s2mps11: Fix ERR_PTR dereference on GPIO
 lookup failure
To:     Sasha Levin <sashal@kernel.org>, Mark Brown <broonie@kernel.org>
Cc:     Sangbeom Kim <sbkim73@samsung.com>,
        Georg Waibel <georg.waibel@sensor-technik.de>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 24 Jun 2019 at 12:11, Sasha Levin <sashal@kernel.org> wrote:
>
> On Mon, Jun 24, 2019 at 09:01:27AM +0200, Krzysztof Kozlowski wrote:
> >On Sat, 22 Jun 2019 at 20:13, Sasha Levin <sashal@kernel.org> wrote:
> >>
> >> Hi,
> >>
> >> [This is an automated email]
> >>
> >> This commit has been processed because it contains a "Fixes:" tag,
> >> fixing commit: 1c984942f0a4 regulator: s2mps11: Pass descriptor instead of GPIO number.
> >>
> >> The bot has tested the following trees: v5.1.12, v4.19.53.
> >>
> >> v5.1.12: Build OK!
> >> v4.19.53: Failed to apply! Possible dependencies:
> >>     Unable to calculate
> >>
> >>
> >> How should we proceed with this patch?
> >
> >The commit mentioned in fixes tag (1c984942f0a4) came in
> >v5.0-rc1/v5.0. Why do you try to port it to v4.19?
>
> This is an interesting one! Usually when something like this happens, it
> means that the "fixed" commit was backported to stable, but as you
> pointed out, it was not.
>
> My scripts have logic to try and detect these backports, and it appears
> that there's a commit with an identical subject line in the 4.19 tree,
> so at this point there are two commits with identical subject lines in
> Linus's tree:
>
> 1c984942f0a4 regulator: s2mps11: Pass descriptor instead of GPIO number
> 0369e02b75e6 regulator: s2mps11: Pass descriptor instead of GPIO number
>
> Which can be confusing for humans too :)

+CC Mark Brown,

Ugh, I see more of commits from this patchset getting to mainline
twice.  One branch goes to Linus via
79f20778fb228ae372cd7602745382fd4543ef31 Merge tag 'regulator-v4.21'
of git://git.kernel.org/pub/scm/linux/kernel/git/broonie/regulator
which is based on v4.20-rc1

The other commits gets there via:
68cc38ff33f38424d0456f9a1ecfec4683226a7e Merge tag 'regulator-v4.18'
of git://git.kernel.org/pub/scm/linux/kernel/git/broonie/regulator
which is before (gets into v4.18-rc1).

But how the latter can be applied again if it is based on something
already containing these commits... I am so confused...

Anyway the Fixes needs to be corrected to contain both (also
0369e02b75e6) and should be backported to v4.19... I'll see if I have
spare time to make a backport.

Best regards,
Krzysztof
