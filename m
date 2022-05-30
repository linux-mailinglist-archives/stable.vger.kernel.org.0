Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B67FF537D08
	for <lists+stable@lfdr.de>; Mon, 30 May 2022 15:41:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237519AbiE3Ngt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 May 2022 09:36:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237807AbiE3Nfq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 May 2022 09:35:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B96F954A3;
        Mon, 30 May 2022 06:28:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 00E3B60EE0;
        Mon, 30 May 2022 13:28:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F02FC3411E;
        Mon, 30 May 2022 13:28:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653917337;
        bh=rtHzjj2GFfazvNSR27w6EM4Oeo2YGiREyRIw+vC3rmw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CfhHlIubqgFaQ26qsyBBX62m3uUuaZOte+nyDQrtvU0kR0r3p2I0BJciH3Ns0Qr5f
         yK/wxJDDQv2V9UzkOx0cAD4sltESdVhYyPq+dxhYOhb9hLdfApa9YR8nKu1vVwHPz/
         0xPub9zkzr4ZlY8sjZdhxdIrm0EDe43j81/eZQeDXSW9D0MKd3mVashrunh2ZFoeVd
         VkdjfNCojlvxJs0Kb/3hyNQLoZQmNg/otb8a6TAgtGV8H/QzFeHj8DVP1MKp5OiuyQ
         poJvranirpFe9McO15yC3QhtE47ly5kgW556iAyE+1Mv8DcgqLNtYClyiVdoMQg3Iz
         twcy4lVXuinVQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Christian Brauner <christian.brauner@ubuntu.com>,
        Seth Forshee <seth.forshee@digitalocean.com>,
        Christoph Hellwig <hch@lst.de>,
        Al Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org,
        Christian Brauner <brauner@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.18 101/159] fs: hold writers when changing mount's idmapping
Date:   Mon, 30 May 2022 09:23:26 -0400
Message-Id: <20220530132425.1929512-101-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220530132425.1929512-1-sashal@kernel.org>
References: <20220530132425.1929512-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christian Brauner <christian.brauner@ubuntu.com>

[ Upstream commit e1bbcd277a53e08d619ffeec56c5c9287f2bf42f ]

Hold writers when changing a mount's idmapping to make it more robust.

The vfs layer takes care to retrieve the idmapping of a mount once
ensuring that the idmapping used for vfs permission checking is
identical to the idmapping passed down to the filesystem.

For ioctl codepaths the filesystem itself is responsible for taking the
idmapping into account if they need to. While all filesystems with
FS_ALLOW_IDMAP raised take the same precautions as the vfs we should
enforce it explicitly by making sure there are no active writers on the
relevant mount while changing the idmapping.

This is similar to turning a mount ro with the difference that in
contrast to turning a mount ro changing the idmapping can only ever be
done once while a mount can transition between ro and rw as much as it
wants.

This is a minor user-visible change. But it is extremely unlikely to
matter. The caller must've created a detached mount via OPEN_TREE_CLONE
and then handed that O_PATH fd to another process or thread which then
must've gotten a writable fd for that mount and started creating files
in there while the caller is still changing mount properties. While not
impossible it will be an extremely rare corner-case and should in
general be considered a bug in the application. Consider making a mount
MOUNT_ATTR_NOEXEC or MOUNT_ATTR_NODEV while allowing someone else to
perform lookups or exec'ing in parallel by handing them a copy of the
OPEN_TREE_CLONE fd or another fd beneath that mount.

Link: https://lore.kernel.org/r/20220510095840.152264-1-brauner@kernel.org
Cc: Seth Forshee <seth.forshee@digitalocean.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org
Signed-off-by: Christian Brauner (Microsoft) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/namespace.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index afe2b64b14f1..41461f55c039 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -4026,8 +4026,9 @@ static int can_idmap_mount(const struct mount_kattr *kattr, struct mount *mnt)
 static inline bool mnt_allow_writers(const struct mount_kattr *kattr,
 				     const struct mount *mnt)
 {
-	return !(kattr->attr_set & MNT_READONLY) ||
-	       (mnt->mnt.mnt_flags & MNT_READONLY);
+	return (!(kattr->attr_set & MNT_READONLY) ||
+		(mnt->mnt.mnt_flags & MNT_READONLY)) &&
+	       !kattr->mnt_userns;
 }
 
 static int mount_setattr_prepare(struct mount_kattr *kattr, struct mount *mnt)
-- 
2.35.1

