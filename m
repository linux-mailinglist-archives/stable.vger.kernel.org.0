Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40F514BE39E
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 18:57:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350001AbiBUJjb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 04:39:31 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:47998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351455AbiBUJhP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 04:37:15 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB03539838;
        Mon, 21 Feb 2022 01:15:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 2B5C2CE0E8B;
        Mon, 21 Feb 2022 09:15:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11116C340E9;
        Mon, 21 Feb 2022 09:15:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645434947;
        bh=jtUIix8YE2fPyTynYc8qgmVp0lmvN90YoZI+APmQjhk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dakPIsi5v9Fpt19+V776r3v5s6HWvvrABY6SmV/x1FFfmEY9xwCetAmNCEjHj291e
         oSZHy0uuRDIH4nG3njpl8xBCnbXZyrxMNxacm+SyJIFDibt6RJuBqcX48UjUZHL9Cp
         +uatGR9L8VQXVKm9cGWGh811ebw4tWkx4zBAaTf0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Namjae Jeon <linkinjeon@kernel.org>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 155/196] ksmbd: fix same UniqueId for dot and dotdot entries
Date:   Mon, 21 Feb 2022 09:49:47 +0100
Message-Id: <20220221084936.120538087@linuxfoundation.org>
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

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit 97550c7478a2da93e348d8c3075d92cddd473a78 ]

ksmbd sets the inode number to UniqueId. However, the same UniqueId for
dot and dotdot entry is set to the inode number of the parent inode.
This patch set them using the current inode and parent inode.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ksmbd/smb_common.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/ksmbd/smb_common.c b/fs/ksmbd/smb_common.c
index 707490ab1f4c4..f2e7e3a654b34 100644
--- a/fs/ksmbd/smb_common.c
+++ b/fs/ksmbd/smb_common.c
@@ -308,14 +308,17 @@ int ksmbd_populate_dot_dotdot_entries(struct ksmbd_work *work, int info_level,
 	for (i = 0; i < 2; i++) {
 		struct kstat kstat;
 		struct ksmbd_kstat ksmbd_kstat;
+		struct dentry *dentry;
 
 		if (!dir->dot_dotdot[i]) { /* fill dot entry info */
 			if (i == 0) {
 				d_info->name = ".";
 				d_info->name_len = 1;
+				dentry = dir->filp->f_path.dentry;
 			} else {
 				d_info->name = "..";
 				d_info->name_len = 2;
+				dentry = dir->filp->f_path.dentry->d_parent;
 			}
 
 			if (!match_pattern(d_info->name, d_info->name_len,
@@ -327,7 +330,7 @@ int ksmbd_populate_dot_dotdot_entries(struct ksmbd_work *work, int info_level,
 			ksmbd_kstat.kstat = &kstat;
 			ksmbd_vfs_fill_dentry_attrs(work,
 						    user_ns,
-						    dir->filp->f_path.dentry->d_parent,
+						    dentry,
 						    &ksmbd_kstat);
 			rc = fn(conn, info_level, d_info, &ksmbd_kstat);
 			if (rc)
-- 
2.34.1



