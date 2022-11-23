Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 076F2635376
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 09:58:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236730AbiKWIzj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 03:55:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236748AbiKWIzf (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 03:55:35 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4738EF2C1B
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 00:55:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0AF49B81EED
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 08:55:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60A5DC433B5;
        Wed, 23 Nov 2022 08:55:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669193731;
        bh=DS2K+CYWhK4PzpuWwhS3eZ2xo7Gl2lsBjFI1NFO1yGs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O6hMe2a+f7MdNbAY/he28b5w4np23GUCjI3XXpEyJdl5NGk+5KNkoz1U3ZhFoTr0n
         gZtwWciwwFbxgroPG1OQGFE1GqZ/LoXBRkHVqQlrQfOwdz1gr1ZwVEE28oC4cthG3z
         f5c4x6qrK4rh2XfKMu0XlGDt9nw/GXxmgBasdlpc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Zhang Xiaoxu <zhangxiaoxu5@huawei.com>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 45/76] cifs: Fix wrong return value checking when GETFLAGS
Date:   Wed, 23 Nov 2022 09:50:44 +0100
Message-Id: <20221123084548.225321247@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084546.742331901@linuxfoundation.org>
References: <20221123084546.742331901@linuxfoundation.org>
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

[ Upstream commit 92bbd67a55fee50743b42825d1c016e7fd5c79f9 ]

The return value of CIFSGetExtAttr is negative, should be checked
with -EOPNOTSUPP rather than EOPNOTSUPP.

Fixes: 64a5cfa6db94 ("Allow setting per-file compression via SMB2/3")
Signed-off-by: Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/ioctl.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/ioctl.c b/fs/cifs/ioctl.c
index bdba9e7a9438..c9226567309b 100644
--- a/fs/cifs/ioctl.c
+++ b/fs/cifs/ioctl.c
@@ -206,7 +206,7 @@ long cifs_ioctl(struct file *filep, unsigned int command, unsigned long arg)
 					rc = put_user(ExtAttrBits &
 						FS_FL_USER_VISIBLE,
 						(int __user *)arg);
-				if (rc != EOPNOTSUPP)
+				if (rc != -EOPNOTSUPP)
 					break;
 			}
 #endif /* CONFIG_CIFS_POSIX */
@@ -235,7 +235,7 @@ long cifs_ioctl(struct file *filep, unsigned int command, unsigned long arg)
 			 *		       pSMBFile->fid.netfid,
 			 *		       extAttrBits,
 			 *		       &ExtAttrMask);
-			 * if (rc != EOPNOTSUPP)
+			 * if (rc != -EOPNOTSUPP)
 			 *	break;
 			 */
 
-- 
2.35.1



