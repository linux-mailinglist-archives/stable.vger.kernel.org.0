Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11D484BDB6D
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 18:40:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350183AbiBUJjV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 04:39:21 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:46410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351652AbiBUJhd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 04:37:33 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 513C53A5FD;
        Mon, 21 Feb 2022 01:16:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id BCCFECE0E66;
        Mon, 21 Feb 2022 09:16:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9ACBFC340E9;
        Mon, 21 Feb 2022 09:16:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645434979;
        bh=CGKZKpHdtpHjqx8nLIub2ekK7SpErawCOlzQRha/BlY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I0NrBd1+rJBec55+7LsX6SuM0K46lq2wSUVfAraKQmy6Ub+7o6zMcXkHWYqmgxrqo
         Z7r2+4QtHeK8Uheb41y13l4QBiCTzBZMGdHZDqrB9qpoUhVzZe/CzFlNFa/a/Ok/jk
         LdyvbaHTisx45E9jkiM2xSNDQh5E9Z1EVPx57V7k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Seth Forshee <seth.forshee@digitalocean.com>,
        Christoph Hellwig <hch@lst.de>, linux-fsdevel@vger.kernel.org,
        Christian Brauner <brauner@kernel.org>
Subject: [PATCH 5.15 188/196] tests: fix idmapped mount_setattr test
Date:   Mon, 21 Feb 2022 09:50:20 +0100
Message-Id: <20220221084937.235971073@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220221084930.872957717@linuxfoundation.org>
References: <20220221084930.872957717@linuxfoundation.org>
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

From: Christian Brauner <brauner@kernel.org>

commit d1c56bfdaca465bd1d0e913053a9c5cafe8b6a6c upstream.

The test treated zero as a successful run when it really should treat
non-zero as a successful run. A mount's idmapping can't change once it
has been attached to the filesystem.

Link: https://lore.kernel.org/r/20220203131411.3093040-2-brauner@kernel.org
Fixes: 01eadc8dd96d ("tests: add mount_setattr() selftests")
Cc: Seth Forshee <seth.forshee@digitalocean.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: linux-fsdevel@vger.kernel.org
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/mount_setattr/mount_setattr_test.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/mount_setattr/mount_setattr_test.c
+++ b/tools/testing/selftests/mount_setattr/mount_setattr_test.c
@@ -1236,7 +1236,7 @@ static int get_userns_fd(unsigned long n
 }
 
 /**
- * Validate that an attached mount in our mount namespace can be idmapped.
+ * Validate that an attached mount in our mount namespace cannot be idmapped.
  * (The kernel enforces that the mount's mount namespace and the caller's mount
  *  namespace match.)
  */
@@ -1259,7 +1259,7 @@ TEST_F(mount_setattr_idmapped, attached_
 
 	attr.userns_fd	= get_userns_fd(0, 10000, 10000);
 	ASSERT_GE(attr.userns_fd, 0);
-	ASSERT_EQ(sys_mount_setattr(open_tree_fd, "", AT_EMPTY_PATH, &attr, sizeof(attr)), 0);
+	ASSERT_NE(sys_mount_setattr(open_tree_fd, "", AT_EMPTY_PATH, &attr, sizeof(attr)), 0);
 	ASSERT_EQ(close(attr.userns_fd), 0);
 	ASSERT_EQ(close(open_tree_fd), 0);
 }


