Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A7B05493D4
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:32:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356061AbiFMLsC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 07:48:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357515AbiFMLqS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 07:46:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F25F8DFE0;
        Mon, 13 Jun 2022 03:52:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0AAF9B80D3A;
        Mon, 13 Jun 2022 10:52:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71382C34114;
        Mon, 13 Jun 2022 10:52:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655117546;
        bh=hMR4mJxRTbcnFioLYn9YBF9bnoQ3ApVCooUwafH/D54=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LIB6Y1rPLR+1U0iQ1tiBqrUMbdPwdfsxUn4m6G1UuXTyNrax6g0xm0ARoHjudlUAt
         v3ujXqgw2ggi8k3AC4ncCuv9E/z4wClq3IGblC+qSybCjdeQIcZFtiyNJSSgQrdoFb
         Lc4MSNeH/prxrWbJ/xLA0GBgiUZO6fai5gp4L4oU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Venky Shankar <vshankar@redhat.com>,
        Xiubo Li <xiubli@redhat.com>,
        Ilya Dryomov <idryomov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 388/411] ceph: allow ceph.dir.rctime xattr to be updatable
Date:   Mon, 13 Jun 2022 12:11:01 +0200
Message-Id: <20220613094940.305918929@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094928.482772422@linuxfoundation.org>
References: <20220613094928.482772422@linuxfoundation.org>
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
index cb18ee637cb7..4bcf0226818d 100644
--- a/fs/ceph/xattr.c
+++ b/fs/ceph/xattr.c
@@ -316,6 +316,14 @@ static ssize_t ceph_vxattrcb_snap_btime(struct ceph_inode_info *ci, char *val,
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
@@ -353,7 +361,7 @@ static struct ceph_vxattr ceph_dir_vxattrs[] = {
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



