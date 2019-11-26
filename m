Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CBD04109F82
	for <lists+stable@lfdr.de>; Tue, 26 Nov 2019 14:48:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727816AbfKZNsw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Nov 2019 08:48:52 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:38867 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727795AbfKZNsw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Nov 2019 08:48:52 -0500
Received: by mail-wm1-f65.google.com with SMTP id z19so3396681wmk.3
        for <stable@vger.kernel.org>; Tue, 26 Nov 2019 05:48:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2Ne1zU2mmCseDmRbQxz1UNgNCwdBOPqdsfF2xdo9d4o=;
        b=OAPCfQN7zSBHP+VHpPRgZfPpWLc2a1MJyHfAaC7qO1GGgo6mhSNe/rAaWxY0NYqISv
         DNJnoedq21rENsuVFFMAkC9s6hRk00qIq/KpKCC0B1aa84PGNYe5nVWe2jwtE6zU6bUH
         FPS3UcQRk1yirb6d8w1KJ31zSBPfoaPCkJwBhlZnYA4fS8taU48V32Z2kZAvI9Gzoh5T
         p1mvaut3RkIEITrQggEWsqn6aWd8KgMfWOs1kg9p4OPVAjct9kFTSqO+TX9qRE52o3WE
         7rk6DRRL+Nrz1hMphW8MNdQMEyNmujxJTPaYEUGsruXUdZg5irx6pEOR3XjLD4UPZR/D
         eEsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2Ne1zU2mmCseDmRbQxz1UNgNCwdBOPqdsfF2xdo9d4o=;
        b=dEcSk0L5xgyrAwU1cJxRTooLLxOXKpBqwQRzE3rYi161IcJmQtAo3JFArhrHd3+iGc
         uMokYKt5bHILWeO1GsacpZIWldXFvkhMbySHymH5kkdYqmOUQ+BEcHQS0720RhPAQ9rb
         VJ/tV676SjJPplN3tlGnTXZpkX4GjgaLjDgWQUVa52nstievB64aIQgCLCdp9DA70K2C
         hD5JBbYrD6ipD+La0Xz/1CzA0C+6FhJcTFgf9DESoqBr1RPXHNez3q4yC0SFMh7Dqv39
         9NGskjZszivoko9NAui1dSW7bi32v3/bk7+sC2JdArKqATvV6fT+eM+RGTTK+22zi/pu
         CrvA==
X-Gm-Message-State: APjAAAWqihWw3VofpaFVtc1PgbX9seHrS9LHWwv9pI0YaMtdKyPI7UL+
        TpC8K0ff2dQarp7sub+XwEv+u2gEvYw=
X-Google-Smtp-Source: APXvYqwn44zlIurCMwIJ0SB4p4q2r/uSals4f6rHZdtw+4FHulqER5XJN9skLnyZiHSMYhhxJaWhlg==
X-Received: by 2002:a05:600c:290d:: with SMTP id i13mr4394524wmd.139.1574776129604;
        Tue, 26 Nov 2019 05:48:49 -0800 (PST)
Received: from localhost.localdomain ([95.149.164.72])
        by smtp.gmail.com with ESMTPSA id m9sm14374131wro.66.2019.11.26.05.48.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Nov 2019 05:48:49 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Subject: [PATCH 4.19 1/5] ARM: 8904/1: skip nomap memblocks while finding the lowmem/highmem boundary
Date:   Tue, 26 Nov 2019 13:48:26 +0000
Message-Id: <20191126134830.12747-1-lee.jones@linaro.org>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chester Lin <clin@suse.com>

[ Upstream commit 59f200ef45852141dd45847563bf8e4c11a48f3f ]

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

