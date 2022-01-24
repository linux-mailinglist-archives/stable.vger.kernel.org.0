Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09F9E49A244
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 02:59:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2365635AbiAXXvZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 18:51:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1578649AbiAXWDO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 17:03:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAA7EC036BF2;
        Mon, 24 Jan 2022 12:41:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 81A22B811F9;
        Mon, 24 Jan 2022 20:41:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9ADF6C340E7;
        Mon, 24 Jan 2022 20:41:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643056905;
        bh=u56yJa6/B5ipNGduQHjOcZv8irApVmodvGSAzEzLbG8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oxquHIc+EmjMhltB+vLjY3P7DyyexD+PbGmRcysqdv8bNJ0sXF+KTlsSAHn5LSELK
         f4i9yIcgrUYYHPB1wcjuE0VHshYNF3Z9F+BdW7BzYhNJ0opqTH+j6/JA/BRvifusx8
         xgyN2fVAaBGwSFqa8YoF4z156LppOTYGdYVPqdWs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 638/846] dm: fix alloc_dax error handling in alloc_dev
Date:   Mon, 24 Jan 2022 19:42:35 +0100
Message-Id: <20220124184123.035154111@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
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
index 76d9da49fda75..671bb454f1649 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1794,8 +1794,10 @@ static struct mapped_device *alloc_dev(int minor)
 	if (IS_ENABLED(CONFIG_DAX_DRIVER)) {
 		md->dax_dev = alloc_dax(md, md->disk->disk_name,
 					&dm_dax_ops, 0);
-		if (IS_ERR(md->dax_dev))
+		if (IS_ERR(md->dax_dev)) {
+			md->dax_dev = NULL;
 			goto bad;
+		}
 	}
 
 	format_dev_t(md->name, MKDEV(_major, minor));
-- 
2.34.1



