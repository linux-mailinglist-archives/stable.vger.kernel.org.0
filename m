Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A22029F4CE
	for <lists+stable@lfdr.de>; Thu, 29 Oct 2020 20:20:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725802AbgJ2TUl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Oct 2020 15:20:41 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:39904 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725797AbgJ2TUT (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Oct 2020 15:20:19 -0400
Received: from mail-wm1-f71.google.com ([209.85.128.71])
        by youngberry.canonical.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <dann.frazier@canonical.com>)
        id 1kYDT7-0000K9-Je
        for stable@vger.kernel.org; Thu, 29 Oct 2020 19:20:17 +0000
Received: by mail-wm1-f71.google.com with SMTP id 13so309196wmf.0
        for <stable@vger.kernel.org>; Thu, 29 Oct 2020 12:20:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fSpEqDiCWW2XgNms6YKEcPAbY3xOvExtPWJEAK2eLxk=;
        b=c8sJ+UFlz0scCJbnrFhcP+axVvssMakD6Vd2g9RZgb58yRU7jjpdah1YRAgGY6sxka
         sZ5dUdCEINZ6d6BnLKPHtR2Jq08duQAWLkEXWsgidXeutIIhWnalFcnaXRqLQjqfATTm
         vFsu56mXIxWgJrZv9Gd5X1VYQ8iIQLdmCPm+HMHCgAO+rWSuUIP1gMSihK7Olz0ZpgSr
         u4CH3YtARifHogOYqWKNOsoNiqI7Ncvoop/qhZOHHsVnV8p6PEFfo/nIvvcLQBCfC3FV
         ZfGaItdUjFeb1qQAycGHP4eOTuLNPCUeDzrZrRFurVySq2wQx1yOoFyg7zgsaU0Flswb
         2uoQ==
X-Gm-Message-State: AOAM532mr5w4tkXPSK0SIwFScFy4O3/0KdbIA85Or24W9CwGn39Q5X8k
        8iV9UIUqwH+gsPrU1tZjlF0xUQB9C5FsdPcckNPndUv4whLj0b6hd5sPhpoJ9AfC+pj461R0++g
        uNbJLDKTt3XPdEt2I8iJEYU5++S/YaNydUGMcJqud1R8ITjVo8g==
X-Received: by 2002:adf:edc6:: with SMTP id v6mr7503618wro.273.1603999217234;
        Thu, 29 Oct 2020 12:20:17 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz6onw9wNHT0ytBnKx5KEC6HF1FyzV0O1Lcug7lK6zG/26VKNtSmQoCIr0fJsfFa7WXE4WmbqKF0FFqj92fP/g=
X-Received: by 2002:adf:edc6:: with SMTP id v6mr7503594wro.273.1603999216980;
 Thu, 29 Oct 2020 12:20:16 -0700 (PDT)
MIME-Version: 1.0
References: <20201029175442.564282-1-dann.frazier@canonical.com> <20201029191923.GB988039@kroah.com>
In-Reply-To: <20201029191923.GB988039@kroah.com>
From:   dann frazier <dann.frazier@canonical.com>
Date:   Thu, 29 Oct 2020 13:20:06 -0600
Message-ID: <CALdTtnuh9=JMwZ8LhBQwAFtLSg_kbB=5ctz21KkMwGRCNmwOMg@mail.gmail.com>
Subject: Re: [PATCH 4.4-5.9] efivarfs: Replace invalid slashes with
 exclamation marks in dentries.
To:     Greg KH <greg@kroah.com>
Cc:     stable@vger.kernel.org, Michael Schaller <misch@google.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Jeremy Kerr <jk@ozlabs.org>, linux-efi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 29, 2020 at 1:18 PM Greg KH <greg@kroah.com> wrote:
>
> On Thu, Oct 29, 2020 at 11:54:42AM -0600, dann frazier wrote:
> > From: Michael Schaller <misch@google.com>
> >
> > commit 336af6a4686d885a067ecea8c3c3dd129ba4fc75 upstream
> >
> > Without this patch efivarfs_alloc_dentry creates dentries with slashes in
> > their name if the respective EFI variable has slashes in its name. This in
> > turn causes EIO on getdents64, which prevents a complete directory listing
> > of /sys/firmware/efi/efivars/.
> >
> > This patch replaces the invalid shlashes with exclamation marks like
> > kobject_set_name_vargs does for /sys/firmware/efi/vars/ to have consistently
> > named dentries under /sys/firmware/efi/vars/ and /sys/firmware/efi/efivars/.
> >
> > Signed-off-by: Michael Schaller <misch@google.com>
> > Link: https://lore.kernel.org/r/20200925074502.150448-1-misch@google.com
> > Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
>
> Any reason you are not signing off on this?

No, sorry:

Signed-off-by: dann frazier <dann.frazier@canonical.com>

Easier if I send a v2?

  -dann

> :(
>
