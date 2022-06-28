Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C426355DD77
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:27:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345233AbiF1MQb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jun 2022 08:16:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345384AbiF1MQa (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Jun 2022 08:16:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 080C323BCA
        for <stable@vger.kernel.org>; Tue, 28 Jun 2022 05:16:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 948A56114A
        for <stable@vger.kernel.org>; Tue, 28 Jun 2022 12:16:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05110C3411D;
        Tue, 28 Jun 2022 12:16:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656418589;
        bh=GyG/Zny/rT+EG9Jngbu89fxddwZYVsDBUUPZkUEpscM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RrEB9g/+y7Tlmjwr7qOElwtG67Hif7oYEujGZMboOpGiqyia/BobIpX9p1eG0M8Jq
         lXnUKHGnbOuF4H4AVxO9yUDFNFKx2Hii+eimAUeh/SwQP7zA+H25tEzWdJLFbFC+bV
         uRJsLzPHWC28/edSbMjWNsS6s+FMAgWaKTpzjdi/oVK4tDWFOKxh+HIiZ7F/Xfb6ua
         YUhCHgQTtiXVC6v0AGMjkNIeCnw01GWr02R3Q4JL5Y91a/5KcGbZjyH8kAzuob1FTm
         ivuDPLsVZslGlN+kNg7Q414bJq9y0JcRi13QBVO4FuT6DGGGacTubReb/+GjQrjvfp
         d8Autn1Lhs7XQ==
From:   Christian Brauner <brauner@kernel.org>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     "Christian Brauner (Microsoft)" <brauner@kernel.org>,
        stable@vger.kernel.org
Subject: [PATCH 00/12] attr: group fix backport
Date:   Tue, 28 Jun 2022 14:16:08 +0200
Message-Id: <20220628121620.188722-1-brauner@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220628102244.wymkrob3cfys2h7i@wittgenstein>
References: 
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2388; h=from:subject; bh=HujcUuv1A+cJvSSnnhqV8aabbzQhjsVdQqQVz2wEDWA=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMSTt+sgbGxn8TGnPfseeiO3VH34eMp1uGLU83Mv3TGBe1AqH 3/zKHaUsDGJcDLJiiiwO7Sbhcst5KjYbZWrAzGFlAhnCwMUpABN5qM3wPzN6jflDgR2hMS46Frw636 P47yxRW6wSs7T3lMh93sItvIwMq9nX9+6dNNWCIaa9mEWf9fDxi2tOW6Xyixtde9+1w2I1HwA=
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

From: "Christian Brauner (Microsoft)" <brauner@kernel.org>

Hey Greg,

As promised, here is a series that allows to backport the fix which
failed to build for you. This backports a few patches that are required
to make this work. I decided to backport them instead of rolling a
custom fix for this. That would've been smaller but there is future
hardening work that I would like to backport and this enables this.

I've run xfstests for ext4, xfs, and btrfs as well as LTP with:
runltp -f fs_perms_simple,fs_bind,containers,cap_bounds,cve,uevent,filecaps
and I see no regressions. There is an xfs failure but that is related to
a - for obvious reasons - missing stable backport.

Thanks!
Christian

Christian Brauner (12):
  fs: add is_idmapped_mnt() helper
  fs: move mapping helpers
  fs: tweak fsuidgid_has_mapping()
  fs: account for filesystem mappings
  docs: update mapping documentation
  fs: use low-level mapping helpers
  fs: remove unused low-level mapping helpers
  fs: port higher-level mapping helpers
  fs: add i_user_ns() helper
  fs: support mapped mounts of mapped filesystems
  fs: fix acl translation
  fs: account for group membership

 Documentation/filesystems/idmappings.rst |  72 -------
 fs/attr.c                                |  26 ++-
 fs/cachefiles/bind.c                     |   2 +-
 fs/ecryptfs/main.c                       |   2 +-
 fs/ksmbd/smbacl.c                        |  19 +-
 fs/ksmbd/smbacl.h                        |   5 +-
 fs/namespace.c                           |  53 +++--
 fs/nfsd/export.c                         |   2 +-
 fs/open.c                                |   8 +-
 fs/overlayfs/super.c                     |   2 +-
 fs/posix_acl.c                           |  27 ++-
 fs/proc_namespace.c                      |   2 +-
 fs/xattr.c                               |   6 +-
 fs/xfs/xfs_inode.c                       |   8 +-
 fs/xfs/xfs_linux.h                       |   1 +
 fs/xfs/xfs_symlink.c                     |   4 +-
 include/linux/fs.h                       | 141 ++++----------
 include/linux/mnt_idmapping.h            | 234 +++++++++++++++++++++++
 include/linux/posix_acl_xattr.h          |   4 +
 security/commoncap.c                     |  15 +-
 20 files changed, 394 insertions(+), 239 deletions(-)
 create mode 100644 include/linux/mnt_idmapping.h


base-commit: 18a33c8dabb88b50b860e0177a73933f2c0ddf68
-- 
2.34.1

