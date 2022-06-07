Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF463540EDB
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 20:59:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353825AbiFGSzD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 14:55:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353987AbiFGSqX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 14:46:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2A3218E447;
        Tue,  7 Jun 2022 10:59:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9F947618DF;
        Tue,  7 Jun 2022 17:59:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41CAFC3411C;
        Tue,  7 Jun 2022 17:59:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654624792;
        bh=u01qew0MMuUX1g5xeHaO2xVFfjnyS5wslX0x3lJMFqQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c5pOGER7mM1basuYeWxlQygFYMBHXDu/Twm8M0AT2N7hBRhswE1imPKDVDWVBf1yu
         Lmnhhg8NkmW5+nkAIhROxoGeAHuwKtE9oo6e4WAJ60smW9lkLmHVWP/oj3ubs+fZYa
         l0xXIfGWTTuCzrojyBB/jRhqLJMpfamJ7XnDqt2MC3q2LFIIWIwK1LS85RvLasfNRN
         HM/vwkaCQOa06CX/aWUbnVyReWCKRsLVbBbwTCzYNVOfgaeDEe2IfSJMFlZclCBnnm
         m9/6VW3E4gUHeFc2+/RFnoV/GHCA3PfXdsX6mf+PfcSuH1hJo3eoBSZ7oyapf0jqG5
         dsP7lA5E+ZzTw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Venky Shankar <vshankar@redhat.com>, Xiubo Li <xiubli@redhat.com>,
        Ilya Dryomov <idryomov@gmail.com>,
        Sasha Levin <sashal@kernel.org>, ceph-devel@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 28/38] ceph: allow ceph.dir.rctime xattr to be updatable
Date:   Tue,  7 Jun 2022 13:58:23 -0400
Message-Id: <20220607175835.480735-28-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220607175835.480735-1-sashal@kernel.org>
References: <20220607175835.480735-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

From: Venky Shankar <vshankar@redhat.com>

[ Upstream commit d7a2dc523085f8b8c60548ceedc696934aefeb0e ]

`rctime' has been a pain point in cephfs due to its buggy
nature - inconsistent values reported and those sorts.
Fixing rctime is non-trivial needing an overall redesign
of the entire nested statistics infrastructure.

As a workaround, PR

     http://github.com/ceph/ceph/pull/37938

allows this extended attribute to be manually set. This allows
users to "fixup" inconsistent rctime values. While this sounds
messy, its probably the wisest approach allowing users/scripts
to workaround buggy rctime values.

The above PR enables Ceph MDS to allow manually setting
rctime extended attribute with the corresponding user-land
changes. We may as well allow the same to be done via kclient
for parity.

Signed-off-by: Venky Shankar <vshankar@redhat.com>
Reviewed-by: Xiubo Li <xiubli@redhat.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ceph/xattr.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/fs/ceph/xattr.c b/fs/ceph/xattr.c
index 197cb1234341..76322c0f6e5f 100644
--- a/fs/ceph/xattr.c
+++ b/fs/ceph/xattr.c
@@ -317,6 +317,14 @@ static ssize_t ceph_vxattrcb_snap_btime(struct ceph_inode_info *ci, char *val,
 	}
 #define XATTR_RSTAT_FIELD(_type, _name)			\
 	XATTR_NAME_CEPH(_type, _name, VXATTR_FLAG_RSTAT)
+#define XATTR_RSTAT_FIELD_UPDATABLE(_type, _name)			\
+	{								\
+		.name = CEPH_XATTR_NAME(_type, _name),			\
+		.name_size = sizeof (CEPH_XATTR_NAME(_type, _name)),	\
+		.getxattr_cb = ceph_vxattrcb_ ## _type ## _ ## _name,	\
+		.exists_cb = NULL,					\
+		.flags = VXATTR_FLAG_RSTAT,				\
+	}
 #define XATTR_LAYOUT_FIELD(_type, _name, _field)			\
 	{								\
 		.name = CEPH_XATTR_NAME2(_type, _name, _field),	\
@@ -354,7 +362,7 @@ static struct ceph_vxattr ceph_dir_vxattrs[] = {
 	XATTR_RSTAT_FIELD(dir, rfiles),
 	XATTR_RSTAT_FIELD(dir, rsubdirs),
 	XATTR_RSTAT_FIELD(dir, rbytes),
-	XATTR_RSTAT_FIELD(dir, rctime),
+	XATTR_RSTAT_FIELD_UPDATABLE(dir, rctime),
 	{
 		.name = "ceph.dir.pin",
 		.name_size = sizeof("ceph.dir.pin"),
-- 
2.35.1

