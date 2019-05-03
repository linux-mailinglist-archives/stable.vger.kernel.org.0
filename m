Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3D6E133A8
	for <lists+stable@lfdr.de>; Fri,  3 May 2019 20:38:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726480AbfECSiD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 May 2019 14:38:03 -0400
Received: from mail-ot1-f66.google.com ([209.85.210.66]:43057 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726470AbfECSiD (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 May 2019 14:38:03 -0400
Received: by mail-ot1-f66.google.com with SMTP id e108so6164729ote.10
        for <stable@vger.kernel.org>; Fri, 03 May 2019 11:38:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=igK2hkimOLYL0v51jrHSB9BR0OokxEkSsmmhvh8dBYg=;
        b=n9XnWJAPxfp9OVLqm1MzLP2NbbIHojI5DaFLgmQfXodUJYykUHDHt7PJJSbZzdttra
         a0PrrohZUmjNCfzfQrFpFfomG0ymsatj7eIJ2NtvJPIlQYH+7j3RhAZzwlKbaXuVSibP
         E01kIRwlXrTgqsl6j8roOzUqzZdSaC3hCJt58=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=igK2hkimOLYL0v51jrHSB9BR0OokxEkSsmmhvh8dBYg=;
        b=LHbNNMt1D66k7KVoP2CthCskCUqL+gUPtuxuNj6WXDan23e5I08RqryUUUgCdnJ9xV
         wlldd1vFKbeH+qAFPMpwEQUlLCXBhszuMpdJ3kp6wRAXVwnjCSElwuEIfDFhZU1l+U+u
         +G1MpMXjrgrzVnixblz3nyWCD7IfECLeVEtVhoNYug4sl1lJBugM7nDZ0GWC8Ccpr6Am
         jbyOoulCmO+Vbb1taoq0KTPrWZy174ptv7cpcYhPdah4cgIq0o4SxJAWY2BoZqRElqi/
         lkYDueMlT7olDuxeJW0ZhRsC8e70KJjCsIXU7x+OKbdgcHlwkbFpnPWukK4Z4sp48N7R
         oiMA==
X-Gm-Message-State: APjAAAWdWYM6fgblcBhv3E6toEhlLU6quhFbjkwx/DTSESPiK+j24Xp/
        awfnxdRVpEjqqxIRyXhoxtwXCLLvaPkJt1/svq5Gvg==
X-Google-Smtp-Source: APXvYqyNKoXq7xTo87oybEtZhPUf9Rpiit6ISgOcAchV1sZ83eW0qVB1QqwR5Ii63agVaWpDu6qea9xTTRZWtibKkMw=
X-Received: by 2002:a9d:1288:: with SMTP id g8mr8368844otg.28.1556908682674;
 Fri, 03 May 2019 11:38:02 -0700 (PDT)
MIME-Version: 1.0
References: <20181018185616.14768-1-keescook@chromium.org> <20181018185616.14768-3-keescook@chromium.org>
In-Reply-To: <20181018185616.14768-3-keescook@chromium.org>
From:   Douglas Anderson <dianders@chromium.org>
Date:   Fri, 3 May 2019 11:37:51 -0700
Message-ID: <CAM0oz-91yjPQKnxGDjwFThs19U=+iziuUr=9z13NSibr_uRxZQ@mail.gmail.com>
Subject: Re: [PATCH pstore-next v2 2/4] pstore: Allocate compression during late_initcall()
To:     Kees Cook <keescook@chromium.org>, stable@vger.kernel.org
Cc:     LKML <linux-kernel@vger.kernel.org>,
        "Joel Fernandes (Google)" <joel@joelfernandes.org>,
        Sai Prakash Ranjan <saiprakash.ranjan@codeaurora.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Dan Williams <dan.j.williams@intel.com>,
        Anton Vorontsov <anton@enomsg.org>,
        Colin Cross <ccross@android.com>,
        Tony Luck <tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On Thu, Oct 18, 2018 at 11:56 AM Kees Cook <keescook@chromium.org> wrote:
>
> From: "Joel Fernandes (Google)" <joel@joelfernandes.org>
>
> ramoops's call of pstore_register() was recently moved to run during
> late_initcall() because the crypto backend may not have been ready during
> postcore_initcall(). This meant early-boot crash dumps were not getting
> caught by pstore any more.
>
> Instead, lets allow calls to pstore_register() earlier, and once crypto
> is ready we can initialize the compression.
>
> Reported-by: Sai Prakash Ranjan <saiprakash.ranjan@codeaurora.org>
> Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
> Tested-by: Sai Prakash Ranjan <saiprakash.ranjan@codeaurora.org>
> Fixes: cb3bee0369bc ("pstore: Use crypto compress API")
> [kees: trivial rebase]
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>  fs/pstore/platform.c | 10 +++++++++-
>  fs/pstore/ram.c      |  2 +-
>  2 files changed, 10 insertions(+), 2 deletions(-)

I'd propose that these three patches:

95047b0519c1 pstore: Refactor compression initialization
416031653eb5 pstore: Allocate compression during late_initcall()
cb095afd4476 pstore: Centralize init/exit routines

Get sent to linux-stable.  Specifically I'll mention that 4.19 needs
it.  IMO the regression of pstore not catching early boot crashes is
pretty serious IMO.

Thanks!

-Doug
