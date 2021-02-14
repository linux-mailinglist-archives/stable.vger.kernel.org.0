Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98F1C31B278
	for <lists+stable@lfdr.de>; Sun, 14 Feb 2021 21:42:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229936AbhBNUlz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Feb 2021 15:41:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229929AbhBNUlw (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 14 Feb 2021 15:41:52 -0500
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE72DC061786
        for <stable@vger.kernel.org>; Sun, 14 Feb 2021 12:41:09 -0800 (PST)
Received: by mail-pf1-x42e.google.com with SMTP id d26so2983611pfn.5
        for <stable@vger.kernel.org>; Sun, 14 Feb 2021 12:41:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:content-transfer-encoding:in-reply-to:references
         :subject:from:cc:to:date:message-id:user-agent;
        bh=oYWxFLLPa20HjzofwDUkJ1EEbixGS+NkoQgDgfKUETc=;
        b=I7TWaZ0IQ/mcqitf4XKHiE0MDu82wOyAOt7KflGP4IbCgV8a8C11FQ0AVN0RioMV4L
         gSvTo5PklY3swS5HCsxJnBq5LvbsRH0FSejiB08PUlEOLSjmYAsObgaQMn4VQVZWCT5t
         /4gUvtmkZr7oNdlAru+OOBZFou85YY7ZartPc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:content-transfer-encoding
         :in-reply-to:references:subject:from:cc:to:date:message-id
         :user-agent;
        bh=oYWxFLLPa20HjzofwDUkJ1EEbixGS+NkoQgDgfKUETc=;
        b=C1DLhHk1aV7GFcwHW9dQDC+NFrDcRCblfdpVVXBZlfdteb2ujhQ8GbyvqgGE7ywXFj
         PgN7BPrZS7JBiC87Bo9tRWb8FefcX9f6wg3cbOLPG80GKulf2lfWyAn2+t1AZLYtO54Z
         mA/ntupmIe0ndEJg0ohPJfrGglQt6msrPc9K/VDJs4JHzvxtFYV3ufiPJfBw3zQ85lXf
         XTUOfxAhAhQyVXcbLhf2hPy1iW3ukKtY9H/Wc9sy42H3aAE3iAOLquOpfJBj6wHLHrJ+
         OqmVetI3a0oOQY/9nQv+XC10NY/7WW5VAc7eJGKe3Nm2FGelkbtLHqXkTCDsyIXhglMU
         RIjg==
X-Gm-Message-State: AOAM532WhxH9+8dy5Q0QYteJeqvvAtcbs30F0F0rhsLZ1qybqjz5B91Y
        PW5rqlyEYqP+yOBa6ytoxmSHjg==
X-Google-Smtp-Source: ABdhPJwU1CEqdqXbPVs359oHWT23f41TunkKUGhcpUDmdM0EpMyqFOwzRty8kv7MzmvBty9gvumwYw==
X-Received: by 2002:a63:f956:: with SMTP id q22mr4584400pgk.115.1613335269610;
        Sun, 14 Feb 2021 12:41:09 -0800 (PST)
Received: from chromium.org ([2620:15c:202:201:5849:e2a:a78c:51ce])
        by smtp.gmail.com with ESMTPSA id 137sm9922709pgb.80.2021.02.14.12.41.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 Feb 2021 12:41:09 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <YCla7cNQxBoG2KCr@kroah.com>
References: <20201207170533.10738-1-mark.rutland@arm.com> <202012081319.D5827CF@keescook> <X9DkdTGAiAEfUvm5@kroah.com> <161300376813.1254594.5196098885798133458@swboyd.mtv.corp.google.com> <YCU9zoiw8EZktw5U@kroah.com> <161306959090.1254594.16358795480052823449@swboyd.mtv.corp.google.com> <YCla7cNQxBoG2KCr@kroah.com>
Subject: Re: [PATCH] lkdtm: don't move ctors to .rodata
From:   Stephen Boyd <swboyd@chromium.org>
Cc:     Kees Cook <keescook@chromium.org>,
        Mark Rutland <mark.rutland@arm.com>,
        linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        stable@vger.kernel.org
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date:   Sun, 14 Feb 2021 12:41:07 -0800
Message-ID: <161333526750.1254594.7267322236004310547@swboyd.mtv.corp.google.com>
User-Agent: alot/0.9.1
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Quoting Greg Kroah-Hartman (2021-02-14 09:16:29)
> On Thu, Feb 11, 2021 at 10:53:10AM -0800, Stephen Boyd wrote:
> >=20
> > Sorry for the confusion. Can commit 655389666643 ("vmlinux.lds.h: Create
> > section for protection against instrumentation") and commit 3f618ab33234
> > ("lkdtm: don't move ctors to .rodata") be backported to 5.4.y and only
> > commit 3f618ab3323407ee4c6a6734a37eb6e9663ebfb9 be backported to 5.10.y?
>=20
> 655389666643 ("vmlinux.lds.h: Create section for protection against
> instrumentation") does not apply cleanly to 5.4.y, so can you provide a
> working backport for both of those patches to 5.4.y that you have
> tested?
>=20

Ok, will do.
