Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84779594671
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 01:03:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241175AbiHOW5E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 18:57:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352359AbiHOWzi (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 18:55:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E8CC261E;
        Mon, 15 Aug 2022 12:55:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C337561178;
        Mon, 15 Aug 2022 19:55:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE486C433D6;
        Mon, 15 Aug 2022 19:55:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660593315;
        bh=P5OullaDC/JY0jpGOHyzfuITkSwrD2srDkMM99RXN/E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vk0A/CwQ3/LOJ73fqyR/tRZv1ZveqgATrJ2218l3LdQ7JGZnfZMb+PbVTDzw01U76
         JMpgJdeKLVHN4IdKB6IXv8SZtyXuEIqL7FGnGKUnEdgt/wwQOErqK0B3Kn/2Kit8pJ
         ZZrr+C9OzYEVBsLh1JG5REEz2cu0wG7i1lXkw3VE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chao Yu <chao.yu@oppo.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0928/1095] f2fs: dont set GC_FAILURE_PIN for background GC
Date:   Mon, 15 Aug 2022 20:05:27 +0200
Message-Id: <20220815180507.633833003@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
User-Agent: quilt/0.67
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

[ Upstream commit 642c0969916eaa4878cb74f36752108e590b0389 ]

So that it can reduce the possibility that file be unpinned forcely by
foreground GC due to .i_gc_failures[GC_FAILURE_PIN] exceeds threshold.

Signed-off-by: Chao Yu <chao.yu@oppo.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/gc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/f2fs/gc.c b/fs/f2fs/gc.c
index e83c07144d8f..6a7e4148ff9d 100644
--- a/fs/f2fs/gc.c
+++ b/fs/f2fs/gc.c
@@ -1202,7 +1202,8 @@ static int move_data_block(struct inode *inode, block_t bidx,
 	}
 
 	if (f2fs_is_pinned_file(inode)) {
-		f2fs_pin_file_control(inode, true);
+		if (gc_type == FG_GC)
+			f2fs_pin_file_control(inode, true);
 		err = -EAGAIN;
 		goto out;
 	}
-- 
2.35.1



