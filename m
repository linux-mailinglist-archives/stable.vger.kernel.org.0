Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C507569B78
	for <lists+stable@lfdr.de>; Mon, 15 Jul 2019 21:36:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730932AbfGOTgW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jul 2019 15:36:22 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:33126 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729948AbfGOTgW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Jul 2019 15:36:22 -0400
Received: by mail-io1-f67.google.com with SMTP id z3so36092322iog.0
        for <stable@vger.kernel.org>; Mon, 15 Jul 2019 12:36:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/pqgaf08UgpSbv0n0bglI8bk42pvD+/A0yujhlQ04oo=;
        b=LDkn8icU/jJCebo8bOQX1caCQdLYedR92fxEplSoVpTuUq7vud5v3NWazJg9T+MDya
         qd0V0DS49nRiMJsERAHveK5hT6IK3hZ2tD0tbOmBsIDTbhrHn+EC9EvwcJSlAhVVieqo
         VaTbDOeTcaTS+evTCbEErkz1nrmZ0LGSKJg+0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/pqgaf08UgpSbv0n0bglI8bk42pvD+/A0yujhlQ04oo=;
        b=ftCwSzw4Z0sfY6LetWXEOJufiUjDqIfqmKEBnKi6NWIJvw8jeA1hDv5h2HUojNvcY5
         QBOW9KwViDmEH+SyF0D8bzOxGSvNEDFPNZeQevWWP1OvUpN7AcxN76Sw4a0lRwfKtuOL
         oWyyau2olmaqUpc2l0k9mmGsb8cvDkfveT63CV8iJ/E/KP96OauzIwiW6ia25/0EIE5v
         DWrwoM0bSbIN0MwoMZ6+87qzOYffxTLkaNe+fHM37SwKacLb41xCYYWRMXxMatwoYeob
         ZU78oVqdX6IzHsYipNc57j8qIKnx9Ycu8WjwuW7i95EoFuCULG2HFhT0SkboQskB+KzJ
         CYTA==
X-Gm-Message-State: APjAAAWCwuTrgKtCmZeqCnD89b7bdhIWZaYwB3U6sk+GpTA+srl0BkL/
        3gwdDgJR42AJagmCtHakaSnjWTCUS3s=
X-Google-Smtp-Source: APXvYqxRwZ351zb8M1/hRy6LFiIUrD3I6TixMiLmsEg30V8/w3U3oIv+7I+b+8z95uw0/GQ56mADgw==
X-Received: by 2002:a05:6638:303:: with SMTP id w3mr17718521jap.103.1563219381003;
        Mon, 15 Jul 2019 12:36:21 -0700 (PDT)
Received: from localhost ([2620:15c:183:200:855f:8919:84a7:4794])
        by smtp.gmail.com with ESMTPSA id a7sm16180046iok.19.2019.07.15.12.36.19
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 15 Jul 2019 12:36:20 -0700 (PDT)
From:   Ross Zwisler <zwisler@chromium.org>
X-Google-Original-From: Ross Zwisler <zwisler@google.com>
To:     stable@vger.kernel.org
Cc:     Ross Zwisler <zwisler@google.com>,
        Dave Airlie <airlied@redhat.com>,
        Guenter Roeck <groeck@google.com>
Subject: [v4.14.y PATCH 0/2] fix drm/udl use-after-free error
Date:   Mon, 15 Jul 2019 13:36:16 -0600
Message-Id: <20190715193618.24578-1-zwisler@google.com>
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
 BUG: KASAN: use-after-free in do_raw_spin_lock+0x1c/0xd0
 Read of size 4 at addr ffff888385e325fc by task kworker/2:2/47
 
 CPU: 2 PID: 47 Comm: kworker/2:2 Tainted: G     U          4.14.133 #19
 Hardware name: GOOGLE Samus, BIOS Google_Samus.6300.276.0 08/17/2016
 Workqueue: events drm_mode_rmfb_work_fn
 Call Trace:
  dump_stack+0x67/0x92
  print_address_description+0x80/0x2d6
  ? do_raw_spin_lock+0x1c/0xd0
  kasan_report+0x255/0x295
  do_raw_spin_lock+0x1c/0xd0
  _raw_spin_lock_irqsave+0x42/0x4e
  ? down_timeout+0x19/0x58
  down_timeout+0x19/0x58
  udl_get_urb+0x3d/0x13b
  ? drm_helper_encoder_in_use+0xc2/0xe1
  udl_crtc_dpms+0x45/0x274
  __drm_helper_disable_unused_functions+0xed/0x150
  drm_crtc_helper_set_config+0x22d/0xfc2
  ? lock_acquire+0x1e4/0x21a
  ? modeset_lock+0x165/0x20e
  ? __mutex_trylock+0x9/0x11
  ? debug_lockdep_rcu_enabled+0x2a/0x59
  __drm_mode_set_config_internal+0xf3/0x240
  drm_crtc_force_disable+0x68/0x83
  drm_framebuffer_remove+0x10b/0x1af
  drm_mode_rmfb_work_fn+0x8d/0x9b
  process_one_work+0x42f/0x7a2
  worker_thread+0x3a4/0x483
  ? flush_delayed_work+0x64/0x64
  kthread+0x1e7/0x1f7
  ? __init_completion+0x2c/0x2c
  ret_from_fork+0x3a/0x50
 
 Allocated by task 1959:
  save_stack+0x46/0xce
  kasan_kmalloc+0x99/0xa8
  kmem_cache_alloc_trace+0x10d/0x133
  udl_driver_load+0x59/0x7fe
  drm_dev_register+0x16b/0x2fd
  udl_usb_probe+0x4f/0xa6
  usb_probe_interface+0x26a/0x31d
  driver_probe_device+0x1d5/0x411
  bus_for_each_drv+0xbe/0xe5
  __device_attach+0xdd/0x15b
  bus_probe_device+0x5a/0x10b
  device_add+0x468/0x7fb
  usb_set_configuration+0x978/0x9e5
  generic_probe+0x45/0x77
  driver_probe_device+0x1d5/0x411
  bus_for_each_drv+0xbe/0xe5
  __device_attach+0xdd/0x15b
  bus_probe_device+0x5a/0x10b
  device_add+0x468/0x7fb
  usb_new_device+0x51d/0x6a1
  hub_event+0xee4/0x1639
  process_one_work+0x42f/0x7a2
  worker_thread+0x31c/0x483
  kthread+0x1e7/0x1f7
  ret_from_fork+0x3a/0x50
 
 Freed by task 1959:
  save_stack+0x46/0xce
  kasan_slab_free+0x8a/0xac
  slab_free_hook+0x52/0x5c
  kfree+0x1a5/0x228
  drm_dev_unregister+0xa6/0x16c
  drm_dev_unplug+0x12/0x5b
  usb_unbind_interface+0xc8/0x2c1
  device_release_driver_internal+0x1e4/0x302
  bus_remove_device+0x1b9/0x1e4
  device_del+0x275/0x42d
  usb_disable_device+0x112/0x2cb
  usb_disconnect+0xef/0x28e
  usb_disconnect+0xe0/0x28e
  hub_event+0x7cc/0x1639
  process_one_work+0x42f/0x7a2
  worker_thread+0x31c/0x483
  kthread+0x1e7/0x1f7
  ret_from_fork+0x3a/0x50
 
 The buggy address belongs to the object at ffff888385e32588
  which belongs to the cache kmalloc-2048 of size 2048
 The buggy address is located 116 bytes inside of
  2048-byte region [ffff888385e32588, ffff888385e32d88)
 The buggy address belongs to the page:
 page:ffffea000e178c00 count:1 mapcount:0 mapping:          (null) index:0x0 compound_mapcount: 0
 flags: 0x8000000000008100(slab|head)
 raw: 8000000000008100 0000000000000000 0000000000000000 00000001000d000d
 raw: ffffea000ee71e20 ffffea000ee6d620 ffff88842d00d0c0 0000000000000000
 page dumped because: kasan: bad access detected
 
 Memory state around the buggy address:
  ffff888385e32480: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
  ffff888385e32500: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 >ffff888385e32580: fc fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                                                 ^
  ffff888385e32600: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
  ffff888385e32680: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ==================================================================

This happens 100% of the time and is resolved by the following patch
upstream:

commit 6ecac85eadb9 ("drm/udl: move to embedding drm device inside udl device.")

This patch is the second in this series, and requires the first patch as
a dependency.  This series apples cleanly to v4.14.133.

Dave Airlie (2):
  drm/udl: introduce a macro to convert dev to udl.
  drm/udl: move to embedding drm device inside udl device.

 drivers/gpu/drm/udl/udl_drv.c  | 56 +++++++++++++++++++++++++++-------
 drivers/gpu/drm/udl/udl_drv.h  |  9 +++---
 drivers/gpu/drm/udl/udl_fb.c   | 12 ++++----
 drivers/gpu/drm/udl/udl_main.c | 35 ++++++---------------
 4 files changed, 65 insertions(+), 47 deletions(-)

-- 
2.22.0.510.g264f2c817a-goog

