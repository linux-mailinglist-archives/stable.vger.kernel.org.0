Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFE6A439F7B
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 21:19:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234434AbhJYTVJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 15:21:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:38296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234573AbhJYTUE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 15:20:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 30C9F6103C;
        Mon, 25 Oct 2021 19:17:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635189461;
        bh=oFeud0A2uIlaNfeGkWC8QwUsaeEnJjXyeWUwVPbfCdI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xqWPoWaA5tb+a6fOMiIn3t/nNgRr329Fsedb66dS/bUKIKlKyBXz81BBbDm14ZEDV
         HIjVOHqTY+q7W182yvOMUIPLwZrBqIfNrIrsVq0mA0ExZnuXHiZqbgu88X5zvxYN2V
         9Bj7usjC43pFYJo4fNOJdVvS3So5Q9BGfxp4mlqk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Douglas Anderson <dianders@chromium.org>,
        Stephen Boyd <swboyd@chromium.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: [PATCH 4.9 10/50] nvmem: Fix shift-out-of-bound (UBSAN) with byte size cells
Date:   Mon, 25 Oct 2021 21:13:57 +0200
Message-Id: <20211025190934.921745976@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211025190932.542632625@linuxfoundation.org>
References: <20211025190932.542632625@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stephen Boyd <swboyd@chromium.org>

commit 5d388fa01fa6eb310ac023a363a6cb216d9d8fe9 upstream.

If a cell has 'nbits' equal to a multiple of BITS_PER_BYTE the logic

 *p &= GENMASK((cell->nbits%BITS_PER_BYTE) - 1, 0);

will become undefined behavior because nbits modulo BITS_PER_BYTE is 0, and we
subtract one from that making a large number that is then shifted more than the
number of bits that fit into an unsigned long.

UBSAN reports this problem:

 UBSAN: shift-out-of-bounds in drivers/nvmem/core.c:1386:8
 shift exponent 64 is too large for 64-bit type 'unsigned long'
 CPU: 6 PID: 7 Comm: kworker/u16:0 Not tainted 5.15.0-rc3+ #9
 Hardware name: Google Lazor (rev3+) with KB Backlight (DT)
 Workqueue: events_unbound deferred_probe_work_func
 Call trace:
  dump_backtrace+0x0/0x170
  show_stack+0x24/0x30
  dump_stack_lvl+0x64/0x7c
  dump_stack+0x18/0x38
  ubsan_epilogue+0x10/0x54
  __ubsan_handle_shift_out_of_bounds+0x180/0x194
  __nvmem_cell_read+0x1ec/0x21c
  nvmem_cell_read+0x58/0x94
  nvmem_cell_read_variable_common+0x4c/0xb0
  nvmem_cell_read_variable_le_u32+0x40/0x100
  a6xx_gpu_init+0x170/0x2f4
  adreno_bind+0x174/0x284
  component_bind_all+0xf0/0x264
  msm_drm_bind+0x1d8/0x7a0
  try_to_bring_up_master+0x164/0x1ac
  __component_add+0xbc/0x13c
  component_add+0x20/0x2c
  dp_display_probe+0x340/0x384
  platform_probe+0xc0/0x100
  really_probe+0x110/0x304
  __driver_probe_device+0xb8/0x120
  driver_probe_device+0x4c/0xfc
  __device_attach_driver+0xb0/0x128
  bus_for_each_drv+0x90/0xdc
  __device_attach+0xc8/0x174
  device_initial_probe+0x20/0x2c
  bus_probe_device+0x40/0xa4
  deferred_probe_work_func+0x7c/0xb8
  process_one_work+0x128/0x21c
  process_scheduled_works+0x40/0x54
  worker_thread+0x1ec/0x2a8
  kthread+0x138/0x158
  ret_from_fork+0x10/0x20

Fix it by making sure there are any bits to mask out.

Fixes: 69aba7948cbe ("nvmem: Add a simple NVMEM framework for consumers")
Cc: Douglas Anderson <dianders@chromium.org>
Cc: stable@vger.kernel.org
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/20211013124511.18726-1-srinivas.kandagatla@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvmem/core.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/nvmem/core.c
+++ b/drivers/nvmem/core.c
@@ -967,7 +967,8 @@ static inline void nvmem_shift_read_buff
 		*p-- = 0;
 
 	/* clear msb bits if any leftover in the last byte */
-	*p &= GENMASK((cell->nbits%BITS_PER_BYTE) - 1, 0);
+	if (cell->nbits % BITS_PER_BYTE)
+		*p &= GENMASK((cell->nbits % BITS_PER_BYTE) - 1, 0);
 }
 
 static int __nvmem_cell_read(struct nvmem_device *nvmem,


