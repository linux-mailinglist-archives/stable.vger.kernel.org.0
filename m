Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4E42500EE8
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 15:20:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243189AbiDNNWq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 09:22:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243954AbiDNNWI (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 09:22:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4ADE972FE;
        Thu, 14 Apr 2022 06:17:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 82A14B82968;
        Thu, 14 Apr 2022 13:17:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F03E4C385A1;
        Thu, 14 Apr 2022 13:17:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649942255;
        bh=KLGo8g7kILFDsYSGimZs1OgY+bChucqqpbIHm8CuvKE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u4Xylr/PCZ4z5CLxdUU0zczSw03f4GN2IsRwWS+IuaSo20Yuib3anyRpx+5zRdl+T
         IeBh8XqcZ08rfyObsmDMGzXKga1jk7hCE/xL5JV38DOE1HdGNUimF//DP6z+gLUqTW
         Q1MsGUJzlzM4wChKGNhVj4vNyB8NJGU65BDrjkPM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Machek <pavel@denx.de>,
        Chao Yu <chao@kernel.org>, Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 4.19 030/338] f2fs: fix to unlock page correctly in error path of is_alive()
Date:   Thu, 14 Apr 2022 15:08:53 +0200
Message-Id: <20220414110839.749999630@linuxfoundation.org>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <20220414110838.883074566@linuxfoundation.org>
References: <20220414110838.883074566@linuxfoundation.org>
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
@@ -589,8 +589,10 @@ static bool is_alive(struct f2fs_sb_info
 		set_sbi_flag(sbi, SBI_NEED_FSCK);
 	}
 
-	if (f2fs_check_nid_range(sbi, dni->ino))
+	if (f2fs_check_nid_range(sbi, dni->ino)) {
+		f2fs_put_page(node_page, 1);
 		return false;
+	}
 
 	*nofs = ofs_of_node(node_page);
 	source_blkaddr = datablock_addr(NULL, node_page, ofs_in_node);


