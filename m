Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB7445417B9
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:04:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378299AbiFGVEr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:04:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378863AbiFGVDj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:03:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18E6F18A879;
        Tue,  7 Jun 2022 11:48:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 199296156D;
        Tue,  7 Jun 2022 18:48:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26177C385A2;
        Tue,  7 Jun 2022 18:48:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654627721;
        bh=24/+sW6Sob7YMv6wVRkObr+QQ67G3CdFjp9sCUgysVY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B8gAGp9vy41VWHqzJZLHlRr2Pqdq2Iy9ioDIXun/6+4PEJQsmueBm75gFttbqt5Yg
         tNMg2N6AKdVlJWcNOyP1UC6HpXdHJY6SNnn4C6bXsWONS/4lI/uQ3fxIiQMVxLybo+
         cF0rodDs4sCczl5tqsCJHVL+TNZz5rl44J5Sqt+8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Subject: [PATCH 5.18 028/879] fs/ntfs3: Update i_ctime when xattr is added
Date:   Tue,  7 Jun 2022 18:52:26 +0200
Message-Id: <20220607165003.492806765@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
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

From: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>

commit 2d44667c306e7806848a3478820f87343feb5421 upstream.

Ctime wasn't updated after setfacl command.
This commit fixes xfstest generic/307
Fixes: be71b5cba2e6 ("fs/ntfs3: Add attrib operations")

Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ntfs3/xattr.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/fs/ntfs3/xattr.c
+++ b/fs/ntfs3/xattr.c
@@ -902,6 +902,9 @@ set_new_fa:
 	err = ntfs_set_ea(inode, name, name_len, value, size, flags);
 
 out:
+	inode->i_ctime = current_time(inode);
+	mark_inode_dirty(inode);
+
 	return err;
 }
 


