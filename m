Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41C9F2A82D1
	for <lists+stable@lfdr.de>; Thu,  5 Nov 2020 16:58:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731437AbgKEP6B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Nov 2020 10:58:01 -0500
Received: from fllv0015.ext.ti.com ([198.47.19.141]:43372 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730973AbgKEP6A (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Nov 2020 10:58:00 -0500
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 0A5FvtNs030602;
        Thu, 5 Nov 2020 09:57:55 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1604591875;
        bh=cRyNJqFzegPh24HdCscOHLjKNMorB21SUKPbtr+eBTU=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=S93VqGNiaXIS5IvvEUoiwSZIhkSUCmjkFHhJo/TVSiUfKWOIAbkWM1DtmpEQdsjDv
         ZFEOzywux+NfNp9A0xR7/MueyLV7vWAu1HgqMS/Ame0zi/DFvefbsbtBbs7NZHvAoR
         QbtJy4RyrLnxFhUZ/9SNPeo6ZEKP2d2iXz+WXjMk=
Received: from DFLE112.ent.ti.com (dfle112.ent.ti.com [10.64.6.33])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 0A5Fvt3O093280
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 5 Nov 2020 09:57:55 -0600
Received: from DFLE103.ent.ti.com (10.64.6.24) by DFLE112.ent.ti.com
 (10.64.6.33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Thu, 5 Nov
 2020 09:57:55 -0600
Received: from lelv0327.itg.ti.com (10.180.67.183) by DFLE103.ent.ti.com
 (10.64.6.24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Thu, 5 Nov 2020 09:57:55 -0600
Received: from [10.250.233.179] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 0A5FvrOL014669;
        Thu, 5 Nov 2020 09:57:54 -0600
Subject: Re: [PATCH] mtd: cfi_cmdset_0002: Use status register where possible
To:     Joakim Tjernlund <joakim.tjernlund@infinera.com>,
        "linux-mtd @ lists . infradead . org" <linux-mtd@lists.infradead.org>
CC:     <stable@vger.kernel.org>
References: <20201022154506.17639-1-joakim.tjernlund@infinera.com>
From:   Vignesh Raghavendra <vigneshr@ti.com>
Message-ID: <256798c1-e7b6-4bfb-bdc7-b143cb2f0502@ti.com>
Date:   Thu, 5 Nov 2020 21:27:52 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201022154506.17639-1-joakim.tjernlund@infinera.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Joakim,

On 10/22/20 9:15 PM, Joakim Tjernlund wrote:
> Commit "mtd: cfi_cmdset_0002: Add support for polling status register"

Standard way to refer to a commit is:

Commit 4844ef80305d ("mtd: cfi_cmdset_0002: Add support for polling status register")

> added support for polling the status rather than using DQ polling.
> However, status register is used only when DQ polling is missing.
> Lets use status register when available as it is superior to DQ polling.
> 
> Signed-off-by: Joakim Tjernlund <joakim.tjernlund@infinera.com>
> Cc: stable@vger.kernel.org
> ---
>  drivers/mtd/chips/cfi_cmdset_0002.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/mtd/chips/cfi_cmdset_0002.c b/drivers/mtd/chips/cfi_cmdset_0002.c
> index a1f3e1031c3d..ee9b322e63bb 100644
> --- a/drivers/mtd/chips/cfi_cmdset_0002.c
> +++ b/drivers/mtd/chips/cfi_cmdset_0002.c
> @@ -117,7 +117,7 @@ static struct mtd_chip_driver cfi_amdstd_chipdrv = {
>  static int cfi_use_status_reg(struct cfi_private *cfi)
>  {
>  	struct cfi_pri_amdstd *extp = cfi->cmdset_priv;
> -	u8 poll_mask = CFI_POLL_STATUS_REG | CFI_POLL_DQ;
> +	u8 poll_mask = CFI_POLL_STATUS_REG;

This local variable now looks pointless and can be dropped.. So,

>  	return extp->MinorVersion >= '5' &&
>  		(extp->SoftwareFeatures & poll_mask) == CFI_POLL_STATUS_REG;
> 

	return extp->MinorVersion >= '5' &&
  			(extp->SoftwareFeatures & CFI_POLL_STATUS_REG);

Regards
Vignesh
