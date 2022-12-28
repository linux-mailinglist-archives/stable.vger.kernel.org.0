Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7709465848D
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:58:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235262AbiL1Q6B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:58:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235351AbiL1Q53 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:57:29 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF85219C2D
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:53:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 59737B8172A
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:53:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5C80C433EF;
        Wed, 28 Dec 2022 16:53:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672246433;
        bh=7IIzYPatVpJ1/OeMVQGZU8F5NDKYw7ZWcrAoaEZRkWI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rEhYYqW/N7oBAgIHnTYg/HOI7cSxIMjw+xuGRUxXa384aGqKOdNHEfzN49BMzZoj2
         /bH1skyqz+umYkA8kNhnmdoodliDBY7KxWpLkbQFq9AChoMTiLNOVKLh9aPUCD/mjo
         wFwNPb24RbB4LogXTLaLHG6O/WYa/VHRX5HwBd/I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, "Paulo Alcantara (SUSE)" <pc@cjr.nz>,
        Zhang Xiaoxu <zhangxiaoxu5@huawei.com>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.0 1071/1073] cifs: Fix xid leak in cifs_get_file_info_unix()
Date:   Wed, 28 Dec 2022 15:44:19 +0100
Message-Id: <20221228144357.330886620@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhang Xiaoxu <zhangxiaoxu5@huawei.com>

commit 10269f13257d4eb6061d09ccce61666316df9838 upstream.

If stardup the symlink target failed, should free the xid,
otherwise the xid will be leaked.

Fixes: 76894f3e2f71 ("cifs: improve symlink handling for smb2+")
Reviewed-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
Signed-off-by: Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/cifs/inode.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -368,8 +368,10 @@ cifs_get_file_info_unix(struct file *fil
 
 	if (cfile->symlink_target) {
 		fattr.cf_symlink_target = kstrdup(cfile->symlink_target, GFP_KERNEL);
-		if (!fattr.cf_symlink_target)
-			return -ENOMEM;
+		if (!fattr.cf_symlink_target) {
+			rc = -ENOMEM;
+			goto cifs_gfiunix_out;
+		}
 	}
 
 	rc = CIFSSMBUnixQFileInfo(xid, tcon, cfile->fid.netfid, &find_data);


