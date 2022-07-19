Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCB2A579C48
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 14:38:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239122AbiGSMiM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 08:38:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240886AbiGSMhy (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 08:37:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 754D67BE01;
        Tue, 19 Jul 2022 05:14:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E651EB81B32;
        Tue, 19 Jul 2022 12:14:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 466AAC341C6;
        Tue, 19 Jul 2022 12:14:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658232862;
        bh=Mg3fED1AAvaDbJxZHyGG4Bsb6lTRQRN91wZoWjfGKTo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kaGuXo3YT0D4T2Wlh3az3I3xMV0uSpB0WirYwnRunGDfwcQm2Jh4FaVSsR9D7vDke
         g6lOFb7hJE1YjSr2SJatCwZ9E1ipeLoeOMhgSuTn7sxn9vVO/BxG6nlD0ZrWvi0q1n
         fWU2VmhoB5QxXBhAOkxRy3m60ZUidXkqiWcduchc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "J. Bruce Fields" <bfields@fieldses.org>,
        Jeff Layton <jlayton@kernel.org>,
        Chuck Lever <chuck.lever@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 072/167] lockd: fix nlm_close_files
Date:   Tue, 19 Jul 2022 13:53:24 +0200
Message-Id: <20220719114703.467947727@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719114656.750574879@linuxfoundation.org>
References: <20220719114656.750574879@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jeff Layton <jlayton@kernel.org>

[ Upstream commit 1197eb5906a5464dbaea24cac296dfc38499cc00 ]

This loop condition tries a bit too hard to be clever. Just test for
the two indices we care about explicitly.

Cc: J. Bruce Fields <bfields@fieldses.org>
Fixes: 7f024fcd5c97 ("Keep read and write fds with each nlm_file")
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/lockd/svcsubs.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/fs/lockd/svcsubs.c b/fs/lockd/svcsubs.c
index b2f277727469..e1c4617de771 100644
--- a/fs/lockd/svcsubs.c
+++ b/fs/lockd/svcsubs.c
@@ -283,11 +283,10 @@ nlm_file_inuse(struct nlm_file *file)
 
 static void nlm_close_files(struct nlm_file *file)
 {
-	struct file *f;
-
-	for (f = file->f_file[0]; f <= file->f_file[1]; f++)
-		if (f)
-			nlmsvc_ops->fclose(f);
+	if (file->f_file[O_RDONLY])
+		nlmsvc_ops->fclose(file->f_file[O_RDONLY]);
+	if (file->f_file[O_WRONLY])
+		nlmsvc_ops->fclose(file->f_file[O_WRONLY]);
 }
 
 /*
-- 
2.35.1



