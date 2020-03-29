Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3EFEE196FAB
	for <lists+stable@lfdr.de>; Sun, 29 Mar 2020 21:17:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728258AbgC2TRq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Mar 2020 15:17:46 -0400
Received: from mail-lf1-f67.google.com ([209.85.167.67]:45941 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727606AbgC2TRq (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 29 Mar 2020 15:17:46 -0400
Received: by mail-lf1-f67.google.com with SMTP id v4so12188713lfo.12
        for <stable@vger.kernel.org>; Sun, 29 Mar 2020 12:17:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nxaXJEs8tvBZ3BYTNjyo4uizqRyN0pN2BrJWxcncwOg=;
        b=YQ0gULpHPid9ot/K5b4ZuKeg95aM6/ty/nbzwmpPSmYxscwzyTMHBa/kdaKxMZVH/a
         O7zUOkEnNprPQPPqg251g2MySMZH1n+3Q+Rfq/wBUNjF3vLXfoul2hc8Wo4jEkwQAY28
         z9UF36p1OGtwqGVYctoXghxHELNRIhxDZ7l+F03JrvXym6vWu0XK6nwIZHRrf9WfGR5O
         MsxCsrVsFPjqnIdmaQlolng1uV8KnNjpdGb7AEF5BX5ZMxUvORlefI18WDjLSHsypgeG
         ShY5lGWhyibD/FGWaOtjs91a0q6xpPnX9g0aES0WVZeORFPKppYt/wOvre9HNpAc3Gc6
         GMMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nxaXJEs8tvBZ3BYTNjyo4uizqRyN0pN2BrJWxcncwOg=;
        b=laqdYqC86FOzGFevW5tSZxnLdubzO44gFLrpb4SiXGULBhj6TXVhju6IXfKn8moAQ3
         kHDKI/JtTtnoSln/Lyq60AJRw6UuZ20lh1cbSQB+nMRUgvTHaQ8p5Ppoh394buSJoGxm
         vOf4iVDECDsWnoa4qOBwAU5NQhFXoX6Gm86pth5qgWJihX5Krj4B6YtYTLBpR7abga1E
         //X/8RdG8PxBhXnK34vJDea5vUevae9ogdMalsalMsh8iOxKfclDigNl+pffYPhJ3lbH
         d2aTjpdeo0ClFuZz/A/2iWPv6Taj3H4Jj1CAcJrvUIVdyVvG4E2ZKQv2hbTGBcRzQp62
         YleQ==
X-Gm-Message-State: AGi0Puap3NZQ9Yky3GSsrkr06Gl+fOOWwL9hO//C4IF3ouZY9v8H1Z7/
        dYr4hXi1TWPI15i620MGrm38ONoDAOS6qxfPy3jgvpzi
X-Google-Smtp-Source: APiQypJTNqGDzjoT/47iTXQaSfYgDUiMfRdCzM5+Me8hKWHALokI33XTvI+AcEhp6KrA/BQ2/IV+V8vOqgMSqp+zBq0=
X-Received: by 2002:a19:234f:: with SMTP id j76mr5956536lfj.105.1585509463860;
 Sun, 29 Mar 2020 12:17:43 -0700 (PDT)
MIME-Version: 1.0
References: <20200329184111.17469-1-jandryuk@gmail.com>
In-Reply-To: <20200329184111.17469-1-jandryuk@gmail.com>
From:   Jason Andryuk <jandryuk@gmail.com>
Date:   Sun, 29 Mar 2020 15:17:32 -0400
Message-ID: <CAKf6xpub_isHjErmj=7yoxeo=2+CKOm+w8b=AWxE-KLJG5d2Dg@mail.gmail.com>
Subject: Re: Stable request: iwlwifi: mvm: fix non-ACPI function
To:     stable@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Mar 29, 2020 at 2:41 PM Jason Andryuk <jandryuk@gmail.com> wrote:
>
> From: Johannes Berg <johannes.berg@intel.com>
>
> commit 7937fd3227055892e169f4b34d21157e57d919e2 upstream.
>
> The code now compiles without ACPI, but there's a warning since
> iwl_mvm_get_ppag_table() isn't used, and iwl_mvm_ppag_init() must
> not unconditionally fail but return success instead.
>
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
> [Drop hunk removing iwl_mvm_get_ppag_table() since it doesn't exist in
> 5.4]
> Signed-off-by: Jason Andryuk <jandryuk@gmail.com>
> ---
> A 5.4 kernel can't "up" an iwlwifi interface when CONFIG_ACPI=n.
> `wpa_supplicant` or `ip link set wlan0 up` return "No such file or
> directory".  The non-acpi stub iwl_mvm_ppag_init() always returns
> -ENOENT which means iwl_mvm_up() always fails.  Backporting the commit
> lets iwl_mvm_up() succeed.

This stable request is only applicable to 5.4

Fixes 6ce1e5c0c207 "iwlwifi: support per-platform antenna gain"

-Jason
