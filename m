Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9425C1853F7
	for <lists+stable@lfdr.de>; Sat, 14 Mar 2020 03:19:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726443AbgCNCTC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Mar 2020 22:19:02 -0400
Received: from condef-04.nifty.com ([202.248.20.69]:51926 "EHLO
        condef-04.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726414AbgCNCTB (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 Mar 2020 22:19:01 -0400
Received: from conssluserg-01.nifty.com ([10.126.8.80])by condef-04.nifty.com with ESMTP id 02E2CYmI010775
        for <stable@vger.kernel.org>; Sat, 14 Mar 2020 11:12:34 +0900
Received: from mail-vs1-f54.google.com (mail-vs1-f54.google.com [209.85.217.54]) (authenticated)
        by conssluserg-01.nifty.com with ESMTP id 02E2CP2u023350;
        Sat, 14 Mar 2020 11:12:25 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conssluserg-01.nifty.com 02E2CP2u023350
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1584151946;
        bh=GhT3aXuBvPthoFeT4yZR0mqs1IRA+1JuQlU0tGqcrJU=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=kYQwFuACp+DPevM5oQFXs9Ib6OTUSSam0ZTV7rTNcw9h2UmGRpoXSQWJzzWmAFFWa
         /pKr6xsxkhTPXiIpsUAuCSTinXh1eFbsrDVXJT2HlY6oRQsBX1GL7vxRZQ2k3uptTY
         xbz2DLLnIzlc6iTZ9HnYEOVEGpUSaoCnUOXjhaUio3XxRgw9SXeY2jvovk7mOryfj/
         465yfohXBjEKhe6wX4e6IJaigie0xm5M3R0wEgA1XQm1HcafG3Y8LKxL6UKe+Eit3O
         yi8NExOc8SP+qWN5JLR2N/Uo8eHIwDCH9uwHkNiwofQmfJMti2SdP22h3qS4WZCRoF
         82LamnoRKB2/g==
X-Nifty-SrcIP: [209.85.217.54]
Received: by mail-vs1-f54.google.com with SMTP id n27so7675171vsa.0;
        Fri, 13 Mar 2020 19:12:25 -0700 (PDT)
X-Gm-Message-State: ANhLgQ3fr3P+CshaprNTEKBMu5e0HpzULM49LC2t4fF4GYwr5xBkO4+c
        ROb/hwWcZOH0fP39QrzB+9bPtHzLk+hARt/zHsc=
X-Google-Smtp-Source: ADFU+vtaZyYpm3dCRe0vFXfXoe7d1/Tma6ScVCnWx2otGG1rDf5iFDKV1/k6kjd53me7l49arctAbI5aKKSU9W6+5+Q=
X-Received: by 2002:a67:eb91:: with SMTP id e17mr6970094vso.179.1584151944414;
 Fri, 13 Mar 2020 19:12:24 -0700 (PDT)
MIME-Version: 1.0
References: <20200311170120.12641-1-jeyu@kernel.org>
In-Reply-To: <20200311170120.12641-1-jeyu@kernel.org>
From:   Masahiro Yamada <masahiroy@kernel.org>
Date:   Sat, 14 Mar 2020 11:11:48 +0900
X-Gmail-Original-Message-ID: <CAK7LNAT-xdMZbK5UeVvm6S-WNimMMKO3b=jkJsU29z6ULPjs_Q@mail.gmail.com>
Message-ID: <CAK7LNAT-xdMZbK5UeVvm6S-WNimMMKO3b=jkJsU29z6ULPjs_Q@mail.gmail.com>
Subject: Re: [PATCH v2] modpost: move the namespace field in Module.symvers last
To:     Jessica Yu <jeyu@kernel.org>
Cc:     Matthias Maennich <maennich@google.com>,
        Lucas De Marchi <lucas.de.marchi@gmail.com>,
        stable <stable@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Mar 12, 2020 at 2:02 AM Jessica Yu <jeyu@kernel.org> wrote:
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


While I am not opposed to this fix,
I did not even notice Module.symvers was official interface.

Kbuild invokes scripts/depmod.sh to finalize
the 'make modules_install', but I do not see the -E
option being used there.

I do not see Module.symvers installed in
/lib/modules/$(uname -r)/.





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
> diff --git a/scripts/export_report.pl b/scripts/export_report.pl
> index 548330e8c4e7..feb3d5542a62 100755
> --- a/scripts/export_report.pl
> +++ b/scripts/export_report.pl
> @@ -94,7 +94,7 @@ if (defined $opt{'o'}) {
>  #
>  while ( <$module_symvers> ) {
>         chomp;
> -       my (undef, $symbol, $namespace, $module, $gpl) = split('\t');
> +       my (undef, $symbol, $module, $gpl, $namespace) = split('\t');
>         $SYMBOL { $symbol } =  [ $module , "0" , $symbol, $gpl];
>  }
>  close($module_symvers);
> diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
> index a3d8370f9544..e1963ef8c07c 100644
> --- a/scripts/mod/modpost.c
> +++ b/scripts/mod/modpost.c
> @@ -2421,7 +2421,7 @@ static void write_if_changed(struct buffer *b, const char *fname)
>  }
>
>  /* parse Module.symvers file. line format:
> - * 0x12345678<tab>symbol<tab>module[[<tab>export]<tab>something]
> + * 0x12345678<tab>symbol<tab>module<tab>export<tab>namespace
>   **/
>  static void read_dump(const char *fname, unsigned int kernel)
>  {
> @@ -2434,7 +2434,7 @@ static void read_dump(const char *fname, unsigned int kernel)
>                 return;
>
>         while ((line = get_next_line(&pos, file, size))) {
> -               char *symname, *namespace, *modname, *d, *export, *end;
> +               char *symname, *namespace, *modname, *d, *export;
>                 unsigned int crc;
>                 struct module *mod;
>                 struct symbol *s;
> @@ -2442,16 +2442,16 @@ static void read_dump(const char *fname, unsigned int kernel)
>                 if (!(symname = strchr(line, '\t')))
>                         goto fail;
>                 *symname++ = '\0';
> -               if (!(namespace = strchr(symname, '\t')))
> -                       goto fail;
> -               *namespace++ = '\0';
> -               if (!(modname = strchr(namespace, '\t')))
> +               if (!(modname = strchr(symname, '\t')))
>                         goto fail;
>                 *modname++ = '\0';
> -               if ((export = strchr(modname, '\t')) != NULL)
> -                       *export++ = '\0';
> -               if (export && ((end = strchr(export, '\t')) != NULL))
> -                       *end = '\0';
> +               if (!(export = strchr(modname, '\t')))
> +                       goto fail;
> +               *export++ = '\0';
> +               if (!(namespace = strchr(export, '\t')))
> +                       goto fail;
> +               *namespace++ = '\0';
> +
>                 crc = strtoul(line, &d, 16);
>                 if (*symname == '\0' || *modname == '\0' || *d != '\0')
>                         goto fail;
> @@ -2502,9 +2502,9 @@ static void write_dump(const char *fname)
>                                 namespace = symbol->namespace;
>                                 buf_printf(&buf, "0x%08x\t%s\t%s\t%s\t%s\n",
>                                            symbol->crc, symbol->name,
> -                                          namespace ? namespace : "",
>                                            symbol->module->name,
> -                                          export_str(symbol->export));
> +                                          export_str(symbol->export),
> +                                          namespace ? namespace : "");
>                         }
>                         symbol = symbol->next;
>                 }
> --
> 2.16.4
>


-- 
Best Regards
Masahiro Yamada
