Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22C2320D197
	for <lists+stable@lfdr.de>; Mon, 29 Jun 2020 20:42:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726482AbgF2SmU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 14:42:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:60608 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727094AbgF2Slc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 14:41:32 -0400
Received: from mail-ot1-f54.google.com (mail-ot1-f54.google.com [209.85.210.54])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EFAB023EB1
        for <stable@vger.kernel.org>; Mon, 29 Jun 2020 15:18:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593443900;
        bh=gX8Gsa2+mywDQczlmd4MB653zX7hdrfb6hhewCL2S5Q=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=lYUI4j+6rgubqgWUkUESJP+Z4GdhtdEQV4rB9s2DhomnDKzK5Jovq4cvN7a/6389B
         x34znZ0u2mtRUe16OdQ/VaETYODEFAem7ULelsXJV6CUcGiYGPK8HII2Ffq2XAmilr
         qwaxS2wnqK4KbxSW+NwbYRXQ+hV8puKv0vY9HdV8=
Received: by mail-ot1-f54.google.com with SMTP id n24so13605301otr.13
        for <stable@vger.kernel.org>; Mon, 29 Jun 2020 08:18:19 -0700 (PDT)
X-Gm-Message-State: AOAM5321a/9hm1TgzhMDqiuFpFkccxf06vC8ZjJiIEDjfGg6nM3+uqwi
        oZI6/I6GUJkowyy820OUX/2mj/5IB+0FIk+5HxI=
X-Google-Smtp-Source: ABdhPJyTz8FWN8gBAXNpNgubgXP+J7Q5Zo2h1UrDDpvhhbQmD0A4K2zDjKNw4u7Q8F4ovkS8pmRxF3xNPQ98kDDkTb0=
X-Received: by 2002:a9d:5a12:: with SMTP id v18mr13284837oth.90.1593443899325;
 Mon, 29 Jun 2020 08:18:19 -0700 (PDT)
MIME-Version: 1.0
References: <1593422635243184@kroah.com>
In-Reply-To: <1593422635243184@kroah.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Mon, 29 Jun 2020 17:18:08 +0200
X-Gmail-Original-Message-ID: <CAMj1kXHfKHuOdx1MYUzN2QncN6SO6CYcPPXTFsGR67_CniWfAw@mail.gmail.com>
Message-ID: <CAMj1kXHfKHuOdx1MYUzN2QncN6SO6CYcPPXTFsGR67_CniWfAw@mail.gmail.com>
Subject: Re: WTF: patch "[PATCH] efi: Make it possible to disable efivar_ssdt
 entirely" was seriously submitted to be applied to the 5.7-stable tree?
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Peter Jones <pjones@redhat.com>, "# 3.4.x" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 29 Jun 2020 at 11:32, <gregkh@linuxfoundation.org> wrote:
>
> The patch below was submitted to be applied to the 5.7-stable tree.
>
> I fail to see how this patch meets the stable kernel rules as found at
> Documentation/process/stable-kernel-rules.rst.
>
> I could be totally wrong, and if so, please respond to
> <stable@vger.kernel.org> and let me know why this patch should be
> applied.  Otherwise, it is now dropped from my patch queues, never to be
> seen again.
>

Without this patch, there is no way to disable sideloading of SSDTs
via EFI variables, which is a security hole. The fact that this is not
governed by the existing ACPI_TABLE_UPGRADE Kconfig option was an
oversight, and so distros currently have this functionality enabled
inadvertently (although most of them have the lockdown check
incorporated as well)

SSDTs can manipulate any memory (even kernel memory that has been
mapped read-only) by using SystemMemory OpRegions in _INI AML methods,
and setting an EFI variable once will make this persist across
reboots.




> ------------------ original commit in Linus's tree ------------------
>
> From 435d1a471598752446a72ad1201b3c980526d869 Mon Sep 17 00:00:00 2001
> From: Peter Jones <pjones@redhat.com>
> Date: Mon, 15 Jun 2020 16:24:08 -0400
> Subject: [PATCH] efi: Make it possible to disable efivar_ssdt entirely
>
> In most cases, such as CONFIG_ACPI_CUSTOM_DSDT and
> CONFIG_ACPI_TABLE_UPGRADE, boot-time modifications to firmware tables
> are tied to specific Kconfig options.  Currently this is not the case
> for modifying the ACPI SSDT via the efivar_ssdt kernel command line
> option and associated EFI variable.
>
> This patch adds CONFIG_EFI_CUSTOM_SSDT_OVERLAYS, which defaults
> disabled, in order to allow enabling or disabling that feature during
> the build.
>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Peter Jones <pjones@redhat.com>
> Link: https://lore.kernel.org/r/20200615202408.2242614-1-pjones@redhat.com
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
>
> diff --git a/drivers/firmware/efi/Kconfig b/drivers/firmware/efi/Kconfig
> index e6fc022bc87e..3939699e62fe 100644
> --- a/drivers/firmware/efi/Kconfig
> +++ b/drivers/firmware/efi/Kconfig
> @@ -278,3 +278,14 @@ config EFI_EARLYCON
>         depends on SERIAL_EARLYCON && !ARM && !IA64
>         select FONT_SUPPORT
>         select ARCH_USE_MEMREMAP_PROT
> +
> +config EFI_CUSTOM_SSDT_OVERLAYS
> +       bool "Load custom ACPI SSDT overlay from an EFI variable"
> +       depends on EFI_VARS && ACPI
> +       default ACPI_TABLE_UPGRADE
> +       help
> +         Allow loading of an ACPI SSDT overlay from an EFI variable specified
> +         by a kernel command line option.
> +
> +         See Documentation/admin-guide/acpi/ssdt-overlays.rst for more
> +         information.
> diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
> index edc5d36caf54..5114cae4ec97 100644
> --- a/drivers/firmware/efi/efi.c
> +++ b/drivers/firmware/efi/efi.c
> @@ -189,7 +189,7 @@ static void generic_ops_unregister(void)
>         efivars_unregister(&generic_efivars);
>  }
>
> -#if IS_ENABLED(CONFIG_ACPI)
> +#ifdef CONFIG_EFI_CUSTOM_SSDT_OVERLAYS
>  #define EFIVAR_SSDT_NAME_MAX   16
>  static char efivar_ssdt[EFIVAR_SSDT_NAME_MAX] __initdata;
>  static int __init efivar_ssdt_setup(char *str)
>
