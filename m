Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E19B2439CB5
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 19:03:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234336AbhJYRF0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 13:05:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:56282 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234559AbhJYRDd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 13:03:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1BEBE6108B;
        Mon, 25 Oct 2021 17:01:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635181262;
        bh=d4GjubSI5FvHm9L9ONnj5WKmwCv3od+nXjxOfix8DNY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ACCc1Cvts8R7Ifl/QwkRfdgvI+xxEoqRhZJjVG8JUmRO0LA89c2cTWIG8c5dKQ/bc
         n4q8klRbGqisOH4U7CJgcljlaZYcjVl9QDN/WhDRhHQxQkesQPM9DPnTLzIjqRBEA5
         nmDi2P8o5LunQiGTRxjZEED8syFO5AbjRkALwcJtM392Io8nELJEAPoJDr/vT4eR1s
         8tMZ9HXy5utzFL/tWaEbRWCc+3s48QRLQkm7z9KZNr4mLu66tBRlyhYZzcItnTVDmm
         Fq9Iy2OO+p7U/ji3Tb+dXS58yRe0mWaJYfSkX54ciS1O09flo1JG3HdxMv5Nw90fU3
         kaQLbqZJH2zDg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Arnd Bergmann <arnd@arndb.de>, Wei Liu <wei.liu@kernel.org>,
        Sasha Levin <sashal@kernel.org>, kys@microsoft.com,
        haiyangz@microsoft.com, sthemmin@microsoft.com,
        decui@microsoft.com, linux-hyperv@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 9/9] hyperv/vmbus: include linux/bitops.h
Date:   Mon, 25 Oct 2021 13:00:48 -0400
Message-Id: <20211025170048.1394542-9-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211025170048.1394542-1-sashal@kernel.org>
References: <20211025170048.1394542-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 8017c99680fa65e1e8d999df1583de476a187830 ]

On arm64 randconfig builds, hyperv sometimes fails with this
error:

In file included from drivers/hv/hv_trace.c:3:
In file included from drivers/hv/hyperv_vmbus.h:16:
In file included from arch/arm64/include/asm/sync_bitops.h:5:
arch/arm64/include/asm/bitops.h:11:2: error: only <linux/bitops.h> can be included directly
In file included from include/asm-generic/bitops/hweight.h:5:
include/asm-generic/bitops/arch_hweight.h:9:9: error: implicit declaration of function '__sw_hweight32' [-Werror,-Wimplicit-function-declaration]
include/asm-generic/bitops/atomic.h:17:7: error: implicit declaration of function 'BIT_WORD' [-Werror,-Wimplicit-function-declaration]

Include the correct header first.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Link: https://lore.kernel.org/r/20211018131929.2260087-1-arnd@kernel.org
Signed-off-by: Wei Liu <wei.liu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hv/hyperv_vmbus.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/hv/hyperv_vmbus.h b/drivers/hv/hyperv_vmbus.h
index cabcb66e7c5e..356382a340b2 100644
--- a/drivers/hv/hyperv_vmbus.h
+++ b/drivers/hv/hyperv_vmbus.h
@@ -13,6 +13,7 @@
 #define _HYPERV_VMBUS_H
 
 #include <linux/list.h>
+#include <linux/bitops.h>
 #include <asm/sync_bitops.h>
 #include <asm/hyperv-tlfs.h>
 #include <linux/atomic.h>
-- 
2.33.0

