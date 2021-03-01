Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3F73328EB3
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:37:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242106AbhCATfN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:35:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:48646 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241873AbhCAT3f (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:29:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C1C5C64F6C;
        Mon,  1 Mar 2021 17:50:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614621026;
        bh=8cMgb4xGAjd8a8wRgt0wH4q4ZXANGpxicI9k8qjckxc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EWLEMU3RB4l5HxIIrOeBfL5/H+/uso21E7YxNbVWR+eyv5y88C5BZnE3kE+7/H8V5
         c8Vej24Uu/EtLmh+TS4kUufDi0+hfabzE2PT7135ptX2Ap+sJrLPbTgRw/37izK0C8
         1dJyh8KxGQp5BCTkghmonMfisjPFX2qBGRbMzplU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>,
        devicetree@vger.kernel.org, KarimAllah Ahmed <karahmed@amazon.de>,
        Quentin Perret <qperret@google.com>,
        Rob Herring <robh@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 336/775] fdt: Properly handle "no-map" field in the memory region
Date:   Mon,  1 Mar 2021 17:08:24 +0100
Message-Id: <20210301161218.225700513@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: KarimAllah Ahmed <karahmed@amazon.de>

[ Upstream commit 86588296acbfb1591e92ba60221e95677ecadb43 ]

Mark the memory region with NOMAP flag instead of completely removing it
from the memory blocks. That makes the FDT handling consistent with the EFI
memory map handling.

Cc: Rob Herring <robh+dt@kernel.org>
Cc: Frank Rowand <frowand.list@gmail.com>
Cc: devicetree@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: KarimAllah Ahmed <karahmed@amazon.de>
Signed-off-by: Quentin Perret <qperret@google.com>
Link: https://lore.kernel.org/r/20210115114544.1830068-2-qperret@google.com
Signed-off-by: Rob Herring <robh@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/of/fdt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/of/fdt.c b/drivers/of/fdt.c
index feb0f2d67fc5f..427b534d60d2d 100644
--- a/drivers/of/fdt.c
+++ b/drivers/of/fdt.c
@@ -1147,7 +1147,7 @@ int __init __weak early_init_dt_reserve_memory_arch(phys_addr_t base,
 					phys_addr_t size, bool nomap)
 {
 	if (nomap)
-		return memblock_remove(base, size);
+		return memblock_mark_nomap(base, size);
 	return memblock_reserve(base, size);
 }
 
-- 
2.27.0



