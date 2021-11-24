Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1580245BC97
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 13:29:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245192AbhKXMbW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 07:31:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:48574 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343618AbhKXM3X (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 07:29:23 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5988060FD9;
        Wed, 24 Nov 2021 12:17:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637756263;
        bh=ZQ8QsDemu4Hw7K8dE2XfajIzh7SCg/F1qpBTFgV4qSs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Lm9TG0v6XFN6u9y4TQrdpvCbswgQkoDsqst8NthvsFYi0AXZed5I5nKKL1G2G6Nx2
         ryUrciV7MO9vYb+5fEBK/ySnHErmvXr9Jjjy7E8ZErxOSuuNmcRsMmLJfrxcZo1kD2
         RCDxsFWUwu1+9VmJ0f1wlaSpBLPVC+R3XpFuYygY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Wei Liu <wei.liu@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 024/251] hyperv/vmbus: include linux/bitops.h
Date:   Wed, 24 Nov 2021 12:54:26 +0100
Message-Id: <20211124115711.089322042@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115710.214900256@linuxfoundation.org>
References: <20211124115710.214900256@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index a166de6efd99c..0996a246c80bb 100644
--- a/drivers/hv/hyperv_vmbus.h
+++ b/drivers/hv/hyperv_vmbus.h
@@ -26,6 +26,7 @@
 #define _HYPERV_VMBUS_H
 
 #include <linux/list.h>
+#include <linux/bitops.h>
 #include <asm/sync_bitops.h>
 #include <linux/atomic.h>
 #include <linux/hyperv.h>
-- 
2.33.0



