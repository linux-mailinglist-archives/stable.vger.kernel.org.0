Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E5DE3CC720
	for <lists+stable@lfdr.de>; Sun, 18 Jul 2021 03:21:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233387AbhGRBYH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 17 Jul 2021 21:24:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:41020 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230259AbhGRBXs (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 17 Jul 2021 21:23:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 29BEF61073;
        Sun, 18 Jul 2021 01:20:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626571251;
        bh=zSkOY6802fCgCfb5LzkbrJxS7DReARrcCK0eEZLZdnw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Rff5+qQPEbqJC1HwHNM+5tdocXkVEWUozPMEp70ljkvbUTh0zWHF1XjDdm6P7nt1I
         dRHInkaGAaRIB75ugcVjTlNmCCe7mj53QXbc1EYec4R48jZ1kK6ll/63Q8sPOaUooF
         OEsF2r7bm6kKFkKb4rg3m2SOSvHMxykAEkcZH5ja4UtSJ+o/L6JbiKiXebNVDpMSVx
         J0V+j9wK5iCtQvR2TJg+Iezesjq42mfVhNfV5teWYQSkGDUM/rdn3lqk0c56+Pb1lp
         TDxQGJYUYcpHzLJgsqanq5xF4ISbL/z7CEZgMNBajDG7ffoFntiz5K0kRXkKc1xz/G
         FNhmwGV6LecTg==
Date:   Sat, 17 Jul 2021 21:20:50 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Sergey Shtylyov <s.shtylyov@omp.ru>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        John Garry <john.garry@huawei.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 4.19 05/39] scsi: hisi_sas: Propagate errors in
 interrupt_init_v1_hw()
Message-ID: <YPOB8hs4jOBRyQsS@sashalap>
References: <20210710023204.3171428-1-sashal@kernel.org>
 <20210710023204.3171428-5-sashal@kernel.org>
 <3e2af821-00e3-6db9-5820-696fdbe003d6@omp.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <3e2af821-00e3-6db9-5820-696fdbe003d6@omp.ru>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Jul 10, 2021 at 12:20:43PM +0300, Sergey Shtylyov wrote:
>On 10.07.2021 5:31, Sasha Levin wrote:
>
>>From: Sergey Shtylyov <s.shtylyov@omp.ru>
>>
>>[ Upstream commit ab17122e758ef68fb21033e25c041144067975f5 ]
>>
>>After commit 6c11dc060427 ("scsi: hisi_sas: Fix IRQ checks") we have the
>>error codes returned by platform_get_irq() ready for the propagation
>>upsream in interrupt_init_v1_hw() -- that will fix still broken deferred
>>probing. Let's propagate the error codes from devm_request_irq() as well
>>since I don't see the reason to override them with -ENOENT...
>>
>>Link: https://lore.kernel.org/r/49ba93a3-d427-7542-d85a-b74fe1a33a73@omp.ru
>>Acked-by: John Garry <john.garry@huawei.com>
>>Signed-off-by: Sergey Shtylyov <s.shtylyov@omp.ru>
>>Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
>>Signed-off-by: Sasha Levin <sashal@kernel.org>
>>---
>>  drivers/scsi/hisi_sas/hisi_sas_v1_hw.c | 12 ++++++------
>>  1 file changed, 6 insertions(+), 6 deletions(-)
>>
>>diff --git a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
>>index 8aa3222fe486..5a777e48963b 100644
>>--- a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
>>+++ b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
>[...]
>>@@ -1717,7 +1717,7 @@ static int interrupt_init_v1_hw(struct hisi_hba *hisi_hba)
>>  		if (!irq) {
>>  			dev_err(dev, "irq init: could not map cq interrupt %d\n",
>>  				idx);
>>-			return -ENOENT;
>>+			return irq;
>
>   This patch is borked too, we don't want to return 0 here...

Looks like it's broken on <=4.19, I'll drop it. Thanks!

-- 
Thanks,
Sasha
