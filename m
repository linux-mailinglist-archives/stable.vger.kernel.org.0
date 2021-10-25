Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5CA0439D07
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 19:08:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234813AbhJYRLD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 13:11:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:55660 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234659AbhJYRD5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 13:03:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 105CA61039;
        Mon, 25 Oct 2021 17:01:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635181279;
        bh=grpr2WWhS9qo0WyghtIQhX8ibOuVGV15fdhKO+vgyc4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l9cHKknLDUcROliw4zSj8FHLgXS1e9dmzsJ/2rdjyWkyJ2WXiIAYfG6Xtnak2RndG
         dx/mV30+J3GpekxOk0bXwMxX5UqXX7b0HAlR7i6f5y/Ec7RTrXWJoB8HxDzPB9NXu+
         geImUn77zvTV4XsYL3dknmKe2ww+YMgUJDvDmxcQnzeQK525mmFpO1JEPWSLLZTDAJ
         r0aJok8jAKMbZ6P72zEdJwhZr8oJfFOpipUVVHt3KgpiKMSGAapBdfDtsT5vuaWMPt
         ROyXRl5eIbQ356tgBnkilVBA5NP9JOfq9iXZRmk7uojxTHtyjoPQzrupvFPXoRJY3X
         dE5CqfL04Bnvw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Arnd Bergmann <arnd@arndb.de>, Wei Liu <wei.liu@kernel.org>,
        Sasha Levin <sashal@kernel.org>, kys@microsoft.com,
        haiyangz@microsoft.com, sthemmin@microsoft.com,
        decui@microsoft.com, linux-hyperv@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 7/7] hyperv/vmbus: include linux/bitops.h
Date:   Mon, 25 Oct 2021 13:01:02 -0400
Message-Id: <20211025170103.1394651-7-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211025170103.1394651-1-sashal@kernel.org>
References: <20211025170103.1394651-1-sashal@kernel.org>
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
index 87d3d7da78f8..7e7c8debbd28 100644
--- a/drivers/hv/hyperv_vmbus.h
+++ b/drivers/hv/hyperv_vmbus.h
@@ -26,6 +26,7 @@
 #define _HYPERV_VMBUS_H
 
 #include <linux/list.h>
+#include <linux/bitops.h>
 #include <asm/sync_bitops.h>
 #include <asm/hyperv-tlfs.h>
 #include <linux/atomic.h>
-- 
2.33.0

