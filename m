Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C73D1E52BB
	for <lists+stable@lfdr.de>; Thu, 28 May 2020 03:13:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726308AbgE1BNP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 May 2020 21:13:15 -0400
Received: from mail.loongson.cn ([114.242.206.163]:41510 "EHLO loongson.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725850AbgE1BNO (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 May 2020 21:13:14 -0400
Received: from localhost.localdomain (unknown [114.242.249.80])
        by mail.loongson.cn (Coremail) with SMTP id AQAAf9Axb+iSD89eyec5AA--.806S2;
        Thu, 28 May 2020 09:10:50 +0800 (CST)
From:   Lichao Liu <liulichao@loongson.cn>
To:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc:     Paul Burton <paulburton@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Max Filippov <jcmvbkbc@gmail.com>,
        Lichao Liu <liulichao@loongson.cn>, jiaxun.yang@flygoat.com,
        yuanjunqing@loongson.cn, linux-mips@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH] MIPS: CPU_LOONGSON2EF need software to maintain cache consistency
Date:   Thu, 28 May 2020 09:10:31 +0800
Message-Id: <20200528011031.30472-1-liulichao@loongson.cn>
X-Mailer: git-send-email 2.17.1
X-CM-TRANSID: AQAAf9Axb+iSD89eyec5AA--.806S2
X-Coremail-Antispam: 1UD129KBjvdXoWrur1fCw43GF15Gr17Xw1kXwb_yoW3GFbEkr
        srK34fWrs5ZFWUXFykJrs5GFyUXayDu347AF1DKF1YkFy5Zw4rGay7JFZ7Jr1UuFs09rWf
        t3ZxXrWkCwn2qjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUIcSsGvfJTRUUUbxkFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
        6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
        A2z4x0Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Cr0_
        Gr1UM28EF7xvwVC2z280aVAFwI0_Gr0_Cr1l84ACjcxK6I8E87Iv6xkF7I0E14v26r4UJV
        WxJr1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
        2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
        W8JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2
        Y2ka0xkIwI1l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4
        xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43
        MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I
        0E14v26r1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWrZr1j6s0DMIIF0xvEx4A2jsIE14v2
        6r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Jr0_GrUvcSsGvfC2KfnxnUUI43ZEXa7VUb
        XdbUUUUUU==
X-CM-SenderInfo: xolxzxpfkd0qxorr0wxvrqhubq/
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

CPU_LOONGSON2EF need software to maintain cache consistency,
so modify the 'cpu_needs_post_dma_flush' function to return true
when the cpu type is CPU_LOONGSON2EF.

Cc: stable@vger.kernel.org
Signed-off-by: Lichao Liu <liulichao@loongson.cn>
---
 arch/mips/mm/dma-noncoherent.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/mips/mm/dma-noncoherent.c b/arch/mips/mm/dma-noncoherent.c
index fcea92d95d86..563c2c0d0c81 100644
--- a/arch/mips/mm/dma-noncoherent.c
+++ b/arch/mips/mm/dma-noncoherent.c
@@ -33,6 +33,7 @@ static inline bool cpu_needs_post_dma_flush(void)
 	case CPU_R10000:
 	case CPU_R12000:
 	case CPU_BMIPS5000:
+	case CPU_LOONGSON2EF:
 		return true;
 	default:
 		/*
-- 
2.17.1

