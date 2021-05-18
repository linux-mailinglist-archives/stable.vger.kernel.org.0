Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38C3A386ED7
	for <lists+stable@lfdr.de>; Tue, 18 May 2021 03:10:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345522AbhERBLP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 21:11:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:57128 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345491AbhERBLM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 21:11:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7959961369;
        Tue, 18 May 2021 01:09:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621300195;
        bh=3Tr08Y78fD2cRH+schCpVdrD0QHHKQyBNwEkv7fNgL8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QFw2zWoWKKrCbjQKiQqjUGf7oqbifjsE9zEP92EofadrgZhd09Gs10yXf5wCFmpud
         0udNe6BXF/ss/hlxr6kW7v+7mi19n+eOHqP+dFWCiPL99skRvuV32WS8Xnw2+JbkwZ
         tH/zadDEiH18jsgnMKltZ1RC/kkNzOtKgSDuZbKwy7GfcxXnhJclbjXw36NLAM08bW
         S3hx6dmOJIjZIQ9zR0h0FjiHr6VC+UP40N7FelSkqdEDXNEDYpfTzdtm7tBLcqFeiq
         XkXZZe+cBGWG+dfK/p7m9D5EEfecLX6d+oIQHBBCQuYEPe14voDN87/QF/ooWxE9V2
         qWSxJSmoVwVNA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Daniel Wagner <dwagner@suse.de>,
        Enzo Matsumiya <ematsumiya@suse.com>,
        Christoph Hellwig <hch@lst.de>,
        Sasha Levin <sashal@kernel.org>, linux-nvme@lists.infradead.org
Subject: [PATCH AUTOSEL 5.11 3/3] nvmet: seset ns->file when open fails
Date:   Mon, 17 May 2021 21:09:49 -0400
Message-Id: <20210518010950.1485574-3-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210518010950.1485574-1-sashal@kernel.org>
References: <20210518010950.1485574-1-sashal@kernel.org>
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
index 0abbefd9925e..b57599724448 100644
--- a/drivers/nvme/target/io-cmd-file.c
+++ b/drivers/nvme/target/io-cmd-file.c
@@ -49,9 +49,11 @@ int nvmet_file_ns_enable(struct nvmet_ns *ns)
 
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
 
 	ret = nvmet_file_ns_revalidate(ns);
-- 
2.30.2

