Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AFB823F9DE
	for <lists+stable@lfdr.de>; Sun,  9 Aug 2020 01:38:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728357AbgHHXio (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Aug 2020 19:38:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:52834 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726807AbgHHXil (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 8 Aug 2020 19:38:41 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F0F072073E;
        Sat,  8 Aug 2020 23:38:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596929920;
        bh=dAoe88Mtbo9LtHCsMieDiuSyR9ZBSp9hgxYb9HLpeHg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Syq2GYHaWIbdRNaOUinmuASwZebDlHAf+AHNftvJyd46TQKSKDM7NqZM9UBtzinzY
         eGozwE0k3t3S4IKSxUX76FW83aL3/EzpLRIxpJO2VU3U60tIlQtN79RgE00s7ojEzM
         H6pXgLAoiAM6+tW0xDsgCB9fmqweVWO1r71FGgqY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Martin Wilck <mwilck@suse.com>, Hannes Reinecke <hare@suse.de>,
        Sagi Grimberg <sagi@grimberg.me>,
        Christoph Hellwig <hch@lst.de>,
        Sasha Levin <sashal@kernel.org>, linux-nvme@lists.infradead.org
Subject: [PATCH AUTOSEL 5.7 56/58] nvme-multipath: fix logic for non-optimized paths
Date:   Sat,  8 Aug 2020 19:37:22 -0400
Message-Id: <20200808233724.3618168-56-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200808233724.3618168-1-sashal@kernel.org>
References: <20200808233724.3618168-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Martin Wilck <mwilck@suse.com>

[ Upstream commit 3f6e3246db0e6f92e784965d9d0edb8abe6c6b74 ]

Handle the special case where we have exactly one optimized path,
which we should keep using in this case.

Fixes: 75c10e732724 ("nvme-multipath: round-robin I/O policy")
Signed off-by: Martin Wilck <mwilck@suse.com>
Signed-off-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/multipath.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/nvme/host/multipath.c b/drivers/nvme/host/multipath.c
index 36db7d2e6a896..2c94e084a61b8 100644
--- a/drivers/nvme/host/multipath.c
+++ b/drivers/nvme/host/multipath.c
@@ -246,6 +246,12 @@ static struct nvme_ns *nvme_round_robin_path(struct nvme_ns_head *head,
 			fallback = ns;
 	}
 
+	/* No optimized path found, re-check the current path */
+	if (!nvme_path_is_disabled(old) &&
+	    old->ana_state == NVME_ANA_OPTIMIZED) {
+		found = old;
+		goto out;
+	}
 	if (!fallback)
 		return NULL;
 	found = fallback;
-- 
2.25.1

