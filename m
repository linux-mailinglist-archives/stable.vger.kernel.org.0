Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BD313487F3
	for <lists+stable@lfdr.de>; Thu, 25 Mar 2021 05:37:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229622AbhCYEhL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Mar 2021 00:37:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:43980 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229730AbhCYEgu (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Mar 2021 00:36:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4425261A1A;
        Thu, 25 Mar 2021 04:36:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1616647010;
        bh=X+a93unu8h61Wnule1KcshcFs3MjMECqef6bYX1cimE=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=F3fxO1BtSmpnQcccyuJpdqkNZx+Hdcg4lqxcxOZqf2Mh8RuIoyaCh47tP8GovS47x
         i58XjR9vPmc0M02m24+oQpCO9AqrJ1Eq8R3K3VTHEDcAotAoPIeEwDd6kRIS8tnswY
         c97ThM/SSoFyYaa7b7c7Or0p/6b/5NR+V/i7EMVY=
Date:   Wed, 24 Mar 2021 21:36:49 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, ks77sj@gmail.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, snild@sony.com, stable@vger.kernel.org,
        tommyhebb@gmail.com, torvalds@linux-foundation.org,
        vitaly.wool@konsulko.com
Subject:  [patch 05/14] z3fold: prevent reclaim/free race for
 headless pages
Message-ID: <20210325043649.utT2m0hPX%akpm@linux-foundation.org>
In-Reply-To: <20210324213324.fe1ba237e471b5de17a08775@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

=46rom: Thomas Hebb <tommyhebb@gmail.com>
Subject: z3fold: prevent reclaim/free race for headless pages

commit ca0246bb97c2 ("z3fold: fix possible reclaim races") introduced the
PAGE_CLAIMED flag "to avoid racing on a z3fold 'headless' page release."
By atomically testing and setting the bit in each of z3fold_free() and
z3fold_reclaim_page(), a double-free was avoided.

However, commit dcf5aedb24f8 ("z3fold: stricter locking and more careful
reclaim") appears to have unintentionally broken this behavior by moving
the PAGE_CLAIMED check in z3fold_reclaim_page() to after the page lock
gets taken, which only happens for non-headless pages.  For headless
pages, the check is now skipped entirely and races can occur again.

I have observed such a race on my system:

    page:00000000ffbd76b7 refcount:0 mapcount:0 mapping:0000000000000000 in=
dex:0x0 pfn:0x165316
    flags: 0x2ffff0000000000()
    raw: 02ffff0000000000 ffffea0004535f48 ffff8881d553a170 0000000000000000
    raw: 0000000000000000 0000000000000011 00000000ffffffff 0000000000000000
    page dumped because: VM_BUG_ON_PAGE(page_ref_count(page) =3D=3D 0)
    ------------[ cut here ]------------
    kernel BUG at include/linux/mm.h:707!
    invalid opcode: 0000 [#1] PREEMPT SMP KASAN PTI
    CPU: 2 PID: 291928 Comm: kworker/2:0 Tainted: G    B             5.10.7=
-arch1-1-kasan #1
    Hardware name: Gigabyte Technology Co., Ltd. H97N-WIFI/H97N-WIFI, BIOS =
F9b 03/03/2016
    Workqueue: zswap-shrink shrink_worker
    RIP: 0010:__free_pages+0x10a/0x130
    Code: c1 e7 06 48 01 ef 45 85 e4 74 d1 44 89 e6 31 d2 41 83 ec 01 e8 e7=
 b0 ff ff eb da 48 c7 c6 e0 32 91 88 48 89 ef e8 a6 89 f8 ff <0f> 0b 4c 89 =
e7 e8 fc 79 07 00 e9 33 ff ff ff 48 89 ef e8 ff 79 07
    RSP: 0000:ffff88819a2ffb98 EFLAGS: 00010296
    RAX: 0000000000000000 RBX: ffffea000594c5a8 RCX: 0000000000000000
    RDX: 1ffffd4000b298b7 RSI: 0000000000000000 RDI: ffffea000594c5b8
    RBP: ffffea000594c580 R08: 000000000000003e R09: ffff8881d5520bbb
    R10: ffffed103aaa4177 R11: 0000000000000001 R12: ffffea000594c5b4
    R13: 0000000000000000 R14: ffff888165316000 R15: ffffea000594c588
    FS:  0000000000000000(0000) GS:ffff8881d5500000(0000) knlGS:00000000000=
00000
    CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
    CR2: 00007f7c8c3654d8 CR3: 0000000103f42004 CR4: 00000000001706e0
    Call Trace:
     z3fold_zpool_shrink+0x9b6/0x1240
     ? sugov_update_single+0x357/0x990
     ? sched_clock+0x5/0x10
     ? sched_clock_cpu+0x18/0x180
     ? z3fold_zpool_map+0x490/0x490
     ? _raw_spin_lock_irq+0x88/0xe0
     shrink_worker+0x35/0x90
     process_one_work+0x70c/0x1210
     ? pwq_dec_nr_in_flight+0x15b/0x2a0
     worker_thread+0x539/0x1200
     ? __kthread_parkme+0x73/0x120
     ? rescuer_thread+0x1000/0x1000
     kthread+0x330/0x400
     ? __kthread_bind_mask+0x90/0x90
     ret_from_fork+0x22/0x30
    Modules linked in: rfcomm ebtable_filter ebtables ip6table_filter ip6_t=
ables iptable_filter ccm algif_aead des_generic libdes ecb algif_skcipher c=
mac bnep md4 algif_hash af_alg vfat fat intel_rapl_msr intel_rapl_common x8=
6_pkg_temp_thermal intel_powerclamp coretemp kvm_intel iwlmvm hid_logitech_=
hidpp kvm at24 mac80211 snd_hda_codec_realtek iTCO_wdt snd_hda_codec_generi=
c intel_pmc_bxt snd_hda_codec_hdmi ledtrig_audio iTCO_vendor_support mei_wd=
t mei_hdcp snd_hda_intel snd_intel_dspcfg libarc4 soundwire_intel irqbypass=
 iwlwifi soundwire_generic_allocation rapl soundwire_cadence intel_cstate s=
nd_hda_codec intel_uncore btusb joydev mousedev snd_usb_audio pcspkr btrtl =
uvcvideo nouveau btbcm i2c_i801 btintel snd_hda_core videobuf2_vmalloc i2c_=
smbus snd_usbmidi_lib videobuf2_memops bluetooth snd_hwdep soundwire_bus sn=
d_soc_rt5640 videobuf2_v4l2 cfg80211 snd_soc_rl6231 videobuf2_common snd_ra=
wmidi lpc_ich alx videodev mdio snd_seq_device snd_soc_core mc ecdh_generic=
 mxm_wmi mei_me
     hid_logitech_dj wmi snd_compress e1000e ac97_bus mei ttm rfkill snd_pc=
m_dmaengine ecc snd_pcm snd_timer snd soundcore mac_hid acpi_pad pkcs8_key_=
parser it87 hwmon_vid crypto_user fuse ip_tables x_tables ext4 crc32c_gener=
ic crc16 mbcache jbd2 dm_crypt cbc encrypted_keys trusted tpm rng_core usbh=
id dm_mod crct10dif_pclmul crc32_pclmul crc32c_intel ghash_clmulni_intel ae=
sni_intel crypto_simd cryptd glue_helper xhci_pci xhci_pci_renesas i915 vid=
eo intel_gtt i2c_algo_bit drm_kms_helper syscopyarea sysfillrect sysimgblt =
fb_sys_fops cec drm agpgart
    ---[ end trace 126d646fc3dc0ad8 ]---

To fix the issue, re-add the earlier test and set in the case where we
have a headless page.

Link: https://lkml.kernel.org/r/c8106dbe6d8390b290cd1d7f873a2942e805349e.16=
15452048.git.tommyhebb@gmail.com
Fixes: dcf5aedb24f8 ("z3fold: stricter locking and more careful reclaim")
Signed-off-by: Thomas Hebb <tommyhebb@gmail.com>
Reviewed-by: Vitaly Wool <vitaly.wool@konsulko.com>
Cc: Jongseok Kim <ks77sj@gmail.com>
Cc: Snild Dolkow <snild@sony.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/z3fold.c |   16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

--- a/mm/z3fold.c~z3fold-prevent-reclaim-free-race-for-headless-pages
+++ a/mm/z3fold.c
@@ -1346,8 +1346,22 @@ static int z3fold_reclaim_page(struct z3
 			page =3D list_entry(pos, struct page, lru);
=20
 			zhdr =3D page_address(page);
-			if (test_bit(PAGE_HEADLESS, &page->private))
+			if (test_bit(PAGE_HEADLESS, &page->private)) {
+				/*
+				 * For non-headless pages, we wait to do this
+				 * until we have the page lock to avoid racing
+				 * with __z3fold_alloc(). Headless pages don't
+				 * have a lock (and __z3fold_alloc() will never
+				 * see them), but we still need to test and set
+				 * PAGE_CLAIMED to avoid racing with
+				 * z3fold_free(), so just do it now before
+				 * leaving the loop.
+				 */
+				if (test_and_set_bit(PAGE_CLAIMED, &page->private))
+					continue;
+
 				break;
+			}
=20
 			if (kref_get_unless_zero(&zhdr->refcount) =3D=3D 0) {
 				zhdr =3D NULL;
_
