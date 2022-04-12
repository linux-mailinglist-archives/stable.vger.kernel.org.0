Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17B5F4FD644
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 12:21:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354534AbiDLHsk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:48:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357370AbiDLHkJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:40:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B987925582;
        Tue, 12 Apr 2022 00:15:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 56B7B6153F;
        Tue, 12 Apr 2022 07:15:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 655C8C385A1;
        Tue, 12 Apr 2022 07:15:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649747741;
        bh=v3qD+lbxvAnDXHBSBZdV7PZeHWEbKNY3rvkqSI17XYc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C3NQSBKQUD6JdWtgJGCVIu3DKcoD98Wtf9OVYZHUl63c+tPz0A94pclZp2NzorrwX
         N13C+on1CorkC76HvW4L7nohj/MiaIDx6+looWLRIcednaxiAd3zN1NSh2SgfoyY/r
         yQL10tx07S2goIk3GrXVYRiRHtilj+j012ljmk2I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiubo Li <xiubli@redhat.com>,
        Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 152/343] ceph: fix memory leak in ceph_readdir when note_last_dentry returns error
Date:   Tue, 12 Apr 2022 08:29:30 +0200
Message-Id: <20220412062955.766286874@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062951.095765152@linuxfoundation.org>
References: <20220412062951.095765152@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Xiubo Li <xiubli@redhat.com>

[ Upstream commit f639d9867eea647005dc824e0e24f39ffc50d4e4 ]

Reset the last_readdir at the same time, and add a comment explaining
why we don't free last_readdir when dir_emit returns false.

Signed-off-by: Xiubo Li <xiubli@redhat.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ceph/dir.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
index 133dbd9338e7..d91fa53e12b3 100644
--- a/fs/ceph/dir.c
+++ b/fs/ceph/dir.c
@@ -478,8 +478,11 @@ static int ceph_readdir(struct file *file, struct dir_context *ctx)
 					2 : (fpos_off(rde->offset) + 1);
 			err = note_last_dentry(dfi, rde->name, rde->name_len,
 					       next_offset);
-			if (err)
+			if (err) {
+				ceph_mdsc_put_request(dfi->last_readdir);
+				dfi->last_readdir = NULL;
 				return err;
+			}
 		} else if (req->r_reply_info.dir_end) {
 			dfi->next_offset = 2;
 			/* keep last name */
@@ -520,6 +523,12 @@ static int ceph_readdir(struct file *file, struct dir_context *ctx)
 		if (!dir_emit(ctx, rde->name, rde->name_len,
 			      ceph_present_ino(inode->i_sb, le64_to_cpu(rde->inode.in->ino)),
 			      le32_to_cpu(rde->inode.in->mode) >> 12)) {
+			/*
+			 * NOTE: Here no need to put the 'dfi->last_readdir',
+			 * because when dir_emit stops us it's most likely
+			 * doesn't have enough memory, etc. So for next readdir
+			 * it will continue.
+			 */
 			dout("filldir stopping us...\n");
 			return 0;
 		}
-- 
2.35.1



