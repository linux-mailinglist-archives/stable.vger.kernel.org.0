Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2FBF3E48AA
	for <lists+stable@lfdr.de>; Fri, 25 Oct 2019 12:39:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392716AbfJYKjY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Oct 2019 06:39:24 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:39913 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730471AbfJYKjY (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Oct 2019 06:39:24 -0400
Received: by mail-wr1-f66.google.com with SMTP id a11so1745875wra.6;
        Fri, 25 Oct 2019 03:39:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=PtQ7iKBOjIp+6P2TmNBw9I9BcPp4QMJns+61i+/Kf5o=;
        b=o7iftBGrBtSNn2PsfezokBwyzgAaNHGlxwSf5/9jV1mSQlIQsKljEEag3Jgs/DapYu
         zw7cHo2n7MFpzE85Ey273ajAMe4pf2OXcbskMS7HjRSRR64Sf+lU9XegygmYet3d8J1G
         6ozH3uTwfmWmY7pkO6+JzYLWdJeutS9rpeie2dQiLX64JDGtHgam5Uv/QKcuijf7ZSMB
         qIOF74BqDywoiVOMdDQoweqw1uj/MBed7yrPY468zqoq566IVXVO+1PugoP/Un57xsui
         YPXJuEz6t5vsndIOilfoaRAzYDkH2RWd0uw8iWzgIazOgoMwaUu711yOC0ZqA54jPwi3
         ROpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=PtQ7iKBOjIp+6P2TmNBw9I9BcPp4QMJns+61i+/Kf5o=;
        b=hZ6Bc/T4TUagUh3XvPkI5u0pnv37Wo5FD+gHALdfU+Z4JRf1yTjQCv31dY94cn45Rz
         DeHTIeBQZpMj3uloBFM7xKhScZ3gEoKyGPtOhX9I+LyZAogkoWSEv95XG7smmdi2kZkq
         32kpfCKZ3+Zk9ba9HrRzCcU4mPRAJOsiDttIAcOlyz+1hMl+szAdiqdwTo+NeOvQIo6/
         FBOi3inn9FNeJJFWA30FWMoUHwHrpJTHZZUinILMXmN3gpEA2ihvMY/ANO6ZWrSXev5S
         TKAi7qRB/RExCR03E06YsITwRiIj9xkAmL4ec0NszFUS1+tGiGKhi8SC+RFrF/1VlfGW
         4WWw==
X-Gm-Message-State: APjAAAVuy8gdUvU53V3s6/a1uVi6L7nZCc40YH9AnMPm6v6oFtHP1ArV
        scendpRur5pF9OSRKiARnbIuxOw9x9eweQ==
X-Google-Smtp-Source: APXvYqzYkw06+l9sVbGGG3YhwRZg8Z/cr+2Dp4dMIkffp+pFpQf6FvZHRKoxqJxyBaZXQanoY1QSEA==
X-Received: by 2002:adf:f78f:: with SMTP id q15mr2287028wrp.282.1571999959376;
        Fri, 25 Oct 2019 03:39:19 -0700 (PDT)
Received: from localhost.localdomain ([62.178.82.229])
        by smtp.gmail.com with ESMTPSA id c21sm1682926wmb.46.2019.10.25.03.39.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Oct 2019 03:39:18 -0700 (PDT)
From:   Christian Gmeiner <christian.gmeiner@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     Christian Gmeiner <christian.gmeiner@gmail.com>,
        stable@vger.kernel.org, Lucas Stach <l.stach@pengutronix.de>,
        Russell King <linux+etnaviv@armlinux.org.uk>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>, etnaviv@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH] etnaviv: fix dumping of iommuv2
Date:   Fri, 25 Oct 2019 12:39:10 +0200
Message-Id: <20191025103919.128171-1-christian.gmeiner@gmail.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

etnaviv_iommuv2_dump_size(..) returns the number of PTE * SZ_4K but etnaviv_iommuv2_dump(..)
increments buf pointer even if there is no PTE. This results in a bad buf pointer which gets
used for memcpy(..).

[  264.408474] 8<--- cut here ---
[  264.412048] Unable to handle kernel paging request at virtual address f1a2c268
[  264.419321] pgd = e5846004
[  264.422069] [f1a2c268] *pgd=00000000
[  264.425702] Internal error: Oops: 805 [#1] SMP ARM
[  264.430520] Modules linked in:
[  264.433616] CPU: 2 PID: 130 Comm: kworker/2:2 Tainted: G        W         5.4.0-rc4 #10
[  264.441643] Hardware name: Freescale i.MX6 Quad/DualLite (Device Tree)
[  264.448227] Workqueue: events drm_sched_job_timedout
[  264.453237] PC is at memcpy+0x50/0x330
[  264.457012] LR is at 0x2
[  264.459572] pc : [<c0c04650>]    lr : [<00000002>]    psr: 200f0013
[  264.465863] sp : ec96fe64  ip : 00000002  fp : 00000140
[  264.471112] r10: 00003000  r9 : ec688040  r8 : 00000002
[  264.476364] r7 : 00000002  r6 : 00000002  r5 : 00000002  r4 : 00000002
[  264.482917] r3 : 00000002  r2 : 00000f60  r1 : f162a020  r0 : f1a2c268
[  264.489472] Flags: nzCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment none
[  264.496635] Control: 10c5387d  Table: 3d26804a  DAC: 00000051
[  264.502407] Process kworker/2:2 (pid: 130, stack limit = 0xe8f69f3d)
[  264.508786] Stack: (0xec96fe64 to 0xec970000)
[  264.513180] fe60:          f1622000 f162218c f162c000 414e5445 f1a2c268 00000ffc c0655a8c
[  264.521394] fe80: 00000000 0000012a f162c268 c064fd78 c0657350 c0187f64 00000001 00000000
[  264.529606] fea0: ed0f9c00 00000001 00000002 435d587d ec688140 ec688100 ed0f9c00 ec688040
[  264.537818] fec0: ed0f9c00 c1308b28 ec96ff1c c13e55b0 c13e41c8 c0657358 ec688260 ed0f9c18
[  264.546029] fee0: ec688100 c0641278 ec688260 ec2f6180 ee1ba700 ee1bda00 c1308b28 c0149b98
[  264.554240] ff00: 00000001 00000000 c0149ae4 c0c21fb0 00000000 00000000 c014a194 c1a4be34
[  264.562452] ff20: c1870740 00000000 c1015384 435d587d ffffe000 ec2f6180 ec2f6194 ee1ba700
[  264.570663] ff40: 00000008 ee1ba734 c1305900 ee1ba700 ffffe000 c014a0e4 ec9537a4 c0c28e64
[  264.578874] ff60: ec96e000 00000000 ec2be780 ec2f99c0 ec96e000 ec2f6180 c014a0b8 ec13fe90
[  264.587086] ff80: ec2be7b8 c0152890 ec96e000 ec2f99c0 c0152750 00000000 00000000 00000000
[  264.595296] ffa0: 00000000 00000000 00000000 c01010b4 00000000 00000000 00000000 00000000
[  264.603506] ffc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
[  264.611716] ffe0: 00000000 00000000 00000000 00000000 00000013 00000000 00000000 00000000
[  264.619944] [<c0c04650>] (memcpy) from [<c0655a8c>] (etnaviv_iommuv2_dump+0x58/0x60)
[  264.627738] [<c0655a8c>] (etnaviv_iommuv2_dump) from [<c064fd78>] (etnaviv_core_dump+0x140/0x45c)
[  264.636658] [<c064fd78>] (etnaviv_core_dump) from [<c0657358>] (etnaviv_sched_timedout_job+0x8c/0xb8)
[  264.645923] [<c0657358>] (etnaviv_sched_timedout_job) from [<c0641278>] (drm_sched_job_timedout+0x38/0x88)
[  264.655631] [<c0641278>] (drm_sched_job_timedout) from [<c0149b98>] (process_one_work+0x2c4/0x7e4)
[  264.664633] [<c0149b98>] (process_one_work) from [<c014a0e4>] (worker_thread+0x2c/0x59c)
[  264.672765] [<c014a0e4>] (worker_thread) from [<c0152890>] (kthread+0x140/0x158)
[  264.680200] [<c0152890>] (kthread) from [<c01010b4>] (ret_from_fork+0x14/0x20)
[  264.687448] Exception stack(0xec96ffb0 to 0xec96fff8)
[  264.692530] ffa0:                                     00000000 00000000 00000000 00000000
[  264.700741] ffc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
[  264.708949] ffe0: 00000000 00000000 00000000 00000000 00000013 00000000
[  264.715599] Code: f5d1f05c f5d1f07c e8b151f8 e2522020 (e8a051f8)
[  264.721727] ---[ end trace 8afcd79e9e2725b3 ]---

Fixes: afb7b3b1deb4 ("drm/etnaviv: implement IOMMUv2 translation")
Cc: stable@vger.kernel.org
Signed-off-by: Christian Gmeiner <christian.gmeiner@gmail.com>
---
 drivers/gpu/drm/etnaviv/etnaviv_iommu_v2.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/etnaviv/etnaviv_iommu_v2.c b/drivers/gpu/drm/etnaviv/etnaviv_iommu_v2.c
index 043111a1d60c..f8bf488e9d71 100644
--- a/drivers/gpu/drm/etnaviv/etnaviv_iommu_v2.c
+++ b/drivers/gpu/drm/etnaviv/etnaviv_iommu_v2.c
@@ -155,9 +155,11 @@ static void etnaviv_iommuv2_dump(struct etnaviv_iommu_context *context, void *bu
 
 	memcpy(buf, v2_context->mtlb_cpu, SZ_4K);
 	buf += SZ_4K;
-	for (i = 0; i < MMUv2_MAX_STLB_ENTRIES; i++, buf += SZ_4K)
-		if (v2_context->mtlb_cpu[i] & MMUv2_PTE_PRESENT)
+	for (i = 0; i < MMUv2_MAX_STLB_ENTRIES; i++)
+		if (v2_context->mtlb_cpu[i] & MMUv2_PTE_PRESENT) {
 			memcpy(buf, v2_context->stlb_cpu[i], SZ_4K);
+			buf += SZ_4K;
+		}
 }
 
 static void etnaviv_iommuv2_restore_nonsec(struct etnaviv_gpu *gpu,
-- 
2.23.0

