Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27BD432855C
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 17:54:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235993AbhCAQxj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 11:53:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:47194 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235354AbhCAQoM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 11:44:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E2AB260241;
        Mon,  1 Mar 2021 16:30:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614616220;
        bh=J5/Ahp1p7dAaaWXEgRpcI0xRuagIwZeR7IGpyTGFHrU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g8gcFmNoVw/IqaKuWlXQM7sPQDb87Jz1sAnMUAZzw32PQg1g3NIz3E7utLPdZ+k6t
         U8slZ1Pgss3YzKOCE4oBVBvw6PlhkNj7PEWBGKJly+gkey0DxVKDgE0rctxsyHWBdm
         ovQYprY8zgEf7B15oWIlwVTVT3+IuszcSsxJwr7k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>,
        devicetree@vger.kernel.org, KarimAllah Ahmed <karahmed@amazon.de>,
        Quentin Perret <qperret@google.com>,
        Rob Herring <robh@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 076/176] fdt: Properly handle "no-map" field in the memory region
Date:   Mon,  1 Mar 2021 17:12:29 +0100
Message-Id: <20210301161024.745081697@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161020.931630716@linuxfoundation.org>
References: <20210301161020.931630716@linuxfoundation.org>
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
index 6337c394bfe32..6df66fcefbb40 100644
--- a/drivers/of/fdt.c
+++ b/drivers/of/fdt.c
@@ -1213,7 +1213,7 @@ int __init __weak early_init_dt_reserve_memory_arch(phys_addr_t base,
 					phys_addr_t size, bool nomap)
 {
 	if (nomap)
-		return memblock_remove(base, size);
+		return memblock_mark_nomap(base, size);
 	return memblock_reserve(base, size);
 }
 
-- 
2.27.0



