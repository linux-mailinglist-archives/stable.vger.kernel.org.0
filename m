Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A8466BB1F0
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 13:31:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232662AbjCOMbo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 08:31:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232641AbjCOMba (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 08:31:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BAD988EF5
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 05:30:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AD6A5B81E00
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 12:30:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0769DC433D2;
        Wed, 15 Mar 2023 12:30:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678883439;
        bh=uBL8rUJC0JIhKydsyI1Kb2yjMx3zAvoatGk1q0OiNmQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EacawJgcDUa1t4dgXEvLNRPTDSTxYPTqN0P9SwSQSPwBZa3AgThVCa6sY8j/cYJnE
         3ta3GwcFX2IoaKZdFwNCbIW3KSewYF0BNDjpHqRN2n5qyJS1WEBRLszb+IkHUh8Wn4
         86kgSz7hkBiP789PIPUwDvGEut+nVOmARIkiYg94=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Miklos Szeredi <miklos@szeredi.hu>,
        "Christian Brauner (Microsoft)" <brauner@kernel.org>,
        Amir Goldstein <amir73il@gmail.com>,
        Leah Rumancik <leah.rumancik@gmail.com>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 104/145] fs: use consistent setgid checks in is_sxid()
Date:   Wed, 15 Mar 2023 13:12:50 +0100
Message-Id: <20230315115742.405360658@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115738.951067403@linuxfoundation.org>
References: <20230315115738.951067403@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christian Brauner <brauner@kernel.org>

commit 8d84e39d76bd83474b26cb44f4b338635676e7e8 upstream.

Now that we made the VFS setgid checking consistent an inode can't be
marked security irrelevant even if the setgid bit is still set. Make
this function consistent with all other helpers.

Note that enforcing consistent setgid stripping checks for file
modification and mode- and ownership changes will cause the setgid bit
to be lost in more cases than useed to be the case. If an unprivileged
user wrote to a non-executable setgid file that they don't have
privilege over the setgid bit will be dropped. This will lead to
temporary failures in some xfstests until they have been updated.

Reported-by: Miklos Szeredi <miklos@szeredi.hu>
Signed-off-by: Christian Brauner (Microsoft) <brauner@kernel.org>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Tested-by: Leah Rumancik <leah.rumancik@gmail.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/fs.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index 9601c2d774c88..23ecfecdc4504 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -3571,7 +3571,7 @@ int __init list_bdev_fs_names(char *buf, size_t size);
 
 static inline bool is_sxid(umode_t mode)
 {
-	return (mode & S_ISUID) || ((mode & S_ISGID) && (mode & S_IXGRP));
+	return mode & (S_ISUID | S_ISGID);
 }
 
 static inline int check_sticky(struct user_namespace *mnt_userns,
-- 
2.39.2



