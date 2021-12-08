Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A1BB46D5AD
	for <lists+stable@lfdr.de>; Wed,  8 Dec 2021 15:31:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235131AbhLHOem (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Dec 2021 09:34:42 -0500
Received: from mail-ot1-f42.google.com ([209.85.210.42]:44812 "EHLO
        mail-ot1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235127AbhLHOel (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Dec 2021 09:34:41 -0500
Received: by mail-ot1-f42.google.com with SMTP id u18-20020a9d7212000000b00560cb1dc10bso2867966otj.11;
        Wed, 08 Dec 2021 06:31:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OU8Tfo1Ya6ArgVKO7nt7tfp7sawO6L+cjBdMbs7fvWw=;
        b=tX2J9ut6PsEE4GWnsPJzi0hiu/qMQ39tk3M9o0T5w4yYOI9Z1EkaI5HSaRVUPXO6ey
         KDcRgQ1GXoOVYyPrM42WJYHqEC9STRx+sFrk1Gohl1+DHteKBOQpOTvz/tbaLBN7Iy50
         mz6o0PYvZppXIhmNEAId1/ISy+QgMr24KuL4ZbYiNY3Ko7rxYW85F8I/coLOxMp+TdJ4
         JdnJVzoyrJLJGASFhj1u/3MzRRLg3AaFglAwtMGZ0MBfwiclgiBbl2ga9YNYb7TfPjr7
         qdPa36BFaiTFIlTQTXb4gZ9Hmxctep7wwNwqB/Dq12gMcRL2eEeZsgFkr50k+NQl1QEE
         /0bQ==
X-Gm-Message-State: AOAM533D9TeBEF7pE+wIiDXcyxtsMkn7BzhijF5Jr6TfhfFgwAyOqgXb
        NTyWjHqSX6IqceNWh1jPkVQd2cWm2Mwh7B5q5yViIOzi
X-Google-Smtp-Source: ABdhPJyaDlGsqAFyvGhaBefHZNLmTqz43e9r++yA7ID3Jltq+rjgyGzAsuMOS7SfCQTBZc4WR5BIEmCEvmKGd+2PdhY=
X-Received: by 2002:a9d:4c10:: with SMTP id l16mr41363239otf.198.1638973869376;
 Wed, 08 Dec 2021 06:31:09 -0800 (PST)
MIME-Version: 1.0
References: <20211207123539.17346-1-sumeet.r.pawnikar@intel.com>
In-Reply-To: <20211207123539.17346-1-sumeet.r.pawnikar@intel.com>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Wed, 8 Dec 2021 15:30:58 +0100
Message-ID: <CAJZ5v0jwjW_HAuEpFdj0+q0ybSck6JDArBxDNatghMMQhDch9g@mail.gmail.com>
Subject: Re: [PATCH] thermal/drivers/int340x: fix: update VCoRefLow MMIO bit
 offset for read
To:     Sumeet Pawnikar <sumeet.r.pawnikar@intel.com>
Cc:     Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        "Zhang, Rui" <rui.zhang@intel.com>,
        Amit Kucheria <amitk@kernel.org>,
        Linux PM <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Dec 7, 2021 at 1:36 PM Sumeet Pawnikar
<sumeet.r.pawnikar@intel.com> wrote:
>
> As part of RFIM validation, found that the register definition VCoRefLow
> of the CPU FIVR registers are different. Current implementation reads it
> from MMIO offset 0x5A18 and bit offset [12:14]. But the actual correct
> register definition is from bit offset [11:13]. Updated to the correct
> bit offset.
>
> Fixes: 473be51142ad ("thermal: int340x: processor_thermal: Add RFIM driver")
> Signed-off-by: Sumeet Pawnikar <sumeet.r.pawnikar@intel.com>
> Cc: stable@vger.kernel.org # 5.14+
> ---
>  drivers/thermal/intel/int340x_thermal/processor_thermal_rfim.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/thermal/intel/int340x_thermal/processor_thermal_rfim.c b/drivers/thermal/intel/int340x_thermal/processor_thermal_rfim.c
> index b25b54d4bac1..e693ec8234fb 100644
> --- a/drivers/thermal/intel/int340x_thermal/processor_thermal_rfim.c
> +++ b/drivers/thermal/intel/int340x_thermal/processor_thermal_rfim.c
> @@ -29,7 +29,7 @@ static const char * const fivr_strings[] = {
>  };
>
>  static const struct mmio_reg tgl_fivr_mmio_regs[] = {
> -       { 0, 0x5A18, 3, 0x7, 12}, /* vco_ref_code_lo */
> +       { 0, 0x5A18, 3, 0x7, 11}, /* vco_ref_code_lo */
>         { 0, 0x5A18, 8, 0xFF, 16}, /* vco_ref_code_hi */
>         { 0, 0x5A08, 8, 0xFF, 0}, /* spread_spectrum_pct */
>         { 0, 0x5A08, 1, 0x1, 8}, /* spread_spectrum_clk_enable */
> --

Applied (with edits in the subject and changelog) as 5.16-rc material, thanks!
