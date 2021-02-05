Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 317E4310533
	for <lists+stable@lfdr.de>; Fri,  5 Feb 2021 07:52:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231301AbhBEGwH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Feb 2021 01:52:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:56538 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230483AbhBEGvh (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Feb 2021 01:51:37 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4001564F9C;
        Fri,  5 Feb 2021 06:50:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612507856;
        bh=941AkqL1nii7c/B1BmKXvFA4vyQEem3CqwJZMXTjS/U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Vge0txLvFe19JT7T9lI/ExzG2SxjlRjRPGpgidOS9ldJFIZ/Z5LgQtn445V11NVrJ
         MTR6Cqk6lFYHaUWCNDcn1amOouaiDQqtgJfV1X3apgjnE1QhLffvQhD0Pp1/qFr1UJ
         YZVYf9f3lwc9sxOdzDA9nL5i5pEeL9azUiSmjy+k=
Date:   Fri, 5 Feb 2021 07:50:54 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Lino Sanfilippo <LinoSanfilippo@gmx.de>
Cc:     peterhuewe@gmx.de, jarkko@kernel.org, jgg@ziepe.ca,
        stefanb@linux.vnet.ibm.com, James.Bottomley@hansenpartnership.com,
        stable@vger.kernel.org, linux-integrity@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Lino Sanfilippo <l.sanfilippo@kunbus.com>
Subject: Re: [PATCH v3 1/2] tpm: fix reference counting for struct tpm_chip
Message-ID: <YBzqzsDpRbhEYR2Y@kroah.com>
References: <1612482643-11796-1-git-send-email-LinoSanfilippo@gmx.de>
 <1612482643-11796-2-git-send-email-LinoSanfilippo@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1612482643-11796-2-git-send-email-LinoSanfilippo@gmx.de>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 05, 2021 at 12:50:42AM +0100, Lino Sanfilippo wrote:
> From: Lino Sanfilippo <l.sanfilippo@kunbus.com>
> 
> The following sequence of operations results in a refcount warning:
> 
> 1. Open device /dev/tpmrm
> 2. Remove module tpm_tis_spi
> 3. Write a TPM command to the file descriptor opened at step 1.
> 
> ------------[ cut here ]------------
> WARNING: CPU: 3 PID: 1161 at lib/refcount.c:25 kobject_get+0xa0/0xa4
> refcount_t: addition on 0; use-after-free.
> Modules linked in: tpm_tis_spi tpm_tis_core tpm mdio_bcm_unimac brcmfmac
> sha256_generic libsha256 sha256_arm hci_uart btbcm bluetooth cfg80211 vc4
> brcmutil ecdh_generic ecc snd_soc_core crc32_arm_ce libaes
> raspberrypi_hwmon ac97_bus snd_pcm_dmaengine bcm2711_thermal snd_pcm
> snd_timer genet snd phy_generic soundcore [last unloaded: spi_bcm2835]
> CPU: 3 PID: 1161 Comm: hold_open Not tainted 5.10.0ls-main-dirty #2
> Hardware name: BCM2711
> [<c0410c3c>] (unwind_backtrace) from [<c040b580>] (show_stack+0x10/0x14)
> [<c040b580>] (show_stack) from [<c1092174>] (dump_stack+0xc4/0xd8)
> [<c1092174>] (dump_stack) from [<c0445a30>] (__warn+0x104/0x108)
> [<c0445a30>] (__warn) from [<c0445aa8>] (warn_slowpath_fmt+0x74/0xb8)
> [<c0445aa8>] (warn_slowpath_fmt) from [<c08435d0>] (kobject_get+0xa0/0xa4)
> [<c08435d0>] (kobject_get) from [<bf0a715c>] (tpm_try_get_ops+0x14/0x54 [tpm])
> [<bf0a715c>] (tpm_try_get_ops [tpm]) from [<bf0a7d6c>] (tpm_common_write+0x38/0x60 [tpm])
> [<bf0a7d6c>] (tpm_common_write [tpm]) from [<c05a7ac0>] (vfs_write+0xc4/0x3c0)
> [<c05a7ac0>] (vfs_write) from [<c05a7ee4>] (ksys_write+0x58/0xcc)
> [<c05a7ee4>] (ksys_write) from [<c04001a0>] (ret_fast_syscall+0x0/0x4c)
> Exception stack(0xc226bfa8 to 0xc226bff0)
> bfa0:                   00000000 000105b4 00000003 beafe664 00000014 00000000
> bfc0: 00000000 000105b4 000103f8 00000004 00000000 00000000 b6f9c000 beafe684
> bfe0: 0000006c beafe648 0001056c b6eb6944
> ---[ end trace d4b8409def9b8b1f ]---
> 
> The reason for this warning is the attempt to get the chip->dev reference
> in tpm_common_write() although the reference counter is already zero.
> 
> Since commit 8979b02aaf1d ("tpm: Fix reference count to main device") the
> extra reference used to prevent a premature zero counter is never taken,
> because the required TPM_CHIP_FLAG_TPM2 flag is never set.
> 
> Fix this by removing the flag condition.
> 
> Commit fdc915f7f719 ("tpm: expose spaces via a device link /dev/tpmrm<n>")
> already introduced function tpm_devs_release() to release the extra
> reference but did not implement the required put on chip->devs that results
> in the call of this function.
> 
> Fix this also by installing an action handler that puts chip->devs as soon
> as the chip is unregistered.
> 
> Fixes: fdc915f7f719 ("tpm: expose spaces via a device link /dev/tpmrm<n>")
> Fixes: 8979b02aaf1d ("tpm: Fix reference count to main device")
> Signed-off-by: Lino Sanfilippo <l.sanfilippo@kunbus.com>
> ---
>  drivers/char/tpm/tpm-chip.c       | 18 +++++++++++++++---
>  drivers/char/tpm/tpm_ftpm_tee.c   |  2 ++
>  drivers/char/tpm/tpm_vtpm_proxy.c |  1 +
>  3 files changed, 18 insertions(+), 3 deletions(-)

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
