Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D61E354986E
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:37:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377522AbiFMNdH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 09:33:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378311AbiFMNbU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 09:31:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AE716FD2C;
        Mon, 13 Jun 2022 04:25:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 97175B80EA7;
        Mon, 13 Jun 2022 11:25:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0964BC34114;
        Mon, 13 Jun 2022 11:25:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655119551;
        bh=dHrpiGBjW9rbIO3xNAUzBvjMwbqUsruwtApSEy5CXQc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mvVJn+MbdjDJplpZevE1DzRDvI3S4Ch1gHt2izLeL97SIGpZs8oy6JUl1ECFOF30p
         MRnkpBn70/AWVfANQa2Xwcf9VMvdSY3g8G+9SFCRjbqKLEA5wzQIg9kb82z+uTids7
         29GdSFoY9SdR1XdmEKUNapALbBF6Ic0HIHtMo1E4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xin Xiong <xiongx18@fudan.edu.cn>,
        Xin Tan <tanxin.ctf@gmail.com>,
        Namjae Jeon <linkinjeon@kernel.org>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 054/339] ksmbd: fix reference count leak in smb_check_perm_dacl()
Date:   Mon, 13 Jun 2022 12:07:59 +0200
Message-Id: <20220613094928.161742164@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094926.497929857@linuxfoundation.org>
References: <20220613094926.497929857@linuxfoundation.org>
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

From: Xin Xiong <xiongx18@fudan.edu.cn>

[ Upstream commit d21a580dafc69aa04f46e6099616146a536b0724 ]

The issue happens in a specific path in smb_check_perm_dacl(). When
"id" and "uid" have the same value, the function simply jumps out of
the loop without decrementing the reference count of the object
"posix_acls", which is increased by get_acl() earlier. This may
result in memory leaks.

Fix it by decreasing the reference count of "posix_acls" before
jumping to label "check_access_bits".

Fixes: 777cad1604d6 ("ksmbd: remove select FS_POSIX_ACL in Kconfig")
Signed-off-by: Xin Xiong <xiongx18@fudan.edu.cn>
Signed-off-by: Xin Tan <tanxin.ctf@gmail.com>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ksmbd/smbacl.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/ksmbd/smbacl.c b/fs/ksmbd/smbacl.c
index 6ecf55ea1fed..38f23bf981ac 100644
--- a/fs/ksmbd/smbacl.c
+++ b/fs/ksmbd/smbacl.c
@@ -1261,6 +1261,7 @@ int smb_check_perm_dacl(struct ksmbd_conn *conn, struct path *path,
 					if (!access_bits)
 						access_bits =
 							SET_MINIMUM_RIGHTS;
+					posix_acl_release(posix_acls);
 					goto check_access_bits;
 				}
 			}
-- 
2.35.1



