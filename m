Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89AEA1F3138
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 03:08:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727109AbgFHXG4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 19:06:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:50458 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727105AbgFHXG4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jun 2020 19:06:56 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 40E6720842;
        Mon,  8 Jun 2020 23:06:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591657616;
        bh=l4UrxZfPytW7PlaB2VeAq30RXCOzD1wa7DQI7P+EKhQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Qw225oKv1tBngdkVT2YvDqZlHfZBpcNREI7ipI6UPfl9PXNVki0m6kAhUmTywou3O
         UQj5JgYkHpOzJ8VOPgcD07vEdRB2IZkQi2+qJL6Ib68fY2K5RNDdDvt/PZXbtzuE7w
         90vxWZFDKQqb0CvzhsnwxVQ5NAmC7ykz8dZPDuHA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ioana Ciornei <ioana.ciornei@nxp.com>,
        Li Yang <leoyang.li@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, linuxppc-dev@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.7 038/274] soc: fsl: dpio: properly compute the consumer index
Date:   Mon,  8 Jun 2020 19:02:11 -0400
Message-Id: <20200608230607.3361041-38-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608230607.3361041-1-sashal@kernel.org>
References: <20200608230607.3361041-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ioana Ciornei <ioana.ciornei@nxp.com>

[ Upstream commit 7596ac9d19a9df25707ecaac0675881f62dd8c18 ]

Mask the consumer index before using it. Without this, we would be
writing frame descriptors beyond the ring size supported by the QBMAN
block.

Fixes: 3b2abda7d28c ("soc: fsl: dpio: Replace QMAN array mode with ring mode enqueue")
Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
Acked-by: Li Yang <leoyang.li@nxp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/fsl/dpio/qbman-portal.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/soc/fsl/dpio/qbman-portal.c b/drivers/soc/fsl/dpio/qbman-portal.c
index 804b8ba9bf5c..23a1377971f4 100644
--- a/drivers/soc/fsl/dpio/qbman-portal.c
+++ b/drivers/soc/fsl/dpio/qbman-portal.c
@@ -669,6 +669,7 @@ int qbman_swp_enqueue_multiple_direct(struct qbman_swp *s,
 		eqcr_ci = s->eqcr.ci;
 		p = s->addr_cena + QBMAN_CENA_SWP_EQCR_CI;
 		s->eqcr.ci = qbman_read_register(s, QBMAN_CINH_SWP_EQCR_CI);
+		s->eqcr.ci &= full_mask;
 
 		s->eqcr.available = qm_cyc_diff(s->eqcr.pi_ring_size,
 					eqcr_ci, s->eqcr.ci);
-- 
2.25.1

