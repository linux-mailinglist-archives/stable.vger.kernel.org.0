Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDE5F59E0E4
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:38:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353904AbiHWLmX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 07:42:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358271AbiHWLlX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 07:41:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2472CCAC49;
        Tue, 23 Aug 2022 02:29:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D1F1E61380;
        Tue, 23 Aug 2022 09:29:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF7B5C433D6;
        Tue, 23 Aug 2022 09:29:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661246941;
        bh=r8ZmBHQ/RJfNsWVpUAvQ9s2Wzj7LryuW23JauTIsPDc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PwCFt2qGe5JXdN7yDTYa1bVD5hq6LBP+wRr+pPLm9wA/el2q0jpBZaRVhLllfejRL
         ofjG51rJJisK9vcfQIrkDuUqqCV6mZgL9gSKP8umo0JPfOUzRRJyc8lLG5QNBSMHQM
         uGbJTS0ea/1nZDiZUdwMhSdO/rFWdFYzuc4q7/P0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xie Yongji <xieyongji@bytedance.com>,
        Miklos Szeredi <mszeredi@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 227/389] fuse: Remove the control interface for virtio-fs
Date:   Tue, 23 Aug 2022 10:25:05 +0200
Message-Id: <20220823080125.082736779@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080115.331990024@linuxfoundation.org>
References: <20220823080115.331990024@linuxfoundation.org>
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

From: Xie Yongji <xieyongji@bytedance.com>

[ Upstream commit c64797809a64c73497082aa05e401a062ec1af34 ]

The commit 15c8e72e88e0 ("fuse: allow skipping control interface and forced
unmount") tries to remove the control interface for virtio-fs since it does
not support aborting requests which are being processed. But it doesn't
work now.

This patch fixes it by skipping creating the control interface if
fuse_conn->no_control is set.

Fixes: 15c8e72e88e0 ("fuse: allow skipping control interface and forced unmount")
Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/fuse/control.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/fuse/control.c b/fs/fuse/control.c
index c23f6f243ad4..2742d74cedda 100644
--- a/fs/fuse/control.c
+++ b/fs/fuse/control.c
@@ -265,7 +265,7 @@ int fuse_ctl_add_conn(struct fuse_conn *fc)
 	struct dentry *parent;
 	char name[32];
 
-	if (!fuse_control_sb)
+	if (!fuse_control_sb || fc->no_control)
 		return 0;
 
 	parent = fuse_control_sb->s_root;
@@ -303,7 +303,7 @@ void fuse_ctl_remove_conn(struct fuse_conn *fc)
 {
 	int i;
 
-	if (!fuse_control_sb)
+	if (!fuse_control_sb || fc->no_control)
 		return;
 
 	for (i = fc->ctl_ndents - 1; i >= 0; i--) {
-- 
2.35.1



