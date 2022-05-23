Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35D92531231
	for <lists+stable@lfdr.de>; Mon, 23 May 2022 18:22:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237101AbiEWO3E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 May 2022 10:29:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237018AbiEWO3D (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 May 2022 10:29:03 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFE30245B3
        for <stable@vger.kernel.org>; Mon, 23 May 2022 07:29:01 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id jx22so15762071ejb.12
        for <stable@vger.kernel.org>; Mon, 23 May 2022 07:29:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=malat-biz.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=gGEKaRL/00sKBHtj1hUxzGszVFwNUoCR3h2OByy1v5w=;
        b=PgJUjLKHURCjSmk42QVyCWSoJV+H0m1LxJrjAUL0xPQDH4TJf0WL0ZA3QxF5I/uF0k
         nycCZr7WbpmWu/RMHE8ogPHz1IyBBlBVJU/aLemja4FM8ucSIyoyFM7n08Z53rvsXisC
         jms5AJ+DvW/Qu8ar+YJ5rrsUllkOU4rD5K/pIakn+NRqFwrVBSxdXuIA+wRfE5qwgq/M
         dFUt3IdchFnQkqhWPCA5pwjyKdHOhi1Ez+9VgX3sxzHm+6imr9osUJx44mNaFjQG9hl9
         /xQNbjvxc329bSIOyqI1tsE0zOoiZd7dV5XNpMbJ9zsZy+F+KAxIwVzRH8h62UIxF1HF
         ARaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=gGEKaRL/00sKBHtj1hUxzGszVFwNUoCR3h2OByy1v5w=;
        b=nSLq7+vomRzACY07AmKWiGNn8NqVo8+HHkiHUnLhF3TEYRCOep8ykXUzvGBMWAP75J
         kVnVcseKe5MSh1fI87r3yKpYD8y0KecICZ5NWAUM7BEBA8h2Mdj73r7H0LQ/DP8L6CjH
         lfFYttPzF9hBEgM6AdLJr+iE7FCSH1sZ/yofZhxFCafHNuuOvsNt3YkvJIElYdgTgOQH
         eBuxCVW8wtcQcNzzTJcQ0xqoWcmGKtH0PR4T7iNQb/0P37lZO6fDYKW72j4CYU50ZLWQ
         0r4TYe7OVVo/Yax6iC+ezDAuJ3gxCKXj6OygMwHMOuE9EaprpVN65ZVpsX6t+xvJg/GJ
         fK2w==
X-Gm-Message-State: AOAM533Ot9CA8jz3eNEjf77g3xqOAvX0Hzc39wHXFtOAt9yL8fwD4xKX
        s6nO2S3iFBVkCDLj7QXeRNX/eA==
X-Google-Smtp-Source: ABdhPJxlgmV9DSbvu2Zh5aV26tUxOqNApPjJGp419HhV0pXpmzudNbsAML6QDeYwa8iixqwMPHQt8A==
X-Received: by 2002:a17:907:7ea2:b0:6fe:d945:7fe with SMTP id qb34-20020a1709077ea200b006fed94507femr1026528ejc.228.1653316140469;
        Mon, 23 May 2022 07:29:00 -0700 (PDT)
Received: from ntb.petris.klfree.czf ([2a02:8070:d483:ed00:4bcc:154f:5c11:5870])
        by smtp.googlemail.com with ESMTPSA id i2-20020aa7c702000000b0042617ba6380sm8252640edq.10.2022.05.23.07.28.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 May 2022 07:28:59 -0700 (PDT)
From:   Petr Malat <oss@malat.biz>
To:     linux-mtd@lists.infradead.org
Cc:     Joern Engel <joern@lazybastard.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Petr Malat <oss@malat.biz>
Subject: [PATCH] mtd: phram: Map RAM using memremap instead of ioremap
Date:   Mon, 23 May 2022 16:28:25 +0200
Message-Id: <20220523142825.3144904-1-oss@malat.biz>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

One can't use memcpy on memory obtained by ioremap, because IO memory
may have different alignment and size access restriction than the system
memory. Use memremap as phram driver operates on RAM.

This fixes an unaligned access on ARM64, which could be triggered with
e.g. dd if=/dev/phram/by-name/testdev bs=8190 count=1

   Unable to handle kernel paging request at virtual address ffffffc01208bfbf
   Mem abort info:
     ESR = 0x96000021
     EC = 0x25: DABT (current EL), IL = 32 bits
     SET = 0, FnV = 0
     EA = 0, S1PTW = 0
   Data abort info:
     ISV = 0, ISS = 0x00000021
     CM = 0, WnR = 0
   swapper pgtable: 4k pages, 39-bit VAs, pgdp=0000000000cd5000
   [ffffffc01208bfbf] pgd=00000002fffff003, p4d=00000002fffff003, pud=00000002fffff003, pmd=0000000100b43003, pte=0068000022221717
   Internal error: Oops: 96000021 [#1] PREEMPT SMP
   CPU: 2 PID: 14768 Comm: dd Tainted: G           O      5.10.116-f13ddced70 #1
   Hardware name: AXM56xx Victoria (DT)
   pstate: 80000005 (Nzcv daif -PAN -UAO -TCO BTYPE=--)
   pc : __memcpy+0x168/0x230
   lr : phram_read+0x68/0xb0 [phram]
   sp : ffffffc0138f3bd0
   x29: ffffffc0138f3bd0 x28: 0000000034a50090
   x27: 0000000000000000 x26: ffffff81176ce000
   x25: 0000000000000000 x24: 0000000000000000
   x23: ffffffc0138f3cb8 x22: ffffff8109475000
   x21: 0000000000000000 x20: ffffff81176ce000
   x19: 0000000000001fff x18: 0000000000000020
   x17: 0000000000000000 x16: 0000000000000000
   x15: ffffff8125861410 x14: 0000000000000000
   x13: 0000000000000000 x12: 0000000000000000
   x11: 0000000000000000 x10: 0000000000000000
   x9 : 0000000000000000 x8 : 0000000000000000
   x7 : 0000000000000000 x6 : 0000000000000000
   x5 : ffffff81176cffff x4 : ffffffc01208bfff
   x3 : ffffff81176cff80 x2 : ffffffffffffffef
   x1 : ffffffc01208bfc0 x0 : ffffff81176ce000
   Call trace:
    __memcpy+0x168/0x230
    mtd_read_oob_std+0x80/0x90
    mtd_read_oob+0x8c/0x150
    mtd_read+0x54/0x80
    mtdchar_read+0xdc/0x2c0
    vfs_read+0xb8/0x1e4
    ksys_read+0x78/0x10c
    __arm64_sys_read+0x28/0x34
    do_el0_svc+0x94/0x1f0
    el0_svc+0x20/0x30
    el0_sync_handler+0x1a4/0x1c0
    el0_sync+0x180/0x1c0
   Code: a984346c a9c4342c f1010042 54fffee8 (a97c3c8e)
   ---[ end trace 5707221d643416b6 ]---

Signed-off-by: Petr Malat <oss@malat.biz>
---
 drivers/mtd/devices/phram.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/mtd/devices/phram.c b/drivers/mtd/devices/phram.c
index d503821a3e60..25d3674b4e51 100644
--- a/drivers/mtd/devices/phram.c
+++ b/drivers/mtd/devices/phram.c
@@ -83,7 +83,7 @@ static void unregister_devices(void)
 
 	list_for_each_entry_safe(this, safe, &phram_list, list) {
 		mtd_device_unregister(&this->mtd);
-		iounmap(this->mtd.priv);
+		memunmap(this->mtd.priv);
 		kfree(this->mtd.name);
 		kfree(this);
 	}
@@ -99,9 +99,9 @@ static int register_device(char *name, phys_addr_t start, size_t len, uint32_t e
 		goto out0;
 
 	ret = -EIO;
-	new->mtd.priv = ioremap(start, len);
+	new->mtd.priv = memremap(start, len, MEMREMAP_WB);
 	if (!new->mtd.priv) {
-		pr_err("ioremap failed\n");
+		pr_err("memremap failed\n");
 		goto out1;
 	}
 
@@ -129,7 +129,7 @@ static int register_device(char *name, phys_addr_t start, size_t len, uint32_t e
 	return 0;
 
 out2:
-	iounmap(new->mtd.priv);
+	memunmap(new->mtd.priv);
 out1:
 	kfree(new);
 out0:
-- 
2.30.2

