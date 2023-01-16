Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5A8D66CB03
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 18:09:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234088AbjAPRJk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 12:09:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234104AbjAPRJP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 12:09:15 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53EBE2A155
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:49:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0D598B81071
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:49:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61D6AC433EF;
        Mon, 16 Jan 2023 16:49:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673887786;
        bh=en2jGy1xQN3/Rhn4olc+0g//kDeJFvf0dMtG0eBM5yQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WfiMqrE3orUQqqofLKqzC4vZ8uknjtCAnLVHGqdSaJo29B/4bqMtsfxfi+LwvDF+H
         jqgLO67gYJEi/K2rCPDe4KiaUkKJHViW7BW7gTXiiD2IH8DT159d8OscL2RisRI25E
         zoOsL/6ngjiE6olnq1QprBx7yYG+4ahcflTJ7p6s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Miaoqian Lin <linmq006@gmail.com>,
        Andrew Donnellan <ajd@linux.ibm.com>,
        Frederic Barrat <fbarrat@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 281/521] cxl: Fix refcount leak in cxl_calc_capp_routing
Date:   Mon, 16 Jan 2023 16:49:03 +0100
Message-Id: <20230116154859.724360378@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154847.246743274@linuxfoundation.org>
References: <20230116154847.246743274@linuxfoundation.org>
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
index acb4a339f5fe..8dbb1998c312 100644
--- a/drivers/misc/cxl/pci.c
+++ b/drivers/misc/cxl/pci.c
@@ -391,6 +391,7 @@ int cxl_calc_capp_routing(struct pci_dev *dev, u64 *chipid,
 	rc = get_phb_index(np, phb_index);
 	if (rc) {
 		pr_err("cxl: invalid phb index\n");
+		of_node_put(np);
 		return rc;
 	}
 
-- 
2.35.1



