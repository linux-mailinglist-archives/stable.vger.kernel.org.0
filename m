Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EE36336E00
	for <lists+stable@lfdr.de>; Thu, 11 Mar 2021 09:41:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231253AbhCKIlN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Mar 2021 03:41:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231422AbhCKIk7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Mar 2021 03:40:59 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D01E8C061574;
        Thu, 11 Mar 2021 00:40:58 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id t18so3104951pjs.3;
        Thu, 11 Mar 2021 00:40:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6mHyVtaVWSP9V2QIq3wJeCIuCzZt3/lvF8Edv6hD61g=;
        b=XUFa0Cyiyni1CphJwyUp0Crd/UMZTGN3WylVXXa4xmaDwP10UFqZfeG5689oOZVrOf
         mW49lwUUDzlnW7tcQVdgBVCZ/VXBcEmDKl56xXILMvA+bQzpcXe11r8vkxIB3yxssoRD
         7tYxjZG+FwMLZK9pUlHlkZobkpjChRmCLWhAMn5pmHLysa4sHRShfDA+HMOnQS0uvZM6
         okkyuExtxOQxWzgbdHqqkesdTibJTSdepuwAa3gL3uR4vXdsLmD3r6L6GstybvEN7hJl
         c9u+ncRpgBjrKsAfNi5MS4eunDUghMFBrIkhtinH/keuIiRfeP5h0330KHTcoFRloE3a
         Y9VA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6mHyVtaVWSP9V2QIq3wJeCIuCzZt3/lvF8Edv6hD61g=;
        b=nwiE4utoOuCv0sPoP6AIqkA4fWBWby5LMPXFnkW7TyQNMgXzQvKNg+jdJdyKzROXLi
         tpjKla7LLAU69YCF315k85Xg4DldpzNhAsVqUgO7Z8/4k8R4l1p2HoW6KK3JGGvoTM93
         qhphrIpNxl0z6d/LexKKQv/sKnldpA4Ou8mp5skYhzP0yaOEO8l7NCUBwCQt2DpDdfsl
         w99zxLummOM6KEjFMAllzIEyUawyODgQxIpI0hD9ZvVhelPj8S1Dg0sXCpxfCc+FieBN
         8iD9MqN2PFjo7WQeggz7OxLZI+HJseS5aORLdnLvc0Le9BDCrGF8h43AaXNqboWGhVkg
         4uEQ==
X-Gm-Message-State: AOAM53160441SZK4ZsaS3rADWctUv36jfB57YJtMVxv5XJiSbdumH7X4
        UgIqYdTPuq4Okm0Brr2uny5ajIloS3ba3fWj
X-Google-Smtp-Source: ABdhPJzzCTl16BWQXDUd6QiXp8eVV/DD2BBXrJK0gAHjOLjNFOoI8dgw2RxRLnu5lmLZqEaFYGJimA==
X-Received: by 2002:a17:90a:bb91:: with SMTP id v17mr7602440pjr.24.1615452057971;
        Thu, 11 Mar 2021 00:40:57 -0800 (PST)
Received: from glados.. ([2601:647:6000:3e5b::a27])
        by smtp.gmail.com with ESMTPSA id c22sm1585829pfl.169.2021.03.11.00.40.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Mar 2021 00:40:57 -0800 (PST)
From:   Thomas Hebb <tommyhebb@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     Thomas Hebb <tommyhebb@gmail.com>, stable@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Vitaly Wool <vitaly.wool@konsulko.com>, linux-mm@kvack.org
Subject: [PATCH] z3fold: prevent reclaim/free race for headless pages
Date:   Thu, 11 Mar 2021 00:40:54 -0800
Message-Id: <c8106dbe6d8390b290cd1d7f873a2942e805349e.1615452048.git.tommyhebb@gmail.com>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit ca0246bb97c2 ("z3fold: fix possible reclaim races") introduced
the PAGE_CLAIMED flag "to avoid racing on a z3fold 'headless' page
release." By atomically testing and setting the bit in each of
z3fold_free() and z3fold_reclaim_page(), a double-free was avoided.

However, commit dcf5aedb24f8 ("z3fold: stricter locking and more careful
reclaim") appears to have unintentionally broken this behavior by moving
the PAGE_CLAIMED check in z3fold_reclaim_page() to after the page lock
gets taken, which only happens for non-headless pages. For headless
pages, the check is now skipped entirely and races can occur again.

I have observed such a race on my system:

    page:00000000ffbd76b7 refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x165316
    flags: 0x2ffff0000000000()
    raw: 02ffff0000000000 ffffea0004535f48 ffff8881d553a170 0000000000000000
    raw: 0000000000000000 0000000000000011 00000000ffffffff 0000000000000000
    page dumped because: VM_BUG_ON_PAGE(page_ref_count(page) == 0)
    ------------[ cut here ]------------
    kernel BUG at include/linux/mm.h:707!
    invalid opcode: 0000 [#1] PREEMPT SMP KASAN PTI
    CPU: 2 PID: 291928 Comm: kworker/2:0 Tainted: G    B             5.10.7-arch1-1-kasan #1
    Hardware name: Gigabyte Technology Co., Ltd. H97N-WIFI/H97N-WIFI, BIOS F9b 03/03/2016
    Workqueue: zswap-shrink shrink_worker
    RIP: 0010:__free_pages+0x10a/0x130
    Code: c1 e7 06 48 01 ef 45 85 e4 74 d1 44 89 e6 31 d2 41 83 ec 01 e8 e7 b0 ff ff eb da 48 c7 c6 e0 32 91 88 48 89 ef e8 a6 89 f8 ff <0f> 0b 4c 89 e7 e8 fc 79 07 00 e9 33 ff ff ff 48 89 ef e8 ff 79 07
    RSP: 0000:ffff88819a2ffb98 EFLAGS: 00010296
    RAX: 0000000000000000 RBX: ffffea000594c5a8 RCX: 0000000000000000
    RDX: 1ffffd4000b298b7 RSI: 0000000000000000 RDI: ffffea000594c5b8
    RBP: ffffea000594c580 R08: 000000000000003e R09: ffff8881d5520bbb
    R10: ffffed103aaa4177 R11: 0000000000000001 R12: ffffea000594c5b4
    R13: 0000000000000000 R14: ffff888165316000 R15: ffffea000594c588
    FS:  0000000000000000(0000) GS:ffff8881d5500000(0000) knlGS:0000000000000000
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
    Modules linked in: rfcomm ebtable_filter ebtables ip6table_filter ip6_tables iptable_filter ccm algif_aead des_generic libdes ecb algif_skcipher cmac bnep md4 algif_hash af_alg vfat fat intel_rapl_msr intel_rapl_common x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel iwlmvm hid_logitech_hidpp kvm at24 mac80211 snd_hda_codec_realtek iTCO_wdt snd_hda_codec_generic intel_pmc_bxt snd_hda_codec_hdmi ledtrig_audio iTCO_vendor_support mei_wdt mei_hdcp snd_hda_intel snd_intel_dspcfg libarc4 soundwire_intel irqbypass iwlwifi soundwire_generic_allocation rapl soundwire_cadence intel_cstate snd_hda_codec intel_uncore btusb joydev mousedev snd_usb_audio pcspkr btrtl uvcvideo nouveau btbcm i2c_i801 btintel snd_hda_core videobuf2_vmalloc i2c_smbus snd_usbmidi_lib videobuf2_memops bluetooth snd_hwdep soundwire_bus snd_soc_rt5640 videobuf2_v4l2 cfg80211 snd_soc_rl6231 videobuf2_common snd_rawmidi lpc_ich alx videodev mdio snd_seq_device snd_soc_core mc ecdh_generic mxm_wmi mei_me
     hid_logitech_dj wmi snd_compress e1000e ac97_bus mei ttm rfkill snd_pcm_dmaengine ecc snd_pcm snd_timer snd soundcore mac_hid acpi_pad pkcs8_key_parser it87 hwmon_vid crypto_user fuse ip_tables x_tables ext4 crc32c_generic crc16 mbcache jbd2 dm_crypt cbc encrypted_keys trusted tpm rng_core usbhid dm_mod crct10dif_pclmul crc32_pclmul crc32c_intel ghash_clmulni_intel aesni_intel crypto_simd cryptd glue_helper xhci_pci xhci_pci_renesas i915 video intel_gtt i2c_algo_bit drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops cec drm agpgart
    ---[ end trace 126d646fc3dc0ad8 ]---

To fix the issue, re-add the earlier test and set in the case where we
have a headless page.

Fixes: dcf5aedb24f8 ("z3fold: stricter locking and more careful reclaim")
Cc: stable@vger.kernel.org
Signed-off-by: Thomas Hebb <tommyhebb@gmail.com>
---

 mm/z3fold.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/mm/z3fold.c b/mm/z3fold.c
index 0152ad9931a8..8ae944eeb8e2 100644
--- a/mm/z3fold.c
+++ b/mm/z3fold.c
@@ -1350,8 +1350,22 @@ static int z3fold_reclaim_page(struct z3fold_pool *pool, unsigned int retries)
 			page = list_entry(pos, struct page, lru);
 
 			zhdr = page_address(page);
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
 
 			if (kref_get_unless_zero(&zhdr->refcount) == 0) {
 				zhdr = NULL;
-- 
2.30.0

