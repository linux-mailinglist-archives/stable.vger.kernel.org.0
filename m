Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 280734996EE
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:20:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1446336AbiAXVH7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:07:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1444615AbiAXVBM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:01:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6478AC04C060;
        Mon, 24 Jan 2022 12:02:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2BC7BB81218;
        Mon, 24 Jan 2022 20:02:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57E8BC340E5;
        Mon, 24 Jan 2022 20:02:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643054546;
        bh=6SWFNtQAhiPbgkd6kdbFRMEtXk7VCljfVemFjaj60sg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2TpbxtHNAAmY+5e0j0RBMk9jmrs0WE5NBAZIgYu6fInyIsMh7TeKkzWpK8kCc2jwX
         2n6YczDxr4hr7W24+FsRbZyNJLPHO21HurcSWuKPUCFomzNB1GI8Bdh8D4OA/dRvYS
         Yz/7zPRcZotPmyGXyiN71MfGnYdDA+BwDBRYxE54=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 423/563] dm: fix alloc_dax error handling in alloc_dev
Date:   Mon, 24 Jan 2022 19:43:08 +0100
Message-Id: <20220124184039.092847415@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184024.407936072@linuxfoundation.org>
References: <20220124184024.407936072@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit d751939235b9b7bc4af15f90a3e99288a8b844a7 ]

Make sure ->dax_dev is NULL on error so that the cleanup path doesn't
trip over an ERR_PTR.

Reported-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/20211129102203.2243509-2-hch@lst.de
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 19a70f434029b..6030cba5b0382 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1894,8 +1894,10 @@ static struct mapped_device *alloc_dev(int minor)
 	if (IS_ENABLED(CONFIG_DAX_DRIVER)) {
 		md->dax_dev = alloc_dax(md, md->disk->disk_name,
 					&dm_dax_ops, 0);
-		if (IS_ERR(md->dax_dev))
+		if (IS_ERR(md->dax_dev)) {
+			md->dax_dev = NULL;
 			goto bad;
+		}
 	}
 
 	add_disk_no_queue_reg(md->disk);
-- 
2.34.1



