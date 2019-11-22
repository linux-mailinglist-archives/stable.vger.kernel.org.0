Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8464E106F48
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 12:14:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727389AbfKVLOm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 06:14:42 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:44833 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730198AbfKVKxZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 22 Nov 2019 05:53:25 -0500
Received: by mail-wr1-f67.google.com with SMTP id i12so8000613wrn.11
        for <stable@vger.kernel.org>; Fri, 22 Nov 2019 02:53:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=UWRbO2P7g4EPCMmLRyVjfEAuVW+/g1Ubr25lGtwVdcY=;
        b=Cai/XqnFpfDfQNxuq4Sbc1zSdxUypMQRCg4hK26gmubGgp0tJKrZSKUovvrpcPVnQK
         /XcE6XLsXVZD8qyArZ4RgEHlpfbHIGmx13F3sJAIcK/6/LUWiUObUIW0Re1E4APtCPCq
         N2hbyupaOgnPTYaF1oZhdoQXVORkMUgs2HWW15gxbwLHT20U9I6Cyz3DT3Zdhl8479lO
         quDQPUxr8r69FRA5xKzbO5Dg2fAedLiL7hQpNf+4Y4GuJ4MF2VcwRDpycaidVZyYfSyv
         Xi4GHuMn7psL6twuTrwj62S5zIDtNMX+l9yrNaGSDZpsJHaI9Id12DO9IdJWldA7rYLe
         5a5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=UWRbO2P7g4EPCMmLRyVjfEAuVW+/g1Ubr25lGtwVdcY=;
        b=Gsieg1NXivPxa30U+uoR537GUfJDaevaZRPl4bg+mwISuY2mzeWqK8oFrpNOH4nAbG
         NrxnE8Qq12vSOazXuNC/qT5mxMF9MG3t9lDEl3VXlwb0PjpvAPRUhwzJAI6/dhIkt/F/
         v6BeyP7/gDDXYt8i5S/rKUCJ8EaZshQBppxDjwbEB+TK3WdR/xYt+jdhqTcMZIi4V3y4
         K+fqu8uXGjI8z3/23xTcqi4JoZbJNktJNvoClUVB9Ste5xRxHEeVutIssqNefV78RBgf
         4XkTfyC6j5IG5xgjuvvU7eSKoWgXNsQdGm9h7xj3p0d1BTwCLnQSu0r0py1DW11n92CZ
         DHiQ==
X-Gm-Message-State: APjAAAVKyOSevjjEQP7ZtEJMWqUq0FAEprfYUMjbllkvhrTq2Vu65prs
        1od0gBwK+6h7BV7Sn8TUrR8eaQ==
X-Google-Smtp-Source: APXvYqwLEZ5r5GiJwv7zZrNgf78uLKUED/yM5IA9IQFguRpYOptfdP65bQ1Bnv2YZtkFGntntzl+xw==
X-Received: by 2002:adf:da52:: with SMTP id r18mr17065698wrl.167.1574420002947;
        Fri, 22 Nov 2019 02:53:22 -0800 (PST)
Received: from localhost.localdomain ([2.27.35.135])
        by smtp.gmail.com with ESMTPSA id o1sm7444087wrs.50.2019.11.22.02.53.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Nov 2019 02:53:22 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org, gregkh@google.com, stable@vger.kernel.org
Subject: [PATCH 4.9 1/8] ARM: 8904/1: skip nomap memblocks while finding the lowmem/highmem boundary
Date:   Fri, 22 Nov 2019 10:52:46 +0000
Message-Id: <20191122105253.11375-1-lee.jones@linaro.org>
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
index 241bf898adf5..7edc6c3f4bd9 100644
--- a/arch/arm/mm/mmu.c
+++ b/arch/arm/mm/mmu.c
@@ -1188,6 +1188,9 @@ void __init adjust_lowmem_bounds(void)
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

