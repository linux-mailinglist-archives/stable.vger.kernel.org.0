Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BF9B419A4E
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 19:06:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235960AbhI0RIR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 13:08:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:46130 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236165AbhI0RHR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Sep 2021 13:07:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EC341611C7;
        Mon, 27 Sep 2021 17:05:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632762339;
        bh=+iUKw716IQ3WXO3TYY4ixtHfiA97BirP4g6fyAHmTvo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aZriNYacTNjPzKCxDy/iFjVFdAndr9VsaVNE6coAL60zCKO6DP0YADbj6nQLkHxzV
         bMfUsFYJUAuDAOAjzqcF4JoKqAXBuqEf8WzEuls01yK7nv4dcGNZCA6t/qZXfwJcB3
         IH3MGUcuTBv0d1LaFArTbOUkeh3MWIiPu+qyKwMc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andreas Larsson <andreas@gaisler.com>,
        Sam Ravnborg <sam@ravnborg.org>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 53/68] sparc32: page align size in arch_dma_alloc
Date:   Mon, 27 Sep 2021 19:02:49 +0200
Message-Id: <20210927170221.788905368@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210927170219.901812470@linuxfoundation.org>
References: <20210927170219.901812470@linuxfoundation.org>
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
index f89603855f1e..b87e0002131d 100644
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



