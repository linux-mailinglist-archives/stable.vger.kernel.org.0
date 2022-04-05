Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91F744F25F9
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 09:51:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230495AbiDEHxQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 03:53:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232771AbiDEHvl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 03:51:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 487944C422;
        Tue,  5 Apr 2022 00:47:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F2831B81B92;
        Tue,  5 Apr 2022 07:47:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DC72C340EE;
        Tue,  5 Apr 2022 07:47:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649144868;
        bh=FD6A8Q2VodmlK/aTr23PGmh0+5iHx7dgmOFrv2Xh6ew=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VszKd8laoEkkxzEynK9e6KjAbODnhjou/jmuR66jNouKn6FnYFIz9nN76sZimduAF
         vPfBTNJjESOkPS/bl0ZeR+4TgSvjnUaah5dF7Cua+LrdTaL4MCPiPT7v064PBDmVfe
         lb2rulWiBmfJTJ6dKin7aVyWExBRkEAVdMlNE6sU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Christian=20G=C3=B6ttsche?= <cgzones@googlemail.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Paul Moore <paul@paul-moore.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0200/1126] selinux: check return value of sel_make_avc_files
Date:   Tue,  5 Apr 2022 09:15:47 +0200
Message-Id: <20220405070413.477480169@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
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

From: Christian Göttsche <cgzones@googlemail.com>

[ Upstream commit bcb62828e3e8c813b6613db6eb7fd9657db248fc ]

sel_make_avc_files() might fail and return a negative errno value on
memory allocation failures. Re-add the check of the return value,
dropped in 66f8e2f03c02 ("selinux: sidtab reverse lookup hash table").

Reported by clang-analyzer:

    security/selinux/selinuxfs.c:2129:2: warning: Value stored to
      'ret' is never read [deadcode.DeadStores]
            ret = sel_make_avc_files(dentry);
            ^     ~~~~~~~~~~~~~~~~~~~~~~~~~~

Fixes: 66f8e2f03c02 ("selinux: sidtab reverse lookup hash table")
Signed-off-by: Christian Göttsche <cgzones@googlemail.com>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
[PM: description line wrapping, added proper commit ref]
Signed-off-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/selinux/selinuxfs.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/security/selinux/selinuxfs.c b/security/selinux/selinuxfs.c
index e4cd7cb856f3..f2f6203e0fff 100644
--- a/security/selinux/selinuxfs.c
+++ b/security/selinux/selinuxfs.c
@@ -2127,6 +2127,8 @@ static int sel_fill_super(struct super_block *sb, struct fs_context *fc)
 	}
 
 	ret = sel_make_avc_files(dentry);
+	if (ret)
+		goto err;
 
 	dentry = sel_make_dir(sb->s_root, "ss", &fsi->last_ino);
 	if (IS_ERR(dentry)) {
-- 
2.34.1



