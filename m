Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADEB66118FB
	for <lists+stable@lfdr.de>; Fri, 28 Oct 2022 19:11:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231147AbiJ1RLM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Oct 2022 13:11:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231216AbiJ1RK1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 Oct 2022 13:10:27 -0400
Received: from mail-qk1-f181.google.com (mail-qk1-f181.google.com [209.85.222.181])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A051679634;
        Fri, 28 Oct 2022 10:08:25 -0700 (PDT)
Received: by mail-qk1-f181.google.com with SMTP id k4so939015qkj.8;
        Fri, 28 Oct 2022 10:08:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ACYDNRFbUSp7i+jczQsEaccisHzmM8JzMkLPkBS56xA=;
        b=5vDmIOQf81ZFU5qBvZSjqx7AAnhKoYtT2vR36fSW4Y6td7r7pf+G69dti9r0CEEC5a
         lk62meRaHfTNon+bmVd00kKn0gmzG/YF17yZfdLxxaxPJUD3xJq9uZ/Ny1MPqCWoJ6bT
         iuO1ydEBeC+qGxVjK4kfUKN9rcJLG3SblbaP2Zhw6exXOU3GxXqkkFkhi2GT8LauY2/P
         MkYqA4uBDfstvZf9ZJsE6NE6jPFobR8T7R3mDCnI6O4n53icntDgDqsc0fZvinDAB64R
         jxKQWSJ+YKii1c4HiNpZNWHzxr9htg0QxOIlChXykoqdQ9nHrrhHCPtgDjYdVnpjcH/p
         ig9Q==
X-Gm-Message-State: ACrzQf0Kd5BIaIZB+g2SLAIlhwSmsqQkdu3cSefKsXu8Z7lfq0jZFRPa
        q2XsQ+LbJ68rgHvMt68iEu1XyOfS9BUQ2ze371s=
X-Google-Smtp-Source: AMsMyM6GirJGOCAxq2HD+MvgRGOX0aUHEUf8UPJWN5E1NV/YOWm4CZ7W0aezKcaOZwjW07YOs1f70zgtPQoCpcq932Y=
X-Received: by 2002:a37:b1c2:0:b0:6fa:1185:4dbf with SMTP id
 a185-20020a37b1c2000000b006fa11854dbfmr177991qkf.764.1666976904692; Fri, 28
 Oct 2022 10:08:24 -0700 (PDT)
MIME-Version: 1.0
References: <20221027042445.60108-1-xueshuai@linux.alibaba.com>
In-Reply-To: <20221027042445.60108-1-xueshuai@linux.alibaba.com>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Fri, 28 Oct 2022 19:08:13 +0200
Message-ID: <CAJZ5v0hdgxsDiXqOmeqBQoZUQJ1RssM=3jpYpWt3qzy0n2eyaA@mail.gmail.com>
Subject: Re: [PATCH] ACPI: APEI: set memory failure flags as
 MF_ACTION_REQUIRED on action required events
To:     Shuai Xue <xueshuai@linux.alibaba.com>
Cc:     rafael@kernel.org, lenb@kernel.org, james.morse@arm.com,
        tony.luck@intel.com, bp@alien8.de, dave.hansen@linux.intel.com,
        jarkko@kernel.org, naoya.horiguchi@nec.com, linmiaohe@huawei.com,
        akpm@linux-foundation.org, stable@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        cuibixuan@linux.alibaba.com, baolin.wang@linux.alibaba.com,
        zhuo.song@linux.alibaba.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 27, 2022 at 6:25 AM Shuai Xue <xueshuai@linux.alibaba.com> wrote:
>
> There are two major types of uncorrected error (UC) :
>
> - Action Required: The error is detected and the processor already consumes the
>   memory. OS requires to take action (for example, offline failure page/kill
>   failure thread) to recover this uncorrectable error.
>
> - Action Optional: The error is detected out of processor execution context.
>   Some data in the memory are corrupted. But the data have not been consumed.
>   OS is optional to take action to recover this uncorrectable error.
>
> For X86 platforms, we can easily distinguish between these two types
> based on the MCA Bank. While for arm64 platform, the memory failure
> flags for all UCs which severity are GHES_SEV_RECOVERABLE are set as 0,
> a.k.a, Action Optional now.
>
> If UC is detected by a background scrubber, it is obviously an Action
> Optional error.  For other errors, we should conservatively regard them
> as Action Required.
>
> cper_sec_mem_err::error_type identifies the type of error that occurred
> if CPER_MEM_VALID_ERROR_TYPE is set. So, set memory failure flags as 0
> for Scrub Uncorrected Error (type 14). Otherwise, set memory failure
> flags as MF_ACTION_REQUIRED.
>
> Signed-off-by: Shuai Xue <xueshuai@linux.alibaba.com>

I need input from the APEI reviewers on this.

Thanks!

> ---
>  drivers/acpi/apei/ghes.c | 10 ++++++++--
>  include/linux/cper.h     |  3 +++
>  2 files changed, 11 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
> index 80ad530583c9..6c03059cbfc6 100644
> --- a/drivers/acpi/apei/ghes.c
> +++ b/drivers/acpi/apei/ghes.c
> @@ -474,8 +474,14 @@ static bool ghes_handle_memory_failure(struct acpi_hest_generic_data *gdata,
>         if (sec_sev == GHES_SEV_CORRECTED &&
>             (gdata->flags & CPER_SEC_ERROR_THRESHOLD_EXCEEDED))
>                 flags = MF_SOFT_OFFLINE;
> -       if (sev == GHES_SEV_RECOVERABLE && sec_sev == GHES_SEV_RECOVERABLE)
> -               flags = 0;
> +       if (sev == GHES_SEV_RECOVERABLE && sec_sev == GHES_SEV_RECOVERABLE) {
> +               if (mem_err->validation_bits & CPER_MEM_VALID_ERROR_TYPE)
> +                       flags = mem_err->error_type == CPER_MEM_SCRUB_UC ?
> +                                       0 :
> +                                       MF_ACTION_REQUIRED;
> +               else
> +                       flags = MF_ACTION_REQUIRED;
> +       }
>
>         if (flags != -1)
>                 return ghes_do_memory_failure(mem_err->physical_addr, flags);
> diff --git a/include/linux/cper.h b/include/linux/cper.h
> index eacb7dd7b3af..b77ab7636614 100644
> --- a/include/linux/cper.h
> +++ b/include/linux/cper.h
> @@ -235,6 +235,9 @@ enum {
>  #define CPER_MEM_VALID_BANK_ADDRESS            0x100000
>  #define CPER_MEM_VALID_CHIP_ID                 0x200000
>
> +#define CPER_MEM_SCRUB_CE                      13
> +#define CPER_MEM_SCRUB_UC                      14
> +
>  #define CPER_MEM_EXT_ROW_MASK                  0x3
>  #define CPER_MEM_EXT_ROW_SHIFT                 16
>
> --
> 2.20.1.9.gb50a0d7
>
