Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B47E1561DAA
	for <lists+stable@lfdr.de>; Thu, 30 Jun 2022 16:17:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236446AbiF3OK4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jun 2022 10:10:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236852AbiF3OK0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Jun 2022 10:10:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A61B7B35C;
        Thu, 30 Jun 2022 06:55:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 80DD4B82AFB;
        Thu, 30 Jun 2022 13:55:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E10B3C34115;
        Thu, 30 Jun 2022 13:55:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656597331;
        bh=fGlnseJ722jXkAQ2+uH9wr7jdYdDgZ7IEsL3r8igi5Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k2HyfPkbQRVJnNH8XHOdO96rOZiyErhyIjcFR4X2Jfv3XhyWLqHqY9gKeYe/eZY9R
         9ga7TJfom6j5rLIHef+PUfyDWAXhTvMAbq/ItoEhvTHI27cX8yGZ8FYAPul9mitXXy
         CaQD/4iEHUiskd8Jo7CoGf+v96A8k/7iopJGI3fE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Seth Forshee <sforshee@digitalocean.com>,
        Christoph Hellwig <hch@lst.de>,
        Al Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        "Christian Brauner (Microsoft)" <brauner@kernel.org>
Subject: [PATCH 5.15 19/28] fs: remove unused low-level mapping helpers
Date:   Thu, 30 Jun 2022 15:47:15 +0200
Message-Id: <20220630133233.494120903@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220630133232.926711493@linuxfoundation.org>
References: <20220630133232.926711493@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christian Brauner <christian.brauner@ubuntu.com>

commit 02e4079913500f24ceb082d8d87d8665f044b298 upstream.

Now that we ported all places to use the new low-level mapping helpers
that are able to support filesystems mounted with an idmapping we can
remove the old low-level mapping helpers. With the removal of these old
helpers we also conclude the renaming of the mapping helpers we started
in commit a65e58e791a1 ("fs: document and rename fsid helpers").

Link: https://lore.kernel.org/r/20211123114227.3124056-8-brauner@kernel.org (v1)
Link: https://lore.kernel.org/r/20211130121032.3753852-8-brauner@kernel.org (v2)
Link: https://lore.kernel.org/r/20211203111707.3901969-8-brauner@kernel.org
Cc: Seth Forshee <sforshee@digitalocean.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>
CC: linux-fsdevel@vger.kernel.org
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Reviewed-by: Seth Forshee <sforshee@digitalocean.com>
Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
Signed-off-by: Christian Brauner (Microsoft) <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/mnt_idmapping.h |   56 ------------------------------------------
 1 file changed, 56 deletions(-)

--- a/include/linux/mnt_idmapping.h
+++ b/include/linux/mnt_idmapping.h
@@ -14,62 +14,6 @@ struct user_namespace;
 extern struct user_namespace init_user_ns;
 
 /**
- * kuid_into_mnt - map a kuid down into a mnt_userns
- * @mnt_userns: user namespace of the relevant mount
- * @kuid: kuid to be mapped
- *
- * Return: @kuid mapped according to @mnt_userns.
- * If @kuid has no mapping INVALID_UID is returned.
- */
-static inline kuid_t kuid_into_mnt(struct user_namespace *mnt_userns,
-				   kuid_t kuid)
-{
-	return make_kuid(mnt_userns, __kuid_val(kuid));
-}
-
-/**
- * kgid_into_mnt - map a kgid down into a mnt_userns
- * @mnt_userns: user namespace of the relevant mount
- * @kgid: kgid to be mapped
- *
- * Return: @kgid mapped according to @mnt_userns.
- * If @kgid has no mapping INVALID_GID is returned.
- */
-static inline kgid_t kgid_into_mnt(struct user_namespace *mnt_userns,
-				   kgid_t kgid)
-{
-	return make_kgid(mnt_userns, __kgid_val(kgid));
-}
-
-/**
- * kuid_from_mnt - map a kuid up into a mnt_userns
- * @mnt_userns: user namespace of the relevant mount
- * @kuid: kuid to be mapped
- *
- * Return: @kuid mapped up according to @mnt_userns.
- * If @kuid has no mapping INVALID_UID is returned.
- */
-static inline kuid_t kuid_from_mnt(struct user_namespace *mnt_userns,
-				   kuid_t kuid)
-{
-	return KUIDT_INIT(from_kuid(mnt_userns, kuid));
-}
-
-/**
- * kgid_from_mnt - map a kgid up into a mnt_userns
- * @mnt_userns: user namespace of the relevant mount
- * @kgid: kgid to be mapped
- *
- * Return: @kgid mapped up according to @mnt_userns.
- * If @kgid has no mapping INVALID_GID is returned.
- */
-static inline kgid_t kgid_from_mnt(struct user_namespace *mnt_userns,
-				   kgid_t kgid)
-{
-	return KGIDT_INIT(from_kgid(mnt_userns, kgid));
-}
-
-/**
  * initial_idmapping - check whether this is the initial mapping
  * @ns: idmapping to check
  *


