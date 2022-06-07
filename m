Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 174FD541DE7
	for <lists+stable@lfdr.de>; Wed,  8 Jun 2022 00:22:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381834AbiFGWW2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 18:22:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349103AbiFGWVm (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 18:21:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5442B26A0AA;
        Tue,  7 Jun 2022 12:21:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 93B9EB823CC;
        Tue,  7 Jun 2022 19:21:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DED30C385A2;
        Tue,  7 Jun 2022 19:21:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654629708;
        bh=6OCOup2jxFyPMio7PTP0EyiHgfEdOVgowN2xRnYuOhg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QUB9u7E6oBTPwvJe4iDcgWpvAq8D64LoONgthKOXqOFA5oSQACn4RvgtgC456FWyN
         k/r750sgFM7MZFL8qT670OVK0KLht7MvtYOrIBYQ94Mg6XRtioWgj1ORA1tkwVafjz
         wYH52W1k5SLXsLjqo3ju4VXcylPM5ZOh3vCVXf2k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paul Moore <paul@paul-moore.com>,
        =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>
Subject: [PATCH 5.18 788/879] landlock: Reduce the maximum number of layers to 16
Date:   Tue,  7 Jun 2022 19:05:06 +0200
Message-Id: <20220607165025.739544729@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Mickaël Salaün <mic@digikod.net>

commit 75c542d6c6cc48720376862d5496d51509160dfd upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/userspace-api/landlock.rst   |    4 ++--
 security/landlock/fs.c                     |   17 +++++++----------
 security/landlock/limits.h                 |    2 +-
 security/landlock/ruleset.h                |    4 ++++
 tools/testing/selftests/landlock/fs_test.c |    2 +-
 5 files changed, 15 insertions(+), 14 deletions(-)

--- a/Documentation/userspace-api/landlock.rst
+++ b/Documentation/userspace-api/landlock.rst
@@ -267,8 +267,8 @@ restrict such paths with dedicated rules
 Ruleset layers
 --------------
 
-There is a limit of 64 layers of stacked rulesets.  This can be an issue for a
-task willing to enforce a new ruleset in complement to its 64 inherited
+There is a limit of 16 layers of stacked rulesets.  This can be an issue for a
+task willing to enforce a new ruleset in complement to its 16 inherited
 rulesets.  Once this limit is reached, sys_landlock_restrict_self() returns
 E2BIG.  It is then strongly suggested to carefully build rulesets once in the
 life of a thread, especially for applications able to launch other applications
--- a/security/landlock/fs.c
+++ b/security/landlock/fs.c
@@ -183,10 +183,10 @@ int landlock_append_fs_rule(struct landl
 
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
@@ -212,11 +212,11 @@ static inline u64 unmask_layers(const st
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
@@ -231,12 +231,9 @@ static int check_access_path(const struc
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
--- a/security/landlock/limits.h
+++ b/security/landlock/limits.h
@@ -15,7 +15,7 @@
 
 /* clang-format off */
 
-#define LANDLOCK_MAX_NUM_LAYERS		64
+#define LANDLOCK_MAX_NUM_LAYERS		16
 #define LANDLOCK_MAX_NUM_RULES		U32_MAX
 
 #define LANDLOCK_LAST_ACCESS_FS		LANDLOCK_ACCESS_FS_MAKE_SYM
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
--- a/tools/testing/selftests/landlock/fs_test.c
+++ b/tools/testing/selftests/landlock/fs_test.c
@@ -1159,7 +1159,7 @@ TEST_F_FORK(layout1, max_layers)
 	const int ruleset_fd = create_ruleset(_metadata, ACCESS_RW, rules);
 
 	ASSERT_LE(0, ruleset_fd);
-	for (i = 0; i < 64; i++)
+	for (i = 0; i < 16; i++)
 		enforce_ruleset(_metadata, ruleset_fd);
 
 	for (i = 0; i < 2; i++) {


