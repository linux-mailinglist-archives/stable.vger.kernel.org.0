Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 784BF66C82D
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:36:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233320AbjAPQgq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:36:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233488AbjAPQg1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:36:27 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3EB832508
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:25:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6F74EB8107D
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:25:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6BB8C433F0;
        Mon, 16 Jan 2023 16:25:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673886314;
        bh=lay2NtNrmRw2kZWDmZ2ZRMpRUVc1q6hf+jpHMRQQtmI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b94WI1zZ0wZG6QF0qE6jFdnrt5IOFgiO8u8M7bq4SvthPGLVEnoPIH3ixuzKm1Kgu
         5psY86geD1cTObzdFZXNEayC5WSUO9ZNmqp+WKhEWFbM9xx7K4m9SQNk1s6EVioXDP
         N29KKTM3GogNjCIDDBuF9AOxdyGD6L+bcC5iibjI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Miaoqian Lin <linmq006@gmail.com>,
        Andrew Donnellan <ajd@linux.ibm.com>,
        Frederic Barrat <fbarrat@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 354/658] cxl: Fix refcount leak in cxl_calc_capp_routing
Date:   Mon, 16 Jan 2023 16:47:22 +0100
Message-Id: <20230116154925.777032141@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
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



