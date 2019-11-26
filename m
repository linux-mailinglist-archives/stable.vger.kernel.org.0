Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A9A06109F7F
	for <lists+stable@lfdr.de>; Tue, 26 Nov 2019 14:48:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727797AbfKZNsE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Nov 2019 08:48:04 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:38039 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727783AbfKZNsE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Nov 2019 08:48:04 -0500
Received: by mail-wr1-f66.google.com with SMTP id i12so22599057wro.5
        for <stable@vger.kernel.org>; Tue, 26 Nov 2019 05:48:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=VAZCmvkt/DJ7QzgF3Z9hhn7Kok0+5MUn19Cy2Exwb/8=;
        b=uXZ9+msVzOgoEnkCOVRAAEtSHQd82VloBFMw50OGjZTTc/g2p3KVfeDddK0Xt7BlZZ
         gK7mQF1El3IvvRKFzbLbdY+FDBjKwDEF10QZLOrJF7V8OSUaIF2SagOfc0NJBQbasGfj
         VTxJkDnTnr6A0ixdewZJJNX9FjCPIKkABikqD9QI/MzgP6L+FrmYwnkJlKfmNJaVRvfI
         P5TIrqPz1eeLADwth9z09bjCFDHOV/jSd92Xf6QvBKgORkUMKeERkJrsVK3YoZ/XjwGZ
         +ZSdb/9L8pxKqSaDU8y6+/Hf9VI0jLmzbzGGtRIFRoGnLEP6P1qB5MT7si8Dw3E68qzi
         KAwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=VAZCmvkt/DJ7QzgF3Z9hhn7Kok0+5MUn19Cy2Exwb/8=;
        b=lVMNVwbBor7eDPTXJEA7IXej4T3RZju3YoRbSRzim2stjR+XoEpCS6d58zFy2mm3oZ
         4Pb5l8cEcyuywQi5R/XOgI19+8BBHszQuVM/HooMkQk8wSeMzEzuN0GWNCjPhvLZ0MZS
         PSOXN9JEspDxPJNbOzJVGyx/zRb0mN+3F73nQSyUGKgUl79kN5uapko6L0pWnRhsUzp5
         six0u7AhbxvydvTkqnDBf2aMKd6nlDZ2khODfTbTqT2uFsc/t6z3id59WD5RMmrXO5Lq
         9BbwpRCiLtBViceSkj1yBGBJT5wzU5rwKgMdJxqhhGl41dhtY4Jo78s+idsegm/0KaVb
         skng==
X-Gm-Message-State: APjAAAWJUBJUpZ3G1uk5GiwCfQ+YYPOtP+AZkS3SYuAVeZHaRZb9WAHh
        vrxZm4MBHF0RrijnORUsMvZafQEssxM=
X-Google-Smtp-Source: APXvYqyBcx0z2Cl2rK90v0ycED87NwQTTk8VV389ZeevALYTllKzlKyc9gfUGziuHfs4DH8z39SvoQ==
X-Received: by 2002:adf:8426:: with SMTP id 35mr36750725wrf.262.1574776082123;
        Tue, 26 Nov 2019 05:48:02 -0800 (PST)
Received: from localhost.localdomain ([95.149.164.72])
        by smtp.gmail.com with ESMTPSA id o1sm15085560wrs.50.2019.11.26.05.48.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Nov 2019 05:48:01 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Subject: [PATCH 4.19 1/3] ARM: 8904/1: skip nomap memblocks while finding the lowmem/highmem boundary
Date:   Tue, 26 Nov 2019 13:47:39 +0000
Message-Id: <20191126134741.12629-1-lee.jones@linaro.org>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chester Lin <clin@suse.com>

[ Upstream commit 52e0019ee21351aef28ea1dd6037254580e0c56a ]

adjust_lowmem_bounds() checks every memblocks in order to find the boundary
between lowmem and highmem. However some memblocks could be marked as NOMAP
so they are not used by kernel, which should be skipped while calculating
the boundary.

Signed-off-by: Chester Lin <clin@suse.com>
Reviewed-by: Mike Rapoport <rppt@linux.ibm.com>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/mm/mmu.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm/mm/mmu.c b/arch/arm/mm/mmu.c
index 70e560cf8ca0..d8cbe772f690 100644
--- a/arch/arm/mm/mmu.c
+++ b/arch/arm/mm/mmu.c
@@ -1195,6 +1195,9 @@ void __init adjust_lowmem_bounds(void)
 		phys_addr_t block_start = reg->base;
 		phys_addr_t block_end = reg->base + reg->size;
 
+		if (memblock_is_nomap(reg))
+			continue;
+
 		if (reg->base < vmalloc_limit) {
 			if (block_end > lowmem_limit)
 				/*
-- 
2.24.0

