Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAF666B465A
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:42:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232844AbjCJOme (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:42:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232859AbjCJOmZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:42:25 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3490120EBC
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:42:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 481F261771
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:42:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52E90C433EF;
        Fri, 10 Mar 2023 14:42:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678459326;
        bh=gqroH3tA5sDEgMCfGKeMPazNlRijwCEdoLxVVlCed20=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EUSJAiR0v9NCQ41IpM0G0UPTPzGS/tUQ0dQLm0QXAyj92fn7/8scW25ZN9E6QP686
         hu2f+sL1ezj+zupb7WhOjmskiXpW79xVBZYFO4Z7p17jsAfWGNg7HW0b0RmJuVVtib
         sT+72lU/S44xlzOgnY+0q4gsRTRPsQy8HwBmetPo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        syzbot+0be96567042453c0c820@syzkaller.appspotmail.com,
        Liu Shixin <liushixin2@huawei.com>,
        Dave Kleikamp <dave.kleikamp@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 284/357] fs/jfs: fix shift exponent db_agl2size negative
Date:   Fri, 10 Mar 2023 14:39:33 +0100
Message-Id: <20230310133747.293452588@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133733.973883071@linuxfoundation.org>
References: <20230310133733.973883071@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Liu Shixin via Jfs-discussion <jfs-discussion@lists.sourceforge.net>

[ Upstream commit fad376fce0af58deebc5075b8539dc05bf639af3 ]

As a shift exponent, db_agl2size can not be less than 0. Add the missing
check to fix the shift-out-of-bounds bug reported by syzkaller:

 UBSAN: shift-out-of-bounds in fs/jfs/jfs_dmap.c:2227:15
 shift exponent -744642816 is negative

Reported-by: syzbot+0be96567042453c0c820@syzkaller.appspotmail.com
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Liu Shixin <liushixin2@huawei.com>
Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/jfs/jfs_dmap.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/jfs/jfs_dmap.c b/fs/jfs/jfs_dmap.c
index aa4643854f947..cc1fed285b2d6 100644
--- a/fs/jfs/jfs_dmap.c
+++ b/fs/jfs/jfs_dmap.c
@@ -193,7 +193,8 @@ int dbMount(struct inode *ipbmap)
 	bmp->db_agwidth = le32_to_cpu(dbmp_le->dn_agwidth);
 	bmp->db_agstart = le32_to_cpu(dbmp_le->dn_agstart);
 	bmp->db_agl2size = le32_to_cpu(dbmp_le->dn_agl2size);
-	if (bmp->db_agl2size > L2MAXL2SIZE - L2MAXAG) {
+	if (bmp->db_agl2size > L2MAXL2SIZE - L2MAXAG ||
+	    bmp->db_agl2size < 0) {
 		err = -EINVAL;
 		goto err_release_metapage;
 	}
-- 
2.39.2



