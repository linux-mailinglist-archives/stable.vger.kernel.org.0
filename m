Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA8E528CAAC
	for <lists+stable@lfdr.de>; Tue, 13 Oct 2020 10:54:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730418AbgJMIyf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Oct 2020 04:54:35 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:53717 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729681AbgJMIyf (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Oct 2020 04:54:35 -0400
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20201013085422euoutp019c70412e0453f89d6bdcfc6f53e160ba~9gVkqL3RZ0334503345euoutp01S
        for <stable@vger.kernel.org>; Tue, 13 Oct 2020 08:54:22 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20201013085422euoutp019c70412e0453f89d6bdcfc6f53e160ba~9gVkqL3RZ0334503345euoutp01S
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1602579262;
        bh=Kk0LqZlSEGTzsjG1lnDEAIBRN4U5DPNxnZeDzusow58=;
        h=Subject:To:Cc:From:Date:In-Reply-To:References:From;
        b=Afkty+Tamg+eMzLPBS3PAyHV1zbtgSVMVR2ZlzO9g7UPlN0gfzwQiYDrg38+Nraib
         CxIM35ry4ooQ7jlJP06hS2IETzxpWNqpxEudC2lmsnG4T7D8PA0HCjvGqteyp//Wxq
         54xzUJKzGetexMspvDS4O3TFNIdkYzRleMW6v/eU=
Received: from eusmges1new.samsung.com (unknown [203.254.199.242]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTP id
        20201013085417eucas1p134178f01e846fc128e68ea19cac6672e~9gVfxaQcD1905519055eucas1p1A;
        Tue, 13 Oct 2020 08:54:17 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
        eusmges1new.samsung.com (EUCPMTA) with SMTP id B8.EA.06456.93B658F5; Tue, 13
        Oct 2020 09:54:17 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20201013085416eucas1p285c57b63894f54a42fb1052cfadd7cb5~9gVfHsxSP0380703807eucas1p2Q;
        Tue, 13 Oct 2020 08:54:16 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
        eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20201013085416eusmtrp216d6e764296b285499e05b3bb43105c4~9gVfHE31j0147001470eusmtrp21;
        Tue, 13 Oct 2020 08:54:16 +0000 (GMT)
X-AuditID: cbfec7f2-809ff70000001938-14-5f856b39f888
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
        eusmgms2.samsung.com (EUCPMTA) with SMTP id C6.AC.06017.83B658F5; Tue, 13
        Oct 2020 09:54:16 +0100 (BST)
Received: from [106.210.88.143] (unknown [106.210.88.143]) by
        eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20201013085415eusmtip19b93c7a3b94706c32deb68cc56bd62e1~9gVesx8sY2707227072eusmtip1O;
        Tue, 13 Oct 2020 08:54:15 +0000 (GMT)
Subject: Re: [PATCH 4.19 27/38] iommu/exynos: add missing put_device() call
 in exynos_iommu_of_xlate()
To:     Pavel Machek <pavel@denx.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Yu Kuai <yukuai3@huawei.com>, Joerg Roedel <jroedel@suse.de>,
        Sasha Levin <sashal@kernel.org>
From:   Marek Szyprowski <m.szyprowski@samsung.com>
Message-ID: <5b869c86-8d35-e834-4fec-6b63a942e484@samsung.com>
Date:   Tue, 13 Oct 2020 10:54:15 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0)
        Gecko/20100101 Thunderbird/78.3.2
MIME-Version: 1.0
In-Reply-To: <20201007094737.GA12593@duo.ucw.cz>
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrLKsWRmVeSWpSXmKPExsWy7djPc7qW2a3xBm19rBbNi9ezWUw+NZfJ
        4vKuOWwWRze4WGxac43NYsHGR4wWcxayObB7zJt1gsWj5chbVo9NqzrZPPbPXcPusfl0tcfn
        TXIBbFFcNimpOZllqUX6dglcGct2zGAu+MVRceDnY9YGxiXsXYycHBICJhIrllwHs4UEVjBK
        rF1l1MXIBWR/YZTY8v8dM4TzmVHi6c9FbDAdX/40MEEkljNKHPpxlRWi/T2jxJQuexBbWCBD
        4lPnWRYQW0QgWOLeyQVsIA3MArMZJc6+2wzWwCZgKNH1tgtsKq+AncTdKf1gDSwCqhLT+peD
        2aICSRLnF/5hhqgRlDg58wlYnFPAQOLZgldgdzMLyEtsfzuHGcIWl7j1ZD7YdRIC29glps1d
        wgpxtotE//3XTBC2sMSr41ugASAj8X8nTEMzo8TDc2vZIZweRonLTTMYIaqsJe6c+wV0KgfQ
        Ck2J9bv0IcKOEgfW3mUGCUsI8EnceCsIcQSfxKRt06HCvBIdbUIQ1WoSs46vg1t78MIl5gmM
        SrOQvDYLyTuzkLwzC2HvAkaWVYziqaXFuempxYZ5qeV6xYm5xaV56XrJ+bmbGIGJ6PS/4592
        MH69lHSIUYCDUYmHd4FfS7wQa2JZcWXuIUYJDmYlEV6ns6fjhHhTEiurUovy44tKc1KLDzFK
        c7AoifMaL3oZKySQnliSmp2aWpBaBJNl4uCUamDcOqV17Zl3Zc9mvtm95Jv9EuXzFg4dgjHF
        i8wlW65fn3XsLoP6/Tcpp72rjWacKPpaFMNrsFBG4/m6JK71kjOU7xUb7mRTXs796KKxfP9m
        Zg/3NdU3Fxht+Va2VL/3ocqS55eztVcFFPEeczQR6HdL4z1rm+C+dlLgxgVClRO2iU0u63n1
        wHafEktxRqKhFnNRcSIADjmf40ADAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrAIsWRmVeSWpSXmKPExsVy+t/xu7oW2a3xBsuei1s0L17PZjH51Fwm
        i8u75rBZHN3gYrFpzTU2iwUbHzFazFnI5sDuMW/WCRaPliNvWT02repk89g/dw27x+bT1R6f
        N8kFsEXp2RTll5akKmTkF5fYKkUbWhjpGVpa6BmZWOoZGpvHWhmZKunb2aSk5mSWpRbp2yXo
        ZSzbMYO54BdHxYGfj1kbGJewdzFyckgImEh8+dPABGILCSxllOic4gQRl5E4Oa2BFcIWlvhz
        rYuti5ELqOYto8Suw7fBEsICGRJ31t4Hs0UEgiXuXd3NBFLELDCbUWLys/2MEB1PGSUOXrvP
        BlLFJmAo0fW2C8zmFbCTuDulnwXEZhFQlZjWvxzMFhVIkvh+tYsRokZQ4uTMJ2BxTgEDiWcL
        XoGdzSxgJjFv80NmCFteYvvbOVC2uMStJ/OZJjAKzULSPgtJyywkLbOQtCxgZFnFKJJaWpyb
        nltspFecmFtcmpeul5yfu4kRGHvbjv3csoOx613wIUYBDkYlHt4Ffi3xQqyJZcWVuYcYJTiY
        lUR4nc6ejhPiTUmsrEotyo8vKs1JLT7EaAr03ERmKdHkfGBayCuJNzQ1NLewNDQ3Njc2s1AS
        5+0QOBgjJJCeWJKanZpakFoE08fEwSnVwFi2q+rx2sYJLc9rXZ4EbFl2SqwkYcH9oLdhG5Wk
        JCOvfl88c4fTIsOQ9euW7noXu7EyY3vkzg8JK9ZfUiywvsMhGnthsZnRyewrM2xeyerJb0kO
        FuA/sUn2P58s09KSUo3VhscmnUwMj39oepft4Vw24TXV3keeV/PxXrwk9aZiS+vulr418sZK
        LMUZiYZazEXFiQDP6Daw0wIAAA==
X-CMS-MailID: 20201013085416eucas1p285c57b63894f54a42fb1052cfadd7cb5
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20201007095256eucas1p150311eeced01b2cc66f6a9ef7061e6ff
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20201007095256eucas1p150311eeced01b2cc66f6a9ef7061e6ff
References: <20201005142108.650363140@linuxfoundation.org>
        <20201005142109.977461657@linuxfoundation.org>
        <CGME20201007095256eucas1p150311eeced01b2cc66f6a9ef7061e6ff@eucas1p1.samsung.com>
        <20201007094737.GA12593@duo.ucw.cz>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Pavel,

On 07.10.2020 11:47, Pavel Machek wrote:
>> From: Yu Kuai <yukuai3@huawei.com>
>>
>> [ Upstream commit 1a26044954a6d1f4d375d5e62392446af663be7a ]
>>
>> if of_find_device_by_node() succeed, exynos_iommu_of_xlate() doesn't have
>> a corresponding put_device(). Thus add put_device() to fix the exception
>> handling for this function implementation.
> Okay, this looks reasonable, but...
>
> Do we miss put_device() in normal path, too? I'd expect another
> put_device at end of exynos_iommu_of_xlate() or perhaps in release
> path somewhere...

Frankly, there is no release path, so there is no need for put_device. 
Once initialized, Exynos IOMMU stays in the system forever. There is no 
point to remove IOMMU nor the API for that. Keeping increased refcount 
for its device just matches this behavior.

If the missing put_device() is really a problem, then we can move it 
from the error path just after data = platform_get_drvdata(sysmmu) 
assignment. Feel free to send a patch if you think this is a more 
appropriate approach.

Best regards

-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland

