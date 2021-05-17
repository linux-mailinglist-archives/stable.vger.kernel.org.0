Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D73FB383466
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 17:11:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242908AbhEQPI0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 11:08:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:46224 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242023AbhEQPGZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 11:06:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4DF2E61C1C;
        Mon, 17 May 2021 14:29:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621261743;
        bh=VV7ARd4sADhy2SCdqI5J0ibwDpbU0nxrrWrcwu9aO+s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i6gki0oEv4nQ/Boh+1pnf/IRYSfWL7mgsEUs6Y3o7uansmbqe2z5Z3fyVfqdNnvvK
         J4LIrgt/LFUF7Jd3mzfOYCfiooceDKjxk2tQSXYf9wc5vgBUkGItZDotBPYtngzxqd
         19oOIllu2ID7uh5CQ+UQkKjTawNr28jlFJsxu+Kc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zheng Yongjun <zhengyongjun3@huawei.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 158/329] dma: idxd: use DEFINE_MUTEX() for mutex lock
Date:   Mon, 17 May 2021 16:01:09 +0200
Message-Id: <20210517140307.471371707@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140302.043055203@linuxfoundation.org>
References: <20210517140302.043055203@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zheng Yongjun <zhengyongjun3@huawei.com>

[ Upstream commit e2fcd6e427c2fae92b366b24759f95d77b6f7bc7 ]

mutex lock can be initialized automatically with DEFINE_MUTEX()
rather than explicitly calling mutex_init().

Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
Acked-by: Dave Jiang <dave.jiang@intel.com>
Link: https://lore.kernel.org/r/20201224132254.30961-1-zhengyongjun3@huawei.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/idxd/init.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/dma/idxd/init.c b/drivers/dma/idxd/init.c
index ababd059da6f..d223242a34f4 100644
--- a/drivers/dma/idxd/init.c
+++ b/drivers/dma/idxd/init.c
@@ -31,7 +31,7 @@ MODULE_AUTHOR("Intel Corporation");
 bool support_enqcmd;
 
 static struct idr idxd_idrs[IDXD_TYPE_MAX];
-static struct mutex idxd_idr_lock;
+static DEFINE_MUTEX(idxd_idr_lock);
 
 static struct pci_device_id idxd_pci_tbl[] = {
 	/* DSA ver 1.0 platforms */
@@ -543,7 +543,6 @@ static int __init idxd_init_module(void)
 	else
 		support_enqcmd = true;
 
-	mutex_init(&idxd_idr_lock);
 	for (i = 0; i < IDXD_TYPE_MAX; i++)
 		idr_init(&idxd_idrs[i]);
 
-- 
2.30.2



