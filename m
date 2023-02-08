Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64FE868EF46
	for <lists+stable@lfdr.de>; Wed,  8 Feb 2023 13:44:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229483AbjBHMoO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Feb 2023 07:44:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230414AbjBHMoO (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Feb 2023 07:44:14 -0500
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF5C73C16;
        Wed,  8 Feb 2023 04:44:12 -0800 (PST)
Received: from lhrpeml500005.china.huawei.com (unknown [172.18.147.201])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4PBfm73Ht9z6J9mD;
        Wed,  8 Feb 2023 20:42:47 +0800 (CST)
Received: from localhost (10.202.227.76) by lhrpeml500005.china.huawei.com
 (7.191.163.240) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.17; Wed, 8 Feb
 2023 12:44:10 +0000
Date:   Wed, 8 Feb 2023 12:44:09 +0000
From:   Jonathan Cameron <Jonathan.Cameron@Huawei.com>
To:     Dan Williams <dan.j.williams@intel.com>
CC:     <linux-cxl@vger.kernel.org>, <stable@vger.kernel.org>,
        <dave.hansen@linux.intel.com>, <linux-mm@kvack.org>,
        <linux-acpi@vger.kernel.org>
Subject: Re: [PATCH 10/18] cxl/region: Fix passthrough-decoder detection
Message-ID: <20230208124409.0000658e@Huawei.com>
In-Reply-To: <167564540422.847146.13816934143225777888.stgit@dwillia2-xfh.jf.intel.com>
References: <167564534874.847146.5222419648551436750.stgit@dwillia2-xfh.jf.intel.com>
        <167564540422.847146.13816934143225777888.stgit@dwillia2-xfh.jf.intel.com>
Organization: Huawei Technologies Research and Development (UK) Ltd.
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.202.227.76]
X-ClientProxiedBy: lhrpeml500001.china.huawei.com (7.191.163.213) To
 lhrpeml500005.china.huawei.com (7.191.163.240)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, 05 Feb 2023 17:03:24 -0800
Dan Williams <dan.j.williams@intel.com> wrote:

> A passthrough decoder is a decoder that maps only 1 target. It is a
> special case because it does not impose any constraints on the
> interleave-math as compared to a decoder with multiple targets. Extend
> the passthrough case to multi-target-capable decoders that only have one
> target selected. I.e. the current code was only considering passthrough
> *ports* which are only a subset of the potential passthrough decoder
> scenarios.
> 
> Fixes: e4f6dfa9ef75 ("cxl/region: Fix 'distance' calculation with passthrough ports")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
>  drivers/cxl/core/region.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/cxl/core/region.c b/drivers/cxl/core/region.c
> index c82d3b6f3d1f..34cf95217901 100644
> --- a/drivers/cxl/core/region.c
> +++ b/drivers/cxl/core/region.c
> @@ -1019,10 +1019,10 @@ static int cxl_port_setup_targets(struct cxl_port *port,
>  		int i, distance;
>  
>  		/*
> -		 * Passthrough ports impose no distance requirements between
> +		 * Passthrough decoders impose no distance requirements between
>  		 * peers

I think we have a terminology inconsistency.  My understanding was we were using
passthrough decoders for the special case where there is no programmable hardware.
In this case I think we are also considering the case where that hardware must
be programmed etc, it's just that we don't care about interleave.
I'd just explain what it is rather than trying to assign a term. 

Decoders that have a single target configured impose...



>  		 */
> -		if (port->nr_dports == 1)
> +		if (cxl_rr->nr_targets == 1)
>  			distance = 0;
>  		else
>  			distance = p->nr_targets / cxl_rr->nr_targets;
> 
> 

