Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73994608704
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 09:55:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232141AbiJVHzs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 03:55:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232184AbiJVHyV (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 03:54:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BF402CA7E3;
        Sat, 22 Oct 2022 00:47:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5298260B00;
        Sat, 22 Oct 2022 07:46:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A3BFC433D7;
        Sat, 22 Oct 2022 07:46:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666424816;
        bh=jn6U7cWk9g7ErLccI+E2jIRBBJZlYMN6lO4atQmarNQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wQ2G5z1QLAc2Fe29X6w6XD8ovLfP6U3rF8of2tJfWtC6JZQGZJf9X0oc7e9ieHGZw
         OmAwAGOmJ3pB/50SdQZRZTWfE3x2vbGTU8yUM9MaSu3JG7JBYalbWPOmPjzibRg/Xt
         U/76Pe1rtwk8yk5IML2ppBTnxIujCxE7DVIRSxNY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        Taras Chornyi <tchornyi@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 287/717] net: prestera: acl: Add check for kmemdup
Date:   Sat, 22 Oct 2022 09:22:46 +0200
Message-Id: <20221022072504.324321512@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221022072415.034382448@linuxfoundation.org>
References: <20221022072415.034382448@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiasheng Jiang <jiasheng@iscas.ac.cn>

[ Upstream commit 9e6fd874c7bb47b6a4295abc4c81b2f41b97e970 ]

As the kemdup could return NULL, it should be better to check the return
value and return error if fails.
Moreover, the return value of prestera_acl_ruleset_keymask_set() should
be checked by cascade.

Fixes: 604ba230902d ("net: prestera: flower template support")
Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
Reviewed-by: Taras Chornyi<tchornyi@marvell.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/prestera/prestera_acl.c    | 8 ++++++--
 drivers/net/ethernet/marvell/prestera/prestera_acl.h    | 4 ++--
 drivers/net/ethernet/marvell/prestera/prestera_flower.c | 6 +++++-
 3 files changed, 13 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/marvell/prestera/prestera_acl.c b/drivers/net/ethernet/marvell/prestera/prestera_acl.c
index 3a141f2db812..c0d4ddc18f87 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_acl.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_acl.c
@@ -162,10 +162,14 @@ prestera_acl_ruleset_create(struct prestera_acl *acl,
 	return ERR_PTR(err);
 }
 
-void prestera_acl_ruleset_keymask_set(struct prestera_acl_ruleset *ruleset,
-				      void *keymask)
+int prestera_acl_ruleset_keymask_set(struct prestera_acl_ruleset *ruleset,
+				     void *keymask)
 {
 	ruleset->keymask = kmemdup(keymask, ACL_KEYMASK_SIZE, GFP_KERNEL);
+	if (!ruleset->keymask)
+		return -ENOMEM;
+
+	return 0;
 }
 
 int prestera_acl_ruleset_offload(struct prestera_acl_ruleset *ruleset)
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_acl.h b/drivers/net/ethernet/marvell/prestera/prestera_acl.h
index f963e1e0c0f0..21dbfe4fe5b8 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_acl.h
+++ b/drivers/net/ethernet/marvell/prestera/prestera_acl.h
@@ -185,8 +185,8 @@ struct prestera_acl_ruleset *
 prestera_acl_ruleset_lookup(struct prestera_acl *acl,
 			    struct prestera_flow_block *block,
 			    u32 chain_index);
-void prestera_acl_ruleset_keymask_set(struct prestera_acl_ruleset *ruleset,
-				      void *keymask);
+int prestera_acl_ruleset_keymask_set(struct prestera_acl_ruleset *ruleset,
+				     void *keymask);
 bool prestera_acl_ruleset_is_offload(struct prestera_acl_ruleset *ruleset);
 int prestera_acl_ruleset_offload(struct prestera_acl_ruleset *ruleset);
 void prestera_acl_ruleset_put(struct prestera_acl_ruleset *ruleset);
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_flower.c b/drivers/net/ethernet/marvell/prestera/prestera_flower.c
index 4d93ad6a284c..553413248823 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_flower.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_flower.c
@@ -428,7 +428,9 @@ int prestera_flower_tmplt_create(struct prestera_flow_block *block,
 	}
 
 	/* preserve keymask/template to this ruleset */
-	prestera_acl_ruleset_keymask_set(ruleset, rule.re_key.match.mask);
+	err = prestera_acl_ruleset_keymask_set(ruleset, rule.re_key.match.mask);
+	if (err)
+		goto err_ruleset_keymask_set;
 
 	/* skip error, as it is not possible to reject template operation,
 	 * so, keep the reference to the ruleset for rules to be added
@@ -444,6 +446,8 @@ int prestera_flower_tmplt_create(struct prestera_flow_block *block,
 	list_add_rcu(&template->list, &block->template_list);
 	return 0;
 
+err_ruleset_keymask_set:
+	prestera_acl_ruleset_put(ruleset);
 err_ruleset_get:
 	kfree(template);
 err_malloc:
-- 
2.35.1



