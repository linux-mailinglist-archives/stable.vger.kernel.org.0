Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EA411EC214
	for <lists+stable@lfdr.de>; Tue,  2 Jun 2020 20:46:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727946AbgFBSqo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Jun 2020 14:46:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726139AbgFBSqo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Jun 2020 14:46:44 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE53CC08C5C0
        for <stable@vger.kernel.org>; Tue,  2 Jun 2020 11:46:43 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id ga6so1863802pjb.1
        for <stable@vger.kernel.org>; Tue, 02 Jun 2020 11:46:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=d4Fn6K9sSJmLeIDx+5ZYAe4QSbvn6y+nwpagCeGiUag=;
        b=eKdiwwUZgObjzDiAaWXu1fITlLXmWFNVxyer43d44+MrNvL++Xiz3qSBGvd3qGRHjI
         Tttx99hIYk/PtTW7oaCImk873psV+O0OzGhBXZ/uP9j5e0HmzUb/zO/QWkfmFl2vI2Kx
         PJB9AzlQsUHdGfyk1Q1wimhqFQbpxBSBHlBtOPR+Jsot0TQVv/8KFMZ0z76tCvV50LQW
         DWjAQ0Dr3AHCr/t/5eDi1u7XwiAkTtGOa01iij+qy8b+nONExiTZz0fOchK5yF/tO5zp
         hVKs02MSt1EtfZRUA3Qu/ce5Dk2Z/2sDkv60pJ4ehO06t140xSTjfjem19mVvbE+RZte
         VtDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=d4Fn6K9sSJmLeIDx+5ZYAe4QSbvn6y+nwpagCeGiUag=;
        b=CXkSkx/rBQvtPJ88mkmwCIpQDuxHP4c/GS8t30GVocELGLfWiWsQc6iyNeJfQ4vfNF
         yl3+g0ENcFIbQA46sX2kChJLwoF4rddjldaUqTkkrq22KKW6+ySqqvEm+t2VkMjMQrlz
         UD+3/vqmZM7j4j1jlGTOjyQkYkJGStz3zNwWq4aTtgzgaxUXlLJW0sjJ8pxAe3imWFlf
         2nKGD0DxkSZSfG8fvz3wnhW7IHWOyAWENs8T1sb40feJ6yam0BPtXC0rbf9jAYd8//IO
         cKaD/F8HsAaVVomXK2y6yNYwq7aCZnwqb9N12ljDVxpArd0Acn/PlFpr1Azll7M1n8/l
         XAgA==
X-Gm-Message-State: AOAM530LtfaQ67G/M0dAwlm36qll0GIxbG8rbXwPxqQ8bizu2P7R3O+n
        9ET9IiXfUuHoXJPOiUlrVHk+1qSOQ3TRN/7E8zys2w==
X-Google-Smtp-Source: ABdhPJxnlzDD9LjX8NOXuBt0jcdY2ooVkC2hieTEZiEeTaqVi66E5hIZf0OS4CPzGdPPb39vpov2an7eKEIF2KO3vvA=
X-Received: by 2002:a17:902:341:: with SMTP id 59mr24917643pld.119.1591123603136;
 Tue, 02 Jun 2020 11:46:43 -0700 (PDT)
MIME-Version: 1.0
References: <CAMj1kXErFuvOoG=DB6sz5HBvDuHDiKwWD8uOyLuxaX-u8-+dbA@mail.gmail.com>
 <20200601231805.207441-1-ndesaulniers@google.com> <BYAPR11MB30969737340044437013BF44F08B0@BYAPR11MB3096.namprd11.prod.outlook.com>
In-Reply-To: <BYAPR11MB30969737340044437013BF44F08B0@BYAPR11MB3096.namprd11.prod.outlook.com>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Tue, 2 Jun 2020 11:46:31 -0700
Message-ID: <CAKwvOdmsCmPFiDOq7AYUyEx=60B=qo8u9yhnJDQ6nd6Ew7xDkQ@mail.gmail.com>
Subject: Re: [PATCH] ACPICA: fix UBSAN warning using __builtin_offsetof
To:     "Kaneda, Erik" <erik.kaneda@intel.com>
Cc:     "Moore, Robert" <robert.moore@intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        Len Brown <lenb@kernel.org>, Ard Biesheuvel <ardb@kernel.org>,
        "dvyukov@google.com" <dvyukov@google.com>,
        "glider@google.com" <glider@google.com>,
        "guohanjun@huawei.com" <guohanjun@huawei.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lorenzo.pieralisi@arm.com" <lorenzo.pieralisi@arm.com>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "pcc@google.com" <pcc@google.com>,
        "rjw@rjwysocki.net" <rjw@rjwysocki.net>,
        "will@kernel.org" <will@kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "devel@acpica.org" <devel@acpica.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 1, 2020 at 5:03 PM Kaneda, Erik <erik.kaneda@intel.com> wrote:
>
>
> Hi,
>
> > Will reported UBSAN warnings:
> > UBSAN: null-ptr-deref in drivers/acpi/acpica/tbfadt.c:459:37
> > UBSAN: null-ptr-deref in arch/arm64/kernel/smp.c:596:6
> >
> > Looks like the emulated offsetof macro ACPI_OFFSET is causing these. We
> > can avoid this by using the compiler builtin, __builtin_offsetof.
>
> I'll take a look at this tomorrow
> >
> > The non-kernel runtime of UBSAN would print:
> > runtime error: member access within null pointer of type for this macro.
>
> actypes.h is owned by ACPICA so we typically do not allow compiler-specific
> extensions because the code is intended to be compiled using the C99 standard
> without compiler extensions. We could allow this sort of thing in a Linux-specific
> header file like include/acpi/platform/aclinux.h but I'll take a look at the error as well..

If I'm not allowed to touch that header, it looks like I can include
<linux/stddef.h> (rather than my host's <stddef.h>) to get a
definition of `offsetof` thats implemented in terms of
`__builtin_offsetof`.  I should be able to use that to replace uses of
ACPI_OFFSET.  Are any of these off limits?

$ grep -rn ACPI_OFFSET
arch/arm64/include/asm/acpi.h:34:#define ACPI_MADT_GICC_MIN_LENGTH
ACPI_OFFSET(  \
arch/arm64/include/asm/acpi.h:41:#define ACPI_MADT_GICC_SPE
(ACPI_OFFSET(struct acpi_madt_generic_interrupt, \
include/acpi/actbl.h:376:#define ACPI_FADT_OFFSET(f)             (u16)
ACPI_OFFSET (struct acpi_table_fadt, f)
drivers/acpi/acpica/acresrc.h:84:#define ACPI_RS_OFFSET(f)
  (u8) ACPI_OFFSET (struct acpi_resource,f)
drivers/acpi/acpica/acresrc.h:85:#define AML_OFFSET(f)
  (u8) ACPI_OFFSET (union aml_resource,f)
drivers/acpi/acpica/acinterp.h:17:#define ACPI_EXD_OFFSET(f)
(u8) ACPI_OFFSET (union acpi_operand_object,f)
drivers/acpi/acpica/acinterp.h:18:#define ACPI_EXD_NSOFFSET(f)
(u8) ACPI_OFFSET (struct acpi_namespace_node,f)
drivers/acpi/acpica/rsdumpinfo.c:16:#define ACPI_RSD_OFFSET(f)
 (u8) ACPI_OFFSET (union acpi_resource_data,f)
drivers/acpi/acpica/rsdumpinfo.c:17:#define ACPI_PRT_OFFSET(f)
 (u8) ACPI_OFFSET (struct acpi_pci_routing_table,f)

-- 
Thanks,
~Nick Desaulniers
