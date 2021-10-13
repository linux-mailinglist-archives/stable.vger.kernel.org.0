Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F290A42C077
	for <lists+stable@lfdr.de>; Wed, 13 Oct 2021 14:45:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233964AbhJMMra (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Oct 2021 08:47:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234180AbhJMMrW (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Oct 2021 08:47:22 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF1ECC061746
        for <stable@vger.kernel.org>; Wed, 13 Oct 2021 05:45:18 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id k7so7855958wrd.13
        for <stable@vger.kernel.org>; Wed, 13 Oct 2021 05:45:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=cuLResFeBhov2ygLcP+AxmAZAimwCmsD/hkXrTpy6fU=;
        b=q3PdKKiohegrxncCCIs6X5z7HTKq5WPMYBbLiZ3P5pxGq0SnGyleFoQXwY/K2L/+Sm
         Kay7ovqxiSUaa8QUPq3s3ssgSz/T7g/xtmlIReB8PaIwLskmvi4qbc6oKxlmOmEf7Mzq
         d3+0DQLZ/FGxtPwN9wtJdRmkDZQARUtOan4je6akCIg55T+CCZNwlM1UqSDiGYWBPv+8
         4/q82fkA2ohQGzDMwfmN8mPuFKuhNp3gr5Ah1SY7umGO48oiR94ubTo7TtBpRNAXQlIJ
         Fx7QX9bwvZ9pQpbwrPHCshORs5GLcpL2GJ52NrtMrRHT3EOJG84ltJ6ucns+HfHZ9Pnd
         XpCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=cuLResFeBhov2ygLcP+AxmAZAimwCmsD/hkXrTpy6fU=;
        b=IlAI+7xaZKnxXXzg33MNlEigag7RJY7qCh+aOcGIDDYZiP2l27h3wdvPAnxH7BgjM4
         4lDjI+SEZrcDyjaYXPD/pVDIirljqbOpzH6EI37MKVH1YtqCj4xhH7vcw7ky18/m8TOw
         yY7iTXAjfPKGXWGIOya+DBWy7jLMaNvPNZVZ8keRsi35OS8LKEqX2KBKgU+S/vUiwj3L
         XncdpJWmnzY3Z/0t7xy2eCZEYPVxZwpJ1+p596/laBt6kb8Xd1CDNgP1hFU808pm9/hH
         qphfrRJDDUhM+3hEKwCNOrzsnKl1HYmkNLnD+Acloe9yftAsf1f+VT81OoJZqhs1xPaS
         MGYg==
X-Gm-Message-State: AOAM531HmECA8ohxDFoFCeySBNz11heDVhetoTckuZMFmJWpPELTFwea
        vosP2tJMSZ0cvo4N7LppwS4ftA==
X-Google-Smtp-Source: ABdhPJzOI5bvspQtVsAWHyHWMg5rqni6kGoUBe9neTzS77CFtoQ4hjLZaBN89wCpVkADKes3TC2pRg==
X-Received: by 2002:a1c:1d8d:: with SMTP id d135mr12873312wmd.191.1634129117425;
        Wed, 13 Oct 2021 05:45:17 -0700 (PDT)
Received: from srini-hackbox.lan (cpc86377-aztw32-2-0-cust226.18-1.cable.virginm.net. [92.233.226.227])
        by smtp.gmail.com with ESMTPSA id a2sm13594981wru.82.2021.10.13.05.45.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Oct 2021 05:45:16 -0700 (PDT)
From:   Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
To:     gregkh@linuxfoundation.org
Cc:     linux-kernel@vger.kernel.org, Stephen Boyd <swboyd@chromium.org>,
        Douglas Anderson <dianders@chromium.org>,
        stable@vger.kernel.org,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: [PATCH] nvmem: Fix shift-out-of-bound (UBSAN) with byte size cells
Date:   Wed, 13 Oct 2021 13:45:11 +0100
Message-Id: <20211013124511.18726-1-srinivas.kandagatla@linaro.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stephen Boyd <swboyd@chromium.org>

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

Cc: Douglas Anderson <dianders@chromium.org>
Fixes: 69aba7948cbe ("nvmem: Add a simple NVMEM framework for consumers")
Cc: stable@vger.kernel.org
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
---
Hi Greg,

Could you pick this up for next possible 5.15 rc.

Thanks,
--srini

 drivers/nvmem/core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/nvmem/core.c b/drivers/nvmem/core.c
index 3d87fadaa160..8976da38b375 100644
--- a/drivers/nvmem/core.c
+++ b/drivers/nvmem/core.c
@@ -1383,7 +1383,8 @@ static void nvmem_shift_read_buffer_in_place(struct nvmem_cell *cell, void *buf)
 		*p-- = 0;
 
 	/* clear msb bits if any leftover in the last byte */
-	*p &= GENMASK((cell->nbits%BITS_PER_BYTE) - 1, 0);
+	if (cell->nbits % BITS_PER_BYTE)
+		*p &= GENMASK((cell->nbits % BITS_PER_BYTE) - 1, 0);
 }
 
 static int __nvmem_cell_read(struct nvmem_device *nvmem,
-- 
2.21.0

