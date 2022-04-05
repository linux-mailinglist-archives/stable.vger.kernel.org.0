Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FDBE4F32F9
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 15:01:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236304AbiDEJAX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:00:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237351AbiDEIlt (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:41:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA79225CA;
        Tue,  5 Apr 2022 01:34:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C3CE8B81A32;
        Tue,  5 Apr 2022 08:34:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C126C385A1;
        Tue,  5 Apr 2022 08:34:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649147663;
        bh=g3OEDdu9egsnZhTeCe9fOFDin2NkH0OKa0ExDPR5Fys=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R17Ij5+uvUUaG+ekAQow05vm1hvAW/+8y2jgwhDEdHmehSyrnSjF0kyT7WLa6UaJf
         CSMTpwvV4pXDB3NQ5QqpreZ+KXJJLA0OWbI7fzGbaRXvj4nycrYA9eXJTkGUYmW+9G
         ony46DVSzx2PwDQjxy9RHAPpew4xa6ocQR4fjYyY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Machek <pavel@denx.de>,
        Chao Yu <chao@kernel.org>, Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 5.16 0070/1017] f2fs: fix to unlock page correctly in error path of is_alive()
Date:   Tue,  5 Apr 2022 09:16:23 +0200
Message-Id: <20220405070356.267712475@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
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

From: Chao Yu <chao@kernel.org>

commit 6d18762ed5cd549fde74fd0e05d4d87bac5a3beb upstream.

As Pavel Machek reported in below link [1]:

After commit 77900c45ee5c ("f2fs: fix to do sanity check in is_alive()"),
node page should be unlock via calling f2fs_put_page() in the error path
of is_alive(), otherwise, f2fs may hang when it tries to lock the node
page, fix it.

[1] https://lore.kernel.org/stable/20220124203637.GA19321@duo.ucw.cz/

Fixes: 77900c45ee5c ("f2fs: fix to do sanity check in is_alive()")
Cc: <stable@vger.kernel.org>
Reported-by: Pavel Machek <pavel@denx.de>
Signed-off-by: Pavel Machek <pavel@denx.de>
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/gc.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/fs/f2fs/gc.c
+++ b/fs/f2fs/gc.c
@@ -1026,8 +1026,10 @@ static bool is_alive(struct f2fs_sb_info
 		set_sbi_flag(sbi, SBI_NEED_FSCK);
 	}
 
-	if (f2fs_check_nid_range(sbi, dni->ino))
+	if (f2fs_check_nid_range(sbi, dni->ino)) {
+		f2fs_put_page(node_page, 1);
 		return false;
+	}
 
 	*nofs = ofs_of_node(node_page);
 	source_blkaddr = data_blkaddr(NULL, node_page, ofs_in_node);


