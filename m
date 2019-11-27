Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1DE4B10AB11
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 08:22:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726496AbfK0HWV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 02:22:21 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:38200 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726470AbfK0HWV (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Nov 2019 02:22:21 -0500
Received: by mail-wm1-f67.google.com with SMTP id z19so6164356wmk.3
        for <stable@vger.kernel.org>; Tue, 26 Nov 2019 23:22:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=HKmKV2QnHf6L1Be1GDSF8wA+iVwfLA2DutY1g50TZSQ=;
        b=Jg5njij/oyiKokuTX0ohPbHSfU9jBIYmc/stO5Vcs4RAaz31O6VQje2pl3xgAAPTaV
         VSYlns4aPHRqAeDNv9lO4VkKXAdIgJEm2xD3/+PLfsMTmCXMm7cbbSDujG0TD7sAo/C9
         MQdRBupS2ZleKSa3ntXHDO9XWRCXYyrJbINRCMK8YZRYwRiAKQCAkLO5b+kUdQS6L1mz
         nyqkvCobjXHDmrw/1GB997iWS0bHbCISYKYOsJrBqUvtl92CFeGo42sXIOECIfj7v6k0
         0pbda73Rw8JKcsBsqV3AUcBQwcJNgTo0ygAfV0n6fouiNVNyJle3O+oCBEJ5KUNFjZYb
         ZDhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=HKmKV2QnHf6L1Be1GDSF8wA+iVwfLA2DutY1g50TZSQ=;
        b=gU7vIN6d7Z38sB+08Z8rVSZiNNt7keDtbf+jkNelaUkNnXnInQz0iQaLSZx7W4O2r0
         XsCxL9FUkRjKRf5MrcbDIM9it0oylN8QLxu4ncvTs0BfSZco4sU/hBxJupjtEKW/IB64
         EFlqhAf1c5FLLQ5+cKKHWlnelhX7dUQwjiI28MT7Cni7A2zA8zWwF+tdfv4T6blwcR+n
         HD54NgMcMqxAy25+kxWwPQj15GGjuYlRfeTgFLLP6evpyF/d2aoEUIiK1/g3r4uuvjwG
         1CYatQJygKZDl8yLwa5FSfd4P/bez0ZEg9JoZ1/D8xhZE7MT58tfohsEfLNgH2Cv/4GR
         dzNg==
X-Gm-Message-State: APjAAAUIxvRW4IdjsluCJfiCoNTEV4GC8mqxmmFlAX8BrD8TyXg4svCc
        dNf4zYtppNNzzyQENmb7Yvrzc03y7G4=
X-Google-Smtp-Source: APXvYqytGnyQj3AY7lJ9OWk177dxTrpH3agBJaX+zwgT9dKpi0ORFU8fyXJANi6lCX1k736ouQ/eZA==
X-Received: by 2002:a1c:8055:: with SMTP id b82mr2841390wmd.176.1574839337328;
        Tue, 26 Nov 2019 23:22:17 -0800 (PST)
Received: from localhost.localdomain ([95.149.164.101])
        by smtp.gmail.com with ESMTPSA id d20sm19406915wra.4.2019.11.26.23.22.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Nov 2019 23:22:16 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Subject: [PATCH 4.14 1/5] ARM: 8904/1: skip nomap memblocks while finding the lowmem/highmem boundary
Date:   Wed, 27 Nov 2019 07:21:58 +0000
Message-Id: <20191127072202.30625-1-lee.jones@linaro.org>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chester Lin <clin@suse.com>

[ Upstream commit 1d31999cf04c21709f72ceb17e65b54a401330da ]

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

