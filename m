Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C8FF6AEFEB
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:28:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233015AbjCGS1t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:27:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232658AbjCGS0k (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:26:40 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 774069FE57
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:20:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id DA1A2CE1C8B
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:20:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA1DBC433D2;
        Tue,  7 Mar 2023 18:20:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678213239;
        bh=V5JZlLOhCSOG5H+xZRDw0QXOabOtSOhHsuxVANlYX6U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r5yDPbS8Ae9SXsEBv5OrPlgXkB2CcY7RxQwDL9gwSm6zodAoD7DwzVyi/Mf3geV/Z
         E3yWD2KllkXpgV2JI5bzWNJtJUqjg502L9TZy/lxL/opPHM5OcoRUkL8aqm8i84tuh
         hZiOqAvBNgk2sehMs6zO254YyZ22r0s7laHguEZA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, "Rafael J. Wysocki" <rafael@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 413/885] kobject: modify kobject_get_path() to take a const *
Date:   Tue,  7 Mar 2023 17:55:47 +0100
Message-Id: <20230307170020.370274738@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
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
index 57fb972fea05b..592f9785b058a 100644
--- a/include/linux/kobject.h
+++ b/include/linux/kobject.h
@@ -115,7 +115,7 @@ extern void kobject_put(struct kobject *kobj);
 extern const void *kobject_namespace(struct kobject *kobj);
 extern void kobject_get_ownership(struct kobject *kobj,
 				  kuid_t *uid, kgid_t *gid);
-extern char *kobject_get_path(struct kobject *kobj, gfp_t flag);
+extern char *kobject_get_path(const struct kobject *kobj, gfp_t flag);
 
 struct kobj_type {
 	void (*release)(struct kobject *kobj);
diff --git a/lib/kobject.c b/lib/kobject.c
index a0b2dbfcfa233..0380ec889a6af 100644
--- a/lib/kobject.c
+++ b/lib/kobject.c
@@ -94,10 +94,10 @@ static int create_dir(struct kobject *kobj)
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
@@ -112,9 +112,9 @@ static int get_kobj_path_length(struct kobject *kobj)
 	return length;
 }
 
-static void fill_kobj_path(struct kobject *kobj, char *path, int length)
+static void fill_kobj_path(const struct kobject *kobj, char *path, int length)
 {
-	struct kobject *parent;
+	const struct kobject *parent;
 
 	--length;
 	for (parent = kobj; parent; parent = parent->parent) {
@@ -136,7 +136,7 @@ static void fill_kobj_path(struct kobject *kobj, char *path, int length)
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



