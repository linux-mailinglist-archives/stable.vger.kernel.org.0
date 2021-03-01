Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 611713286AE
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 18:16:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237758AbhCARNL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 12:13:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:35192 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237393AbhCARIP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 12:08:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 62E4364F83;
        Mon,  1 Mar 2021 16:40:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614616855;
        bh=8wgMwc7LmJgtQd6NOmoMNzGIONIVgak4qsRa5KBJ08U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=La11i8yDHyKg/sJOqg0kK9q6S+i8dYLJrHQtBrkoyBrASE5IvsLlscJyz5irVhrxj
         KumUth/zlJwzEpLx4sDvMU4QlDgv0nmtToe+Bp0Nh9AVFyuhbqMdJDB2X4rmZSqj72
         rFQDPW6JYdd8EnTjkeV1tiRemINAV3456sV4PcbA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>,
        devicetree@vger.kernel.org, KarimAllah Ahmed <karahmed@amazon.de>,
        Quentin Perret <qperret@google.com>,
        Rob Herring <robh@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 118/247] fdt: Properly handle "no-map" field in the memory region
Date:   Mon,  1 Mar 2021 17:12:18 +0100
Message-Id: <20210301161037.451876670@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161031.684018251@linuxfoundation.org>
References: <20210301161031.684018251@linuxfoundation.org>
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
index 800ad252cf9c6..aa15e5d183c18 100644
--- a/drivers/of/fdt.c
+++ b/drivers/of/fdt.c
@@ -1173,7 +1173,7 @@ int __init __weak early_init_dt_reserve_memory_arch(phys_addr_t base,
 					phys_addr_t size, bool nomap)
 {
 	if (nomap)
-		return memblock_remove(base, size);
+		return memblock_mark_nomap(base, size);
 	return memblock_reserve(base, size);
 }
 
-- 
2.27.0



