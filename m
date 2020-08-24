Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7ACC24F471
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 10:36:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726770AbgHXIgf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 04:36:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:49262 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726730AbgHXIgd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Aug 2020 04:36:33 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CDFFF22B3F;
        Mon, 24 Aug 2020 08:36:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598258193;
        bh=Tj68wpcq8gwgRKTspOtj86cQXqXyuM2JjWCZZk96Frc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tAb6bLQ1Ugx0Dx3Bvl4WY+snoCUlXvHvo7ko8DsfYMqlcifvX47TQSO99KLfkxapi
         O3GXyExjhAUsuPD8yPYTEZglzj6H0H90IjAtOd9giJf8cMmhSKGT47MRtLiH0CTcAq
         jDJGxzXiSMIsl5dvusD08GqQRLWmgJCFl44hO10s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        Rob Herring <robh@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 108/148] of/address: check for invalid range.cpu_addr
Date:   Mon, 24 Aug 2020 10:30:06 +0200
Message-Id: <20200824082419.198945010@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200824082413.900489417@linuxfoundation.org>
References: <20200824082413.900489417@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

[ Upstream commit f49c7faf776f16607c948d852a03b04a88c3b583 ]

Currently invalid CPU addresses are not being sanity checked resulting in
SATA setup failure on a SynQuacer SC2A11 development machine. The original
check was removed by and earlier commit, so add a sanity check back in
to avoid this regression.

Fixes: 7a8b64d17e35 ("of/address: use range parser for of_dma_get_range")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Link: https://lore.kernel.org/r/20200817113208.523805-1-colin.king@canonical.com
Signed-off-by: Rob Herring <robh@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/of/address.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/of/address.c b/drivers/of/address.c
index 8eea3f6e29a44..340d3051b1ce2 100644
--- a/drivers/of/address.c
+++ b/drivers/of/address.c
@@ -980,6 +980,11 @@ int of_dma_get_range(struct device_node *np, u64 *dma_addr, u64 *paddr, u64 *siz
 			/* Don't error out as we'd break some existing DTs */
 			continue;
 		}
+		if (range.cpu_addr == OF_BAD_ADDR) {
+			pr_err("translation of DMA address(%llx) to CPU address failed node(%pOF)\n",
+			       range.bus_addr, node);
+			continue;
+		}
 		dma_offset = range.cpu_addr - range.bus_addr;
 
 		/* Take lower and upper limits */
-- 
2.25.1



