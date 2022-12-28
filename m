Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FEA8658126
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:25:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234449AbiL1QZT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:25:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234806AbiL1QY1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:24:27 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A9F2193FE
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:21:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 40D84B81707
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:21:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACD83C433D2;
        Wed, 28 Dec 2022 16:21:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672244506;
        bh=d65Vl+/h8bBat4qNVjHnKd9X9TaalEA3kwmfWgwqhJE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ShOis65ohEFhCOcJEo2n8ehoUl1lBxK5EnnLCljXqSwDn3nm5NPYma4NqLU3M7Sgo
         YuGCQi1945I3PAel9x9LWjNW1wEcpB+frdqwE7B7kjap8+I/mRrsf1DeqpVXvN3If0
         evP9Zly7XG1X6FnRDWE5XHinHpedrjyMn8ktGQa0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yangtao Li <frank.li@vivo.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0685/1146] f2fs: fix iostat parameter for discard
Date:   Wed, 28 Dec 2022 15:37:04 +0100
Message-Id: <20221228144348.748658145@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
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
index c568821b8463..c1d0713666ee 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -1170,7 +1170,7 @@ static int __submit_discard_cmd(struct f2fs_sb_info *sbi,
 
 		atomic_inc(&dcc->issued_discard);
 
-		f2fs_update_iostat(sbi, NULL, FS_DISCARD, 1);
+		f2fs_update_iostat(sbi, NULL, FS_DISCARD, len * F2FS_BLKSIZE);
 
 		lstart += len;
 		start += len;
-- 
2.35.1



