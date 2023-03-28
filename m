Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE9CC6CC2D9
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 16:49:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233362AbjC1OtM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 10:49:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233324AbjC1Os5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 10:48:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05E02CDF7
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 07:48:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 604C461835
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 14:48:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70796C433EF;
        Tue, 28 Mar 2023 14:48:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680014886;
        bh=UWNUTyopbp++PSvDH2A9A01OLLgAwQsEiVnamn+KmYU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=x6fLGYRjb7KUqqQGBTo4UZSzTprFBDwhR3xJjVbz5hbAKsHd2i+VJ/N3hLmdxqaTz
         UoM2grMYs+ZRdgdgO/RWe37OfeJyY2OIHyAEX/1Thl4R4rjAiUhVDtG13tXtmKwhNB
         rGlW2XidA6fGx/FTnxVqV7z0Hf1ZAlZDb5k18qvw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, ChenXiaoSong <chenxiaosong2@huawei.com>,
        Namjae Jeon <linkinjeon@kernel.org>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 088/240] ksmbd: fix possible refcount leak in smb2_open()
Date:   Tue, 28 Mar 2023 16:40:51 +0200
Message-Id: <20230328142623.442467184@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142619.643313678@linuxfoundation.org>
References: <20230328142619.643313678@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: ChenXiaoSong <chenxiaosong2@huawei.com>

[ Upstream commit 2624b445544ffc1472ccabfb6ec867c199d4c95c ]

Reference count of acls will leak when memory allocation fails. Fix this
by adding the missing posix_acl_release().

Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
Signed-off-by: ChenXiaoSong <chenxiaosong2@huawei.com>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ksmbd/smb2pdu.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index b553d93a94eb5..89724cc62299c 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -2996,8 +2996,11 @@ int smb2_open(struct ksmbd_work *work)
 							sizeof(struct smb_acl) +
 							sizeof(struct smb_ace) * ace_num * 2,
 							GFP_KERNEL);
-					if (!pntsd)
+					if (!pntsd) {
+						posix_acl_release(fattr.cf_acls);
+						posix_acl_release(fattr.cf_dacls);
 						goto err_out;
+					}
 
 					rc = build_sec_desc(user_ns,
 							    pntsd, NULL, 0,
-- 
2.39.2



