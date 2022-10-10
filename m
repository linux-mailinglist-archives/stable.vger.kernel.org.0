Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D3175F986A
	for <lists+stable@lfdr.de>; Mon, 10 Oct 2022 08:34:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230326AbiJJGea (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Oct 2022 02:34:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231298AbiJJGe3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Oct 2022 02:34:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B23AF5601D
        for <stable@vger.kernel.org>; Sun,  9 Oct 2022 23:34:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 742A6B80DE2
        for <stable@vger.kernel.org>; Mon, 10 Oct 2022 06:34:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA98BC433D6;
        Mon, 10 Oct 2022 06:34:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665383666;
        bh=L7YFDp5Car26g03MG1SdTXQA1CGKrEqm7LNsd0pKYVU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=C/diJJEwVNw/4wIXebzrMo50EZfur4Cxo/QanZ4uGmkdJA8d9nYwdXwRInmkgknvG
         hXCwXm3a+uyNxMSDHIBeav1NIWvFnuQvzuk0Xz/ANpwQiMP+Vv+CLK5fbZYtc7ZQmy
         OIhzvZOBDTCi2Kka7VUY6lmZXyDBhwcs9AYpJdlc=
Date:   Mon, 10 Oct 2022 08:34:59 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Brian Norris <briannorris@chromium.org>
Cc:     stable@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: Re: [5.19.y PATCH 2/2] mmc: core: Terminate infinite loop in SD-UHS
 voltage switch
Message-ID: <Y0O9E8QzLm/lEZQq@kroah.com>
References: <20221007183647.2775030-1-briannorris@chromium.org>
 <20221007183647.2775030-2-briannorris@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221007183647.2775030-2-briannorris@chromium.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Oct 07, 2022 at 11:36:47AM -0700, Brian Norris wrote:
> commit e9233917a7e53980664efbc565888163c0a33c3f upstream.
> 
> This loop intends to retry a max of 10 times, with some implicit
> termination based on the SD_{R,}OCR_S18A bit. Unfortunately, the
> termination condition depends on the value reported by the SD card
> (*rocr), which may or may not correctly reflect what we asked it to do.
> 
> Needless to say, it's not wise to rely on the card doing what we expect;
> we should at least terminate the loop regardless. So, check both the
> input and output values, so we ensure we will terminate regardless of
> the SD card behavior.
> 
> Note that SDIO learned a similar retry loop in commit 0797e5f1453b
> ("mmc: core: Fixup signal voltage switch"), but that used the 'ocr'
> result, and so the current pre-terminating condition looks like:
> 
>     rocr & ocr & R4_18V_PRESENT
> 
> (i.e., it doesn't have the same bug.)
> 
> This addresses a number of crash reports seen on ChromeOS that look
> like the following:
> 
>     ... // lots of repeated: ...
>     <4>[13142.846061] mmc1: Skipping voltage switch
>     <4>[13143.406087] mmc1: Skipping voltage switch
>     <4>[13143.964724] mmc1: Skipping voltage switch
>     <4>[13144.526089] mmc1: Skipping voltage switch
>     <4>[13145.086088] mmc1: Skipping voltage switch
>     <4>[13145.645941] mmc1: Skipping voltage switch
>     <3>[13146.153969] INFO: task halt:30352 blocked for more than 122 seconds.
>     ...
> 
> Fixes: f2119df6b764 ("mmc: sd: add support for signal voltage switch procedure")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Brian Norris <briannorris@chromium.org>
> Reviewed-by: Guenter Roeck <linux@roeck-us.net>
> Link: https://lore.kernel.org/r/20220914014010.2076169-1-briannorris@chromium.org
> Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
> ---
> Should also apply cleanly to 4.14.y and newer.

All now queued up.

greg k-h
