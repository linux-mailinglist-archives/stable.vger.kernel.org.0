Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B04E134CA9E
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:41:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233595AbhC2IjO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:39:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:55110 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234950AbhC2Ihk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:37:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 00CC361613;
        Mon, 29 Mar 2021 08:37:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617007060;
        bh=atK0IFSXyZaB9N5YS8aCzMT9DSGHF4kQf1csFMDfuMU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=13ham1UToiF1YWpQF/x2szszbj6vrigv8+jPpomvbHSamYp57xIzTcooSB37xu8D2
         i+BM7sO69fAhYYAvtCXHyOElDIuv0z02PdlE9qtDRKY0fpFPBkhF4rbUNMushnTtwb
         lH3rQTJZKY1I+ho+eIhV0+YLAloAB8DveGxJP+Kw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        Sunil Goutham <sgoutham@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 207/254] octeontx2-af: Fix memory leak of object buf
Date:   Mon, 29 Mar 2021 09:58:43 +0200
Message-Id: <20210329075639.898720661@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075633.135869143@linuxfoundation.org>
References: <20210329075633.135869143@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

[ Upstream commit 9e0a537d06fc36861e4f78d0a7df1fe2b3592714 ]

Currently the error return path when lfs fails to allocate is not free'ing
the memory allocated to buf. Fix this by adding the missing kfree.

Addresses-Coverity: ("Resource leak")
Fixes: f7884097141b ("octeontx2-af: Formatting debugfs entry rsrc_alloc.")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Acked-by: Sunil Goutham <sgoutham@marvell.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
index ea1e520b6552..0488651a68d0 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
@@ -169,8 +169,10 @@ static ssize_t rvu_dbg_rsrc_attach_status(struct file *filp,
 		return -ENOSPC;
 
 	lfs = kzalloc(lf_str_size, GFP_KERNEL);
-	if (!lfs)
+	if (!lfs) {
+		kfree(buf);
 		return -ENOMEM;
+	}
 	off +=	scnprintf(&buf[off], buf_size - 1 - off, "%-*s", lf_str_size,
 			  "pcifunc");
 	for (index = 0; index < BLK_COUNT; index++)
-- 
2.30.1



