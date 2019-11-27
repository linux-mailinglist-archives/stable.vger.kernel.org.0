Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 15AB910AB09
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 08:22:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726426AbfK0HWG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 02:22:06 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:45865 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726373AbfK0HWG (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Nov 2019 02:22:06 -0500
Received: by mail-wr1-f66.google.com with SMTP id z10so25275799wrs.12
        for <stable@vger.kernel.org>; Tue, 26 Nov 2019 23:22:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=UWRbO2P7g4EPCMmLRyVjfEAuVW+/g1Ubr25lGtwVdcY=;
        b=PkBawT7ckvErv66yavO79Cb2B9m+9s8C+5vgtgN7tImRaIt8Sk6Y6hKdUjFaM45u8o
         PCLwrOlT4IzF/g2foIHl7ECmt0WEtQR12j2P+R4ac515t02D762zZ13ZX+QeI4QwIlVh
         2AxlFEXW9qV2cQ3q9Xf3emNwP4oy5IqoIVhFjskKTpMeyPPbFEFDc/+ugb6cIDxI/pDo
         uJ5pJHEtWVD+jVhZZX/YL9IHtTEWtvUTsRyxpGpvbtlgqZN4WxOmR/etCG89B+Sxde4t
         DXAmKZJj0C5KsfvtaRvq+MvWhvcU0BsR8e1I3aql67CeGOTaJNJG8YCL5jXhOfklHF2y
         MbhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=UWRbO2P7g4EPCMmLRyVjfEAuVW+/g1Ubr25lGtwVdcY=;
        b=n7YqxdnfbFpWsDp4pUcT0fj5+yxxL6Gw+EHX3vEXv2C4oseepUfqqP1NPDrbY0QgGw
         seK5yRxPIdzAOrUtmUenBl5zvbNLeDVRQBws4w3gA8sEPG2iTiyY00508YqOtww6EdeR
         YIgXX3NpXGECbiydFsJABEb7DfGjOgnSbi1zjUjIU5DO0zk3qGZkQW5MKvvIUlaJMf8t
         5CUb2gHFtDIX4qT2IaMRbyUIziV+9MRTTy63PPEdvsXjrNHdGhG4TXxNNJ0Yg0sqxpe1
         MklppyyG/b5DInD5ZnBCsbI1QdUhYNWCpnAf7qLkpYrVjYHHLeFLnnw8hAnCqT/9ERz+
         RFvA==
X-Gm-Message-State: APjAAAWuKO0f+ulSSduMJppOc5ryvqAcWG5BrldOL+39lTfT4vaEDQaO
        dnO4nGwq0gcXTrBl2+M4Py/L5vqdKMk=
X-Google-Smtp-Source: APXvYqxfeJZuhbfxHGbO+JINjR6Ck8B03LxdHWzq8cTquoUhaYaQJ8rYxa4LR6YTTAQeMqU2ZXJe/A==
X-Received: by 2002:adf:eecc:: with SMTP id a12mr29427632wrp.363.1574839323938;
        Tue, 26 Nov 2019 23:22:03 -0800 (PST)
Received: from localhost.localdomain ([95.149.164.101])
        by smtp.gmail.com with ESMTPSA id e16sm17983130wrj.80.2019.11.26.23.22.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Nov 2019 23:22:03 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Subject: [PATCH 4.9 1/6] ARM: 8904/1: skip nomap memblocks while finding the lowmem/highmem boundary
Date:   Wed, 27 Nov 2019 07:21:39 +0000
Message-Id: <20191127072144.30537-1-lee.jones@linaro.org>
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

