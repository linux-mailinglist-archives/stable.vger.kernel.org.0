Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 391CD5F7BA0
	for <lists+stable@lfdr.de>; Fri,  7 Oct 2022 18:39:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229638AbiJGQjq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Oct 2022 12:39:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229627AbiJGQjp (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 7 Oct 2022 12:39:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24EFB659D;
        Fri,  7 Oct 2022 09:39:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AA108B82405;
        Fri,  7 Oct 2022 16:39:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2EBCC433D6;
        Fri,  7 Oct 2022 16:39:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665160778;
        bh=EVRiG8wrILRusZ071HgcPsFHaVuHPPSDKTYh/GkXZ2U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=CQ7yT9UAZqegW/mofAinMziszqqOitMFZSC3AUUAtoPdtCYZjL0XNKBntXsSWrPXP
         xad8rnCw2VUGFwtQR/74HdGoF4g7XkVnebPs0ex+uLvqGCWf+qS6LAuWYLYRQmnUTx
         kN5aPDpYOXcTADj0hvE1eW4GYgDhd73becO0nwwc=
Date:   Fri, 7 Oct 2022 18:40:19 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Andrew Chernyakov <acherniakov@astralinux.ru>
Cc:     Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@somainline.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        linux-arm-msm@vger.kernel.org, linux-remoteproc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        stable@vger.kernel.org, lvc-project@linuxtesting.org,
        Stephen Boyd <sboyd@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>
Subject: Re: [PATCH 5.10 1/1] rpmsg: qcom: glink: replace strncpy() with
 strscpy_pad()
Message-ID: <Y0BWc6A8C++M9TWP@kroah.com>
References: <20221007132931.123755-1-acherniakov@astralinux.ru>
 <20221007132931.123755-2-acherniakov@astralinux.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20221007132931.123755-2-acherniakov@astralinux.ru>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Oct 07, 2022 at 04:29:31PM +0300, Andrew Chernyakov wrote:
> From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
> 
> commit 766279a8f85df32345dbda03b102ca1ee3d5ddea upstream.
> 
> The use of strncpy() is considered deprecated for NUL-terminated
> strings[1]. Replace strncpy() with strscpy_pad(), to keep existing
> pad-behavior of strncpy, similarly to commit 08de420a8014 ("rpmsg:
> glink: Replace strncpy() with strscpy_pad()").  This fixes W=1 warning:
> 
>   In function ‘qcom_glink_rx_close’,
>     inlined from ‘qcom_glink_work’ at ../drivers/rpmsg/qcom_glink_native.c:1638:4:
>   drivers/rpmsg/qcom_glink_native.c:1549:17: warning: ‘strncpy’ specified bound 32 equals destination size [-Wstringop-truncation]
>    1549 |                 strncpy(chinfo.name, channel->name, sizeof(chinfo.name));
> 
> [1] https://www.kernel.org/doc/html/latest/process/deprecated.html#strncpy-on-nul-terminated-strings
> 
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
> Reviewed-by: Stephen Boyd <sboyd@kernel.org>
> Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
> Link: https://lore.kernel.org/r/20220519073330.7187-1-krzysztof.kozlowski@linaro.org
> Signed-off-by: Andrew Chernyakov <acherniakov@astralinux.ru>
> ---
>  drivers/rpmsg/qcom_glink_native.c | 2 +-
>  drivers/rpmsg/qcom_smd.c          | 4 ++--
>  2 files changed, 3 insertions(+), 3 deletions(-)

Why just this specific kernel branch?  We can't add patches to an older
tree and have someone upgrade to a newer one and hit the same issue.

So please provide backports for all active versions.  In this case that
would be 5.15.y and 5.19.y.

thanks,

greg k-h
