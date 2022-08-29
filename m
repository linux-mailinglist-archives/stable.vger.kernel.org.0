Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B68F05A4893
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 13:12:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231273AbiH2LMl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 07:12:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230241AbiH2LMH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 07:12:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06B85B1F2;
        Mon, 29 Aug 2022 04:08:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 097DD611F6;
        Mon, 29 Aug 2022 11:08:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18EC6C433D6;
        Mon, 29 Aug 2022 11:08:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661771329;
        bh=nxFzwG/Su71x1AgWj7cs9KQ+UqjXZBU327nkcS2HGEQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dOwk5L6oJz/2mysobMCAgG3Y39EnvIua3kAJ7YUtco7v4e5LSjx/CBScBsYPkGcox
         7w8hJVQyHbnXqe8dFY86F66Bn4v2z8bXRsBsmfdvNqxWBii9Ql3ZeihvuPjma8zv02
         klKwZVuWVwbddwXdvn/XBHugHIBje1cRTKt75UXE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Seth Forshee <sforshee@digitalocean.com>,
        "Christian Brauner (Microsoft)" <brauner@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 017/158] fs: require CAP_SYS_ADMIN in target namespace for idmapped mounts
Date:   Mon, 29 Aug 2022 12:57:47 +0200
Message-Id: <20220829105809.545246034@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220829105808.828227973@linuxfoundation.org>
References: <20220829105808.828227973@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Seth Forshee <sforshee@digitalocean.com>

[ Upstream commit bf1ac16edf6770a92bc75cf2373f1f9feea398a4 ]

Idmapped mounts should not allow a user to map file ownsership into a
range of ids which is not under the control of that user. However, we
currently don't check whether the mounter is privileged wrt to the
target user namespace.

Currently no FS_USERNS_MOUNT filesystems support idmapped mounts, thus
this is not a problem as only CAP_SYS_ADMIN in init_user_ns is allowed
to set up idmapped mounts. But this could change in the future, so add a
check to refuse to create idmapped mounts when the mounter does not have
CAP_SYS_ADMIN in the target user namespace.

Fixes: bd303368b776 ("fs: support mapped mounts of mapped filesystems")
Signed-off-by: Seth Forshee <sforshee@digitalocean.com>
Reviewed-by: Christian Brauner (Microsoft) <brauner@kernel.org>
Link: https://lore.kernel.org/r/20220816164752.2595240-1-sforshee@digitalocean.com
Signed-off-by: Christian Brauner (Microsoft) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/namespace.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/namespace.c b/fs/namespace.c
index e6a7e769d25dd..a59f8d645654a 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -4238,6 +4238,13 @@ static int build_mount_idmapped(const struct mount_attr *attr, size_t usize,
 		err = -EPERM;
 		goto out_fput;
 	}
+
+	/* We're not controlling the target namespace. */
+	if (!ns_capable(mnt_userns, CAP_SYS_ADMIN)) {
+		err = -EPERM;
+		goto out_fput;
+	}
+
 	kattr->mnt_userns = get_user_ns(mnt_userns);
 
 out_fput:
-- 
2.35.1



