Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BF2745273C
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 03:17:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244282AbhKPCUU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 21:20:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:57864 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237961AbhKORjx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 12:39:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9FB89632E3;
        Mon, 15 Nov 2021 17:26:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636997196;
        bh=TjenZcRn8UZcpPnaYPODH0Mc6K8LNJeiIvDmNPqaf+8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1PxuMnOWH7lQfuuX1lR0QJRjnPxw2YBhW/zv0/e8GfJAp9EdUs59fTqRr24BpjBQu
         Z+yhUJBWx3FKpWs7G6G5+A2baxRCH3XThr33kxv2bPf/NFh2hoSxrIzbVNEVewE8HA
         V2kLsfvc+YavCd/d+Sl4PSHJ0LN2XA/l8KYrz5ok=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Wei Liu <wei.liu@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 059/575] hyperv/vmbus: include linux/bitops.h
Date:   Mon, 15 Nov 2021 17:56:24 +0100
Message-Id: <20211115165345.686892873@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165343.579890274@linuxfoundation.org>
References: <20211115165343.579890274@linuxfoundation.org>
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
index 40e2b9f91163c..7845fa5de79e9 100644
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



