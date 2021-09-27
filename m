Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E443419B19
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 19:13:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236738AbhI0RP0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 13:15:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:55992 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237219AbhI0ROT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Sep 2021 13:14:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EB73F6121E;
        Mon, 27 Sep 2021 17:09:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632762599;
        bh=0zYJAE45lLThOEfIxFaR/OUCkonU2nQgap5RVqfRKwk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LZQ1ocUJpd+0FuIss5k/jBdtVSI7+nZZZZERpPJACDTxhcan1S0zLq1gOVfhQdNqI
         Ul66zO5Yy9ivn8Kzlf62Z/61e9vtQUxkhQvnfDZg0s5IsKPFw1BsZlD/SvVFNKCli3
         3uWEdhXnqNkkd6eAP/FPyAf+t/tKNmEu2NvQ1aWE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andreas Larsson <andreas@gaisler.com>,
        Sam Ravnborg <sam@ravnborg.org>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 084/103] sparc32: page align size in arch_dma_alloc
Date:   Mon, 27 Sep 2021 19:02:56 +0200
Message-Id: <20210927170228.671358178@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210927170225.702078779@linuxfoundation.org>
References: <20210927170225.702078779@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andreas Larsson <andreas@gaisler.com>

[ Upstream commit 59583f747664046aaae5588d56d5954fab66cce8 ]

Commit 53b7670e5735 ("sparc: factor the dma coherent mapping into
helper") lost the page align for the calls to dma_make_coherent and
srmmu_unmapiorange. The latter cannot handle a non page aligned len
argument.

Signed-off-by: Andreas Larsson <andreas@gaisler.com>
Reviewed-by: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/sparc/kernel/ioport.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/sparc/kernel/ioport.c b/arch/sparc/kernel/ioport.c
index 8e1d72a16759..7ceae24b0ca9 100644
--- a/arch/sparc/kernel/ioport.c
+++ b/arch/sparc/kernel/ioport.c
@@ -356,7 +356,9 @@ err_nomem:
 void arch_dma_free(struct device *dev, size_t size, void *cpu_addr,
 		dma_addr_t dma_addr, unsigned long attrs)
 {
-	if (!sparc_dma_free_resource(cpu_addr, PAGE_ALIGN(size)))
+	size = PAGE_ALIGN(size);
+
+	if (!sparc_dma_free_resource(cpu_addr, size))
 		return;
 
 	dma_make_coherent(dma_addr, size);
-- 
2.33.0



