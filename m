Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A05D386EE7
	for <lists+stable@lfdr.de>; Tue, 18 May 2021 03:10:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345666AbhERBLq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 21:11:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:57630 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345593AbhERBL1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 21:11:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9F8DD613CE;
        Tue, 18 May 2021 01:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621300210;
        bh=wj0QOsfNOBtX701n2BDKmsB94m/zURdKlOYZuzfEqXs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CH557ljF79DrPWmJ1/0B841wSJjwrNkKqZS1m4/7e3bLQPys7sbQIuzBEAd6/d1XA
         DCw/JHgUNrmfjwxQZjIKHT9fru7yAAsGgKS+oWvb0j6JqLcSdjJYV3VAybP3kmDr8J
         9Lpe3NtcK648ssB2dY2+jtWegg1mnVy4WdVHiHrG96ixYVId6AjFdcbW5x77ACxMFP
         b+nXL7a/Jkj/m2Oda069Kc+eG0eAAlS3RY2qkXsjU1Se7cn1NlITpPgptgaQANqrRc
         YWU8mgjxcCaJLq6qbxvLy6ThZXV206D6K/qF16w/LniW6HLQnkfdg1WqAwDmeXc9Ph
         HAeGwtJ6oPMyA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Daniel Wagner <dwagner@suse.de>,
        Enzo Matsumiya <ematsumiya@suse.com>,
        Christoph Hellwig <hch@lst.de>,
        Sasha Levin <sashal@kernel.org>, linux-nvme@lists.infradead.org
Subject: [PATCH AUTOSEL 4.19 2/2] nvmet: seset ns->file when open fails
Date:   Mon, 17 May 2021 21:10:06 -0400
Message-Id: <20210518011006.1486026-2-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210518011006.1486026-1-sashal@kernel.org>
References: <20210518011006.1486026-1-sashal@kernel.org>
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
index 39d972e2595f..ad6263cf7303 100644
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

