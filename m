Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A0917168C83
	for <lists+stable@lfdr.de>; Sat, 22 Feb 2020 06:23:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726230AbgBVFXr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Feb 2020 00:23:47 -0500
Received: from mail-qk1-f193.google.com ([209.85.222.193]:35966 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726189AbgBVFXr (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Feb 2020 00:23:47 -0500
Received: by mail-qk1-f193.google.com with SMTP id f3so1028053qkh.3
        for <stable@vger.kernel.org>; Fri, 21 Feb 2020 21:23:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=lca.pw; s=google;
        h=content-transfer-encoding:from:mime-version:date:subject:message-id
         :cc:to;
        bh=IBBznMQ3bpiql9lX29jMw8rTRB5UTkasssHzmZ7+M1c=;
        b=LrZLayjPzm6EQLYSudY/2Rq4gWifOId4PQrAAT2F3r3h4NRgVvIhbC9wOx7dlx1Tyk
         WYPz/nHQ3vkybT2k2xkip3nUM4f72z609ZgHuowVvxaTzPOYtt/rzDEr2NC84AIv8CXR
         U0opX2VzCXA/HJ/qpCXLc9V2nv5DRytdGovTfs1rZAEOs7Y6qmGvGpAdfto34hIsA8Ra
         pkfe+e2+ciVrJ92OSsP2KnSO+hNJDpQYdRs7y3RPJ+SbfCtXmkkIIvCahCwn6T2Unqfv
         bBKdNSO98xMr8l4tnMagKiMmWhHFfKIKh6j29waM9bi1stIdadM5rNWv1myS2PUTOZqY
         FLTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:content-transfer-encoding:from:mime-version:date
         :subject:message-id:cc:to;
        bh=IBBznMQ3bpiql9lX29jMw8rTRB5UTkasssHzmZ7+M1c=;
        b=UUGJ1MLQOckQeG0WhDVXXavuwFdJGNSTK32du4lQzpvjyWoVfp3vHVVgkWoWXBq7Pt
         JtNG0X7rw0NvGaA84WHh+Jy5cXfHpohgrFyDJ3b619470IfOh0Wa2hATZcP2NyFKrJxD
         LCAGJZtAeAGDIF+ZQUev5Zk/zSNzKytFxMpcsaeKC5LPBNuaejfKvfH7acmfHBkuxGwC
         Kwv0cbWL5LOQ1XP1CthK2Es8N26TslJY12+m5eVy6sKiGYJcBjZmIBqEmTJo12gxfWkp
         /TJV9iIfTzHcFOhpyexRTglVFM+ADr8GA9pt/HlPnXyBwiCVwGQVSWEBC1PjmrHN3iJ7
         hE/A==
X-Gm-Message-State: APjAAAXdE9b6oQEeyBnK0YO//hCrp1dhacFPdzZWHnWK3nctc1ia3ry6
        xwuKNn31mRBUqYquyhQ7msyElQ==
X-Google-Smtp-Source: APXvYqxGJcaAbkb93bWjAuEqI5MWehvGgfWEWF9ozw2izn5dANYgU464h3LFov9e+Z+7R98DjY8LlQ==
X-Received: by 2002:a37:bc06:: with SMTP id m6mr21225596qkf.383.1582349026611;
        Fri, 21 Feb 2020 21:23:46 -0800 (PST)
Received: from [192.168.1.183] (pool-71-184-117-43.bstnma.fios.verizon.net. [71.184.117.43])
        by smtp.gmail.com with ESMTPSA id j30sm2612022qki.96.2020.02.21.21.23.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Feb 2020 21:23:46 -0800 (PST)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
From:   Qian Cai <cai@lca.pw>
Mime-Version: 1.0 (1.0)
Date:   Sat, 22 Feb 2020 00:23:44 -0500
Subject: Re: [PATCH v2] mm/hugetlb: fix a addressing exception caused by huge_pte_offset()
Message-Id: <C4ED630A-FAD8-4998-A0A3-9C36F3303379@lca.pw>
Cc:     akpm@linux-foundation.org, mike.kravetz@oracle.com,
        kirill.shutemov@linux.intel.com, linux-kernel@vger.kernel.org,
        arei.gonglei@huawei.com, weidong.huang@huawei.com,
        weifuqiang@huawei.com, kvm@vger.kernel.org, linux-mm@kvack.org,
        Matthew Wilcox <willy@infradead.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        stable@vger.kernel.org
To:     "Longpeng(Mike)" <longpeng2@huawei.com>
X-Mailer: iPhone Mail (17D50)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



> On Feb 21, 2020, at 10:34 PM, Longpeng(Mike) <longpeng2@huawei.com> wrote:=

>=20
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index dd8737a..90daf37 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -4910,28 +4910,30 @@ pte_t *huge_pte_offset(struct mm_struct *mm,
> {
>    pgd_t *pgd;
>    p4d_t *p4d;
> -    pud_t *pud;
> -    pmd_t *pmd;
> +    pud_t *pud, pud_entry;
> +    pmd_t *pmd, pmd_entry;
>=20
>    pgd =3D pgd_offset(mm, addr);
> -    if (!pgd_present(*pgd))
> +    if (!pgd_present(READ_ONCE(*pgd)))
>        return NULL;
>    p4d =3D p4d_offset(pgd, addr);
> -    if (!p4d_present(*p4d))
> +    if (!p4d_present(READ_ONCE(*p4d)))
>        return NULL;

What=E2=80=99s the point of READ_ONCE() on those two places?=
