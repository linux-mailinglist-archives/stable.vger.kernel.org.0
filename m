Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A29683AD07
	for <lists+stable@lfdr.de>; Mon, 10 Jun 2019 04:34:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730278AbfFJCeH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jun 2019 22:34:07 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:37378 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730055AbfFJCeE (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 Jun 2019 22:34:04 -0400
Received: by mail-ed1-f67.google.com with SMTP id w13so12198200eds.4
        for <stable@vger.kernel.org>; Sun, 09 Jun 2019 19:34:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=afKgTHmsyagHLmYfWGsSLRAHwZWSCleIZNkXxK90uPY=;
        b=fawIqtj7htmk9JLOUC28S3iKNbxX4HMtjGN+MuVQUAVuCjMhYUz6VWwQ727OC2TTt4
         W5z42Nj1T8lmxR/j7JX2G/xkWIznAEh54U6SciR/Py1AiQQ97VIHcIfNhg7M+zqeL7gK
         izRcmPWT4FC06S8MN1aWWe825DOKTmxJM7433UVz2/MiCaj8Sz4LpRPzK7PDdPsyVETN
         QR4AJ6dqdo+Lu1gSRb3uPqLcByPZNMcPQHqBtKIumdmVs7248ruDEZxzggK8rE72NPxk
         oCxocsJ0+FYyrkeVnrDf1c2D/DC+TFx/SVnL9hSuiS3a/m0iWaGSv3k+BBZlFXVajXAB
         JwBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=afKgTHmsyagHLmYfWGsSLRAHwZWSCleIZNkXxK90uPY=;
        b=LbD+vtOuOjMflpDOBfhx6+Z3P8/nzmX11DQuREGULPRlVgUYIRPyyL0g7PrqAv5/Xp
         erCQ4jWaX5G034dk4+LJjMjWO3KyfW5vESSUHCqHMTHwlEryRq1cObIciVU9t8XV4Fk8
         bnE4hPlWs88JhX4zHe0t6fKNvzUk6cXOm95FgkwLTgkkLjAB7+Nr6MFBmQMg+NKtQG0y
         bYtGIykNMQh6vVp46p+cEk7zBPFkwrTjP50DBEXaKHRbZzvDxJ5XP3qWZD62lktZrkhl
         C2aGoZ7fTrhDUWVwWJIimmdL0aVVsbhyMFBZomgifmiVKejvsE9ugZSlGZrlnpDj09QI
         4ZAA==
X-Gm-Message-State: APjAAAVUKYWuRi6LVIPCIhilwuQfpZ8+t95f4W9z34P/7HYkqbIz602J
        l1IKkAJQgoIAELGwEJ+iIXrkbgOl4w1CqkGkrf7MrQ==
X-Google-Smtp-Source: APXvYqyZ4zJSQrjpclg/tB88jotg/Lr0qMzgyhbyLXcOThxD7RIRBMYssHeHhkPCoz1e8x5WG9KYWcH5HQbN/vEAUJ0=
X-Received: by 2002:a50:ec1a:: with SMTP id g26mr71250547edr.174.1560134042811;
 Sun, 09 Jun 2019 19:34:02 -0700 (PDT)
MIME-Version: 1.0
References: <20190605111412.3461-1-zhang.chunyan@linaro.org> <20190606010857.GF29739@sasha-vm>
In-Reply-To: <20190606010857.GF29739@sasha-vm>
From:   Chunyan Zhang <zhang.chunyan@linaro.org>
Date:   Mon, 10 Jun 2019 10:33:51 +0800
Message-ID: <CAG2=9p_6Rk4oUu0hWKdzHNxRg=Hsboz=vYwsmfagmuCHzEKMOg@mail.gmail.com>
Subject: Re: [BACKPORT 4.4.y] PM / sleep: prohibit devices probing during suspend/hibernation
To:     Sasha Levin <sashal@kernel.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Grygorii Strashko <grygorii.Strashko@ti.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Chunyan Zhang <zhang.lyra@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 6 Jun 2019 at 09:08, Sasha Levin <sashal@kernel.org> wrote:
>
> On Wed, Jun 05, 2019 at 07:14:12PM +0800, Chunyan Zhang wrote:
> >From: "Strashko, Grygorii" <grygorii.strashko@ti.com>
> >
> >[ Upstream commit 013c074f8642d8e815ad670601f8e27155a74b57 ]
> >
> >It is unsafe [1] if probing of devices will happen during suspend or
> >hibernation and system behavior will be unpredictable in this case.
> >So, let's prohibit device's probing in dpm_prepare() and defer their
> >probing instead. The normal behavior will be restored in
> >dpm_complete().
> >
> >This patch introduces new DD core APIs:
> > device_block_probing()
> >   It will disable probing of devices and defer their probes instead.
> > device_unblock_probing()
> >   It will restore normal behavior and trigger re-probing of deferred
> >   devices.
> >
> >[1] https://lkml.org/lkml/2015/9/11/554
> >
> >Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
> >Acked-by: Pavel Machek <pavel@ucw.cz>
> >Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> >Signed-off-by: Chunyan Zhang <zhang.chunyan@linaro.org>
>
> This patch had to be fixed a few times (see 015bb5e134 and 9a2a5a638f8),
> we can't just take it as is.
>
> It might be just simpler to move to a newer kernel at this point.

Thanks for the information and suggestion!

Chunyan

>
> --
> Thanks,
> Sasha
