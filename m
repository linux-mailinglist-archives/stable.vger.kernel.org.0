Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC8621DA955
	for <lists+stable@lfdr.de>; Wed, 20 May 2020 06:38:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726463AbgETEit (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 May 2020 00:38:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726379AbgETEis (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 May 2020 00:38:48 -0400
Received: from mail-oi1-x244.google.com (mail-oi1-x244.google.com [IPv6:2607:f8b0:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E071C061A0F
        for <stable@vger.kernel.org>; Tue, 19 May 2020 21:38:44 -0700 (PDT)
Received: by mail-oi1-x244.google.com with SMTP id r25so1849241oij.4
        for <stable@vger.kernel.org>; Tue, 19 May 2020 21:38:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/gvGtY5nqJXPbJ1LBsOILjTaDTKNBUV9oTxyk5neDx8=;
        b=dfrdutoU73QiEI7RWhK3Xq9DKlTgEjQ31RRM66E++uRGGez1lIqk/qtQ6nML+l2lZs
         USS7DkFQNTMxvkSA6GtCDuIxqfw0+hctBd7BT2ZqOlAPoPaCtDBsENa2oeLGb7jq8L7x
         7uPnwTa5kqPTFR3E0k4uizFSdSWlFZfZycmtLC0dR4psle5GcCHgAvqTUNW8kWA7qOmn
         L/B0MY1Z3P8UtYz2P6SnWc9qNRvmDximS79CwuLQGp51YGcQIjbjUwRdw5zifkUd7iPA
         6dnNZT8JjtUBMG48gD0jlWbAA7NJXR7qigrkMF66XYS1/QSMKrLrxdKgEIzfyH7L/Z3p
         mFyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/gvGtY5nqJXPbJ1LBsOILjTaDTKNBUV9oTxyk5neDx8=;
        b=VlCNd9p+NsWEPmiE3DMLy25KbiHPcq1FzE3hEcNngftpf8FJ/tezv3A3orQanRpEUZ
         VfCfkE1tq5ACxEtNrTkYjeIErYB2+v8smp2PhD8CvKUq/dKjJSh6ozPPRTt/m4JOH4L4
         chz6fIf1ruf3PubuvKNZ/hDWiP/eAEoeZZqfymzwtvL2pUmu59oqoriHYRB+RYTC1GXN
         oE2muxXYeADCCc1UX7aI1nrwlf4w7FJdzALUkhRbtC0Zy4XvwvBoL3lLfYrh+enl/FkI
         BmyNYjY106l1p/wMzHtcrQfMAZu/Gm9TFY7OcjW8mXO5dH2m9E+Gk/oVoiGDaDhca9se
         dpVA==
X-Gm-Message-State: AOAM530C3RGbV7WVpozy2rEIFZWsDsLrsjelKPnpKhLxhOV22Z+UZ9Xe
        9OqAR3Sfkny5NoFBpx2xQ7ZIO0pLlfbbhrLO1QznXCQ0
X-Google-Smtp-Source: ABdhPJz9Do6JGTC2Xjtyghaq1P404WN1SjGSsMaszjfbRq1bSzqPkD5zd4sCBRDHzeDX5e2szj+lCQlb49uh9ew8Mz4=
X-Received: by 2002:aca:f1c2:: with SMTP id p185mr1986908oih.69.1589949523526;
 Tue, 19 May 2020 21:38:43 -0700 (PDT)
MIME-Version: 1.0
References: <20200520043626.181820-1-saravanak@google.com>
In-Reply-To: <20200520043626.181820-1-saravanak@google.com>
From:   Saravana Kannan <saravanak@google.com>
Date:   Tue, 19 May 2020 21:38:07 -0700
Message-ID: <CAGETcx9hYrnMF8JU+KV6jvxExq3jYgdg4Z_-TyjN4RUQnV8qvA@mail.gmail.com>
Subject: Re: [PATCH v1] driver core: Fix handling of SYNC_STATE_ONLY +
 STATELESS device links
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Saravana Kannan <saravanak@google.com>
Cc:     Android Kernel Team <kernel-team@android.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 19, 2020 at 9:36 PM Saravana Kannan <saravanak@google.com> wrote:
>
> Commit 21c27f06587d ("driver core: Fix SYNC_STATE_ONLY device link
> implementation") didn't completely fix STATELESS + SYNC_STATE_ONLY
> handling.
>
> What looks like an optimization in that commit is actually a bug that
> causes an if condition to always take the else path. This prevents
> reordering of devices in the dpm_list when a DL_FLAG_STATELESS device
> link is create on top of an existing DL_FLAG_SYNC_STATE_ONLY device
> link.
>
> Fixes: 21c27f06587d ("driver core: Fix SYNC_STATE_ONLY device link implementation")
> Signed-off-by: Saravana Kannan <saravanak@google.com>
> ---
> Sigh... device links are tricky and hard! Sorry about the endless fixes :(
> Also, how was this not caught by the compiler as a warning?
>
> -Saravana
>
>  drivers/base/core.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/base/core.c b/drivers/base/core.c
> index 83a3e0b62ce3..dfd4e94ef790 100644
> --- a/drivers/base/core.c
> +++ b/drivers/base/core.c
> @@ -543,12 +543,14 @@ struct device_link *device_link_add(struct device *consumer,
>
>                 if (flags & DL_FLAG_STATELESS) {
>                         kref_get(&link->kref);
> -                       link->flags |= DL_FLAG_STATELESS;
>                         if (link->flags & DL_FLAG_SYNC_STATE_ONLY &&
> -                           !(link->flags & DL_FLAG_STATELESS))
> +                           !(link->flags & DL_FLAG_STATELESS)) {
> +                               link->flags |= DL_FLAG_STATELESS;
>                                 goto reorder;
> -                       else
> +                       } else {
> +                               link->flags |= DL_FLAG_STATELESS;
>                                 goto out;
> +                       }
>                 }
>
>                 /*

Forgot to add stable@vger.kernel.org. Doing that now.

-Saravana
