Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69407386EE1
	for <lists+stable@lfdr.de>; Tue, 18 May 2021 03:10:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345657AbhERBLo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 21:11:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:57508 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345581AbhERBLX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 21:11:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5AB3B613BA;
        Tue, 18 May 2021 01:10:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621300206;
        bh=+Ry8OFtRQ6R/dls8cjldcYfjKLo1G6vnoM5kpwSEqFE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MZJ5+KU2dZTlGdmBzwjnAEU9cfCjW3KdKZGrvKv0QBrXF/lkvZhj8M07YKpQJ/trZ
         Wfx7TUaBmmlwfpoUeRC8xtEyMxbv1/x3/aD7oITqN/AT4uSJxX7vzeuvPVDPQKtbgK
         xFunzee0zAQeAiHBazY38K38Gph7OBNh1TUXzco7xoz7Y60aU7TPIn3KpabQqiJ00e
         yzM/XGdBRyXhpIxHZpHXkpCibcthn2UzWWEzcYFTSpvp4NMkZAvDmTl63wLBOGpQ3W
         PpBw1sDGhbrxTb4b+4ADB2e383cobPwCqdCeiGqmjZQtNgknixSjyEDYWdLWctBT3D
         yJgWnI6iSbiug==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Daniel Wagner <dwagner@suse.de>,
        Enzo Matsumiya <ematsumiya@suse.com>,
        Christoph Hellwig <hch@lst.de>,
        Sasha Levin <sashal@kernel.org>, linux-nvme@lists.infradead.org
Subject: [PATCH AUTOSEL 5.4 2/2] nvmet: seset ns->file when open fails
Date:   Mon, 17 May 2021 21:10:02 -0400
Message-Id: <20210518011002.1485938-2-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210518011002.1485938-1-sashal@kernel.org>
References: <20210518011002.1485938-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Wagner <dwagner@suse.de>

[ Upstream commit 85428beac80dbcace5b146b218697c73e367dcf5 ]

Reset the ns->file value to NULL also in the error case in
nvmet_file_ns_enable().

The ns->file variable points either to file object or contains the
error code after the filp_open() call. This can lead to following
problem:

When the user first setups an invalid file backend and tries to enable
the ns, it will fail. Then the user switches over to a bdev backend
and enables successfully the ns. The first received I/O will crash the
system because the IO backend is chosen based on the ns->file value:

static u16 nvmet_parse_io_cmd(struct nvmet_req *req)
{
	[...]

	if (req->ns->file)
		return nvmet_file_parse_io_cmd(req);

	return nvmet_bdev_parse_io_cmd(req);
}

Reported-by: Enzo Matsumiya <ematsumiya@suse.com>
Signed-off-by: Daniel Wagner <dwagner@suse.de>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/io-cmd-file.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/nvme/target/io-cmd-file.c b/drivers/nvme/target/io-cmd-file.c
index 05453f5d1448..6ca17a0babae 100644
--- a/drivers/nvme/target/io-cmd-file.c
+++ b/drivers/nvme/target/io-cmd-file.c
@@ -38,9 +38,11 @@ int nvmet_file_ns_enable(struct nvmet_ns *ns)
 
 	ns->file = filp_open(ns->device_path, flags, 0);
 	if (IS_ERR(ns->file)) {
-		pr_err("failed to open file %s: (%ld)\n",
-				ns->device_path, PTR_ERR(ns->file));
-		return PTR_ERR(ns->file);
+		ret = PTR_ERR(ns->file);
+		pr_err("failed to open file %s: (%d)\n",
+			ns->device_path, ret);
+		ns->file = NULL;
+		return ret;
 	}
 
 	ret = vfs_getattr(&ns->file->f_path,
-- 
2.30.2

