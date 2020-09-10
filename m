Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E51B6264342
	for <lists+stable@lfdr.de>; Thu, 10 Sep 2020 12:06:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730556AbgIJKGn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Sep 2020 06:06:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:39116 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730523AbgIJKGh (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Sep 2020 06:06:37 -0400
Received: from mail-oi1-f173.google.com (mail-oi1-f173.google.com [209.85.167.173])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8197B21D80;
        Thu, 10 Sep 2020 10:06:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599732396;
        bh=PsgV3/p7HeIxS4BDkyn1Hz8uhnBf8EDv0rx5idJ+6iw=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=EOhIebwwXUwe3ifWsLdqeXcJhzZ+u4e9RHyS20FYpNjUUKBPmQot4iV18AtmUEfW0
         Eu7gtA6IrHE75kCgs8wEzO0Qu3kLUYp5V8vqHa/a8mikB2age+7TlSynQUDdeKHWm0
         3+heFSxPgS61ZpmRclX9kbCkBoNHhkyqQAXkL9mg=
Received: by mail-oi1-f173.google.com with SMTP id c13so5379944oiy.6;
        Thu, 10 Sep 2020 03:06:36 -0700 (PDT)
X-Gm-Message-State: AOAM533egzEjdWIocBhHDtGSAEivtFBQA92IwPuZJ5XwnywEUacpg8mo
        5hTtwlPTNIfkFJuN+trsXGq5I49Li1ZR3M+pUL0=
X-Google-Smtp-Source: ABdhPJz2vXLwznJzG7G9XegKF0TCGXzgUeoxI4CtyIa3q99Kdzxypfv6JDuj8TZ9L0IMAIjb7rdHepQhNcigO8z75gI=
X-Received: by 2002:aca:d845:: with SMTP id p66mr3033135oig.47.1599732395679;
 Thu, 10 Sep 2020 03:06:35 -0700 (PDT)
MIME-Version: 1.0
References: <20200909225354.3118328-1-keescook@chromium.org>
In-Reply-To: <20200909225354.3118328-1-keescook@chromium.org>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Thu, 10 Sep 2020 13:06:24 +0300
X-Gmail-Original-Message-ID: <CAMj1kXGP_EH661xYXKydo5ph5BKLhs9DeLrgr9gtxeXrwBSCLg@mail.gmail.com>
Message-ID: <CAMj1kXGP_EH661xYXKydo5ph5BKLhs9DeLrgr9gtxeXrwBSCLg@mail.gmail.com>
Subject: Re: [PATCH v5] test_firmware: Test platform fw loading on non-EFI systems
To:     Kees Cook <keescook@chromium.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "# 3.4.x" <stable@vger.kernel.org>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Scott Branden <scott.branden@broadcom.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Hans de Goede <hdegoede@redhat.com>,
        linux-efi <linux-efi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 10 Sep 2020 at 01:54, Kees Cook <keescook@chromium.org> wrote:
>
> On non-EFI systems, it wasn't possible to test the platform firmware
> loader because it will have never set "checked_fw" during __init.
> Instead, allow the test code to override this check. Additionally split
> the declarations into a private symbol namespace so there is greater
> enforcement of the symbol visibility.
>
> Fixes: 548193cba2a7 ("test_firmware: add support for firmware_request_platform")
> Cc: stable@vger.kernel.org
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
> This is split out from the larger kernel_read_file series:
>     https://lore.kernel.org/lkml/20200729175845.1745471-1-keescook@chromium.org/
> specifically this was:
>     https://lore.kernel.org/lkml/20200729175845.1745471-2-keescook@chromium.org/
>
> I've dropped the review tags, since this is changing the "how" of the patch...
> ---
>  drivers/firmware/efi/embedded-firmware.c | 10 +++++-----
>  include/linux/efi_embedded_fw.h          |  6 ++----
>  lib/test_firmware.c                      |  9 +++++++++
>  3 files changed, 16 insertions(+), 9 deletions(-)
>

Acked-by: Ard Biesheuvel <ardb@kernel.org>

> diff --git a/drivers/firmware/efi/embedded-firmware.c b/drivers/firmware/efi/embedded-firmware.c
> index a1b199de9006..84e32634ed6c 100644
> --- a/drivers/firmware/efi/embedded-firmware.c
> +++ b/drivers/firmware/efi/embedded-firmware.c
> @@ -16,9 +16,9 @@
>
>  /* Exported for use by lib/test_firmware.c only */
>  LIST_HEAD(efi_embedded_fw_list);
> -EXPORT_SYMBOL_GPL(efi_embedded_fw_list);
> -
> -static bool checked_for_fw;
> +EXPORT_SYMBOL_NS_GPL(efi_embedded_fw_list, TEST_FIRMWARE);
> +bool efi_embedded_fw_checked;
> +EXPORT_SYMBOL_NS_GPL(efi_embedded_fw_checked, TEST_FIRMWARE);
>
>  static const struct dmi_system_id * const embedded_fw_table[] = {
>  #ifdef CONFIG_TOUCHSCREEN_DMI
> @@ -119,14 +119,14 @@ void __init efi_check_for_embedded_firmwares(void)
>                 }
>         }
>
> -       checked_for_fw = true;
> +       efi_embedded_fw_checked = true;
>  }
>
>  int efi_get_embedded_fw(const char *name, const u8 **data, size_t *size)
>  {
>         struct efi_embedded_fw *iter, *fw = NULL;
>
> -       if (!checked_for_fw) {
> +       if (!efi_embedded_fw_checked) {
>                 pr_warn("Warning %s called while we did not check for embedded fw\n",
>                         __func__);
>                 return -ENOENT;
> diff --git a/include/linux/efi_embedded_fw.h b/include/linux/efi_embedded_fw.h
> index 57eac5241303..a97a12bb2c9e 100644
> --- a/include/linux/efi_embedded_fw.h
> +++ b/include/linux/efi_embedded_fw.h
> @@ -8,8 +8,8 @@
>  #define EFI_EMBEDDED_FW_PREFIX_LEN             8
>
>  /*
> - * This struct and efi_embedded_fw_list are private to the efi-embedded fw
> - * implementation they are in this header for use by lib/test_firmware.c only!
> + * This struct is private to the efi-embedded fw implementation.
> + * They are in this header for use by lib/test_firmware.c only!
>   */
>  struct efi_embedded_fw {
>         struct list_head list;
> @@ -18,8 +18,6 @@ struct efi_embedded_fw {
>         size_t length;
>  };
>
> -extern struct list_head efi_embedded_fw_list;
> -
>  /**
>   * struct efi_embedded_fw_desc - This struct is used by the EFI embedded-fw
>   *                               code to search for embedded firmwares.
> diff --git a/lib/test_firmware.c b/lib/test_firmware.c
> index 9fee2b93a8d1..06c955057756 100644
> --- a/lib/test_firmware.c
> +++ b/lib/test_firmware.c
> @@ -26,6 +26,8 @@
>  #include <linux/vmalloc.h>
>  #include <linux/efi_embedded_fw.h>
>
> +MODULE_IMPORT_NS(TEST_FIRMWARE);
> +
>  #define TEST_FIRMWARE_NAME     "test-firmware.bin"
>  #define TEST_FIRMWARE_NUM_REQS 4
>  #define TEST_FIRMWARE_BUF_SIZE SZ_1K
> @@ -489,6 +491,9 @@ static ssize_t trigger_request_store(struct device *dev,
>  static DEVICE_ATTR_WO(trigger_request);
>
>  #ifdef CONFIG_EFI_EMBEDDED_FIRMWARE
> +extern struct list_head efi_embedded_fw_list;
> +extern bool efi_embedded_fw_checked;
> +
>  static ssize_t trigger_request_platform_store(struct device *dev,
>                                               struct device_attribute *attr,
>                                               const char *buf, size_t count)
> @@ -501,6 +506,7 @@ static ssize_t trigger_request_platform_store(struct device *dev,
>         };
>         struct efi_embedded_fw efi_embedded_fw;
>         const struct firmware *firmware = NULL;
> +       bool saved_efi_embedded_fw_checked;
>         char *name;
>         int rc;
>
> @@ -513,6 +519,8 @@ static ssize_t trigger_request_platform_store(struct device *dev,
>         efi_embedded_fw.data = (void *)test_data;
>         efi_embedded_fw.length = sizeof(test_data);
>         list_add(&efi_embedded_fw.list, &efi_embedded_fw_list);
> +       saved_efi_embedded_fw_checked = efi_embedded_fw_checked;
> +       efi_embedded_fw_checked = true;
>
>         pr_info("loading '%s'\n", name);
>         rc = firmware_request_platform(&firmware, name, dev);
> @@ -530,6 +538,7 @@ static ssize_t trigger_request_platform_store(struct device *dev,
>         rc = count;
>
>  out:
> +       efi_embedded_fw_checked = saved_efi_embedded_fw_checked;
>         release_firmware(firmware);
>         list_del(&efi_embedded_fw.list);
>         kfree(name);
> --
> 2.25.1
>
