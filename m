Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 476D715B1B
	for <lists+stable@lfdr.de>; Tue,  7 May 2019 07:52:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728907AbfEGFjj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 May 2019 01:39:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:59202 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728479AbfEGFjh (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 May 2019 01:39:37 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6401620578;
        Tue,  7 May 2019 05:39:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557207577;
        bh=Xr2lq4+YQIty+EgsKo1pDRwS9bE6NkkxmsNUf3Zmo5M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DdH2GT6XVaGEkPOFDUxoiwY1j9h6ysCuyfRQ6rNgpIwxnHqvtOQo18wSchcQ0nmqd
         9YattNngqtGGJtKJy9FolJv2t3AtF9anKMKzEDh398wTR5O/4Y90f0mKMjst8S8QN7
         DavOx9pjGF8sox4CxCpAFV1KNSEOhBEuboKNK1VU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <alexander.levin@microsoft.com>,
        sparclinux@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 35/95] sparc64: Export __node_distance.
Date:   Tue,  7 May 2019 01:37:24 -0400
Message-Id: <20190507053826.31622-35-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190507053826.31622-1-sashal@kernel.org>
References: <20190507053826.31622-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "David S. Miller" <davem@davemloft.net>

[ Upstream commit 2b4792eaa9f553764047d157365ed8b7787751a3 ]

Some drivers reference it via node_distance(), for example the
NVME host driver core.

ERROR: "__node_distance" [drivers/nvme/host/nvme-core.ko] undefined!
make[1]: *** [scripts/Makefile.modpost:92: __modpost] Error 1

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <alexander.levin@microsoft.com>
---
 arch/sparc/mm/init_64.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/sparc/mm/init_64.c b/arch/sparc/mm/init_64.c
index 984e9d65ea0d..76977296dc9c 100644
--- a/arch/sparc/mm/init_64.c
+++ b/arch/sparc/mm/init_64.c
@@ -1383,6 +1383,7 @@ int __node_distance(int from, int to)
 	}
 	return numa_latency[from][to];
 }
+EXPORT_SYMBOL(__node_distance);
 
 static int __init find_best_numa_node_for_mlgroup(struct mdesc_mlgroup *grp)
 {
-- 
2.20.1

