Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A56153E2A0
	for <lists+stable@lfdr.de>; Mon,  6 Jun 2022 10:54:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231470AbiFFHvA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Jun 2022 03:51:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231509AbiFFHu6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Jun 2022 03:50:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC20ABBCCD
        for <stable@vger.kernel.org>; Mon,  6 Jun 2022 00:50:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 72E99B8115E
        for <stable@vger.kernel.org>; Mon,  6 Jun 2022 07:50:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D29F5C385A9;
        Mon,  6 Jun 2022 07:50:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654501855;
        bh=ImowYR75L/d8pAAiZ3S7M12ogyhRiBm7k5wDX6ng/08=;
        h=Subject:To:Cc:From:Date:From;
        b=h4vtJYRnCaTzv+rqf4U5+o8xKDPJBpnb5Fs/We/S2JYv7j6uEBPY6+7+100gg1FOU
         cF77GjlfCY/v9dMU+7jqwhUKLIoo5UQ0hmIeDsl8ONeuG4PKS/NOm8RbFv/XM67Jfr
         gE9vTVarUdUZTr4rpRRK81VfQVvDre5uRgarFx8Q=
Subject: WTF: patch "[PATCH] landlock: Reduce the maximum number of layers to 16" was seriously submitted to be applied to the 5.18-stable tree?
To:     mic@digikod.net, paul@paul-moore.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 06 Jun 2022 09:50:34 +0200
Message-ID: <1654501834220242@kroah.com>
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

From 75c542d6c6cc48720376862d5496d51509160dfd Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>
Date: Fri, 6 May 2022 18:10:52 +0200
Subject: [PATCH] landlock: Reduce the maximum number of layers to 16
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The maximum number of nested Landlock domains is currently 64.  Because
of the following fix and to help reduce the stack size, let's reduce it
to 16.  This seems large enough for a lot of use cases (e.g. sandboxed
init service, spawning a sandboxed SSH service, in nested sandboxed
containers).  Reducing the number of nested domains may also help to
discover misuse of Landlock (e.g. creating a domain per rule).

Add and use a dedicated layer_mask_t typedef to fit with the number of
layers.  This might be useful when changing it and to keep it consistent
with the maximum number of layers.

Reviewed-by: Paul Moore <paul@paul-moore.com>
Link: https://lore.kernel.org/r/20220506161102.525323-3-mic@digikod.net
Cc: stable@vger.kernel.org
Signed-off-by: Mickaël Salaün <mic@digikod.net>

diff --git a/Documentation/userspace-api/landlock.rst b/Documentation/userspace-api/landlock.rst
index f35552ff19ba..b68e7a51009f 100644
--- a/Documentation/userspace-api/landlock.rst
+++ b/Documentation/userspace-api/landlock.rst
@@ -267,8 +267,8 @@ restrict such paths with dedicated ruleset flags.
 Ruleset layers
 --------------
 
-There is a limit of 64 layers of stacked rulesets.  This can be an issue for a
-task willing to enforce a new ruleset in complement to its 64 inherited
+There is a limit of 16 layers of stacked rulesets.  This can be an issue for a
+task willing to enforce a new ruleset in complement to its 16 inherited
 rulesets.  Once this limit is reached, sys_landlock_restrict_self() returns
 E2BIG.  It is then strongly suggested to carefully build rulesets once in the
 life of a thread, especially for applications able to launch other applications
diff --git a/security/landlock/fs.c b/security/landlock/fs.c
index d4006add8bdf..f48c0a3b1e75 100644
--- a/security/landlock/fs.c
+++ b/security/landlock/fs.c
@@ -183,10 +183,10 @@ int landlock_append_fs_rule(struct landlock_ruleset *const ruleset,
 
 /* Access-control management */
 
-static inline u64 unmask_layers(const struct landlock_ruleset *const domain,
-				const struct path *const path,
-				const access_mask_t access_request,
-				u64 layer_mask)
+static inline layer_mask_t
+unmask_layers(const struct landlock_ruleset *const domain,
+	      const struct path *const path, const access_mask_t access_request,
+	      layer_mask_t layer_mask)
 {
 	const struct landlock_rule *rule;
 	const struct inode *inode;
@@ -212,11 +212,11 @@ static inline u64 unmask_layers(const struct landlock_ruleset *const domain,
 	 */
 	for (i = 0; i < rule->num_layers; i++) {
 		const struct landlock_layer *const layer = &rule->layers[i];
-		const u64 layer_level = BIT_ULL(layer->level - 1);
+		const layer_mask_t layer_bit = BIT_ULL(layer->level - 1);
 
 		/* Checks that the layer grants access to the full request. */
 		if ((layer->access & access_request) == access_request) {
-			layer_mask &= ~layer_level;
+			layer_mask &= ~layer_bit;
 
 			if (layer_mask == 0)
 				return layer_mask;
@@ -231,12 +231,9 @@ static int check_access_path(const struct landlock_ruleset *const domain,
 {
 	bool allowed = false;
 	struct path walker_path;
-	u64 layer_mask;
+	layer_mask_t layer_mask;
 	size_t i;
 
-	/* Make sure all layers can be checked. */
-	BUILD_BUG_ON(BITS_PER_TYPE(layer_mask) < LANDLOCK_MAX_NUM_LAYERS);
-
 	if (!access_request)
 		return 0;
 	if (WARN_ON_ONCE(!domain || !path))
diff --git a/security/landlock/limits.h b/security/landlock/limits.h
index 41372f22837f..17c2a2e7fe1e 100644
--- a/security/landlock/limits.h
+++ b/security/landlock/limits.h
@@ -15,7 +15,7 @@
 
 /* clang-format off */
 
-#define LANDLOCK_MAX_NUM_LAYERS		64
+#define LANDLOCK_MAX_NUM_LAYERS		16
 #define LANDLOCK_MAX_NUM_RULES		U32_MAX
 
 #define LANDLOCK_LAST_ACCESS_FS		LANDLOCK_ACCESS_FS_MAKE_SYM
diff --git a/security/landlock/ruleset.h b/security/landlock/ruleset.h
index 8d5717594931..521af2848951 100644
--- a/security/landlock/ruleset.h
+++ b/security/landlock/ruleset.h
@@ -23,6 +23,10 @@ typedef u16 access_mask_t;
 /* Makes sure all filesystem access rights can be stored. */
 static_assert(BITS_PER_TYPE(access_mask_t) >= LANDLOCK_NUM_ACCESS_FS);
 
+typedef u16 layer_mask_t;
+/* Makes sure all layers can be checked. */
+static_assert(BITS_PER_TYPE(layer_mask_t) >= LANDLOCK_MAX_NUM_LAYERS);
+
 /**
  * struct landlock_layer - Access rights for a given layer
  */
diff --git a/tools/testing/selftests/landlock/fs_test.c b/tools/testing/selftests/landlock/fs_test.c
index a8f54c4462eb..e13f046a172a 100644
--- a/tools/testing/selftests/landlock/fs_test.c
+++ b/tools/testing/selftests/landlock/fs_test.c
@@ -1159,7 +1159,7 @@ TEST_F_FORK(layout1, max_layers)
 	const int ruleset_fd = create_ruleset(_metadata, ACCESS_RW, rules);
 
 	ASSERT_LE(0, ruleset_fd);
-	for (i = 0; i < 64; i++)
+	for (i = 0; i < 16; i++)
 		enforce_ruleset(_metadata, ruleset_fd);
 
 	for (i = 0; i < 2; i++) {

