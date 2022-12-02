Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADC49640856
	for <lists+stable@lfdr.de>; Fri,  2 Dec 2022 15:23:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232307AbiLBOXe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Dec 2022 09:23:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbiLBOXd (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Dec 2022 09:23:33 -0500
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE565CE40D;
        Fri,  2 Dec 2022 06:23:31 -0800 (PST)
Received: from frapeml500005.china.huawei.com (unknown [172.18.147.207])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4NNwC75HWyz67Zy6;
        Fri,  2 Dec 2022 22:22:59 +0800 (CST)
Received: from lhrpeml500005.china.huawei.com (7.191.163.240) by
 frapeml500005.china.huawei.com (7.182.85.13) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 2 Dec 2022 15:23:30 +0100
Received: from localhost (10.202.227.76) by lhrpeml500005.china.huawei.com
 (7.191.163.240) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Fri, 2 Dec
 2022 14:23:29 +0000
Date:   Fri, 2 Dec 2022 14:23:28 +0000
From:   Jonathan Cameron <Jonathan.Cameron@Huawei.com>
To:     Dan Williams <dan.j.williams@intel.com>
CC:     <linux-cxl@vger.kernel.org>, <stable@vger.kernel.org>,
        <dave.jiang@intel.com>, <nvdimm@lists.linux.dev>,
        <dave@stgolabs.net>
Subject: Re: [PATCH 2/5] cxl/region: Fix missing probe failure
Message-ID: <20221202142328.00004254@Huawei.com>
In-Reply-To: <166993220462.1995348.1698008475198427361.stgit@dwillia2-xfh.jf.intel.com>
References: <166993219354.1995348.12912519920112533797.stgit@dwillia2-xfh.jf.intel.com>
        <166993220462.1995348.1698008475198427361.stgit@dwillia2-xfh.jf.intel.com>
Organization: Huawei Technologies Research and Development (UK) Ltd.
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.202.227.76]
X-ClientProxiedBy: lhrpeml500002.china.huawei.com (7.191.160.78) To
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

On Thu, 01 Dec 2022 14:03:24 -0800
Dan Williams <dan.j.williams@intel.com> wrote:

> cxl_region_probe() allows for regions not in the 'commit' state to be
> enabled. Fail probe when the region is not committed otherwise the
> kernel may indicate that an address range is active when none of the
> decoders are active.
> 
> Fixes: 8d48817df6ac ("cxl/region: Add region driver boiler plate")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Huh. I wonder why this wasn't triggering a build warning given
rc is assigned but unused.

Ah well, this is clearly the original intent and makes sense.

Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>

> ---
>  drivers/cxl/core/region.c |    3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/cxl/core/region.c b/drivers/cxl/core/region.c
> index f9ae5ad284ff..1bc2ebefa2a5 100644
> --- a/drivers/cxl/core/region.c
> +++ b/drivers/cxl/core/region.c
> @@ -1923,6 +1923,9 @@ static int cxl_region_probe(struct device *dev)
>  	 */
>  	up_read(&cxl_region_rwsem);
>  
> +	if (rc)
> +		return rc;
> +
>  	switch (cxlr->mode) {
>  	case CXL_DECODER_PMEM:
>  		return devm_cxl_add_pmem_region(cxlr);
> 

