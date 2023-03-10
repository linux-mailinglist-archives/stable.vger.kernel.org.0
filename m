Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 701146B4687
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:43:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232818AbjCJOnx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:43:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232890AbjCJOni (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:43:38 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 029D9F4024
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:43:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 941E8B822C4
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:43:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1DB1C433EF;
        Fri, 10 Mar 2023 14:43:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678459414;
        bh=nmBdanEHMTbExyB7ERQ9GpBI50Fx8n+sAvs+/M6tljY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Kgm463ANkzgSXn21fhIQWRujUn/gb04yohWwMDjX5oXQ6wQHFZCnPV6en4qjNi5xa
         NDXVrXFCHrXjQDKxOrVQdyycqf3a3v1jeFw4AKwgT6xKaoY3XqosF8AeYDFbOF5c/s
         r37g9Vs5OBirnHGpmdu/wsay+aAz8GTWL8tujJhk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jiri Slaby <jirislaby@kernel.org>,
        George Kennedy <george.kennedy@oracle.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 323/357] vc_screen: modify vcs_size() handling in vcs_read()
Date:   Fri, 10 Mar 2023 14:40:12 +0100
Message-Id: <20230310133748.918084596@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133733.973883071@linuxfoundation.org>
References: <20230310133733.973883071@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: George Kennedy <george.kennedy@oracle.com>

[ Upstream commit 46d733d0efc79bc8430d63b57ab88011806d5180 ]

Restore the vcs_size() handling in vcs_read() to what
it had been in previous version.

Fixes: 226fae124b2d ("vc_screen: move load of struct vc_data pointer in vcs_read() to avoid UAF")
Suggested-by: Jiri Slaby <jirislaby@kernel.org>
Signed-off-by: George Kennedy <george.kennedy@oracle.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/vt/vc_screen.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/tty/vt/vc_screen.c b/drivers/tty/vt/vc_screen.c
index eb7208f07345d..90de3331e4a51 100644
--- a/drivers/tty/vt/vc_screen.c
+++ b/drivers/tty/vt/vc_screen.c
@@ -296,10 +296,8 @@ vcs_read(struct file *file, char __user *buf, size_t count, loff_t *ppos)
 		 */
 		size = vcs_size(inode);
 		if (size < 0) {
-			if (read)
-				break;
 			ret = size;
-			goto unlock_out;
+			break;
 		}
 		if (pos >= size)
 			break;
-- 
2.39.2



