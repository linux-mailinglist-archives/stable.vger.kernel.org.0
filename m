Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 265374D41ED
	for <lists+stable@lfdr.de>; Thu, 10 Mar 2022 08:35:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233846AbiCJHgd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Mar 2022 02:36:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240115AbiCJHgc (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Mar 2022 02:36:32 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9D0C80927
        for <stable@vger.kernel.org>; Wed,  9 Mar 2022 23:35:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6BC3661A77
        for <stable@vger.kernel.org>; Thu, 10 Mar 2022 07:35:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46D59C340E8;
        Thu, 10 Mar 2022 07:35:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646897730;
        bh=vX0HuCeUWdWhrCAWx1E1AdBiTBSWfSkB4BtaONtx3zk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=sRm64cXMROvOWVTRNBoazrLXfokllHqEd0JNhw/L6hr0oQXtt8uCg25rJJHR/TuE3
         9L3du+JpOotEpndfyMhmIb8W0GR93A6IAkhbBOg5MjMRUeV1uxYDgxs5Rx6vq00Jac
         7XvoN0jYVrZ49css32UZk4IPlXw2CC32/alLgmDo=
Date:   Thu, 10 Mar 2022 08:35:27 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Ryan Tierney <ryant@trellian.com>
Cc:     stable@vger.kernel.org, regressions@lists.linux.dev
Subject: Re: kernel BUG at include/linux/swapops.h:204!
Message-ID: <YimqP5SxHix4f6AW@kroah.com>
References: <f45ff567-6ef7-8a43-a645-4b9ab2e7a8ae@trellian.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <f45ff567-6ef7-8a43-a645-4b9ab2e7a8ae@trellian.com>
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Mar 10, 2022 at 03:21:15PM +1100, Ryan Tierney wrote:
> Hi Linux kernel team,
>=20
> We have had multiple servers lock up over the course of a few months on
> kernel version 5.10.92
> Looking to find out any information to help mitigate this.
>=20
> I've also found a related report here back in 2021: https://lore.kernel.o=
rg/all/757b684a-67b5-999b-7f2d-b55fb1c61fd8@google.com/T/
>=20
> Please see the stack trace obtained during this lockup
>=20
>  [2136172.975892] ------------[ cut here ]------------
>  [2136172.975896] kernel BUG at include\/linux\/swapops.h:204!
>  [2136172.981268] invalid opcode: 0000 [#1] SMP NOPTI
>  [2136172.985983] CPU: 49 PID: 1672949 Comm: apt-cache Not tainted 5.10.0=
-11-amd64 #1 Debian 5.10.92-1
>  [2136172.994944] Hardware name: Supermicro AS -1114S-WN10RT\/H12SSW-NTR,=
 BIOS 2.3 10\/28\/2021
>  [2136173.003042] RIP: e030:__migration_entry_wait+0xf9\/0x100
>  [2136173.008444] Code: 0f 45 c2 41 8b 40 34 85 c0 74 9f 8d 50 01 f0 41 0=
f b1 50 34 75 f1 48 89 ef e8 03 e0 e4 ff 66 90 5b 4c 89 c7 5d e9 27 48 f7 f=
f <0f> 0b 0f 1f 44 00 00 0f 1f 44 00 00 49 89 f9 48 8b 3e e8 08 39 d8
>  [2136173.027394] RSP: e02b:ffffc90075a4fdb8 EFLAGS: 00010246
>  [2136173.032795] RAX: 000fffffc0000000 RBX: ffff88807b0e6968 RCX: ffffea=
00006a6f87
>  [2136173.040114] RDX: 0000000000000000 RSI: ffff88807b0e6968 RDI: ffffff=
fffcac8400
>  [2136173.047429] RBP: ffffea0001ec39a8 R08: ffffea00006a6f40 R09: ffff88=
804679f2c0
>  [2136173.054745] R10: 000ffffffffff000 R11: 0000000000000000 R12: ffffc9=
0075a4fe40
>  [2136173.062060] R13: 7c0000000001a9bd R14: fff0000000000fff R15: 000000=
0000000000
>  [2136173.069378] FS:  00007f2cc7eee800(0000) GS:ffff888117440000(0000) k=
nlGS:0000000000000000
>  [2136173.077651] CS:  e030 DS: 0000 ES: 0000 CR0: 0000000080050033
>  [2136173.083575] CR2: 00007f2cc4b2df8c CR3: 000000008d396000 CR4: 000000=
0000050660
>  [2136173.090893] Call Trace:
>  [2136173.093527]  do_swap_page+0x66f\/0x900
>  [2136173.097370]  handle_mm_fault+0xd7d\/0x1bf0
>  [2136173.101584]  ? xfs_file_read_iter+0x6e\/0xd0 [xfs]
>  [2136173.106468]  do_user_addr_fault+0x1b8\/0x3f0
>  [2136173.110835]  exc_page_fault+0x78\/0x160
>  [2136173.114766]  ? asm_exc_page_fault+0x8\/0x30
>  [2136173.119038]  asm_exc_page_fault+0x1e\/0x30
>  [2136173.123224] RIP: e033:0x7f2cc8930fcb
>  [2136173.126977] Code: 8b 46 08 48 8d 14 80 48 8d 04 50 48 8d 44 85 00 4=
8 39 c3 74 5a 8b 43 10 48 8d 14 80 48 8d 04 50 48 8d 5c 85 00 48 39 eb 74 4=
5 <8b> 33 4c 01 c6 0f b7 46 fe 49 39 c4 75 c7 4c 89 e2 4c 89 44 24 08
>  [2136173.145919] RSP: e02b:00007ffd2a3f3e80 EFLAGS: 00010206
>  [2136173.151323] RAX: 0000000000000005 RBX: 00007f2cc4b2df8c RCX: 000000=
0000000006
>  [2136173.158632] RDX: 00007f2cc351b2e6 RSI: 00007ffd2a3f3fd0 RDI: 00007f=
2cc351b2e6
>  [2136173.165948] RBP: 00007f2cc339b000 R08: 00007f2cc339b000 R09: 000000=
0000000de0
>  [2136173.173262] R10: 00007f2cc4c8bc7c R11: 00000000206e6f68 R12: 000000=
0000000005
>  [2136173.180580] R13: 00007ffd2a3f3f20 R14: 00007f2cc4b0d410 R15: 000055=
ab3740af08
>  [2136173.187892] Modules linked in: xen_acpi_processor xen_gntdev xen_ev=
tchn binfmt_misc xenfs xen_privcmd nls_ascii nls_cp437 vfat fat ghash_clmul=
ni_intel aesni_intel libaes crypto_simd cryptd glue_helper wmi_bmof efi_pst=
ore pcspkr ast drm_vram_helper drm_ttm_helper ttm ccp drm_kms_helper rng_co=
re rndis_host cdc_ether cec usbnet i2c_algo_bit joydev mii k10temp sp5100_t=
co watchdog ipmi_ssif evdev bridge acpi_ipmi ipmi_si 8021q ipmi_devintf gar=
p ipmi_msghandler stp mrp llc button bonding loop psmouse uhci_hcd ohci_hcd=
 ehci_hcd drbd lru_cache drm fuse configfs efivarfs ip_tables x_tables auto=
fs4 xfs raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx =
xor hid_generic usbhid hid raid6_pq libcrc32c crc32c_generic raid0 multipat=
h linear raid1 raid10 md_mod crc32_pclmul crc32c_intel ahci libahci xhci_pc=
i nvme xhci_hcd libata nvme_core i40e t10_pi usbcore bnxt_en scsi_mod crc_t=
10dif crct10dif_generic crct10dif_pclmul crct10dif_common ptp usb_common i2=
c_piix4 pps_core wmi
>  [2136173.274260] ---[ end trace 37e8c1af7f6e782a ]---
>=20

This looks like a filesystem issue, have you tried asking on the
linux-fsdevel mailing list?

And does it also happen on 5.16?

thanks,

greg k-h
