Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC6B033695F
	for <lists+stable@lfdr.de>; Thu, 11 Mar 2021 02:03:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229490AbhCKBCi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Mar 2021 20:02:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229483AbhCKBCK (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Mar 2021 20:02:10 -0500
Received: from mail-lj1-x233.google.com (mail-lj1-x233.google.com [IPv6:2a00:1450:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54A61C061574
        for <stable@vger.kernel.org>; Wed, 10 Mar 2021 17:02:10 -0800 (PST)
Received: by mail-lj1-x233.google.com with SMTP id 2so199343ljr.5
        for <stable@vger.kernel.org>; Wed, 10 Mar 2021 17:02:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=c8MWUEPcWRqlNN6HV0ALExHUT0G/wuf/0Gpk6qlo1WE=;
        b=UhMP6tzOupn8Kgm9qYDbMvA5SCQImG9o3THb5a8Ek4/IxA6Ws6YGQoiQaHOUEBSRcc
         /ZpjF/pAJubmqTu9r/jwd7HBBwpIAp/E+cSIIircb7aU6kwwbRJuxr7BN5dvmMGw01io
         5pVLAWKHtIxUn/RKgjkjffI+X8LpF5V88y1/uaJ9Ku/hMV1zyg+KDMDkBrczbFUCzhGs
         S4hOB6Km+eAAvrBcseYvd3NlDzvkQTg6zzCq3AqRuJ06/FT5I8IqtJbek2KTykNN+zRz
         s3z1LKVDczv1nd/6qnTe63ho1j/gNgmQLCSc3V4M1KuFMY7f99od7XGzD+aT+hY2pOVY
         96xA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=c8MWUEPcWRqlNN6HV0ALExHUT0G/wuf/0Gpk6qlo1WE=;
        b=EtMULKpOseZBu0g+c2+B5dTHrSAHqkzUPXyEFypuW+3T54SuDuxnI4OKjKyMMqdxG2
         1hOzHdzpcbe6MhpNI/aO0jbX+zCpY9R4j9codaTw1L5jg7PmtYVbFK5v5GhlJBwyhlyk
         rSPyylPmEuMAIw8ZaBXAmG9cjfg4aE5c6xun5okNJpZu09te+QJVJy7FLCYGohLBRiZk
         I/y8JEkxhEr9IvberJsCluC9QJogd8/V8rveA5YtVwJ0mftAeEge1Yfb/ZTq+HlO/i5r
         h+ox4y1BsXqJCTi7sZ6XPf+pYQxPu9KKb/N/gKM7SHyF7Wa2igGUg9garzYegYdTEwuy
         oyHQ==
X-Gm-Message-State: AOAM531EWAFOS/+V76AyzWHV9ooPrBgCnp8YN7jfjvsYo6EY2QyJDsNb
        gPMJXsrAWrI8gnpOBrbbufxRm3qypIZJjNUhqa+wrw==
X-Google-Smtp-Source: ABdhPJzkcZbjChLiKr2QTj6cupQ7Gt4EKlXJ9kqPzoWN9882YNqqEJKPD3YGlEuuS/DQkce8boJ9ojboDa+oHD5ilFI=
X-Received: by 2002:a2e:1649:: with SMTP id 9mr3492915ljw.74.1615424528892;
 Wed, 10 Mar 2021 17:02:08 -0800 (PST)
MIME-Version: 1.0
References: <20210310152900.149380-1-ulf.hansson@linaro.org>
In-Reply-To: <20210310152900.149380-1-ulf.hansson@linaro.org>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Thu, 11 Mar 2021 02:01:57 +0100
Message-ID: <CACRpkdayGkuJE9z+QT41ZVoJJN4sBx4e28c5OLzC9obvE94gBw@mail.gmail.com>
Subject: Re: [PATCH] mmc: core: Fix hanging on I/O during system suspend for
 removable cards
To:     Ulf Hansson <ulf.hansson@linaro.org>
Cc:     linux-mmc <linux-mmc@vger.kernel.org>,
        "Rafael J . Wysocki" <rjw@rjwysocki.net>,
        Kiwoong Kim <kwmad.kim@samsung.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Android Kernel Team <kernel-team@android.com>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 10, 2021 at 4:29 PM Ulf Hansson <ulf.hansson@linaro.org> wrote:

> The mmc core uses a PM notifier to temporarily during system suspend, turn
> off the card detection mechanism for removal/insertion of (e)MMC/SD/SDIO
> cards. Additionally, the notifier may be used to remove an SDIO card
> entirely, if a corresponding SDIO functional driver don't have the system
> suspend/resume callbacks assigned. This behaviour has been around for a
> very long time.
>
> However, a recent bug report tells us there are problems with this
> approach. More precisely, when receiving the PM_SUSPEND_PREPARE
> notification, we may end up hanging on I/O to be completed, thus also
> preventing the system from getting suspended.
>
> In the end what happens, is that the cancel_delayed_work_sync() in
> mmc_pm_notify() ends up waiting for mmc_rescan() to complete - and since
> mmc_rescan() wants to claim the host, it needs to wait for the I/O to be
> completed first.
>
> Typically, this problem is triggered in Android, if there is ongoing I/O
> while the user decides to suspend, resume and then suspend the system
> again. This due to that after the resume, an mmc_rescan() work gets punted
> to the workqueue, which job is to verify that the card remains inserted
> after the system has resumed.
>
> To fix this problem, userspace needs to become frozen to suspend the I/O,
> prior to turning off the card detection mechanism. Therefore, let's drop
> the PM notifiers for mmc subsystem altogether and rely on the card
> detection to be turned off/on as a part of the system_freezable_wq, that we
> are already using.
>
> Moreover, to allow and SDIO card to be removed during system suspend, let's
> manage this from a ->prepare() callback, assigned at the mmc_host_class
> level. In this way, we can use the parent device (the mmc_host_class
> device), to remove the card device that is the child, in the
> device_prepare() phase.
>
> Reported-by: Kiwoong Kim <kwmad.kim@samsung.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>

This makes sense to me.
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
