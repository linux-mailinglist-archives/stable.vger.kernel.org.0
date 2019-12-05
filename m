Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C24E3113E5F
	for <lists+stable@lfdr.de>; Thu,  5 Dec 2019 10:42:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729070AbfLEJm3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Dec 2019 04:42:29 -0500
Received: from mail-qv1-f66.google.com ([209.85.219.66]:40002 "EHLO
        mail-qv1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729068AbfLEJm2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Dec 2019 04:42:28 -0500
Received: by mail-qv1-f66.google.com with SMTP id i3so1031605qvv.7
        for <stable@vger.kernel.org>; Thu, 05 Dec 2019 01:42:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=lca.pw; s=google;
        h=content-transfer-encoding:from:mime-version:subject:date:message-id
         :references:cc:in-reply-to:to;
        bh=zI7a5PBMJJ5CQd2iIgpWJ2uNZMsj1Eei+ZBMJ2MdOPA=;
        b=fTOKyT6d57EX40FTt7xk4dm4F/UKZ5SwM2IFqMsoI3yfCsmiz1FI8MWUjUkTW+F8U5
         5tgPXiXJqUuWe7Qodfx5FSKinWR7lJg97JBfWXy+kq3FYdd5l+903umSf2oRYNDRhE2R
         S5uHHUuFYZBkm8h4EnoqLKT1Rlyo2awbgrNFIjBCmTDh6UMW1KhhO6gVLyTg6d6H4tEW
         0Zr1G6WSRkal+43oiuUQ6FomOPA2umQZSFlLBokCeW4eEfBPY3I+Wzptb5XhEznTm8h5
         eNDVrRQcoEuMf+9dH1iAr5C0eHAXzOIecEf9jsze1Bpz6oGXAn4ShzKYlvb++3dY3XXz
         gvSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:content-transfer-encoding:from:mime-version
         :subject:date:message-id:references:cc:in-reply-to:to;
        bh=zI7a5PBMJJ5CQd2iIgpWJ2uNZMsj1Eei+ZBMJ2MdOPA=;
        b=lUII0B88QkMnu3ydWEy5Melf0WplQILU0q8L5SYNld+YxiuoSe3NHIMFfs8IMKbU87
         z1D5YWRLffx5sm03numxmaDVMgLExChU7RbHqpVo7luxqdBCwqOFhRKFOCTheVXoaULB
         aBu1YNx2cmg3gSiDbbhjJ6gljOh6kSDoCQzxn1S/LjYXfhePNoMDAkAdQDgtT/KOeruG
         UDDIb6oyQLecp4DpueqBECgZX/oSj0neOny4l6JZLL0ynOPk/yLP9Q5II1fOsCzd+vxf
         yLvstZhLjAFiEWUAKVrnQeLHylKk4anb0UBg3myeytNkZV+wNeYB+qpE95XCJWBSj1zh
         aXVQ==
X-Gm-Message-State: APjAAAXc2ZWOQ+m8GQ/cml6X6SPRSNa60lcBBiAhrKtxXfFVgq7h5+Ce
        QgRAQTJmDWMFowZF2z11YgzcNxRSQYkzkw==
X-Google-Smtp-Source: APXvYqw4MD2MUemRLyJ8RFAeY7TUJzzy4DevHu4JGTfkFeWfxi7tVEGh2w/A/72jz0ef24uQmreUGw==
X-Received: by 2002:ad4:5689:: with SMTP id bc9mr6409168qvb.132.1575538947064;
        Thu, 05 Dec 2019 01:42:27 -0800 (PST)
Received: from [192.168.1.183] (pool-71-184-117-43.bstnma.fios.verizon.net. [71.184.117.43])
        by smtp.gmail.com with ESMTPSA id 13sm4716663qke.85.2019.12.05.01.42.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Dec 2019 01:42:26 -0800 (PST)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
From:   Qian Cai <cai@lca.pw>
Mime-Version: 1.0 (1.0)
Subject: Re: [v2 PATCH] mm: move_pages: return valid node id in status if the page is already on the target node
Date:   Thu, 5 Dec 2019 04:42:25 -0500
Message-Id: <9E51ECF6-E9E8-4772-B7D8-7E528DD56A89@lca.pw>
References: <1575519678-86510-1-git-send-email-yang.shi@linux.alibaba.com>
Cc:     fabecassis@nvidia.com, jhubbard@nvidia.com, mhocko@suse.com,
        cl@linux.com, vbabka@suse.cz, mgorman@techsingularity.net,
        akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
In-Reply-To: <1575519678-86510-1-git-send-email-yang.shi@linux.alibaba.com>
To:     Yang Shi <yang.shi@linux.alibaba.com>
X-Mailer: iPhone Mail (17B111)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



> On Dec 4, 2019, at 11:21 PM, Yang Shi <yang.shi@linux.alibaba.com> wrote:
>=20
> Felix Abecassis reports move_pages() would return random status if the
> pages are already on the target node by the below test program:
>=20
> ---8<---
>=20
> int main(void)
> {
>    const long node_id =3D 1;
>    const long page_size =3D sysconf(_SC_PAGESIZE);
>    const int64_t num_pages =3D 8;
>=20
>    unsigned long nodemask =3D  1 << node_id;
>    long ret =3D set_mempolicy(MPOL_BIND, &nodemask, sizeof(nodemask));
>    if (ret < 0)
>        return (EXIT_FAILURE);
>=20
>    void **pages =3D malloc(sizeof(void*) * num_pages);
>    for (int i =3D 0; i < num_pages; ++i) {
>        pages[i] =3D mmap(NULL, page_size, PROT_WRITE | PROT_READ,
>                MAP_PRIVATE | MAP_POPULATE | MAP_ANONYMOUS,
>                -1, 0);
>        if (pages[i] =3D=3D MAP_FAILED)
>            return (EXIT_FAILURE);
>    }
>=20
>    ret =3D set_mempolicy(MPOL_DEFAULT, NULL, 0);
>    if (ret < 0)
>        return (EXIT_FAILURE);
>=20
>    int *nodes =3D malloc(sizeof(int) * num_pages);
>    int *status =3D malloc(sizeof(int) * num_pages);
>    for (int i =3D 0; i < num_pages; ++i) {
>        nodes[i] =3D node_id;
>        status[i] =3D 0xd0; /* simulate garbage values */
>    }
>=20
>    ret =3D move_pages(0, num_pages, pages, nodes, status, MPOL_MF_MOVE);
>    printf("move_pages: %ld\n", ret);
>    for (int i =3D 0; i < num_pages; ++i)
>        printf("status[%d] =3D %d\n", i, status[i]);
> }
> ---8<---
>=20
> Then running the program would return nonsense status values:
> $ ./move_pages_bug
> move_pages: 0
> status[0] =3D 208
> status[1] =3D 208
> status[2] =3D 208
> status[3] =3D 208
> status[4] =3D 208
> status[5] =3D 208
> status[6] =3D 208
> status[7] =3D 208
>=20
> This is because the status is not set if the page is already on the
> target node, but move_pages() should return valid status as long as it
> succeeds.  The valid status may be errno or node id.
>=20
> We can't simply initialize status array to zero since the pages may be
> not on node 0.  Fix it by updating status with node id which the page is
> already on.  And, it looks we have to update the status inside
> add_page_for_migration() since the page struct is not available outside
> it.
>=20
> Make add_page_for_migration() return 1 if store_status() is failed in
> order to not mix up the status value since -EFAULT is also a valid
> status.

Don=E2=80=99t really feel it is a bug after all. As you mentioned, the manpa=
ge was rather poorly written. Why it is not a good idea just update the manp=
age or/and code comments instead to document the current behavior?=
