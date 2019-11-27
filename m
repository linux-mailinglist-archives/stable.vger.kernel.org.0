Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B8CCC10AB18
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 08:22:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726514AbfK0HWi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 02:22:38 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:36377 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726520AbfK0HWi (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Nov 2019 02:22:38 -0500
Received: by mail-wr1-f65.google.com with SMTP id z3so25354654wru.3
        for <stable@vger.kernel.org>; Tue, 26 Nov 2019 23:22:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xBQD+e/TnUVrvhwSCfQXht9+xwZCKiD7itNG4fU+Fq0=;
        b=q2LM0NffHubfSWw1G9gXOM0FNLRtUcGxzKhp1N835dGtdhcC+O+N1Zsz90o4lMarTU
         dCykHEH9WgJlSoEHtKE/nimF1IOe+PVKjE35o8i3pnFNBfde0DmIfTARU20USPtwVXV9
         BS5gNcVC5BkaoSwKXvStvSzA+IPQHgiqfzR/5Qh04ppfWA9WXuJ+nAmue2gN6V9iUJJn
         fmCypmSYoRYugx5K2UNJVFyh7zlyiFCVgN3BWglMUd+W1FWersq64ki/m3R9XkMHpqCx
         MgTXM5HvmIr/UVVJC29PFeIMHslGRFdm7PvJbGY1AhDtlB0iLcd96QtV3RfEg8UVun3g
         kGUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xBQD+e/TnUVrvhwSCfQXht9+xwZCKiD7itNG4fU+Fq0=;
        b=P8Jn5mgK8pqSDw5hj0E2/+tkwFZ8LhQfuZSj75GR8lgPPogsmhRo9dhCnIseBkysVH
         tta/3VDYES5k6tKAytFnzPmv1EDf46TOrY7vrcZKdVltY37BtR9c4qFj7wzUIN+0E8Ge
         OS+BlgBep44RmeTPzV/Nni/dIzfeqVmc3yFwrlaWIR6yA3aNzbJyuY+tXxJULd2xlgRe
         xUy/aYJwtUzKNV50gbCkfmbHA0KGPCOffT35dFqBgfw/PfBrZ3Ji1fQf24DKePwL5qRK
         IUU5zgtJ5QwQzvEHQq61Dipdb+QD06o8HJloegqXJIQVccZdtnnNBnd2XC67aj3mq6gb
         89+Q==
X-Gm-Message-State: APjAAAX1jqlBRNLcvq0RDVgA89og/RYwseV3pYYsQrGCcyfoB3xJSL7F
        riSaqwroYjz01kpwvueMu4+6OTofbj4=
X-Google-Smtp-Source: APXvYqz6sKZk26mQ+Hqm3rKVqltQmhDKlC/95HaXm9UbHpOfOutGxzxvzmgboA17+Scm0BSqM2pkwA==
X-Received: by 2002:adf:f20f:: with SMTP id p15mr38364653wro.370.1574839354216;
        Tue, 26 Nov 2019 23:22:34 -0800 (PST)
Received: from localhost.localdomain ([95.149.164.101])
        by smtp.gmail.com with ESMTPSA id g21sm19605289wrb.48.2019.11.26.23.22.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Nov 2019 23:22:33 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Subject: [PATCH 5.3 1/2] ARM: 8904/1: skip nomap memblocks while finding the lowmem/highmem boundary
Date:   Wed, 27 Nov 2019 07:22:18 +0000
Message-Id: <20191127072219.30798-1-lee.jones@linaro.org>
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
index d5e0b908f0ba..25da9b2d9610 100644
--- a/arch/arm/mm/mmu.c
+++ b/arch/arm/mm/mmu.c
@@ -1197,6 +1197,9 @@ void __init adjust_lowmem_bounds(void)
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

