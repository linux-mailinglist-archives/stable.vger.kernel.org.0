Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D27E6AF43B
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 20:15:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233721AbjCGTPE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 14:15:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233712AbjCGTOl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 14:14:41 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C92F92263
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:58:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D48CCB819D0
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:58:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E9B9C433D2;
        Tue,  7 Mar 2023 18:58:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678215496;
        bh=Gr6ITl5YURZoEGZKTpTytwqn985BylCEAgPKBZxGhHw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YP2NWpBEvTzmGUj8sVxfUI0rLer6pF8lm8rgP0VUUO9hPHnnVz3UyO7fzLjxlpmhl
         cIDIXhKHLoWTPbMDy4yMszEjF+LDyl0zJ1O4fcbpSfrUBV5uceJLcCdzWi8MetNxTe
         sTE+OL1rVHM7huD9C0QgTxztSZyOCra1gaXz4sMg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, "Rafael J. Wysocki" <rafael@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 280/567] kobject: modify kobject_get_path() to take a const *
Date:   Tue,  7 Mar 2023 18:00:16 +0100
Message-Id: <20230307165918.035102796@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307165905.838066027@linuxfoundation.org>
References: <20230307165905.838066027@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

[ Upstream commit 33a0a1e3b3d17445832177981dc7a1c6a5b009f8 ]

kobject_get_path() does not modify the kobject passed to it, so make the
pointer constant.

Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Link: https://lore.kernel.org/r/20221001165315.2690141-1-gregkh@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 3bb2a01caa81 ("kobject: Fix slab-out-of-bounds in fill_kobj_path()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/kobject.h |  2 +-
 lib/kobject.c           | 10 +++++-----
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/include/linux/kobject.h b/include/linux/kobject.h
index ea30529fba08a..d38916e598a59 100644
--- a/include/linux/kobject.h
+++ b/include/linux/kobject.h
@@ -116,7 +116,7 @@ extern void kobject_put(struct kobject *kobj);
 extern const void *kobject_namespace(struct kobject *kobj);
 extern void kobject_get_ownership(struct kobject *kobj,
 				  kuid_t *uid, kgid_t *gid);
-extern char *kobject_get_path(struct kobject *kobj, gfp_t flag);
+extern char *kobject_get_path(const struct kobject *kobj, gfp_t flag);
 
 /**
  * kobject_has_children - Returns whether a kobject has children.
diff --git a/lib/kobject.c b/lib/kobject.c
index ea53b30cf4837..94ff7fd5d80bc 100644
--- a/lib/kobject.c
+++ b/lib/kobject.c
@@ -126,10 +126,10 @@ static int create_dir(struct kobject *kobj)
 	return 0;
 }
 
-static int get_kobj_path_length(struct kobject *kobj)
+static int get_kobj_path_length(const struct kobject *kobj)
 {
 	int length = 1;
-	struct kobject *parent = kobj;
+	const struct kobject *parent = kobj;
 
 	/* walk up the ancestors until we hit the one pointing to the
 	 * root.
@@ -144,9 +144,9 @@ static int get_kobj_path_length(struct kobject *kobj)
 	return length;
 }
 
-static void fill_kobj_path(struct kobject *kobj, char *path, int length)
+static void fill_kobj_path(const struct kobject *kobj, char *path, int length)
 {
-	struct kobject *parent;
+	const struct kobject *parent;
 
 	--length;
 	for (parent = kobj; parent; parent = parent->parent) {
@@ -168,7 +168,7 @@ static void fill_kobj_path(struct kobject *kobj, char *path, int length)
  *
  * Return: The newly allocated memory, caller must free with kfree().
  */
-char *kobject_get_path(struct kobject *kobj, gfp_t gfp_mask)
+char *kobject_get_path(const struct kobject *kobj, gfp_t gfp_mask)
 {
 	char *path;
 	int len;
-- 
2.39.2



