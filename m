Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4846910AB14
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 08:22:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726515AbfK0HW3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 02:22:29 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:54386 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726470AbfK0HW3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Nov 2019 02:22:29 -0500
Received: by mail-wm1-f68.google.com with SMTP id b11so5858694wmj.4
        for <stable@vger.kernel.org>; Tue, 26 Nov 2019 23:22:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=HKmKV2QnHf6L1Be1GDSF8wA+iVwfLA2DutY1g50TZSQ=;
        b=NBlVlsL97KGwwCAPQ7DAncBZNY0kxh+nt1m9SZ3ouwiA9cTnV4WQZvIEqNi4S6G12G
         U3OoSyyO0eXoLoaNz5ZdeCxjRsA8TWTZS22tg455uHWbXVKvfYIvunULQLVbPdbXWElO
         8XG20hKxle6bKhWPozxzo5PUgMy+QwJfYwL8QDWzm9J/1OaCh3xp8Z47cbYv0BfXrqOc
         QlN0IbMg4cskZDgVzli54sU7eMexwYRrqowUkine3lZCl8ErPc/pDmFtoJ2G/BLYnbDQ
         12rl+XRq1hukXfrJFtFdpPuAFsGRFNU1XepjK2/t/zNNlJ0dV3wXndkA6mE6r4sPp7fZ
         fPYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=HKmKV2QnHf6L1Be1GDSF8wA+iVwfLA2DutY1g50TZSQ=;
        b=r6HbwbX84hzlbpFjYRwvu/toi9MJNELVXgH0wi0wwA2mxrVYLwfGk4DkT0z5O3k0B+
         OsnRe9/SHkmOBpg+epmGwiUkme0nxO/hkL0/yJQ++2wfgcSRrkhtWkzclEMmOQG45ZH9
         1XQXjjpAmFhV2hyq3itfWNbdiF0zSyvtDydD+rh5D01cSgg5h/fOoeQ+dYrr9S7asBOg
         upA121JK8ZSARC1K6hUf2Ts3AZ59qciGE6N7zOMkMToDlvLK+awurxM90hUxh7q5WLOr
         78rz3qOCnmX/6DGLwsCP64o+dpf92flFxQNG7QJ+tKuN9QJL99WkngW2BetgLrk3vEZA
         tG7w==
X-Gm-Message-State: APjAAAV/w7fufguzTbpe3SiAmTJZ4ilN4RBwhmuLNuCjYZONtv30AxED
        UEXLYLFaPKFjaNz7743hOMW4dvbldlw=
X-Google-Smtp-Source: APXvYqw9iq7JdTs1DemHX/azd2GmeRDLwvfLxT58cenigi8f0fCS5Svzy8k3+OIvYpqctGeDNbxlTg==
X-Received: by 2002:a1c:7f94:: with SMTP id a142mr2644622wmd.33.1574839346273;
        Tue, 26 Nov 2019 23:22:26 -0800 (PST)
Received: from localhost.localdomain ([95.149.164.101])
        by smtp.gmail.com with ESMTPSA id c193sm5986641wma.8.2019.11.26.23.22.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Nov 2019 23:22:25 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Subject: [PATCH 4.19 1/3] ARM: 8904/1: skip nomap memblocks while finding the lowmem/highmem boundary
Date:   Wed, 27 Nov 2019 07:22:08 +0000
Message-Id: <20191127072210.30715-1-lee.jones@linaro.org>
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

