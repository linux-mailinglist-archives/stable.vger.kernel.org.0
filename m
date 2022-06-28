Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDC8F55D71F
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:17:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345436AbiF1MQl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jun 2022 08:16:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345462AbiF1MQk (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Jun 2022 08:16:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B45B23BCA
        for <stable@vger.kernel.org>; Tue, 28 Jun 2022 05:16:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ACE0860FFB
        for <stable@vger.kernel.org>; Tue, 28 Jun 2022 12:16:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E9B5C341CA;
        Tue, 28 Jun 2022 12:16:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656418599;
        bh=CUQxWBZm3SKGIKYziSNIFQ8eKn4eAlZZ/kLsxZdOKJA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ll01/ZsQSd4TmxfW60QGcF3/G/+svYuPfueMkCUEEa4Xs5M7w1pS8cQYASuSBBap9
         meD3tJidppYwXEkBR+3kFEvds/EKXOeWfTut/EcYBclk4lBmtuIgvaI+H6AJHTCkRq
         XCFiJXZkXqMBF13Vh7gDigI8KF6jYd4pr7FNrFlBmqrxGUOGm07RFp93bAciSYbTIz
         S0ZnL4QzknVcqqgutX27yMBVoJmuIvcq/mDQljG3DzNAArKEcVqf8ZoR9t1iBMQ9kG
         mIUeie4poRsh7zAJtpLBrbB5O5I9Y6bnPxEOyAI4d+9vodZ+CcIEAjKSJ3XSPI9z4Q
         mzsKFC4/vSKGQ==
From:   Christian Brauner <brauner@kernel.org>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Christian Brauner <christian.brauner@ubuntu.com>,
        stable@vger.kernel.org
Subject: [PATCH 07/12] fs: remove unused low-level mapping helpers
Date:   Tue, 28 Jun 2022 14:16:15 +0200
Message-Id: <20220628121620.188722-8-brauner@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220628102244.wymkrob3cfys2h7i@wittgenstein>
References: <20220628121620.188722-1-brauner@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3247; i=brauner@kernel.org; h=from:subject; bh=OYr+RsYI2O8OZ2wdpiz81d3MT7XVxvAmQN62FL8C2sg=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMSTt+sifZF+Z+Hzm22PFnzuOC1zK2/fy1rZpgs+lfsuaN0Vf Lkqc0lHKwiDGxSArpsji0G4SLrecp2KzUaYGzBxWJpAhDFycAjCRv/YM/4Mui3kL26zp26q7vdjai9 nZuv3CN9XVK7fPLbjbHzjjfwfDf091rmVTOO6ZNc4r3bjn6TL5IgMzp7Qw/g9cgalXGR0uMwEA
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
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
---
 include/linux/mnt_idmapping.h | 56 -----------------------------------
 1 file changed, 56 deletions(-)

diff --git a/include/linux/mnt_idmapping.h b/include/linux/mnt_idmapping.h
index 60341cd33ccc..0c6ab3f4c952 100644
--- a/include/linux/mnt_idmapping.h
+++ b/include/linux/mnt_idmapping.h
@@ -13,62 +13,6 @@ struct user_namespace;
  */
 extern struct user_namespace init_user_ns;
 
-/**
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
 /**
  * initial_idmapping - check whether this is the initial mapping
  * @ns: idmapping to check
-- 
2.34.1

