Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC3355AE722
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 14:03:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237050AbiIFMCj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 08:02:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232906AbiIFMCe (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 08:02:34 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06DF479637
        for <stable@vger.kernel.org>; Tue,  6 Sep 2022 05:02:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 97CADB8188A
        for <stable@vger.kernel.org>; Tue,  6 Sep 2022 12:02:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E662C433C1;
        Tue,  6 Sep 2022 12:02:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662465747;
        bh=haGz2JSkeUqopu/71UJkO4kBXmyLwgD8UHtX20K4/5A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=IxRl9cFYk3ovEqFSsIuDNaxJrKH4U9YTDtMSzkH5qlnU9R8ZC8o1G5WfWo1/1jw3t
         0MSizTZTiCaFiEP+MfGxVykJlX4VIiJHwihLWm1D8/5Y7np9W+Z8PNsJyr+MrY3oos
         FosrX/oTXH/3killGG20FKM3TJbxpZ6rLf1R8yVg=
Date:   Tue, 6 Sep 2022 14:02:24 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Adrian Hunter <adrian.hunter@intel.com>
Cc:     stable@vger.kernel.org, Ulf Hansson <ulf.hansson@linaro.org>,
        Seunghui Lee <sh043.lee@samsung.com>
Subject: Re: [PATCH 5.10] mmc: core: Fix UHS-I SD 1.8V workaround branch
Message-ID: <Yxc20M+KrFi9f8Nb@kroah.com>
References: <20220906060834.58305-1-adrian.hunter@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220906060834.58305-1-adrian.hunter@intel.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 06, 2022 at 09:08:34AM +0300, Adrian Hunter wrote:
> commit 15c56208c79c340686869c31595c209d1431c5e8 upstream.
> 
> When introduced, upon success, the 1.8V fixup workaround in
> mmc_sd_init_card() would branch to practically the end of the function, to
> a label named "done". Unfortunately, perhaps due to the label name, over
> time new code has been added that really should have come after "done" not
> before it. Let's fix the problem by moving the label to the correct place
> and rename it "cont".
> 
> Fixes: 045d705dc1fb ("mmc: core: Enable the MMC host software queue for the SD card")
> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
> Reviewed-by: Seunghui Lee <sh043.lee@samsung.com>
> Cc: stable@vger.kernel.org
> Link: https://lore.kernel.org/r/20220815073321.63382-2-adrian.hunter@intel.com
> Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
> [Backport to 5.10]
> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
> ---
>  drivers/mmc/core/sd.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)

Now queued up, thanks.

greg k-h
