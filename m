Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89C4E1E5BBE
	for <lists+stable@lfdr.de>; Thu, 28 May 2020 11:23:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728265AbgE1JWz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 May 2020 05:22:55 -0400
Received: from lelv0142.ext.ti.com ([198.47.23.249]:54718 "EHLO
        lelv0142.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728264AbgE1JWy (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 May 2020 05:22:54 -0400
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 04S9MmsX130695;
        Thu, 28 May 2020 04:22:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1590657768;
        bh=/Wdo0if7NVPAlofWxugu+NvYgar4E2L7mukGEI+7YkA=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=WXdtZJBV1eqGnMZaIRytmy8jZXYyuT1gaWy/IN+RuWc7/ylU2HKeyTpMb28wziMF9
         tywXTeptrDPyFOvJIA++2kjjW2nW+EC52mylyNx1XteJdbkAN+UFKjy+zQa0k9PXSV
         1+J0zOP53GfHov1eVqh9nOrpvArsB21InxiVnd8E=
Received: from DLEE104.ent.ti.com (dlee104.ent.ti.com [157.170.170.34])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 04S9MmIO001252
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 28 May 2020 04:22:48 -0500
Received: from DLEE112.ent.ti.com (157.170.170.23) by DLEE104.ent.ti.com
 (157.170.170.34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Thu, 28
 May 2020 04:22:48 -0500
Received: from lelv0327.itg.ti.com (10.180.67.183) by DLEE112.ent.ti.com
 (157.170.170.23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Thu, 28 May 2020 04:22:48 -0500
Received: from [192.168.2.6] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 04S9MeUk095917;
        Thu, 28 May 2020 04:22:41 -0500
Subject: Re: [PATCHv2] media: videobuf2-dma-contig: fix bad kfree in
 vb2_dma_contig_clear_max_seg_size
To:     Ulf Hansson <ulf.hansson@linaro.org>
CC:     Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "# 4.0+" <stable@vger.kernel.org>
References: <20200527082334.20774-1-tomi.valkeinen@ti.com>
 <CAPDyKFqRa81q9EYFKB52kr6+EPJBK5u+4_hC0+ZnxU_axbxAZQ@mail.gmail.com>
From:   Tomi Valkeinen <tomi.valkeinen@ti.com>
Message-ID: <77572269-ca18-acd4-89c6-ca4145ed29db@ti.com>
Date:   Thu, 28 May 2020 12:22:35 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <CAPDyKFqRa81q9EYFKB52kr6+EPJBK5u+4_hC0+ZnxU_axbxAZQ@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 28/05/2020 12:14, Ulf Hansson wrote:
> On Wed, 27 May 2020 at 10:23, Tomi Valkeinen <tomi.valkeinen@ti.com> wrote:
>>
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
> 
> Thanks for fixing this!
> 
> However, as I tried to point out in v1, don't you need to care about
> drivers/media/platform/s5p-mfc/s5p_mfc.c, which allocates its own type
> of struct device (non-platform). No?

Oh my bad. I thought Marek posted a patch for it, but now that I look, Marek's patch was for 
ExynosDRM. Somehow I managed to mix up that with the s5p in my head.

I'll try to find time to look at s5p too, but if anyone gets there first, feel free to fix it.

  Tomi

-- 
Texas Instruments Finland Oy, Porkkalankatu 22, 00180 Helsinki.
Y-tunnus/Business ID: 0615521-4. Kotipaikka/Domicile: Helsinki
