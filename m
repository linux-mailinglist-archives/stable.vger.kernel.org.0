Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 726B0593C2E
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 22:37:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344498AbiHOTnW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 15:43:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344195AbiHOTip (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 15:38:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FF6921B9;
        Mon, 15 Aug 2022 11:46:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DDA2FB81082;
        Mon, 15 Aug 2022 18:46:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F954C433D6;
        Mon, 15 Aug 2022 18:46:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660589205;
        bh=9aQn6HVkvYsPal5YbQdM+9fKm2iAIf76v5YHe/43/XA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GzOswDYptWuQuZonavXj/TOgKfHQeuU15DkMhlL3Lv7fV9ZLGPQO4a3yCyjcNZ6GF
         riwUoOIaDUopefftlXZs4dzAYmM+RH5xtWx08Aj8sHX8xZeWWPOerAhAtHM5nuHXfA
         N5DF81h2nSN1izEC/EiCeKxGa07dtC2mAuhsM8Bw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xie Yongji <xieyongji@bytedance.com>,
        Miklos Szeredi <mszeredi@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 628/779] fuse: Remove the control interface for virtio-fs
Date:   Mon, 15 Aug 2022 20:04:32 +0200
Message-Id: <20220815180404.220639286@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
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
index 000d2e5627e9..79f01d09c78c 100644
--- a/fs/fuse/control.c
+++ b/fs/fuse/control.c
@@ -275,7 +275,7 @@ int fuse_ctl_add_conn(struct fuse_conn *fc)
 	struct dentry *parent;
 	char name[32];
 
-	if (!fuse_control_sb)
+	if (!fuse_control_sb || fc->no_control)
 		return 0;
 
 	parent = fuse_control_sb->s_root;
@@ -313,7 +313,7 @@ void fuse_ctl_remove_conn(struct fuse_conn *fc)
 {
 	int i;
 
-	if (!fuse_control_sb)
+	if (!fuse_control_sb || fc->no_control)
 		return;
 
 	for (i = fc->ctl_ndents - 1; i >= 0; i--) {
-- 
2.35.1



