Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 912E669A78
	for <lists+stable@lfdr.de>; Mon, 15 Jul 2019 20:07:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729292AbfGOSG0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jul 2019 14:06:26 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:44534 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729277AbfGOSG0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Jul 2019 14:06:26 -0400
Received: by mail-io1-f67.google.com with SMTP id s7so35493388iob.11
        for <stable@vger.kernel.org>; Mon, 15 Jul 2019 11:06:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=kZR0+ye1f7+dl441ahjbNy4WqlkLXMCg7mpgL8yrdJI=;
        b=AVrQxzKmIuWVBPdNuaF3ZDh+q7Wul8vCyWkYPG3sfDxlxEKUnmofc4EHwWV/C7UbE9
         zxSIDEJYvOm1EbPlZh3HJhlCtd7tWWz33hf+Sp767C2kN0CWLgrXnvxEuElN7VbLqFE4
         Vq6Y2foul6IXtN2mV++Qq4X0yIKe1ENWcYlhc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=kZR0+ye1f7+dl441ahjbNy4WqlkLXMCg7mpgL8yrdJI=;
        b=XEubiYWCw0fu9hZZUQ5q86/emJtOuvy4gOF8leCyUvHuXy14PMsMr8rv1MyF9h7WKN
         CK5dWoqCAAlwaWZhAeKJCBGriyRx+KgspfNZtRQBGgsRdiW40EUxdmmV1F0W9sBmeMcW
         HoNNKpduOo4fM2xuD7tIJplOXJ/ooBqR9GboMrxs75jKoQAolrLihWn1O0+lg92vEVOA
         m64aFEapLWeHjglNbPhAMvK1URptxYJkwmQ5mogwNN7sOGPl49mcZEXpMMoa7bEjJ7qR
         PGOcmOBmqHeKq23EMMM0dWOoQOhB3YeuFjb5BbEY2CkN+RiJtgIPxKGr3gH2582gSBtJ
         HCCQ==
X-Gm-Message-State: APjAAAUijMaZJNJLCLhXOHrcjE/X6zR3elXoOpqKkBAD2ir/SdLjlJZz
        mFPb13q2XjbM44EFxKOhxBSrIAyi32Q=
X-Google-Smtp-Source: APXvYqw5hEY5E5wA3mVD5gmiUw+nMV0c1zxXOhyjCbSur4o4Ri2s5pCrCVITN4jhOBZExppGVPCAJA==
X-Received: by 2002:a6b:7317:: with SMTP id e23mr11750037ioh.37.1563213985083;
        Mon, 15 Jul 2019 11:06:25 -0700 (PDT)
Received: from localhost ([2620:15c:183:200:855f:8919:84a7:4794])
        by smtp.gmail.com with ESMTPSA id z17sm28550403iol.73.2019.07.15.11.06.23
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 15 Jul 2019 11:06:24 -0700 (PDT)
From:   Ross Zwisler <zwisler@chromium.org>
X-Google-Original-From: Ross Zwisler <zwisler@google.com>
To:     stable@vger.kernel.org
Cc:     Ross Zwisler <zwisler@google.com>,
        Dave Airlie <airlied@redhat.com>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        Guenter Roeck <groeck@google.com>
Subject: [v4.19.y PATCH 0/3] fix drm/udl use-after-free error
Date:   Mon, 15 Jul 2019 12:05:55 -0600
Message-Id: <20190715180558.221737-1-zwisler@google.com>
X-Mailer: git-send-email 2.22.0.510.g264f2c817a-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When testing with a device which uses the drm/udl driver, KASAN shows
that on hot-remove we have a use-after-free:

 ==================================================================
 BUG: KASAN: use-after-free in do_raw_spin_lock+0x1c/0xdd
 Read of size 4 at addr ffff88841863668c by task kworker/2:3/2085

 CPU: 2 PID: 2085 Comm: kworker/2:3 Tainted: G     U  W         4.19.59-dirty #15
 Hardware name: GOOGLE Samus, BIOS Google_Samus.6300.276.0 08/17/2016
 Workqueue: events drm_mode_rmfb_work_fn
 Call Trace:
  dump_stack+0x62/0x8b
  print_address_description+0x80/0x2d2
  ? do_raw_spin_lock+0x1c/0xdd
  kasan_report+0x26a/0x2aa
  do_raw_spin_lock+0x1c/0xdd
  _raw_spin_lock_irqsave+0x19/0x1f
  down_timeout+0x19/0x58
  udl_get_urb+0x3d/0x13c
  ? udl_crtc_dpms+0x2e/0x270
  udl_crtc_dpms+0x45/0x270
  __drm_helper_disable_unused_functions+0xed/0x150
  drm_crtc_helper_set_config+0x214/0xf25
  ? ___slab_alloc.constprop.75+0xdd/0x48c
  ? drm_modeset_lock_all+0x33/0xbb
  ? ___might_sleep+0x80/0x1b6
  __drm_mode_set_config_internal+0x103/0x22c
  drm_crtc_force_disable+0x4e/0x69
  drm_framebuffer_remove+0x169/0x508
  ? do_raw_spin_unlock+0xd4/0xde
  ? mmdrop+0x16/0x29
  drm_mode_rmfb_work_fn+0x8d/0x9b
  process_one_work+0x309/0x4df
  worker_thread+0x369/0x447
  ? create_worker+0x2f1/0x2f1
  kthread+0x223/0x233
  ? kthread_worker_fn+0x29c/0x29c
  ret_from_fork+0x35/0x40

 Allocated by task 2085:
  kasan_kmalloc+0x99/0xa8
  kmem_cache_alloc_trace+0x105/0x12b
  udl_driver_load+0x52/0x776
  drm_dev_register+0x151/0x2d6
  udl_usb_probe+0x4f/0xa6
  usb_probe_interface+0x25e/0x311
  really_probe+0x1f1/0x3ee
  driver_probe_device+0xd6/0x112
  bus_for_each_drv+0xbb/0xe2
  __device_attach+0xdb/0x159
  bus_probe_device+0x5a/0x100
  device_add+0x4bf/0x847
  usb_set_configuration+0x972/0x9df
  generic_probe+0x45/0x77
  really_probe+0x1f1/0x3ee
  driver_probe_device+0xd6/0x112
  bus_for_each_drv+0xbb/0xe2
  __device_attach+0xdb/0x159
  bus_probe_device+0x5a/0x100
  device_add+0x4bf/0x847
  usb_new_device+0x540/0x6ba
  hub_event+0x1017/0x161c
  process_one_work+0x309/0x4df
  worker_thread+0x2de/0x447
  kthread+0x223/0x233
  ret_from_fork+0x35/0x40

 Freed by task 2085:
  __kasan_slab_free+0x102/0x126
  slab_free_freelist_hook+0x4d/0x9d
  kfree+0x127/0x1bd
  drm_dev_unregister+0xae/0x167
  drm_dev_unplug+0x2e/0x38
  usb_unbind_interface+0xc5/0x2be
  device_release_driver_internal+0x229/0x381
  bus_remove_device+0x1a2/0x1cd
  device_del+0x26b/0x42c
  usb_disable_device+0x112/0x2c9
  usb_disconnect+0xed/0x28c
  usb_disconnect+0xde/0x28c
  hub_event+0x7eb/0x161c
  process_one_work+0x309/0x4df
  worker_thread+0x2de/0x447
  kthread+0x223/0x233
  ret_from_fork+0x35/0x40

 The buggy address belongs to the object at ffff888418636600
  which belongs to the cache kmalloc-2048 of size 2048
 The buggy address is located 140 bytes inside of
  2048-byte region [ffff888418636600, ffff888418636e00)
 The buggy address belongs to the page:
 page:ffffea0010618c00 count:1 mapcount:0 mapping:ffff88842d403040 index:0x0 compound_mapcount: 0
 flags: 0x8000000000008100(slab|head)
 raw: 8000000000008100 dead000000000100 dead000000000200 ffff88842d403040
 raw: 0000000000000000 00000000000f000f 00000001ffffffff 0000000000000000
 page dumped because: kasan: bad access detected

 Memory state around the buggy address:
  ffff888418636580: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
  ffff888418636600: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 >ffff888418636680: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                       ^
  ffff888418636700: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
  ffff888418636780: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ==================================================================
 Disabling lock debugging due to kernel taint
 [drm] wait for urb interrupted: ffffffc2 available: 4

This happens 100% of the time and is resolved by the following patch
upstream:

commit 6ecac85eadb9 ("drm/udl: move to embedding drm device inside udl device.")

This patch is the third in this series, and requires the first two
patches as dependencies.  All three were clean cherry-picks on top of
v4.19.59.

Dave Airlie (2):
  drm/udl: introduce a macro to convert dev to udl.
  drm/udl: move to embedding drm device inside udl device.

Thomas Zimmermann (1):
  drm/udl: Replace drm_dev_unref with drm_dev_put

 drivers/gpu/drm/udl/udl_drv.c  | 56 +++++++++++++++++++++++++++-------
 drivers/gpu/drm/udl/udl_drv.h  |  9 +++---
 drivers/gpu/drm/udl/udl_fb.c   | 12 ++++----
 drivers/gpu/drm/udl/udl_gem.c  |  2 +-
 drivers/gpu/drm/udl/udl_main.c | 35 ++++++---------------
 5 files changed, 66 insertions(+), 48 deletions(-)

-- 
2.22.0.510.g264f2c817a-goog

