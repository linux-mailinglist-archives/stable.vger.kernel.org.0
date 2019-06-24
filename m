Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 653835092D
	for <lists+stable@lfdr.de>; Mon, 24 Jun 2019 12:47:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728117AbfFXKrg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jun 2019 06:47:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:37572 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726960AbfFXKrg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Jun 2019 06:47:36 -0400
Received: from mail-lj1-f173.google.com (mail-lj1-f173.google.com [209.85.208.173])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2847820820
        for <stable@vger.kernel.org>; Mon, 24 Jun 2019 10:47:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561373255;
        bh=7cuNQF3ObRp0MQbyQAXGhrWlucgpmPnL6gf7i1+hGZ0=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=eEZTpLU6voW4XKsiRi771k1hVcO4Ci41Wzf4O8qFBPxETV7a/uFmvlmhlLIwp1kMc
         XeBATn6pXH1FGNPSuMHdYLZRY8CzLvEHV096NmYi8dXtqtHefCffCnXK0nzGkI9m/A
         yPgteTPqcj5MbB1AssU1tyxlwe3bYMYvrdybuwzY=
Received: by mail-lj1-f173.google.com with SMTP id 131so12135809ljf.4
        for <stable@vger.kernel.org>; Mon, 24 Jun 2019 03:47:35 -0700 (PDT)
X-Gm-Message-State: APjAAAV0WZYp00ypRVjlfa7eqxdQp1adxwXF6zGWVXSUv+r8Rk4enEeb
        c6j6gAHvD20ePcv8SGkOGosA9vKN/2SHB+LaAvY=
X-Google-Smtp-Source: APXvYqwF6kbkvEAbrp9y3VfgKQWbWKmKlqO4YS+CAd1mTMcxXCJK6jaVMzMeWPpqZQyxbYQibRyq7w8iWGpBFk4zsOc=
X-Received: by 2002:a2e:124b:: with SMTP id t72mr72699794lje.143.1561373253468;
 Mon, 24 Jun 2019 03:47:33 -0700 (PDT)
MIME-Version: 1.0
References: <1560948159-21926-1-git-send-email-krzk@kernel.org>
 <20190622181347.3BFC52070B@mail.kernel.org> <CAJKOXPeZH+jiXxsm_cpWsfuju=vhAd2GDoj_aH811pv17C6YOQ@mail.gmail.com>
 <20190624101129.GQ2226@sasha-vm> <CAJKOXPdCyhE8FDjc_XFkqPTPK-7k8bhnu5WEg+EOebaC3O6K+g@mail.gmail.com>
In-Reply-To: <CAJKOXPdCyhE8FDjc_XFkqPTPK-7k8bhnu5WEg+EOebaC3O6K+g@mail.gmail.com>
From:   Krzysztof Kozlowski <krzk@kernel.org>
Date:   Mon, 24 Jun 2019 12:47:22 +0200
X-Gmail-Original-Message-ID: <CAJKOXPeBeeTQrp1ZYPTtc3Y8faUpmroqW0Ljh=NMgtpxJR-DPw@mail.gmail.com>
Message-ID: <CAJKOXPeBeeTQrp1ZYPTtc3Y8faUpmroqW0Ljh=NMgtpxJR-DPw@mail.gmail.com>
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

 On Mon, 24 Jun 2019 at 12:41, Krzysztof Kozlowski <krzk@kernel.org> wrote:
>
> On Mon, 24 Jun 2019 at 12:11, Sasha Levin <sashal@kernel.org> wrote:
> >
> > On Mon, Jun 24, 2019 at 09:01:27AM +0200, Krzysztof Kozlowski wrote:
> > >On Sat, 22 Jun 2019 at 20:13, Sasha Levin <sashal@kernel.org> wrote:
> > >>
> > >> Hi,
> > >>
> > >> [This is an automated email]
> > >>
> > >> This commit has been processed because it contains a "Fixes:" tag,
> > >> fixing commit: 1c984942f0a4 regulator: s2mps11: Pass descriptor instead of GPIO number.
> > >>
> > >> The bot has tested the following trees: v5.1.12, v4.19.53.
> > >>
> > >> v5.1.12: Build OK!
> > >> v4.19.53: Failed to apply! Possible dependencies:
> > >>     Unable to calculate
> > >>
> > >>
> > >> How should we proceed with this patch?
> > >
> > >The commit mentioned in fixes tag (1c984942f0a4) came in
> > >v5.0-rc1/v5.0. Why do you try to port it to v4.19?
> >
> > This is an interesting one! Usually when something like this happens, it
> > means that the "fixed" commit was backported to stable, but as you
> > pointed out, it was not.
> >
> > My scripts have logic to try and detect these backports, and it appears
> > that there's a commit with an identical subject line in the 4.19 tree,
> > so at this point there are two commits with identical subject lines in
> > Linus's tree:
> >
> > 1c984942f0a4 regulator: s2mps11: Pass descriptor instead of GPIO number
> > 0369e02b75e6 regulator: s2mps11: Pass descriptor instead of GPIO number
> >
> > Which can be confusing for humans too :)
>
> +CC Mark Brown,
>
> Ugh, I see more of commits from this patchset getting to mainline
> twice.  One branch goes to Linus via
> 79f20778fb228ae372cd7602745382fd4543ef31 Merge tag 'regulator-v4.21'
> of git://git.kernel.org/pub/scm/linux/kernel/git/broonie/regulator
> which is based on v4.20-rc1
>
> The other commits gets there via:
> 68cc38ff33f38424d0456f9a1ecfec4683226a7e Merge tag 'regulator-v4.18'
> of git://git.kernel.org/pub/scm/linux/kernel/git/broonie/regulator
> which is before (gets into v4.18-rc1).
>
> But how the latter can be applied again if it is based on something
> already containing these commits... I am so confused...
>
> Anyway the Fixes needs to be corrected to contain both (also
> 0369e02b75e6) and should be backported to v4.19... I'll see if I have
> spare time to make a backport.

Ah, I see now revert of the first commit
37fa23dbccbd97663acc085bd79246f427e603a1 (regulator: s2mps11: Fix boot
on Odroid XU3). Actually git diff points that there was no effective
change in the s2mps11 regulator.

Since the revert got into v4.18, then v4.19 is safe and there is no
need for backport.

Best regards,
Krzysztof
