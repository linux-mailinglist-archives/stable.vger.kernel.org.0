Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A41B5657D30
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:40:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233940AbiL1PkZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:40:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233121AbiL1PkY (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:40:24 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10E34167DF
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:40:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A293061562
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:40:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B97AC433EF;
        Wed, 28 Dec 2022 15:40:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672242023;
        bh=lay2NtNrmRw2kZWDmZ2ZRMpRUVc1q6hf+jpHMRQQtmI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L0UVGMmhoyUm3QWNWZzTJsAh0S4DaPKbqeqJUD1c9x748A96FRR1ZafKEM+/1Prhe
         vyiQOzSWxAmDWRkp8ZLZiEHe4fLz9s4CyQE1WfLa3jxm208mvs2mMlqO7bvmOSoy1I
         DQrkakfs0Qe/JO5gBD7LdpcstPlythqyHMeI2UUY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Miaoqian Lin <linmq006@gmail.com>,
        Andrew Donnellan <ajd@linux.ibm.com>,
        Frederic Barrat <fbarrat@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 554/731] cxl: Fix refcount leak in cxl_calc_capp_routing
Date:   Wed, 28 Dec 2022 15:41:01 +0100
Message-Id: <20221228144312.597136454@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miaoqian Lin <linmq006@gmail.com>

[ Upstream commit 1d09697ff22908ae487fc8c4fbde1811732be523 ]

of_get_next_parent() returns a node pointer with refcount incremented,
we should use of_node_put() on it when not need anymore.
This function only calls of_node_put() in normal path,
missing it in the error path.
Add missing of_node_put() to avoid refcount leak.

Fixes: f24be42aab37 ("cxl: Add psl9 specific code")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Acked-by: Andrew Donnellan <ajd@linux.ibm.com>
Acked-by: Frederic Barrat <fbarrat@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20220605060038.62217-1-linmq006@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/cxl/pci.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/misc/cxl/pci.c b/drivers/misc/cxl/pci.c
index 0ac3f4cb88ac..d183836d80e3 100644
--- a/drivers/misc/cxl/pci.c
+++ b/drivers/misc/cxl/pci.c
@@ -387,6 +387,7 @@ int cxl_calc_capp_routing(struct pci_dev *dev, u64 *chipid,
 	rc = get_phb_index(np, phb_index);
 	if (rc) {
 		pr_err("cxl: invalid phb index\n");
+		of_node_put(np);
 		return rc;
 	}
 
-- 
2.35.1



