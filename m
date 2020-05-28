Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FC4F1E5BC6
	for <lists+stable@lfdr.de>; Thu, 28 May 2020 11:24:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728351AbgE1JYU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 May 2020 05:24:20 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:45232 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728217AbgE1JYT (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 May 2020 05:24:19 -0400
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20200528092417euoutp0155d58ac9006e8dac0da675a45a3cf452~TJuS1aPPj1897418974euoutp01P
        for <stable@vger.kernel.org>; Thu, 28 May 2020 09:24:17 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20200528092417euoutp0155d58ac9006e8dac0da675a45a3cf452~TJuS1aPPj1897418974euoutp01P
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1590657857;
        bh=lmZORPHWbRogGBdRHznQdNDJLcQTakN6p6FxUMWtgf8=;
        h=Subject:To:Cc:From:Date:In-Reply-To:References:From;
        b=I7bZ6CNRDfKtZLlt/HLfq7PJ1enVqkgh2hjllIkgxkdO2aD34A8QU1HYCXDtWedCX
         iDj6pcRecvhFDAMLSuTFU1k5AW/j3BBmbsMXfYBLPr4TxL/iR9Jr/9hCYtnAW0xuuQ
         inTQw9MLCai58wT08b+F5eCi/7wR+v6REpahWdSM=
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTP id
        20200528092416eucas1p14cda21412c24013c34ceb521b753266c~TJuSoGQo21725917259eucas1p1B;
        Thu, 28 May 2020 09:24:16 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
        eusmges2new.samsung.com (EUCPMTA) with SMTP id 9E.D0.60679.0438FCE5; Thu, 28
        May 2020 10:24:16 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20200528092416eucas1p1ff94186c5b81d9e6988e123ddff13b9b~TJuSUqJ102540225402eucas1p1O;
        Thu, 28 May 2020 09:24:16 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
        eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20200528092416eusmtrp2d2272613d20d21d74d2cee6cf6fa67d8~TJuSUFawi0474104741eusmtrp2K;
        Thu, 28 May 2020 09:24:16 +0000 (GMT)
X-AuditID: cbfec7f4-0cbff7000001ed07-c0-5ecf8340fa41
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
        eusmgms1.samsung.com (EUCPMTA) with SMTP id 6C.AA.08375.0438FCE5; Thu, 28
        May 2020 10:24:16 +0100 (BST)
Received: from [106.210.88.143] (unknown [106.210.88.143]) by
        eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20200528092416eusmtip242b66b283487eb10f92fa6602003efc0~TJuR4-4Sv1299612996eusmtip2T;
        Thu, 28 May 2020 09:24:16 +0000 (GMT)
Subject: Re: [PATCHv2] media: videobuf2-dma-contig: fix bad kfree in
 vb2_dma_contig_clear_max_seg_size
To:     Ulf Hansson <ulf.hansson@linaro.org>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc:     Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "# 4.0+" <stable@vger.kernel.org>
From:   Marek Szyprowski <m.szyprowski@samsung.com>
Message-ID: <53acbff5-ccb2-1f26-c1e3-54a540ac537f@samsung.com>
Date:   Thu, 28 May 2020 11:24:17 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
        Thunderbird/68.8.1
MIME-Version: 1.0
In-Reply-To: <CAPDyKFqRa81q9EYFKB52kr6+EPJBK5u+4_hC0+ZnxU_axbxAZQ@mail.gmail.com>
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrIKsWRmVeSWpSXmKPExsWy7djP87oOzefjDBYuNrG4vGsOm0XPhq2s
        Fss2/WGyWLDxEaPF+vm32CyOrw13YPPYtKqTzePOtT1sHsdvbGfy+LxJLoAlissmJTUnsyy1
        SN8ugStjQcMU5oLr/BWblzexNjA28HYxcnJICJhIPDi0mr2LkYtDSGAFo8Skdb+gnC+MEufb
        t0M5nxklLq07zAzT8n/STVYQW0hgOaPEvROlEEXvGSXWvFvBBpIQFsiQ2HT0A1iDiECQxJ8d
        VxlBipgFNjFKLH97nQkkwSZgKNH1tgusgVfATmLKlctgNouAqsT3J3vBbFGBWIme+6+YIWoE
        JU7OfMICYnMKBErsXrUGbA6zgLzE9rdzmCFscYlbT+YzgSyTEFjGLnHy6XJGiLNdJL6uW80C
        YQtLvDq+hR3ClpH4vxOmoZlR4uG5tewQTg+jxOWmGVDd1hJ3zv0COokDaIWmxPpd+hBhR4lH
        L18yg4QlBPgkbrwVhDiCT2LStulQYV6JjjYhiGo1iVnH18GtPXjhEvMERqVZSF6bheSdWUje
        mYWwdwEjyypG8dTS4tz01GKjvNRyveLE3OLSvHS95PzcTYzAhHP63/EvOxh3/Uk6xCjAwajE
        w9vhdS5OiDWxrLgy9xCjBAezkgiv09nTcUK8KYmVValF+fFFpTmpxYcYpTlYlMR5jRe9jBUS
        SE8sSc1OTS1ILYLJMnFwSjUw2td8OpkV905BZ5e4v9juM0rPT+gaXG34a802vTJ2R+86/qZT
        qxU//mQ+Lvfx9/F7D7xYuf43CITFHOdYy5BxT774rPVM0ebaJv9m5fIM1crNt58nXVwuE7Rg
        zt8Td3Ml3mxdd7Yyyvdpwpu+gp07m2Vcgo54SsRv5IzbKMTDcYiH1clsjuRBJZbijERDLeai
        4kQAk0T/eTQDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMIsWRmVeSWpSXmKPExsVy+t/xe7oOzefjDJ69k7G4vGsOm0XPhq2s
        Fss2/WGyWLDxEaPF+vm32CyOrw13YPPYtKqTzePOtT1sHsdvbGfy+LxJLoAlSs+mKL+0JFUh
        I7+4xFYp2tDCSM/Q0kLPyMRSz9DYPNbKyFRJ384mJTUnsyy1SN8uQS9jQcMU5oLr/BWblzex
        NjA28HYxcnJICJhI/J90k7WLkYtDSGApo8TfhZtYIRIyEienNUDZwhJ/rnWxQRS9ZZSYcvMM
        O0hCWCBDYtPRD8xdjBwcIgJBEqsXSoHUMAtsYpTo+bQAquEqo8SqrTMZQRrYBAwlut6CTOLk
        4BWwk5hy5TKYzSKgKvH9yV4wW1QgVqJ78Q92iBpBiZMzn7CA2JwCgRK7V61hArGZBcwk5m1+
        yAxhy0tsfzsHyhaXuPVkPtMERqFZSNpnIWmZhaRlFpKWBYwsqxhFUkuLc9Nziw31ihNzi0vz
        0vWS83M3MQIjbNuxn5t3MF7aGHyIUYCDUYmH18DjXJwQa2JZcWXuIUYJDmYlEV6ns6fjhHhT
        EiurUovy44tKc1KLDzGaAj03kVlKNDkfGP15JfGGpobmFpaG5sbmxmYWSuK8HQIHY4QE0hNL
        UrNTUwtSi2D6mDg4pRoY27nPuFn8eG651Jfrr7xIB3tey6nCQhuVhZVPrc7lvYl56XrM/Vms
        y5P7lz+9+y8rfbHextraeeke5sRQvovPVlv7HBdy33CHqfOZczWT8u4AFmXOWskSxxnOvta9
        3t+nuLJzHt9ovF2dI6wi6grrx9l3I2wFbmXG8NRl8y9u5rsaEBl49Z0SS3FGoqEWc1FxIgA2
        4S6NxgIAAA==
X-CMS-MailID: 20200528092416eucas1p1ff94186c5b81d9e6988e123ddff13b9b
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20200528091458eucas1p13645743b402f161dfa2fcd2b1e0e3b60
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20200528091458eucas1p13645743b402f161dfa2fcd2b1e0e3b60
References: <20200527082334.20774-1-tomi.valkeinen@ti.com>
        <CGME20200528091458eucas1p13645743b402f161dfa2fcd2b1e0e3b60@eucas1p1.samsung.com>
        <CAPDyKFqRa81q9EYFKB52kr6+EPJBK5u+4_hC0+ZnxU_axbxAZQ@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Ulf,

On 28.05.2020 11:14, Ulf Hansson wrote:
> On Wed, 27 May 2020 at 10:23, Tomi Valkeinen <tomi.valkeinen@ti.com> wrote:
>> Commit 9495b7e92f716ab2bd6814fab5e97ab4a39adfdd ("driver core: platform:
>> Initialize dma_parms for platform devices") in v5.7-rc5 causes
>> vb2_dma_contig_clear_max_seg_size() to kfree memory that was not
>> allocated by vb2_dma_contig_set_max_seg_size().
>>
>> The assumption in vb2_dma_contig_set_max_seg_size() seems to be that
>> dev->dma_parms is always NULL when the driver is probed, and the case
>> where dev->dma_parms has bee initialized by someone else than the driver
>> (by calling vb2_dma_contig_set_max_seg_size) will cause a failure.
>>
>> All the current users of these functions are platform devices, which now
>> always have dma_parms set by the driver core. To fix the issue for v5.7,
>> make vb2_dma_contig_set_max_seg_size() return an error if dma_parms is
>> NULL to be on the safe side, and remove the kfree code from
>> vb2_dma_contig_clear_max_seg_size().
>>
>> For v5.8 we should remove the two functions and move the
>> dma_set_max_seg_size() calls into the drivers.
>>
>> Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ti.com>
>> Fixes: 9495b7e92f71 ("driver core: platform: Initialize dma_parms for platform devices")
>> Cc: stable@vger.kernel.org
> Thanks for fixing this!
>
> However, as I tried to point out in v1, don't you need to care about
> drivers/media/platform/s5p-mfc/s5p_mfc.c, which allocates its own type
> of struct device (non-platform). No?

I will send a patch for the S5P MFC driver separately. It is not so 
critical, because the mentioned 2port memory case is not used on any 
board with the default exynos_defconfig from mainline. On Exynos4-based 
boards it is only used when IOMMU is disabled. It is mainly for 
S5PV210/S5PC110 boards, which are still not fully functional after 
conversion to device-tree.

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland

