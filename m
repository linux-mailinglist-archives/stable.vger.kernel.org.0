Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA72A66DD95
	for <lists+stable@lfdr.de>; Tue, 17 Jan 2023 13:29:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236556AbjAQM3e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Jan 2023 07:29:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236237AbjAQM3d (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Jan 2023 07:29:33 -0500
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74E6C3864D;
        Tue, 17 Jan 2023 04:29:32 -0800 (PST)
Received: by mail-ej1-f48.google.com with SMTP id ud5so75000615ejc.4;
        Tue, 17 Jan 2023 04:29:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XvL/LegkvK9EKnxy8A3MR7YAU6rBsnrI3W2QeGatsPI=;
        b=JNWAAEInJ4C3rhzOkCxkFaOWtVPJV+LYAGVYG5NJgqxUeJouGzF6L8PKxMUJYmucL4
         jVXmFL6XEipqWIUQdKXmUvfga0sSCBpjvpJ2DK39ke7dRUQAv9RarLEX95Amj08kokuK
         6k691oxqfQzbNrWr7v7qKkRjozVi97trW7sAAVFzI/XxbB38YoWy0a3PZlzxs5nQMQZD
         BPH6DPrulS9ek2ibHwY0tDDrpeL9d9AF+kwVeUkE1elU8KTySZLPpt8Fi0xA1SLkHoN4
         ZgfLhXx8okSpEFNoQbOJlQ1wDYus3Jg2uCmS7T4TmzBYuXakj/xCRqR7aYVWnN64D/DG
         s7OQ==
X-Gm-Message-State: AFqh2kpHpOLuF4TnXlM8e5OST5JcElsoy2/RLMTdOfyNvpqwjLeOyPBv
        0LW+NSWIHa9nSR72lVNJm9BrjYx4HkQ4c14HfC+dL/gb6Vo=
X-Google-Smtp-Source: AMrXdXsQWqHCS3/TtVDjli00woZEy+CSyJpI9QvNFxvnRdUDZbgiQ/lqyWwO/YWAa5w9evS8i1VBpGNbCzXdsf0Yr7A=
X-Received: by 2002:a17:906:d971:b0:84d:381c:bdaa with SMTP id
 rp17-20020a170906d97100b0084d381cbdaamr269463ejb.79.1673958570951; Tue, 17
 Jan 2023 04:29:30 -0800 (PST)
MIME-Version: 1.0
References: <20230112133319.3615177-1-ardb@kernel.org>
In-Reply-To: <20230112133319.3615177-1-ardb@kernel.org>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Tue, 17 Jan 2023 13:29:14 +0100
Message-ID: <CAJZ5v0iuwwDjDQDsdP3uvAO18EOcWXzCS6Yu0g62q40Em0vSOA@mail.gmail.com>
Subject: Re: [PATCH v2] ACPI: PRM: Check whether EFI runtime is available
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     linux-efi@vger.kernel.org, stable@vger.kernel.org,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 12, 2023 at 2:33 PM Ard Biesheuvel <ardb@kernel.org> wrote:
>
> The ACPI PRM address space handler calls efi_call_virt_pointer() to
> execute PRM firmware code, but doing so is only permitted when the EFI
> runtime environment is available. Otherwise, such calls are guaranteed
> to result in a crash, and must therefore be avoided.
>
> Given that the EFI runtime services may become unavailable after a crash
> occurring in the firmware, we need to check this each time the PRM
> address space handler is invoked. If the EFI runtime services were not
> available at registration time to being with, don't install the address
> space handler at all.
>
> Cc: <stable@vger.kernel.org>
> Cc: "Rafael J. Wysocki" <rafael@kernel.org>
> Cc: Len Brown <lenb@kernel.org>
> Cc: linux-acpi@vger.kernel.org
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> ---
> v2: check both at registration and at invocation time
>
>  drivers/acpi/prmt.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
>
> diff --git a/drivers/acpi/prmt.c b/drivers/acpi/prmt.c
> index 998101cf16e47145..3d4c4620f9f95309 100644
> --- a/drivers/acpi/prmt.c
> +++ b/drivers/acpi/prmt.c
> @@ -236,6 +236,11 @@ static acpi_status acpi_platformrt_space_handler(u32 function,
>         efi_status_t status;
>         struct prm_context_buffer context;
>
> +       if (!efi_enabled(EFI_RUNTIME_SERVICES)) {
> +               pr_err_ratelimited("PRM: EFI runtime services no longer available\n");
> +               return AE_NO_HANDLER;

This error code is only used in GPE handling ATM.

The one that actually causes ACPICA to log a "no handler" error (in
acpi_ex_access_region()) is AE_NOT_EXIST.  Should it be used here?


> +       }
> +
>         /*
>          * The returned acpi_status will always be AE_OK. Error values will be
>          * saved in the first byte of the PRM message buffer to be used by ASL.
> @@ -325,6 +330,11 @@ void __init init_prmt(void)
>
>         pr_info("PRM: found %u modules\n", mc);
>
> +       if (!efi_enabled(EFI_RUNTIME_SERVICES)) {
> +               pr_err("PRM: EFI runtime services unavailable\n");
> +               return;
> +       }
> +
>         status = acpi_install_address_space_handler(ACPI_ROOT_OBJECT,
>                                                     ACPI_ADR_SPACE_PLATFORM_RT,
>                                                     &acpi_platformrt_space_handler,
> --
> 2.39.0
>
