Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 219CD603F65
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 11:31:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233712AbiJSJbk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 05:31:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233789AbiJSJ31 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 05:29:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86138EAC85;
        Wed, 19 Oct 2022 02:12:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EE86A61826;
        Wed, 19 Oct 2022 08:55:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F059C433D6;
        Wed, 19 Oct 2022 08:55:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666169716;
        bh=94Vil/zmhvmsJ0iy/6ZnYelSEc/3VoLdzE2dwZt/+lw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GS5yOWPNqSSMGvu8AwFZ3YCb8tv7gda4bthxA/1wKG5kZJ7pqjQQE6NsH+a01HRzm
         6TDhRn/uqtrx51Sn8d88NEXvgM7/PkirNIka8NZFS/GgfNsW8Pfig+n4cIPY18dHMT
         oqg3Lh6uaofJHidasvUnOqk8BTnJNsviLezFw8S4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        Taras Chornyi <tchornyi@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 338/862] net: prestera: acl: Add check for kmemdup
Date:   Wed, 19 Oct 2022 10:27:05 +0200
Message-Id: <20221019083304.999767544@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index 3d4b85f2d541..f6b2933859d0 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_acl.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_acl.c
@@ -178,10 +178,14 @@ prestera_acl_ruleset_create(struct prestera_acl *acl,
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
index 03fc5b9dc925..131bfbc87cd7 100644
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
index 19d3b55c578e..cf551a8379ac 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_flower.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_flower.c
@@ -452,7 +452,9 @@ int prestera_flower_tmplt_create(struct prestera_flow_block *block,
 	}
 
 	/* preserve keymask/template to this ruleset */
-	prestera_acl_ruleset_keymask_set(ruleset, rule.re_key.match.mask);
+	err = prestera_acl_ruleset_keymask_set(ruleset, rule.re_key.match.mask);
+	if (err)
+		goto err_ruleset_keymask_set;
 
 	/* skip error, as it is not possible to reject template operation,
 	 * so, keep the reference to the ruleset for rules to be added
@@ -468,6 +470,8 @@ int prestera_flower_tmplt_create(struct prestera_flow_block *block,
 	list_add_rcu(&template->list, &block->template_list);
 	return 0;
 
+err_ruleset_keymask_set:
+	prestera_acl_ruleset_put(ruleset);
 err_ruleset_get:
 	kfree(template);
 err_malloc:
-- 
2.35.1



