Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5121350CB9C
	for <lists+stable@lfdr.de>; Sat, 23 Apr 2022 17:16:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231972AbiDWPTL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 23 Apr 2022 11:19:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232001AbiDWPTK (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 23 Apr 2022 11:19:10 -0400
Received: from mail-oa1-x29.google.com (mail-oa1-x29.google.com [IPv6:2001:4860:4864:20::29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B21933A22
        for <stable@vger.kernel.org>; Sat, 23 Apr 2022 08:16:13 -0700 (PDT)
Received: by mail-oa1-x29.google.com with SMTP id 586e51a60fabf-e5ca5c580fso11679316fac.3
        for <stable@vger.kernel.org>; Sat, 23 Apr 2022 08:16:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=+Z8i3Sf79kQmbsZCRy7tgX2BrMIrvDhagSyA9O02bRs=;
        b=b8+1G7DuMVB/EgYkfLbMFJSWeyUtfh8tukMduU8Jwkm8r7mlMq73cST1V1AWe4JKrP
         VSd4nb9d7C9HaKkZUhxpae0cnj+nPe3xHdMp1R49IEmQOhWeXHAyGTWPyBcYyFGO72aV
         uxZjsif+DoBP+6l4B7WMhWLRQ7yl9EBoIXP16WMw1s0kDcgtRHPD++PoHquvsJ1pm6x/
         o79jja6Ku4GYWKJ4jJWO+/hnFc1yw6YbmUCynhwKKxP2RKYIseX5AWP9DKKzRujm6XLx
         mKumKkgDze1G0/S4C0FuLTFvoT/GE3i+bWnJJjmKyTh0axUmcNpZL+4pwyBAwykcmjLe
         KlgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=+Z8i3Sf79kQmbsZCRy7tgX2BrMIrvDhagSyA9O02bRs=;
        b=NXDvMYb023CTIgJXmftOIGRcgKz+G99KFJCmyYDAz8A4qAbf3AL9ZkFaE1fc+MkX4E
         o7R72DWTSB3nm8oyp5BK1q3kijOzNVhLR50RXNKRjZy0oPg+02+PWksc9WThQ9Kyd4dZ
         XRQ2cmst3TZ+SasNlsyobbP2qM85qUW0UyjPmbrhP3F6cOLttiv4VMk5+uyz3GNCGsgv
         x65V62BQITfUFvXP5vPAxcGPhZzY5Uab5R0SFJVXJbRbSfxOFesgjujnSVTFiYlkrwFi
         zHZB2GAzEWSwkHLuqpOnUwIx+mvuR+hUnLehNAwak8szpuKi8gPbNYgpE8eCtBCiP72Y
         +a8Q==
X-Gm-Message-State: AOAM532Um47txZZZTMZS0SsxzKXr3LsQLSUPaQtMBhE5h3CJWRKj6Ztc
        cpMbFQtpvYQJEc0dIwsR5V7zJGFGCasLpElp
X-Google-Smtp-Source: ABdhPJzuY1MsOi4UM15qQCC37vc8BRI0PBgBxIkc8xCzrR15vBpdXvAOqP6rg2XV8ToSSAFumy/yAQ==
X-Received: by 2002:a05:6870:c110:b0:e7:ff9e:c888 with SMTP id f16-20020a056870c11000b000e7ff9ec888mr3600693oad.19.1650726972533;
        Sat, 23 Apr 2022 08:16:12 -0700 (PDT)
Received: from ripper ([2600:1700:a0:3dc8:205:1bff:fec0:b9b3])
        by smtp.gmail.com with ESMTPSA id w36-20020a05687033a400b000d75f1d9b82sm1645301oae.47.2022.04.23.08.16.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 Apr 2022 08:16:11 -0700 (PDT)
Date:   Sat, 23 Apr 2022 08:18:12 -0700
From:   Bjorn Andersson <bjorn.andersson@linaro.org>
To:     Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Cc:     martin.petersen@oracle.com, jejb@linux.ibm.com,
        avri.altman@wdc.com, alim.akhtar@samsung.com,
        linux-arm-msm@vger.kernel.org, quic_asutoshd@quicinc.com,
        quic_cang@quicinc.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, bvanassche@acm.org,
        ahalaney@redhat.com, stable@vger.kernel.org
Subject: Re: [PATCH v2 3/5] scsi: ufs: qcom: Add a readl() to make sure
 ref_clk gets enabled
Message-ID: <YmQYtHfSYJxKwivg@ripper>
References: <20220423140245.394092-1-manivannan.sadhasivam@linaro.org>
 <20220423140245.394092-4-manivannan.sadhasivam@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220423140245.394092-4-manivannan.sadhasivam@linaro.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat 23 Apr 07:02 PDT 2022, Manivannan Sadhasivam wrote:

> In ufs_qcom_dev_ref_clk_ctrl(), it was noted that the ref_clk needs to be
> stable for at least 1us. Even though there is wmb() to make sure the write
> gets "completed", there is no guarantee that the write actually reached
> the UFS device. There is a good chance that the write could be stored in
> a Write Buffer (WB). In that case, even though the CPU waits for 1us, the
> ref_clk might not be stable for that period.
> 
> So lets do a readl() to make sure that the previous write has reached the
> UFS device before udelay().
> 
> Also, the wmb() after writel_relaxed is not really needed. Both writel and
> readl are ordered on all architectures and the CPU won't speculate
> instructions after readl() due to the in-built control dependency with
> read value on weakly ordered architectures. So it can be safely removed.
> 
> Cc: stable@vger.kernel.org
> Fixes: f06fcc7155dc ("scsi: ufs-qcom: add QUniPro hardware support and power optimizations")
> Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>

Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>

> ---
>  drivers/scsi/ufs/ufs-qcom.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufs-qcom.c b/drivers/scsi/ufs/ufs-qcom.c
> index 6ee33cc0ad09..f47a16b7cff5 100644
> --- a/drivers/scsi/ufs/ufs-qcom.c
> +++ b/drivers/scsi/ufs/ufs-qcom.c
> @@ -687,8 +687,11 @@ static void ufs_qcom_dev_ref_clk_ctrl(struct ufs_qcom_host *host, bool enable)
>  
>  		writel_relaxed(temp, host->dev_ref_clk_ctrl_mmio);
>  
> -		/* ensure that ref_clk is enabled/disabled before we return */
> -		wmb();
> +		/*
> +		 * Make sure the write to ref_clk reaches the destination and
> +		 * not stored in a Write Buffer (WB).
> +		 */
> +		readl(host->dev_ref_clk_ctrl_mmio);
>  
>  		/*
>  		 * If we call hibern8 exit after this, we need to make sure that
> -- 
> 2.25.1
> 
