Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A46D3675D2C
	for <lists+stable@lfdr.de>; Fri, 20 Jan 2023 19:56:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229689AbjATS4K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Jan 2023 13:56:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbjATS4J (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Jan 2023 13:56:09 -0500
Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 179166C12C;
        Fri, 20 Jan 2023 10:56:05 -0800 (PST)
Received: from zn.tnic (p5de8e9fe.dip0.t-ipconnect.de [93.232.233.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 956681EC0682;
        Fri, 20 Jan 2023 19:56:03 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1674240963;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=nNdhkNTHsvTW1v9Je9j5xMnmdfrjN9ZvkDa4cJMrLxE=;
        b=IjjRnqRKu6QaNTF3MMG/a9bqezfBraHl6lJvJZBwxln/lQItXFr6zSkja7hi6F7+F3/FE3
        OcG9MdTx9uE6WKyzChH83Q0qDKcdxh55tuzYHqRnyhdgWQUW2QrMwCdWKBu6eDEbQ+kFhW
        4rN5vsFELNRIE+48QuW53DWVSbTouic=
Date:   Fri, 20 Jan 2023 19:56:03 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Cc:     andersson@kernel.org, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, tony.luck@intel.com,
        quic_saipraka@quicinc.com, konrad.dybcio@linaro.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        james.morse@arm.com, mchehab@kernel.org, rric@kernel.org,
        linux-edac@vger.kernel.org, quic_ppareek@quicinc.com,
        luca.weiss@fairphone.com, ahalaney@redhat.com, steev@kali.org,
        stable@vger.kernel.org
Subject: Re: [PATCH v6 03/17] EDAC/qcom: Do not pass llcc_driv_data as
 edac_device_ctl_info's pvt_info
Message-ID: <Y8rjw/VLXICtK0hO@zn.tnic>
References: <20230118150904.26913-1-manivannan.sadhasivam@linaro.org>
 <20230118150904.26913-4-manivannan.sadhasivam@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230118150904.26913-4-manivannan.sadhasivam@linaro.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jan 18, 2023 at 08:38:50PM +0530, Manivannan Sadhasivam wrote:
> The memory for "llcc_driv_data" is allocated by the LLCC driver. But when
> it is passed as "pvt_info" to the EDAC core, it will get freed during the
> qcom_edac driver release. So when the qcom_edac driver gets probed again,
> it will try to use the freed data leading to the use-after-free bug.
> 
> Hence, do not pass "llcc_driv_data" as pvt_info but rather reference it
> using the "platform_data" in the qcom_edac driver.
> 
> Cc: <stable@vger.kernel.org> # 4.20
> Fixes: 27450653f1db ("drivers: edac: Add EDAC driver support for QCOM SoCs")
> Tested-by: Steev Klimaszewski <steev@kali.org> # Thinkpad X13s
> Tested-by: Andrew Halaney <ahalaney@redhat.com> # sa8540p-ride
> Reported-by: Steev Klimaszewski <steev@kali.org>
> Reviewed-by: Borislav Petkov (AMD) <bp@alien8.de>
> Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
> ---
>  drivers/edac/qcom_edac.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)

Applied, thanks.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
