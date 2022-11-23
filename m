Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57F9B635866
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:57:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236307AbiKWJ5S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:57:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236727AbiKWJzk (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:55:40 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 822E6F00D
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:51:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 39B3CB81EF6
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:51:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B28FC433C1;
        Wed, 23 Nov 2022 09:50:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669197058;
        bh=3RvsOKUIeEkCaOeS8cC9Z8xROjwYtqJs6Ri7PW7eAJU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iDkaZcm5l79I2Gu17/XZMGp9/8QfIrXxeGDm4AasW5crBDO/C/KV07hBODgHlbz+o
         kx2yctINO95wYu3BYecVh/PhLIQKc9bF0RUGuwgR1u0+5ovZy07TjoAIxhpiePVz6Z
         Gdtc6SzdOLExw0pCiN6mAtbv93502a9RrWjC9vr4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Zhang Xiaoxu <zhangxiaoxu5@huawei.com>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 187/314] cifs: Fix wrong return value checking when GETFLAGS
Date:   Wed, 23 Nov 2022 09:50:32 +0100
Message-Id: <20221123084634.038703194@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084625.457073469@linuxfoundation.org>
References: <20221123084625.457073469@linuxfoundation.org>
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
index b6e6e5d6c8dd..baccda02deab 100644
--- a/fs/cifs/ioctl.c
+++ b/fs/cifs/ioctl.c
@@ -343,7 +343,7 @@ long cifs_ioctl(struct file *filep, unsigned int command, unsigned long arg)
 					rc = put_user(ExtAttrBits &
 						FS_FL_USER_VISIBLE,
 						(int __user *)arg);
-				if (rc != EOPNOTSUPP)
+				if (rc != -EOPNOTSUPP)
 					break;
 			}
 #endif /* CONFIG_CIFS_ALLOW_INSECURE_LEGACY */
@@ -373,7 +373,7 @@ long cifs_ioctl(struct file *filep, unsigned int command, unsigned long arg)
 			 *		       pSMBFile->fid.netfid,
 			 *		       extAttrBits,
 			 *		       &ExtAttrMask);
-			 * if (rc != EOPNOTSUPP)
+			 * if (rc != -EOPNOTSUPP)
 			 *	break;
 			 */
 
-- 
2.35.1



