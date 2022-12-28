Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C43C865807F
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:18:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234622AbiL1QSN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:18:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233192AbiL1QR2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:17:28 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69A82FCE3
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:16:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 097FEB81730
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:16:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64C62C433EF;
        Wed, 28 Dec 2022 16:16:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672244162;
        bh=lXEuSs+abOms+cVyJLywwXWMhSmVpGFxM/8vaaNsc+w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jYVjdjWIbOSWRhJWo+WRGYsmVvYaorYo5uL+sa3Wxc5FoXoH5tmKv/uKQFLtyJs/P
         06eEOH/jepdOs/qamn5DuBBIW5GntnoEcWrq708RLr1GxqvSn/0EGWE+x07J8dX6fH
         SaWY8J/HqYQpe7HjDjdKITDdf9G1ZVIPg+WymExc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yangtao Li <frank.li@vivo.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0661/1073] f2fs: fix iostat parameter for discard
Date:   Wed, 28 Dec 2022 15:37:29 +0100
Message-Id: <20221228144345.999957176@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
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

From: Yangtao Li <frank.li@vivo.com>

[ Upstream commit 15e38ee44d50cad264da80ef75626b9224ddc4a3 ]

Just like other data we count uses the number of bytes as the basic unit,
but discard uses the number of cmds as the statistical unit. In fact the
discard command contains the number of blocks, so let's change to the
number of bytes as the base unit.

Fixes: b0af6d491a6b ("f2fs: add app/fs io stat")
Signed-off-by: Yangtao Li <frank.li@vivo.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/segment.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index 27690f757913..2afed479160b 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -1171,7 +1171,7 @@ static int __submit_discard_cmd(struct f2fs_sb_info *sbi,
 
 		atomic_inc(&dcc->issued_discard);
 
-		f2fs_update_iostat(sbi, FS_DISCARD, 1);
+		f2fs_update_iostat(sbi, FS_DISCARD, len * F2FS_BLKSIZE);
 
 		lstart += len;
 		start += len;
-- 
2.35.1



