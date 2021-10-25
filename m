Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2B43439C8B
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 19:01:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234305AbhJYREB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 13:04:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:55836 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234446AbhJYRDJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 13:03:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3C80160FDC;
        Mon, 25 Oct 2021 17:00:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635181247;
        bh=vJ9PzBQVL0ZA3WtkALPFdgdKujQu8aXRFytz2wBr5Yo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T9RZ4mA5YIAX2tDGxEgxueZgNf0MfzKmwBI3S8vfnQaHe0ez6fy31saBOaOLL7w+d
         TpYa6i3iR86deVmTyPLscbpF3LSYFV0E84NIAnkJMxBy0MYPATw9diTAbEK5G9b7Gr
         eDfK8N85VU43SRfkzR7htuos/l8iIzyduygin76TnxuN9CNbiAfyMb1XldrMk1fMUC
         Vjmm8r0knsebMz0OO8enInF6URKftjumIjSiH2fVWjlAr8MOi6bgjhCSHGzAnTiHBf
         +hfli61i3oYm3zEeT3m+lg9zavcT4s7pIQ3+6NJr0+ZNcOzqpHis75U0E5YA18vOS3
         OWBxWSt+5xEqQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Arnd Bergmann <arnd@arndb.de>, Wei Liu <wei.liu@kernel.org>,
        Sasha Levin <sashal@kernel.org>, kys@microsoft.com,
        haiyangz@microsoft.com, sthemmin@microsoft.com,
        decui@microsoft.com, linux-hyperv@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 13/13] hyperv/vmbus: include linux/bitops.h
Date:   Mon, 25 Oct 2021 13:00:22 -0400
Message-Id: <20211025170023.1394358-13-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211025170023.1394358-1-sashal@kernel.org>
References: <20211025170023.1394358-1-sashal@kernel.org>
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
index 40e2b9f91163..7845fa5de79e 100644
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

