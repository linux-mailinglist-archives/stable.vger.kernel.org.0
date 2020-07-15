Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 394552207AE
	for <lists+stable@lfdr.de>; Wed, 15 Jul 2020 10:44:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729466AbgGOInv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Jul 2020 04:43:51 -0400
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:8674 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729377AbgGOInu (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Jul 2020 04:43:50 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f0ec18c0000>; Wed, 15 Jul 2020 01:42:52 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Wed, 15 Jul 2020 01:43:50 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Wed, 15 Jul 2020 01:43:50 -0700
Received: from [10.26.73.219] (172.20.13.39) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 15 Jul
 2020 08:43:44 +0000
Subject: Re: [PATCH 2/2] usb: tegra: Fix zero length memory allocation
To:     Thierry Reding <thierry.reding@gmail.com>
CC:     Mathias Nyman <mathias.nyman@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <stable@vger.kernel.org>
References: <20200712102837.24340-1-jonathanh@nvidia.com>
 <20200712102837.24340-2-jonathanh@nvidia.com> <20200714093256.GG141356@ulmo>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <9c8ddf99-40fb-547f-81a9-05f0c64c9a5f@nvidia.com>
Date:   Wed, 15 Jul 2020 09:43:42 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200714093256.GG141356@ulmo>
X-Originating-IP: [172.20.13.39]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="windows-1252"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1594802572; bh=3xiQ0vTDOSTESSN096aBDlKYmYjzrdf/LhVyTEamGSc=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=nc7TV2jLCSjE3pSrrGfu/3q01u0z0h9PWL0U6XakGVGY4UqrVPyuW4xTolcE0HET4
         9qp+6VYCgB2I9PqGZaNwqVVNMmtnrC14xan6oxdDMn9q+sx7+8EGXr1cgOFN4KKcdQ
         vXfNKcIxRyn6hkm/FOHJw2GHkYQ7TVJi3Yfu9cluLqu67f5fkRnbT2NtX7NPw87phJ
         CXKKVCd8ZVY+UeHBD+bz7iaM7/nPk3s+pVuV3hDpocPthL+c0980bsGJOTmrrUAvqb
         bhAjyMx2jZvFR8DnFPpDUggd5+451h4klTBbtIZY4hkJxi2knFNDqCJ0orF0ZiUsD+
         f2UXlqXmCR4ZA==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 14/07/2020 10:32, Thierry Reding wrote:
> On Sun, Jul 12, 2020 at 11:28:37AM +0100, Jon Hunter wrote:
>> After commit cad064f1bd52 ("devres: handle zero size in devm_kmalloc()")
>> was added system suspend started failing on Tegra186. The kernel log
>> showed that the Tegra XHCI driver was crashing on entry to suspend when
>> attemptin the save the USB context. The problem is caused because we
>> are trying to allocate a zero length array for the IPFS context on
>> Tegra186 and following commit cad064f1bd52 ("devres: handle zero size
>> in devm_kmalloc()") this now causes a NULL pointer deference crash
>> when we try to access the memory. Fix this by only allocating memory
>> for both the IPFS and FPCI contexts when required.
>>
>> Cc: stable@vger.kernel.org
>>
>> Fixes: 5c4e8d3781bc ("usb: host: xhci-tegra: Add support for XUSB context save/restore")
>>
>> Signed-off-by: Jon Hunter <jonathanh@nvidia.com>
>> ---
>>  drivers/usb/host/xhci-tegra.c | 22 ++++++++++++++--------
>>  1 file changed, 14 insertions(+), 8 deletions(-)
> 
> Actually it would seem to me that this is no longer a bug after your fix
> in patch 1. We only ever access tegra->context.ipfs if
> tegra->soc->ipfs.num_offsets > 0, so the special ZERO_SIZE_PTR case will
> not actually cause an issue anymore.
> 
> The reason why this was crashing was because tegra->context.fpci was
> allocated with a zero size (because of the bug that you fixed in patch
> 1) and then that zero-size pointer was dereferenced because the code was
> correctly checking for tegra->soc->fpci.num_offsets > 0 in the context
> save and restore.
> 
> So I don't think there's a bug here. It's not wrong to allocate a zero-
> size buffer. It's only a bug to then go and dereference it. Are you
> still seeing the issue if you leave out this patch and only apply patch
> 1?

Ah yes you are right. OK, we can drop this. I will update the commit
message to patch 1/1.

Jon

-- 
nvpublic
