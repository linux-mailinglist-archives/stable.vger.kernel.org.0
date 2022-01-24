Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0528E498285
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 15:39:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240260AbiAXOjr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 09:39:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240095AbiAXOjk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 09:39:40 -0500
Received: from mail-ot1-x330.google.com (mail-ot1-x330.google.com [IPv6:2607:f8b0:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E382C06173B;
        Mon, 24 Jan 2022 06:39:40 -0800 (PST)
Received: by mail-ot1-x330.google.com with SMTP id l64-20020a9d1b46000000b005983a0a8aaaso22536666otl.3;
        Mon, 24 Jan 2022 06:39:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WRnmLg2nPya3Lli2a3VtYubGXc/FUMVFB+/lJ6rJUqw=;
        b=JHy5ih6cO2KnwpVZg9yE8MS9kgaCBdqFYsbe5gYKEg4oYSjPv23OcnK7RozX2C/lTC
         zxnk96DdQshmFsZxwaJ/pTs5Xw7OMlJ6Pno9zGzAhkR60O0oCe7XRMpQzLrhT46Y8lDD
         6Rn2ueKzjR0QMFwFxntk/4odYw4FYUzkyIiAdkA7TCZoMbaSxvyziwhkjxipA/UWbz+1
         C1OJ39n7sFGNpQYzgLiRBSMYldeDK2VsxZGwGjradQ8GNanKnG5nYJ+7rrdOIXHEHYt8
         p3Lf+VbFKluFYCirULe4DvwmoyvWGJFwe6Zk5hLRaIHhqdc0QK5Rz3RLHYD2b3Vk+rlB
         CUrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WRnmLg2nPya3Lli2a3VtYubGXc/FUMVFB+/lJ6rJUqw=;
        b=SgbjQgBSLmo8vUM/5Y6wcUVSaLUKaWi9QgpkfeRbvuQmQpih43BIwUiC+sNfv/I816
         HYjSjqm8gSMLb103ui5UA0j6H4pySZm+aXyxyFGLUKLnspj8Fz7THtMt+O9ptkzQ12oM
         FO66xalpPuB/Yn68xxiodjD2NFQSW2rQJZH5MmxlG1DCGKQvvdlimRMFAbF7m57oWxLy
         7cobPJ3OexDPnawgKIL2Y4u76yOplTLXcd3LwIm5yXizEH8YwCz34GmptK5qhNUub189
         OwdcTsu2bOyzd8GwHNrq4BOI/XEObMp2ce8NBzejXHmRCJXigZWJAOrJkVD2w77UJat0
         PP/Q==
X-Gm-Message-State: AOAM531sVVurxQ/2Z5xMEvooL7N+FKDPEAZmpCk5lxTPIi3+TdgIz+Gg
        KVBtOSWCdkVVeqri5VvXt0C25LEaD0X/UVzQDGQ=
X-Google-Smtp-Source: ABdhPJwV10rQv+WJ0fiTMkYZOugBJay7apmmkDUEn7c9Erwq89BMS5eSkAOWSsF7F1roYUJx1Pxydi+faZylXyrG6fI=
X-Received: by 2002:a9d:f04:: with SMTP id 4mr11896147ott.326.1643035179591;
 Mon, 24 Jan 2022 06:39:39 -0800 (PST)
MIME-Version: 1.0
References: <20220112131552.3329380-1-aisheng.dong@nxp.com>
In-Reply-To: <20220112131552.3329380-1-aisheng.dong@nxp.com>
From:   Dong Aisheng <dongas86@gmail.com>
Date:   Mon, 24 Jan 2022 22:34:00 +0800
Message-ID: <CAA+hA=T=kavt-zvrraXh+BJcSPVWtzyXhkycrmdtNCxzKsbaaQ@mail.gmail.com>
Subject: Re: [PATCH v2 0/2] mm: fix cma allocation fail sometimes
To:     Dong Aisheng <aisheng.dong@nxp.com>
Cc:     linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, jason.hui.liu@nxp.com,
        leoyang.li@nxp.com, abel.vesa@nxp.com, shawnguo@kernel.org,
        linux-imx@nxp.com, akpm@linux-foundation.org,
        m.szyprowski@samsung.com, lecopzer.chen@mediatek.com,
        david@redhat.com, vbabka@suse.cz, stable@vger.kernel.org,
        shijie.qin@nxp.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Gently Ping...

On Wed, Jan 12, 2022 at 9:17 PM Dong Aisheng <aisheng.dong@nxp.com> wrote:
>
> We observed an issue with NXP 5.15 LTS kernel that dma_alloc_coherent()
> may fail sometimes when there're multiple processes trying to allocate
> CMA memory.
>
> This issue can be very easily reproduced on MX6Q SDB board with latest
> linux-next kernel by writing a test module creating 16 or 32 threads
> allocating random size of CMA memory in parallel at the background.
> Or simply enabling CONFIG_CMA_DEBUG, you can see endless of CMA alloc
> retries during booting:
> [    1.452124] cma: cma_alloc(): memory range at (ptrval) is busy,retrying
> ....
> (thousands of reties)
> NOTE: MX6 has CONFIG_FORCE_MAX_ZONEORDER=14 which means MAX_ORDER is
> 13 (32M).
>
> The root cause of this issue is that since commit a4efc174b382
> ("mm/cma.c: remove redundant cma_mutex lock"), CMA supports concurrent
> memory allocation.
> It's possible that the pageblock process A try to alloc has already
> been isolated by the allocation of process B during memory migration.
>
> When there're multi process allocating CMA memory in parallel, it's
> likely that other the remain pageblocks may have also been isolated,
> then CMA alloc fail finally during the first round of scanning of the
> whole available CMA bitmap.
>
> This patchset introduces a retry mechanism to rescan CMA bitmap for -EBUSY
> error in case the target pageblock may has been temporarily isolated
> by others and released later.
> It also improves the CMA allocation performance by trying the next
> pageblock during reties rather than looping in the same pageblock
> which is in -EBUSY state.
>
> Theoretically, this issue can be easily reproduced on ARMv7 platforms
> with big MAX_ORDER/pageblock
> e.g. 1G RAM(320M reserved CMA) and 32M pageblock ARM platform:
> Page block order: 13
> Pages per block:  8192
>
> The following test is based on linux-next: next-20211213.
>
> Without the fix, it's easily fail.
> # insmod cma_alloc.ko pnum=16
> [  274.322369] CMA alloc test enter: thread number: 16
> [  274.329948] cpu: 0, pid: 692, index 4 pages 144
> [  274.330143] cpu: 1, pid: 694, index 2 pages 44
> [  274.330359] cpu: 2, pid: 695, index 7 pages 757
> [  274.330760] cpu: 2, pid: 696, index 4 pages 144
> [  274.330974] cpu: 2, pid: 697, index 6 pages 512
> [  274.331223] cpu: 2, pid: 698, index 6 pages 512
> [  274.331499] cpu: 2, pid: 699, index 2 pages 44
> [  274.332228] cpu: 2, pid: 700, index 0 pages 7
> [  274.337421] cpu: 0, pid: 701, index 1 pages 38
> [  274.337618] cpu: 2, pid: 702, index 0 pages 7
> [  274.344669] cpu: 1, pid: 703, index 0 pages 7
> [  274.344807] cpu: 3, pid: 704, index 6 pages 512
> [  274.348269] cpu: 2, pid: 705, index 5 pages 148
> [  274.349490] cma: cma_alloc: reserved: alloc failed, req-size: 38 pages, ret: -16
> [  274.366292] cpu: 1, pid: 706, index 4 pages 144
> [  274.366562] cpu: 0, pid: 707, index 3 pages 128
> [  274.367356] cma: cma_alloc: reserved: alloc failed, req-size: 128 pages, ret: -16
> [  274.367370] cpu: 0, pid: 707, index 3 pages 128 failed
> [  274.371148] cma: cma_alloc: reserved: alloc failed, req-size: 148 pages, ret: -16
> [  274.375348] cma: cma_alloc: reserved: alloc failed, req-size: 144 pages, ret: -16
> [  274.384256] cpu: 2, pid: 708, index 0 pages 7
> ....
>
> With the fix, 32 threads allocating in parallel can pass overnight
> stress test.
>
> root@imx6qpdlsolox:~# insmod cma_alloc.ko pnum=32
> [  112.976809] cma_alloc: loading out-of-tree module taints kernel.
> [  112.984128] CMA alloc test enter: thread number: 32
> [  112.989748] cpu: 2, pid: 707, index 6 pages 512
> [  112.994342] cpu: 1, pid: 708, index 6 pages 512
> [  112.995162] cpu: 0, pid: 709, index 3 pages 128
> [  112.995867] cpu: 2, pid: 710, index 0 pages 7
> [  112.995910] cpu: 3, pid: 711, index 2 pages 44
> [  112.996005] cpu: 3, pid: 712, index 7 pages 757
> [  112.996098] cpu: 3, pid: 713, index 7 pages 757
> ...
> [41877.368163] cpu: 1, pid: 737, index 2 pages 44
> [41877.369388] cpu: 1, pid: 736, index 3 pages 128
> [41878.486516] cpu: 0, pid: 737, index 2 pages 44
> [41878.486515] cpu: 2, pid: 739, index 4 pages 144
> [41878.486622] cpu: 1, pid: 736, index 3 pages 128
> [41878.486948] cpu: 2, pid: 735, index 7 pages 757
> [41878.487279] cpu: 2, pid: 738, index 4 pages 144
> [41879.526603] cpu: 1, pid: 739, index 3 pages 128
> [41879.606491] cpu: 2, pid: 737, index 3 pages 128
> [41879.606550] cpu: 0, pid: 736, index 0 pages 7
> [41879.612271] cpu: 2, pid: 738, index 4 pages 144
> ...
>
> v1:
> https://patchwork.kernel.org/project/linux-mm/cover/20211215080242.3034856-1-aisheng.dong@nxp.com/
>
> Dong Aisheng (2):
>   mm: cma: fix allocation may fail sometimes
>   mm: cma: try next MAX_ORDER_NR_PAGES during retry
>
>  mm/cma.c | 15 ++++++++++++++-
>  1 file changed, 14 insertions(+), 1 deletion(-)
>
> --
> 2.25.1
>
