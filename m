Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 099D7F67EB
	for <lists+stable@lfdr.de>; Sun, 10 Nov 2019 08:40:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726594AbfKJHkx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 10 Nov 2019 02:40:53 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:52823 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726604AbfKJHkw (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 10 Nov 2019 02:40:52 -0500
Received: by mail-wm1-f65.google.com with SMTP id c17so10183604wmk.2
        for <stable@vger.kernel.org>; Sat, 09 Nov 2019 23:40:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HxpoD9KJAp6Pi8CWbh+1fjoBik+RNb6nY/kAwCZAIBo=;
        b=ak7z8mufaryNbxBmjQI9L4qUHciMMWNx1rUw8DFj2w9UY8jYahalEgKTiiiKIbQNlx
         NlaWGDZ8+NG21e+zrhT2Z2dKLEg4o3Wsswarr+c3xaJHB9s0g3x7g5P7zMhFhbdvo/0t
         P+9m4yELZSD1QxPmrmsf8tDWZwdi+B8GRbFgKsVPKuDNx/5lXAI1BV+nFYDhKBUbFwJz
         aUaHlxW7sjqO6BsxFvb7IS8n6mn3EHZ4u+RwCFoP70Q4YVqVLT/MOOj6Euv2z4WSs/4k
         YKL9xYxBvZwoxAxAFxQ7TigM3ML6pvRqLDN8enV5tlRgaJ7CSIlV7Y26UDHGBgj2A2Ww
         stXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HxpoD9KJAp6Pi8CWbh+1fjoBik+RNb6nY/kAwCZAIBo=;
        b=YqdHCQHFhn/nHkGn/v/0HbLXZAx4My/WwyEdqZ9mekxGc+nNR7QnNep2G+gH/vXTQa
         fYQc2vgfRh91PMyWrHcBAONDisdPNiOG8DCchWkNdjoWgR6Xpv2KMt23gTMTyJf2qyzy
         im1kidPmfsFfgXPXKXuy+Vl0ziWnk/3iu619SkZ8FHx3s1j6QWTFJMGE0QwHofLEAEMN
         YdVmUMOmR2oNQhhfH+APblhSdaqNkYZBFNzQLQii/C6LMqdDoPv378gMA8q+1lTaNrR1
         tzv9I0SV2UMyO2mJXw7l7X6UILl1b4krttO6q8+W/UFc8x3LU9oTv5sQpVfevnO8pDSt
         TFqw==
X-Gm-Message-State: APjAAAW3F+8MEF0wW88xVGjOyFjK2SVelmQ4V0wWYBz8FOnosS3WAkET
        MJ1kTl2OWvAJcf/0qzdx9i8Gkb76WRkJdqJZC4OGhw==
X-Google-Smtp-Source: APXvYqzkp7enP7kYNXg3Uqa+0Fw6qJrSPbsMmaUl4mfUBUfsJEUT8ssxl/EkrCzpQV/lZmnzeC119RgBY+YhTy3R1vs=
X-Received: by 2002:a1c:3d08:: with SMTP id k8mr14383712wma.119.1573371647420;
 Sat, 09 Nov 2019 23:40:47 -0800 (PST)
MIME-Version: 1.0
References: <20191110024013.29782-1-sashal@kernel.org> <20191110024013.29782-135-sashal@kernel.org>
In-Reply-To: <20191110024013.29782-135-sashal@kernel.org>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Sun, 10 Nov 2019 08:40:36 +0100
Message-ID: <CAKv+Gu9yELrHDSvyX-2HnFuZfYS_46Y7hb0gE4fLqwMkDtkTfw@mail.gmail.com>
Subject: Re: [PATCH AUTOSEL 4.19 135/191] efi/x86: Handle page faults
 occurring while running EFI runtime services
To:     Sasha Levin <sashal@kernel.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        Sai Praneeth <sai.praneeth.prakhya@intel.com>,
        Bhupesh Sharma <bhsharma@redhat.com>,
        Matt Fleming <matt@codeblueprint.co.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-efi <linux-efi@vger.kernel.org>,
        platform-driver-x86@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, 10 Nov 2019 at 03:44, Sasha Levin <sashal@kernel.org> wrote:
>
> From: Sai Praneeth <sai.praneeth.prakhya@intel.com>
>
> [ Upstream commit 3425d934fc0312f62024163736a7afe4de20c10f ]
>
> Memory accesses performed by UEFI runtime services should be limited to:
> - reading/executing from EFI_RUNTIME_SERVICES_CODE memory regions
> - reading/writing from/to EFI_RUNTIME_SERVICES_DATA memory regions
> - reading/writing by-ref arguments
> - reading/writing from/to the stack.
>
> Accesses outside these regions may cause the kernel to hang because the
> memory region requested by the firmware isn't mapped in efi_pgd, which
> causes a page fault in ring 0 and the kernel fails to handle it, leading
> to die(). To save kernel from hanging, add an EFI specific page fault
> handler which recovers from such faults by
> 1. If the efi runtime service is efi_reset_system(), reboot the machine
>    through BIOS.
> 2. If the efi runtime service is _not_ efi_reset_system(), then freeze
>    efi_rts_wq and schedule a new process.
>
> The EFI page fault handler offers us two advantages:
> 1. Avoid potential hangs caused by buggy firmware.
> 2. Shout loud that the firmware is buggy and hence is not a kernel bug.
>
> Tested-by: Bhupesh Sharma <bhsharma@redhat.com>
> Suggested-by: Matt Fleming <matt@codeblueprint.co.uk>
> Based-on-code-from: Ricardo Neri <ricardo.neri@intel.com>
> Signed-off-by: Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>
> Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
> [ardb: clarify commit log]
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>

NAK

This backports a patch to -stable that is *known* to be broken, given
that the same series backports a patch that fixes it.


> ---
>  arch/x86/include/asm/efi.h              |  1 +
>  arch/x86/mm/fault.c                     |  9 +++
>  arch/x86/platform/efi/quirks.c          | 78 +++++++++++++++++++++++++
>  drivers/firmware/efi/runtime-wrappers.c |  8 +++
>  include/linux/efi.h                     |  8 ++-
>  5 files changed, 103 insertions(+), 1 deletion(-)
>
> diff --git a/arch/x86/include/asm/efi.h b/arch/x86/include/asm/efi.h
> index baa549f8e9188..45864898f7e50 100644
> --- a/arch/x86/include/asm/efi.h
> +++ b/arch/x86/include/asm/efi.h
> @@ -138,6 +138,7 @@ extern void __init efi_apply_memmap_quirks(void);
>  extern int __init efi_reuse_config(u64 tables, int nr_tables);
>  extern void efi_delete_dummy_variable(void);
>  extern void efi_switch_mm(struct mm_struct *mm);
> +extern void efi_recover_from_page_fault(unsigned long phys_addr);
>
>  struct efi_setup_data {
>         u64 fw_vendor;
> diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
> index 1bcb7242ad79a..53e69c7c5cd18 100644
> --- a/arch/x86/mm/fault.c
> +++ b/arch/x86/mm/fault.c
> @@ -16,6 +16,7 @@
>  #include <linux/prefetch.h>            /* prefetchw                    */
>  #include <linux/context_tracking.h>    /* exception_enter(), ...       */
>  #include <linux/uaccess.h>             /* faulthandler_disabled()      */
> +#include <linux/efi.h>                 /* efi_recover_from_page_fault()*/
>  #include <linux/mm_types.h>
>
>  #include <asm/cpufeature.h>            /* boot_cpu_has, ...            */
> @@ -25,6 +26,7 @@
>  #include <asm/vsyscall.h>              /* emulate_vsyscall             */
>  #include <asm/vm86.h>                  /* struct vm86                  */
>  #include <asm/mmu_context.h>           /* vma_pkey()                   */
> +#include <asm/efi.h>                   /* efi_recover_from_page_fault()*/
>
>  #define CREATE_TRACE_POINTS
>  #include <asm/trace/exceptions.h>
> @@ -783,6 +785,13 @@ no_context(struct pt_regs *regs, unsigned long error_code,
>         if (is_errata93(regs, address))
>                 return;
>
> +       /*
> +        * Buggy firmware could access regions which might page fault, try to
> +        * recover from such faults.
> +        */
> +       if (IS_ENABLED(CONFIG_EFI))
> +               efi_recover_from_page_fault(address);
> +
>         /*
>          * Oops. The kernel tried to access some bad page. We'll have to
>          * terminate things with extreme prejudice:
> diff --git a/arch/x86/platform/efi/quirks.c b/arch/x86/platform/efi/quirks.c
> index 844d31cb8a0c7..669babcaf245a 100644
> --- a/arch/x86/platform/efi/quirks.c
> +++ b/arch/x86/platform/efi/quirks.c
> @@ -16,6 +16,7 @@
>  #include <asm/efi.h>
>  #include <asm/uv/uv.h>
>  #include <asm/cpu_device_id.h>
> +#include <asm/reboot.h>
>
>  #define EFI_MIN_RESERVE 5120
>
> @@ -654,3 +655,80 @@ int efi_capsule_setup_info(struct capsule_info *cap_info, void *kbuff,
>  }
>
>  #endif
> +
> +/*
> + * If any access by any efi runtime service causes a page fault, then,
> + * 1. If it's efi_reset_system(), reboot through BIOS.
> + * 2. If any other efi runtime service, then
> + *    a. Return error status to the efi caller process.
> + *    b. Disable EFI Runtime Services forever and
> + *    c. Freeze efi_rts_wq and schedule new process.
> + *
> + * @return: Returns, if the page fault is not handled. This function
> + * will never return if the page fault is handled successfully.
> + */
> +void efi_recover_from_page_fault(unsigned long phys_addr)
> +{
> +       if (!IS_ENABLED(CONFIG_X86_64))
> +               return;
> +
> +       /*
> +        * Make sure that an efi runtime service caused the page fault.
> +        * "efi_mm" cannot be used to check if the page fault had occurred
> +        * in the firmware context because efi=old_map doesn't use efi_pgd.
> +        */
> +       if (efi_rts_work.efi_rts_id == NONE)
> +               return;
> +
> +       /*
> +        * Address range 0x0000 - 0x0fff is always mapped in the efi_pgd, so
> +        * page faulting on these addresses isn't expected.
> +        */
> +       if (phys_addr >= 0x0000 && phys_addr <= 0x0fff)
> +               return;
> +
> +       /*
> +        * Print stack trace as it might be useful to know which EFI Runtime
> +        * Service is buggy.
> +        */
> +       WARN(1, FW_BUG "Page fault caused by firmware at PA: 0x%lx\n",
> +            phys_addr);
> +
> +       /*
> +        * Buggy efi_reset_system() is handled differently from other EFI
> +        * Runtime Services as it doesn't use efi_rts_wq. Although,
> +        * native_machine_emergency_restart() says that machine_real_restart()
> +        * could fail, it's better not to compilcate this fault handler
> +        * because this case occurs *very* rarely and hence could be improved
> +        * on a need by basis.
> +        */
> +       if (efi_rts_work.efi_rts_id == RESET_SYSTEM) {
> +               pr_info("efi_reset_system() buggy! Reboot through BIOS\n");
> +               machine_real_restart(MRR_BIOS);
> +               return;
> +       }
> +
> +       /*
> +        * Before calling EFI Runtime Service, the kernel has switched the
> +        * calling process to efi_mm. Hence, switch back to task_mm.
> +        */
> +       arch_efi_call_virt_teardown();
> +
> +       /* Signal error status to the efi caller process */
> +       efi_rts_work.status = EFI_ABORTED;
> +       complete(&efi_rts_work.efi_rts_comp);
> +
> +       clear_bit(EFI_RUNTIME_SERVICES, &efi.flags);
> +       pr_info("Froze efi_rts_wq and disabled EFI Runtime Services\n");
> +
> +       /*
> +        * Call schedule() in an infinite loop, so that any spurious wake ups
> +        * will never run efi_rts_wq again.
> +        */
> +       for (;;) {
> +               set_current_state(TASK_IDLE);
> +               schedule();
> +       }
> +
> +       return;
> +}
> diff --git a/drivers/firmware/efi/runtime-wrappers.c b/drivers/firmware/efi/runtime-wrappers.c
> index b31e3d3729a6d..e2abfdb5cee6a 100644
> --- a/drivers/firmware/efi/runtime-wrappers.c
> +++ b/drivers/firmware/efi/runtime-wrappers.c
> @@ -61,6 +61,11 @@ struct efi_runtime_work efi_rts_work;
>  ({                                                                     \
>         efi_rts_work.status = EFI_ABORTED;                              \
>                                                                         \
> +       if (!efi_enabled(EFI_RUNTIME_SERVICES)) {                       \
> +               pr_warn_once("EFI Runtime Services are disabled!\n");   \
> +               goto exit;                                              \
> +       }                                                               \
> +                                                                       \
>         init_completion(&efi_rts_work.efi_rts_comp);                    \
>         INIT_WORK(&efi_rts_work.work, efi_call_rts);                    \
>         efi_rts_work.arg1 = _arg1;                                      \
> @@ -79,6 +84,8 @@ struct efi_runtime_work efi_rts_work;
>         else                                                            \
>                 pr_err("Failed to queue work to efi_rts_wq.\n");        \
>                                                                         \
> +exit:                                                                  \
> +       efi_rts_work.efi_rts_id = NONE;                                 \
>         efi_rts_work.status;                                            \
>  })
>
> @@ -400,6 +407,7 @@ static void virt_efi_reset_system(int reset_type,
>                         "could not get exclusive access to the firmware\n");
>                 return;
>         }
> +       efi_rts_work.efi_rts_id = RESET_SYSTEM;
>         __efi_call_virt(reset_system, reset_type, status, data_size, data);
>         up(&efi_runtime_lock);
>  }
> diff --git a/include/linux/efi.h b/include/linux/efi.h
> index 9d4c25090fd04..9a86f467b8911 100644
> --- a/include/linux/efi.h
> +++ b/include/linux/efi.h
> @@ -1666,8 +1666,13 @@ struct linux_efi_tpm_eventlog {
>
>  extern int efi_tpm_eventlog_init(void);
>
> -/* efi_runtime_service() function identifiers */
> +/*
> + * efi_runtime_service() function identifiers.
> + * "NONE" is used by efi_recover_from_page_fault() to check if the page
> + * fault happened while executing an efi runtime service.
> + */
>  enum efi_rts_ids {
> +       NONE,
>         GET_TIME,
>         SET_TIME,
>         GET_WAKEUP_TIME,
> @@ -1677,6 +1682,7 @@ enum efi_rts_ids {
>         SET_VARIABLE,
>         QUERY_VARIABLE_INFO,
>         GET_NEXT_HIGH_MONO_COUNT,
> +       RESET_SYSTEM,
>         UPDATE_CAPSULE,
>         QUERY_CAPSULE_CAPS,
>  };
> --
> 2.20.1
>
