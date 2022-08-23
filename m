Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 018A959E3C8
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:44:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242089AbiHWMdZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 08:33:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239324AbiHWM3h (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 08:29:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F5699A965
        for <stable@vger.kernel.org>; Tue, 23 Aug 2022 02:45:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8DA686138B
        for <stable@vger.kernel.org>; Tue, 23 Aug 2022 09:44:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9477EC433C1;
        Tue, 23 Aug 2022 09:44:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661247853;
        bh=5VnopQ/I9SCUlyB0Lmukczx3+amUB5IUn2tr6Vri5lY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=vYzRV63m7FhSCBW+OQZvoYuRmF4kCOgwHmCqm0Dr7u/HdmC0rH95DJJvRizJpb42G
         CUGTOTDpDG2XXPCjIIC4b6qbP+fLOGb0nMouAtuZ9jogMIRcBGhZKFW0X9zpyAyEyb
         d/NBA7LOyowTIlzPAAkdDB9sABtMcO17XOEE46I0=
Date:   Tue, 23 Aug 2022 10:30:22 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jens Wiklander <jens.wiklander@linaro.org>
Cc:     stable@vger.kernel.org, Pavel Machek <pavel@denx.de>
Subject: Re: [PATCH for 5.10.y] tee: fix memory leak in tee_shm_register()
Message-ID: <YwSQHoHoH/kOriOA@kroah.com>
References: <20220823082326.9155-1-jens.wiklander@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220823082326.9155-1-jens.wiklander@linaro.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 23, 2022 at 10:23:26AM +0200, Jens Wiklander wrote:
> Moves the access_ok() check for valid memory range from user space from
> the function tee_shm_register() to tee_ioctl_shm_register(). With this
> we error out early before anything is done that must be undone on error.
> 
> Fixes: 578c349570d2 ("tee: add overflow check in register_shm_helper()")
> Cc: stable@vger.kernel.org # 5.10
> Reported-by: Pavel Machek <pavel@denx.de>
> Signed-off-by: Jens Wiklander <jens.wiklander@linaro.org>
> ---
> Hi,
> 
> This patch targets the 5.10.y release to take care of a recently introduced
> issue there.

Thanks, now queued up.

greg k-h
