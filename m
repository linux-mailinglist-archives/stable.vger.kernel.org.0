Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0119F5410DC
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 21:30:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355388AbiFGT3m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 15:29:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356822AbiFGT2N (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 15:28:13 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 537E26A027;
        Tue,  7 Jun 2022 11:11:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id A5A96CE2439;
        Tue,  7 Jun 2022 18:10:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFEB5C385A2;
        Tue,  7 Jun 2022 18:10:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654625458;
        bh=24/+sW6Sob7YMv6wVRkObr+QQ67G3CdFjp9sCUgysVY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ty3EyXE5U+aXqZn3krI/O98oDhJ177LiKwyAqPB0xNjiT5+UzVA6rGap4aJTMYWbj
         WWMgPQT+qb+1Gs6FiuHrUku5BQ4Fjz0y2uWaixLsv5R9q2wrFfLVvMZLgH1foT8tqH
         tGbqhbyymfOrG49Z0T4EJuOh0BwmZbzz0/EqiAhM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Subject: [PATCH 5.17 026/772] fs/ntfs3: Update i_ctime when xattr is added
Date:   Tue,  7 Jun 2022 18:53:38 +0200
Message-Id: <20220607164949.787502692@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164948.980838585@linuxfoundation.org>
References: <20220607164948.980838585@linuxfoundation.org>
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
 


