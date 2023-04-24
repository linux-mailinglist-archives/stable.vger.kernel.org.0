Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A60B6ECD39
	for <lists+stable@lfdr.de>; Mon, 24 Apr 2023 15:21:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231997AbjDXNVg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Apr 2023 09:21:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232008AbjDXNVf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Apr 2023 09:21:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99FE95257
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 06:21:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 363A962230
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 13:21:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47F74C433EF;
        Mon, 24 Apr 2023 13:21:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1682342478;
        bh=9qsBXT1RXKXnMQgwUxELknUgr6vmnV05+EAgaC7ZTgg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iNg+y2apBHobIi1W2AfMarKuF6rUhZ4LPfuVDPNbvx8MtpZbdp6aZ8nQZzP9bLl9X
         UOsMtbSESQQzmX+TyJSx02wTy7159UyMcBIv3y8gYDEVFYNnQXpgkPHvTnHZEOtf1v
         eyaY5EjFYHmZTIriU0gcVbhl9G5rDumR5A+WnBuQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Miklos Szeredi <mszeredi@redhat.com>,
        Yang Bo <yb203166@antfin.com>
Subject: [PATCH 5.15 55/73] fuse: fix attr version comparison in fuse_read_update_size()
Date:   Mon, 24 Apr 2023 15:17:09 +0200
Message-Id: <20230424131131.062487048@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230424131129.040707961@linuxfoundation.org>
References: <20230424131129.040707961@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miklos Szeredi <mszeredi@redhat.com>

commit 484ce65715b06aead8c4901f01ca32c5a240bc71 upstream.

A READ request returning a short count is taken as indication of EOF, and
the cached file size is modified accordingly.

Fix the attribute version checking to allow for changes to fc->attr_version
on other inodes.

Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Yang Bo <yb203166@antfin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/fuse/file.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -793,7 +793,7 @@ static void fuse_read_update_size(struct
 	struct fuse_inode *fi = get_fuse_inode(inode);
 
 	spin_lock(&fi->lock);
-	if (attr_ver == fi->attr_version && size < inode->i_size &&
+	if (attr_ver >= fi->attr_version && size < inode->i_size &&
 	    !test_bit(FUSE_I_SIZE_UNSTABLE, &fi->state)) {
 		fi->attr_version = atomic64_inc_return(&fc->attr_version);
 		i_size_write(inode, size);


