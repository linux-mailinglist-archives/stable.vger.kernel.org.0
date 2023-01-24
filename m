Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C27D67A695
	for <lists+stable@lfdr.de>; Wed, 25 Jan 2023 00:03:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233944AbjAXXDA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Jan 2023 18:03:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229740AbjAXXC7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Jan 2023 18:02:59 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A9CE4AA63
        for <stable@vger.kernel.org>; Tue, 24 Jan 2023 15:02:58 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id n203-20020a2572d4000000b0078f09db9888so17967364ybc.18
        for <stable@vger.kernel.org>; Tue, 24 Jan 2023 15:02:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=jFCDOVwBx3QUvcMyKCToQPVtKOpYmeI/WzOaX/ijtqo=;
        b=lGUMU0GoyjMvxhR5c/END1G2FVaGF8h/lxKsEBZG9c0LJpJjGKejWRHgfC/drxKDSH
         62fajyC2+vuvDk/7FQKN7N60LwQR1dtnGfw0mirFy1kccUYDvzbFEkq8WorpafsApGyW
         YNdikjtXJ0qvizHvdRE8nZwpmwgkyZKvHejop621KmwDUsS0FCq48chv5FiSx0xM801v
         +B37aWPXTixdEO0BnBF0OdMDojYAN0xYneU1Zik51sP498ARl78sXWW6D7upcRoxS444
         ZNlYQh/izuCYRt7+jyaKxT3dQ7Bw+rpvfieeWL3tTUx1TPXnxolTdPGfTD098yBSi7NJ
         hZpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=jFCDOVwBx3QUvcMyKCToQPVtKOpYmeI/WzOaX/ijtqo=;
        b=NKTxOeZJMvyqfu/+fH46uPaiDefpDJfPwsfvTEYzR1R7mWPPz3vAQ+M2a+il4Fb3p9
         2KlLPPSpSlgPTWXCiUMBF0Ddv6NjGl0VteQ9VsmGVsVWCF9YXushnQZULia4lRgpArNC
         79ApQ6IBA/rcwDnNo3+Dhd0OJbPpcZwbuVVyk9Z2L4uLo/h+aoGZjZDqP4VhVOyAZAo5
         GrXzrmbsupHI1kRlI0HBscxGSyCIuCVtEIR3xNsZA2Pnh6suagi91dHIMx6kHj87uZyH
         luBbgmp1FmxwARNdG4m27yiJgOOxWpVF9EUfDj77YG8WDD8MhFXmhQISapCx6E5xMWtV
         6oIA==
X-Gm-Message-State: AFqh2krCCq0JL8w4ZKuYouocNFpuFYNtUBpdw43V59AUvZVJQYGxuaLY
        uo3UAQeE5S2+Y+pXeu3ctBeM7m7qHrfQ41rjEgLb0Q==
X-Google-Smtp-Source: AMrXdXudHpb6hExu0NEHtxFsSqiV2w86qKxRTpDMvyw3aa8/qFaD7i3+qsxBf+fcybfThAjbSBPvI40rjFUZGrzvMaW7+A==
X-Received: from isaacmanjarres.irv.corp.google.com ([2620:15c:2d:3:b15:b561:51fb:73c3])
 (user=isaacmanjarres job=sendgmr) by 2002:a0d:e285:0:b0:4d8:4718:1c51 with
 SMTP id l127-20020a0de285000000b004d847181c51mr3040255ywe.284.1674601377338;
 Tue, 24 Jan 2023 15:02:57 -0800 (PST)
Date:   Tue, 24 Jan 2023 15:02:54 -0800
Mime-Version: 1.0
X-Mailer: git-send-email 2.39.1.405.gd4c25cc71f-goog
Message-ID: <20230124230254.295589-1-isaacmanjarres@google.com>
Subject: [PATCH v1] Revert "mm: kmemleak: alloc gray object for reserved
 region with direct map"
From:   "Isaac J. Manjarres" <isaacmanjarres@google.com>
To:     Catalin Marinas <catalin.marinas@arm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>
Cc:     linux-mm@kvack.org, Saravana Kannan <saravanak@google.com>,
        "Isaac J. Manjarres" <isaacmanjarres@google.com>,
        stable@vger.kernel.org, Calvin Zhang <calvinzhang.cool@gmail.com>,
        kernel-team@android.com, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This reverts commit 972fa3a7c17c9d60212e32ecc0205dc585b1e769.

Kmemleak operates by periodically scanning memory regions for pointers
to allocated memory blocks to determine if they are leaked or not.
However, reserved memory regions can be used for DMA transactions
between a device and a CPU, and thus, wouldn't contain pointers to
allocated memory blocks, making them inappropriate for kmemleak to
scan. Thus, revert this commit.

Cc: stable@vger.kernel.org # 5.17+
Cc: Calvin Zhang <calvinzhang.cool@gmail.com>
Signed-off-by: Isaac J. Manjarres <isaacmanjarres@google.com>
---
 drivers/of/fdt.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/of/fdt.c b/drivers/of/fdt.c
index f08b25195ae7..d1a68b6d03b3 100644
--- a/drivers/of/fdt.c
+++ b/drivers/of/fdt.c
@@ -26,7 +26,6 @@
 #include <linux/serial_core.h>
 #include <linux/sysfs.h>
 #include <linux/random.h>
-#include <linux/kmemleak.h>
 
 #include <asm/setup.h>  /* for COMMAND_LINE_SIZE */
 #include <asm/page.h>
@@ -525,12 +524,9 @@ static int __init __reserved_mem_reserve_reg(unsigned long node,
 		size = dt_mem_next_cell(dt_root_size_cells, &prop);
 
 		if (size &&
-		    early_init_dt_reserve_memory(base, size, nomap) == 0) {
+		    early_init_dt_reserve_memory(base, size, nomap) == 0)
 			pr_debug("Reserved memory: reserved region for node '%s': base %pa, size %lu MiB\n",
 				uname, &base, (unsigned long)(size / SZ_1M));
-			if (!nomap)
-				kmemleak_alloc_phys(base, size, 0);
-		}
 		else
 			pr_err("Reserved memory: failed to reserve memory for node '%s': base %pa, size %lu MiB\n",
 			       uname, &base, (unsigned long)(size / SZ_1M));
-- 
2.39.1.405.gd4c25cc71f-goog

