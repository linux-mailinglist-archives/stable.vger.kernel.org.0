Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D58E450C08
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 18:31:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232536AbhKOReQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 12:34:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:45642 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237708AbhKORcb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 12:32:31 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5BB43632A4;
        Mon, 15 Nov 2021 17:20:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636996836;
        bh=nV0pbrdkHPY5eKY+aHXvF0B3I4WxIca4P2TKnrr5/HY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j2OIqq0GgIE+bLSBmazi9ISTXlWdywrj2Jf9ylKfLFPhWPdIhG9lclLgP4pJ+xe+j
         SRewUM58LMNAcbP5llKxH2/ADL+iKAcmHqh+NX7VWLGAP9Hk/OOxHlQdLfs8cZA9nm
         hNrDIWEqxFOucSPPbzccRRa6ocZVhI3/GGBdFEQA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bixuan Cui <cuibixuan@linux.alibaba.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 286/355] powerpc/44x/fsp2: add missing of_node_put
Date:   Mon, 15 Nov 2021 18:03:30 +0100
Message-Id: <20211115165322.978451015@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165313.549179499@linuxfoundation.org>
References: <20211115165313.549179499@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bixuan Cui <cuibixuan@linux.alibaba.com>

[ Upstream commit 290fe8aa69ef5c51c778c0bb33f8ef0181c769f5 ]

Early exits from for_each_compatible_node() should decrement the
node reference counter.  Reported by Coccinelle:

./arch/powerpc/platforms/44x/fsp2.c:206:1-25: WARNING: Function
"for_each_compatible_node" should have of_node_put() before return
around line 218.

Fixes: 7813043e1bbc ("powerpc/44x/fsp2: Add irq error handlers")
Signed-off-by: Bixuan Cui <cuibixuan@linux.alibaba.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/1635406102-88719-1-git-send-email-cuibixuan@linux.alibaba.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/platforms/44x/fsp2.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/powerpc/platforms/44x/fsp2.c b/arch/powerpc/platforms/44x/fsp2.c
index b299e43f5ef94..823397c802def 100644
--- a/arch/powerpc/platforms/44x/fsp2.c
+++ b/arch/powerpc/platforms/44x/fsp2.c
@@ -208,6 +208,7 @@ static void node_irq_request(const char *compat, irq_handler_t errirq_handler)
 		if (irq == NO_IRQ) {
 			pr_err("device tree node %pOFn is missing a interrupt",
 			      np);
+			of_node_put(np);
 			return;
 		}
 
@@ -215,6 +216,7 @@ static void node_irq_request(const char *compat, irq_handler_t errirq_handler)
 		if (rc) {
 			pr_err("fsp_of_probe: request_irq failed: np=%pOF rc=%d",
 			      np, rc);
+			of_node_put(np);
 			return;
 		}
 	}
-- 
2.33.0



