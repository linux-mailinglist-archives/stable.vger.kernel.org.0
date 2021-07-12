Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E4523C52AB
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:50:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347119AbhGLHsl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:48:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:52932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346503AbhGLHqj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:46:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 361ED613FA;
        Mon, 12 Jul 2021 07:41:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626075712;
        bh=kRiago927HFg+ZHkm+g4t8aU2H8KxprrSkJHgBpdzM4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sv0Qyh5M6WoiiVcu+ZtNGfHMTDYbOeKq7iKWY0p/jWQybNkUuUY8oJnaJKmMYHBj6
         82L/DZOmNnOxWG5PG9fRLpaMVCpz1pDn+Z9Yn8geuRdyj3KLQYNjqJ41M8S6xqKPqR
         1MLuIVgYIgiDlKJYkUDAPk7c4VRmG2qgyDJx5WqM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Tuan Phan <tuanphan@os.amperecomputing.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 330/800] perf/arm-cmn: Fix invalid pointer when access dtc object sharing the same IRQ number
Date:   Mon, 12 Jul 2021 08:05:53 +0200
Message-Id: <20210712061001.527925982@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tuan Phan <tuanphan@os.amperecomputing.com>

[ Upstream commit 4e16f283edc289820e9b2d6f617ed8e514ee8396 ]

When multiple dtcs share the same IRQ number, the irq_friend which
used to refer to dtc object gets calculated incorrect which leads
to invalid pointer.

Fixes: 0ba64770a2f2 ("perf: Add Arm CMN-600 PMU driver")

Signed-off-by: Tuan Phan <tuanphan@os.amperecomputing.com>
Reviewed-by: Robin Murphy <robin.murphy@arm.com>
Link: https://lore.kernel.org/r/1623946129-3290-1-git-send-email-tuanphan@os.amperecomputing.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/perf/arm-cmn.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/perf/arm-cmn.c b/drivers/perf/arm-cmn.c
index 56a5c355701d..49016f2f505e 100644
--- a/drivers/perf/arm-cmn.c
+++ b/drivers/perf/arm-cmn.c
@@ -1212,7 +1212,7 @@ static int arm_cmn_init_irqs(struct arm_cmn *cmn)
 		irq = cmn->dtc[i].irq;
 		for (j = i; j--; ) {
 			if (cmn->dtc[j].irq == irq) {
-				cmn->dtc[j].irq_friend = j - i;
+				cmn->dtc[j].irq_friend = i - j;
 				goto next;
 			}
 		}
-- 
2.30.2



