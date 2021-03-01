Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFAC43288F9
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 18:52:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231908AbhCARrl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 12:47:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:33834 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238384AbhCARm2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 12:42:28 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C5FEB650D0;
        Mon,  1 Mar 2021 16:57:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614617836;
        bh=uGqG15nqGHgs+ORqH5Fco4ZMe5TNrzHzNyyYcZk2gCw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V3Gmdmx998FCX9id/L/AEMcH9kzlzstI02wRCgeCDmplvd1FJbVghK7vF0FX86lX1
         ptMAuzKW+mm3VUk3JWKrwnkwiBBCRCiZAJ2+BE7sp9ChmYsnEpAAFTWJA3yJ47++7H
         csqbFFOfCzR80oaheGWh7vcZWp0JitSrJF3ZNPoo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 213/340] nvmem: core: Fix a resource leak on error in nvmem_add_cells_from_of()
Date:   Mon,  1 Mar 2021 17:12:37 +0100
Message-Id: <20210301161058.784412623@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161048.294656001@linuxfoundation.org>
References: <20210301161048.294656001@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 72e008ce307fa2f35f6783997378b32e83122839 ]

This doesn't call of_node_put() on the error path so it leads to a
memory leak.

Fixes: 0749aa25af82 ("nvmem: core: fix regression in of_nvmem_cell_get()")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/20210129171430.11328-2-srinivas.kandagatla@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvmem/core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/nvmem/core.c b/drivers/nvmem/core.c
index 84f4078216a36..acd82ff41951f 100644
--- a/drivers/nvmem/core.c
+++ b/drivers/nvmem/core.c
@@ -345,6 +345,7 @@ static int nvmem_add_cells_from_of(struct nvmem_device *nvmem)
 				cell->name, nvmem->stride);
 			/* Cells already added will be freed later. */
 			kfree_const(cell->name);
+			of_node_put(cell->np);
 			kfree(cell);
 			return -EINVAL;
 		}
-- 
2.27.0



