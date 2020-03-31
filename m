Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F749198BEF
	for <lists+stable@lfdr.de>; Tue, 31 Mar 2020 07:49:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726236AbgCaFta (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Mar 2020 01:49:30 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:54527 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726001AbgCaFta (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 31 Mar 2020 01:49:30 -0400
Received: by mail-wm1-f65.google.com with SMTP id c81so1097294wmd.4;
        Mon, 30 Mar 2020 22:49:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=akp0u+2EZyjkXRTktFBRie6W2QUhVt5xzpZQY3EmKZ4=;
        b=n3k/+bcR5fXnorrLNk9E9DgQ9LST30+ImuiExFAaJZBkpD65aZaGCJMrZVSaa/6hrR
         jm91dr/6lOj2gyRE8dKFzd1Xn0Ti0ROG+3FdmgvIYCY0m1l11//MUz4ucSM6WySg7TsV
         kqkNfR9RE/IPcsMEXzB4BCnlvW7+ZpjMZRT1yrfQ1qMi2Se7hwtR9YFxizmjQHtfVvop
         lwNQSoDSVjnALkt29L5ylyHnLukf9jvMRKPfkgUoF4ArfDZ9E7pHTF6NcnSCEjspwn0l
         ftYf/oBaVvX6yDJAy0yuB0Kq3q3jBuEyv6Q7F2O7OQdsxr7jgLLB+bKilbcOZ+KdwWTq
         ZbEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=akp0u+2EZyjkXRTktFBRie6W2QUhVt5xzpZQY3EmKZ4=;
        b=idMkB8KgVnCCeBdKndc89dN6/Nm28FUE2/NSIryAqVCVMWhPHGT9lHf++Hs3p1SfkM
         zuQupnlNbAwNXuU+9fmWweFpBFu+u6vJZnAlhnuJJqB8hzcXzMUaMJW07xjg6o5KZprF
         nAh2SxwycwST3zAlELslC+Ulq13l4BZt9YPD5RMfCimfRKTZu/crwYJ5jszZiXWdxJDp
         eQJv+OFmIx4yxtzMh2JrndWKqdeggaJpiY6eSkeRgiBVdxmg1L4VU0Wu2yL9Y8ygihzL
         lYSYON5yDlvPiNX0jQaqgQvnhbrChjMzDdfnEvuj7Bmi2hJmaLx+YYwenAFBQy0kPM/C
         fxpg==
X-Gm-Message-State: ANhLgQ06vlCVG0QFDeqlRbg2g+0JmVeNA3411aeFPNMcm2YpHjo7XDTO
        nDDsrNs2dTVoXkP4K/wRY7kuGgRQn7O9foYjtGM=
X-Google-Smtp-Source: ADFU+vsPPBv4f6I083Yyts7nUfgkFzoUhNZuiaOjBTjlUJOP4wyhd8d9kI7/WifpTUwypco1pr5vwCTfHvkL8Ae5PQc=
X-Received: by 2002:a1c:b642:: with SMTP id g63mr1552422wmf.108.1585633768060;
 Mon, 30 Mar 2020 22:49:28 -0700 (PDT)
MIME-Version: 1.0
References: <20200311170120.12641-1-jeyu@kernel.org>
In-Reply-To: <20200311170120.12641-1-jeyu@kernel.org>
From:   John Stultz <john.stultz@linaro.org>
Date:   Mon, 30 Mar 2020 22:49:17 -0700
Message-ID: <CANcMJZDhSUV8CU_ixOSxstVVBMW3rVrrQVYMmy1fz=OdhxA_GQ@mail.gmail.com>
Subject: Re: [PATCH v2] modpost: move the namespace field in Module.symvers last
To:     Jessica Yu <jeyu@kernel.org>
Cc:     Masahiro Yamada <yamada.masahiro@socionext.com>,
        Matthias Maennich <maennich@google.com>,
        Lucas De Marchi <lucas.de.marchi@gmail.com>,
        stable@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 11, 2020 at 10:03 AM Jessica Yu <jeyu@kernel.org> wrote:
>
> In order to preserve backwards compatability with kmod tools, we have to
> move the namespace field in Module.symvers last, as the depmod -e -E
> option looks at the first three fields in Module.symvers to check symbol
> versions (and it's expected they stay in the original order of crc,
> symbol, module).
>
> In addition, update an ancient comment above read_dump() in modpost that
> suggested that the export type field in Module.symvers was optional. I
> suspect that there were historical reasons behind that comment that are
> no longer accurate. We have been unconditionally printing the export
> type since 2.6.18 (commit bd5cbcedf44), which is over a decade ago now.
>
> Fix up read_dump() to treat each field as non-optional. I suspect the
> original read_dump() code treated the export field as optional in order
> to support pre <= 2.6.18 Module.symvers (which did not have the export
> type field). Note that although symbol namespaces are optional, the
> field will not be omitted from Module.symvers if a symbol does not have
> a namespace. In this case, the field will simply be empty and the next
> delimiter or end of line will follow.
>
> Cc: stable@vger.kernel.org
> Fixes: cb9b55d21fe0 ("modpost: add support for symbol namespaces")
> Tested-by: Matthias Maennich <maennich@google.com>
> Reviewed-by: Matthias Maennich <maennich@google.com>
> Reviewed-by: Lucas De Marchi <lucas.demarchi@intel.com>
> Signed-off-by: Jessica Yu <jeyu@kernel.org>
> ---
> v2:
>
>   - Explain the changes to read_dump() and the comment (and provide
>     historical context) in the commit message. (Lucas De Marchi)
>
>  Documentation/kbuild/modules.rst |  4 ++--
>  scripts/export_report.pl         |  2 +-
>  scripts/mod/modpost.c            | 24 ++++++++++++------------
>  3 files changed, 15 insertions(+), 15 deletions(-)
>
> diff --git a/Documentation/kbuild/modules.rst b/Documentation/kbuild/modules.rst
> index 69fa48ee93d6..e0b45a257f21 100644
> --- a/Documentation/kbuild/modules.rst
> +++ b/Documentation/kbuild/modules.rst
> @@ -470,9 +470,9 @@ build.
>
>         The syntax of the Module.symvers file is::
>
> -       <CRC>       <Symbol>          <Namespace>  <Module>                         <Export Type>
> +       <CRC>       <Symbol>         <Module>                         <Export Type>     <Namespace>
>
> -       0xe1cc2a05  usb_stor_suspend  USB_STORAGE  drivers/usb/storage/usb-storage  EXPORT_SYMBOL_GPL
> +       0xe1cc2a05  usb_stor_suspend drivers/usb/storage/usb-storage  EXPORT_SYMBOL_GPL USB_STORAGE
>
>         The fields are separated by tabs and values may be empty (e.g.
>         if no namespace is defined for an exported symbol).

Despite the documentation here claiming the namespace field can be
empty, I'm seeing some trouble with this patch when building external
modules:
  FATAL: parse error in symbol dump file

I've confirmed reverting it make things work again, but its not clear
to me quite yet why.

The only difference I can find is that the Module.symvers in the
external module project doesn't seem to have a tab at the end of each
line (where as Module.symvers for the kernel - which doesn't seem to
have any namespace names - does).

Is there something I need to tweak on the external Kbuild to get
Module.symvers to be generated properly (with the empty tab at the
end) for this new change?
Or does the parser need to be a bit more flexible?

thanks
-john
