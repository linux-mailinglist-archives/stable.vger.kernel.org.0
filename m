Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23F624BAFA4
	for <lists+stable@lfdr.de>; Fri, 18 Feb 2022 03:25:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231579AbiBRCXe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Feb 2022 21:23:34 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:34426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231583AbiBRCXd (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Feb 2022 21:23:33 -0500
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AF0710875B
        for <stable@vger.kernel.org>; Thu, 17 Feb 2022 18:23:17 -0800 (PST)
Received: by mail-pl1-x62d.google.com with SMTP id x11so6026357pll.10
        for <stable@vger.kernel.org>; Thu, 17 Feb 2022 18:23:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=qlFCJvtsoFhAC6B656rI4CAiTCAEIaN9fza+d6cKKMA=;
        b=CyYDFXBqfqTrwf+t/blLpQF1qdF8hDUp8Zldfrdo1atusmBe5YIAUmmYLMAw7hODXO
         fD4hM5rgp+mABfwbmFYG+9yq9NfSK8Et6/+Zh8ox3kHodMfZ4n2e1i2D2y22Hy+0JP1f
         xSJAApVmCgJdBctnUf2I+n61wZI0Luh7zUDIS8EuwNm8wn7C9lByy4nFeVTReXZOLus6
         tSa6eEjFdgaz0FiHnSQZsNVnEngv7O/TEqxyJ2ma6ZY7PYhiOxgehLajk2Z55ST8CJj/
         GRGe8S4/4zuf78TToby71Y50Xq3za+ntB+2UQ4rr5z80C/9VeHXZjSN+D0RtRv280jkW
         mjoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=qlFCJvtsoFhAC6B656rI4CAiTCAEIaN9fza+d6cKKMA=;
        b=RHVJJ9FMebQPoUjfChk+vkm6cvrO0MC5KJyerh/hlUhE8S7g1on9F2g7xAJOWLhTVs
         LmYXA3TbZTS0EdsgvacEUn9O47awab7tTajpHT1mQK9D6rl+mjjFa4ORJHjdlypHIkcY
         tSw2wQU37S4fAWYfcHIuX59RfORecggoWaQJkCFdiO3kOdUwb3Jpj2/d+7XVmRP5wHm3
         +SIQCjGztdTjJeGnJlpHdHd7WASP1PqI3DxhwCQdlcyvU0UJH7XqQuzcBZoMjhfu463A
         xoEP40ZGua3xZ9/1m5q9KXdsjG677RmTzUqIUsPxchvCvtrrIAIry0k8qD0AG5tteHXz
         uHeg==
X-Gm-Message-State: AOAM530ytxDXQF/hxVOaCnReazoG3OiWAyMBwtC27B98Q+UgcwJQ8v9x
        96WOE1UcaQrzTQIBjPLrb3A=
X-Google-Smtp-Source: ABdhPJx3x17nbBroJaprM83J1GVuaHoaC4PRj6D2q5DpC1wjv+ba8i0tP7pt0A8XfOXrrZELqFw7Nw==
X-Received: by 2002:a17:902:b105:b0:149:7c20:c15b with SMTP id q5-20020a170902b10500b001497c20c15bmr5326157plr.173.1645150996581;
        Thu, 17 Feb 2022 18:23:16 -0800 (PST)
Received: from smtpclient.apple (c-24-6-216-183.hsd1.ca.comcast.net. [24.6.216.183])
        by smtp.gmail.com with ESMTPSA id a38sm860329pfx.121.2022.02.17.18.23.15
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 17 Feb 2022 18:23:16 -0800 (PST)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 15.0 \(3693.40.0.1.81\))
Subject: Re: [PATCH] userfaultfd: mark uffd_wp regardless of VM_WRITE flag
From:   Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <Yg79WMuYLS1sxASL@xz-m1.local>
Date:   Thu, 17 Feb 2022 18:23:14 -0800
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Linux-MM <linux-mm@kvack.org>,
        Mike Rapoport <rppt@linux.vnet.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>, stable@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <BDBC90F4-22E1-48CC-9DB8-773C044F0231@gmail.com>
References: <20220217211602.2769-1-namit@vmware.com>
 <Yg79WMuYLS1sxASL@xz-m1.local>
To:     Peter Xu <peterx@redhat.com>
X-Mailer: Apple Mail (2.3693.40.0.1.81)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



> On Feb 17, 2022, at 5:58 PM, Peter Xu <peterx@redhat.com> wrote:
>=20
> Hello, Nadav,
>=20
> On Thu, Feb 17, 2022 at 09:16:02PM +0000, Nadav Amit wrote:
>> From: Nadav Amit <namit@vmware.com>
>>=20
>> When a PTE is set by UFFD operations such as UFFDIO_COPY, the PTE is
>> currently only marked as write-protected if the VMA has VM_WRITE flag
>> set. This seems incorrect or at least would be unexpected by the =
users.
>>=20
>> Consider the following sequence of operations that are being =
performed
>> on a certain page:
>>=20
>> 	mprotect(PROT_READ)
>> 	UFFDIO_COPY(UFFDIO_COPY_MODE_WP)
>> 	mprotect(PROT_READ|PROT_WRITE)
>=20
> No objection to the patch, however I'm wondering why this is a valid =
use
> case because mprotect seems to be conflict with uffd, because AFAICT
> mprotect(PROT_READ|PROT_WRITE) can already grant write bit.
>=20
> In change_pte_range():
>=20
>        if (dirty_accountable && pte_dirty(ptent) &&
>                        (pte_soft_dirty(ptent) ||
>                                !(vma->vm_flags & VM_SOFTDIRTY))) {
>                ptent =3D pte_mkwrite(ptent);
>        }

I think you are right, and an additional patch is needed to prevent
mprotect() from making an entry writable if the PTE has _PAGE_UFFD_WP
set and uffd_wp_resolve was not provided. I missed that.

I=E2=80=99ll post another patch for this one.

>=20
> PS: I always think here the VM_SOFTDIRTY check is wrong, IMHO it =
should be:
>=20
>        if (dirty_accountable && pte_dirty(ptent) &&
>                        (pte_soft_dirty(ptent) ||
>                        (vma->vm_flags & VM_SOFTDIRTY))) {
>                ptent =3D pte_mkwrite(ptent);
>        }
>=20
> Because when VM_SOFTDIRTY is cleared it means soft dirty enabled.  I =
wanted
> to post a patch but I never yet.

Seems that you are right. Yet, having this wrong code around for
some time raises the concern whether something will break. By the
soft-dirty I saw so far, it seems that it is not commonly used.

> Could I ask why you need mprotect() with uffd?

Sure. I think I mentioned it before, that I want to use userfaultfd
for other processes [1], by having one monitor UFFD for multiple
processes that handles their swap/prefetch activities based on custom
policies.

I try to set the least amount of constraints on what these processes
might do, and mprotect() is something they are allowed to do.

I would hopefully send the patches that are required for all of that
and open source my code soon. In the meanwhile I try to upstream the
least controversial parts.

[1] https://lore.kernel.org/linux-mm/YWZCClDorCCM7KMG@t490s/t/

