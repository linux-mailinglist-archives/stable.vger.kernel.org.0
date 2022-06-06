Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBCD353E2CB
	for <lists+stable@lfdr.de>; Mon,  6 Jun 2022 10:55:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231469AbiFFHv1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Jun 2022 03:51:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231519AbiFFHv0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Jun 2022 03:51:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C846C17C1
        for <stable@vger.kernel.org>; Mon,  6 Jun 2022 00:51:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D7FDC611B4
        for <stable@vger.kernel.org>; Mon,  6 Jun 2022 07:51:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E605BC3411C;
        Mon,  6 Jun 2022 07:51:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654501884;
        bh=189WsCILZxDvfFX0aklDiB5ZECav7OaRPAodDn01SpM=;
        h=Subject:To:Cc:From:Date:From;
        b=LODKlz3Tvv2KInyn81IyRC8RAl+9ydi7ZXXqIf8vIQ4KP70tU0FzGOJL0pW0WLUcd
         4mo4efEuOULyJ61qCouVYiBHindkz6BNZEVZnarEdXqtUYhOgoiNmyBvMW678Q65ZQ
         JTPUSyDFIFXEjJL9slzqjEFuTu3TId0U9qJpoXWw=
Subject: WTF: patch "[PATCH] landlock: Create find_rule() from unmask_layers()" was seriously submitted to be applied to the 5.18-stable tree?
To:     mic@digikod.net, paul@paul-moore.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 06 Jun 2022 09:51:08 +0200
Message-ID: <1654501868219141@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The patch below was submitted to be applied to the 5.18-stable tree.

I fail to see how this patch meets the stable kernel rules as found at
Documentation/process/stable-kernel-rules.rst.

I could be totally wrong, and if so, please respond to 
<stable@vger.kernel.org> and let me know why this patch should be
applied.  Otherwise, it is now dropped from my patch queues, never to be
seen again.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 2cd7cd6eed88b8383cfddce589afe9c0ae1d19b4 Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>
Date: Fri, 6 May 2022 18:10:53 +0200
Subject: [PATCH] landlock: Create find_rule() from unmask_layers()
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This refactoring will be useful in a following commit.

Reviewed-by: Paul Moore <paul@paul-moore.com>
Link: https://lore.kernel.org/r/20220506161102.525323-4-mic@digikod.net
Cc: stable@vger.kernel.org
Signed-off-by: Mickaël Salaün <mic@digikod.net>

diff --git a/security/landlock/fs.c b/security/landlock/fs.c
index f48c0a3b1e75..20953bff8fd5 100644
--- a/security/landlock/fs.c
+++ b/security/landlock/fs.c
@@ -183,23 +183,36 @@ int landlock_append_fs_rule(struct landlock_ruleset *const ruleset,
 
 /* Access-control management */
 
-static inline layer_mask_t
-unmask_layers(const struct landlock_ruleset *const domain,
-	      const struct path *const path, const access_mask_t access_request,
-	      layer_mask_t layer_mask)
+/*
+ * The lifetime of the returned rule is tied to @domain.
+ *
+ * Returns NULL if no rule is found or if @dentry is negative.
+ */
+static inline const struct landlock_rule *
+find_rule(const struct landlock_ruleset *const domain,
+	  const struct dentry *const dentry)
 {
 	const struct landlock_rule *rule;
 	const struct inode *inode;
-	size_t i;
 
-	if (d_is_negative(path->dentry))
-		/* Ignore nonexistent leafs. */
-		return layer_mask;
-	inode = d_backing_inode(path->dentry);
+	/* Ignores nonexistent leafs. */
+	if (d_is_negative(dentry))
+		return NULL;
+
+	inode = d_backing_inode(dentry);
 	rcu_read_lock();
 	rule = landlock_find_rule(
 		domain, rcu_dereference(landlock_inode(inode)->object));
 	rcu_read_unlock();
+	return rule;
+}
+
+static inline layer_mask_t unmask_layers(const struct landlock_rule *const rule,
+					 const access_mask_t access_request,
+					 layer_mask_t layer_mask)
+{
+	size_t layer_level;
+
 	if (!rule)
 		return layer_mask;
 
@@ -210,8 +223,9 @@ unmask_layers(const struct landlock_ruleset *const domain,
 	 * the remaining layers for each inode, from the first added layer to
 	 * the last one.
 	 */
-	for (i = 0; i < rule->num_layers; i++) {
-		const struct landlock_layer *const layer = &rule->layers[i];
+	for (layer_level = 0; layer_level < rule->num_layers; layer_level++) {
+		const struct landlock_layer *const layer =
+			&rule->layers[layer_level];
 		const layer_mask_t layer_bit = BIT_ULL(layer->level - 1);
 
 		/* Checks that the layer grants access to the full request. */
@@ -269,8 +283,9 @@ static int check_access_path(const struct landlock_ruleset *const domain,
 	while (true) {
 		struct dentry *parent_dentry;
 
-		layer_mask = unmask_layers(domain, &walker_path, access_request,
-					   layer_mask);
+		layer_mask =
+			unmask_layers(find_rule(domain, walker_path.dentry),
+				      access_request, layer_mask);
 		if (layer_mask == 0) {
 			/* Stops when a rule from each layer grants access. */
 			allowed = true;

