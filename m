Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D433B594D2D
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 03:34:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245146AbiHPAtY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 20:49:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240795AbiHPAr1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 20:47:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D95B7B5E67;
        Mon, 15 Aug 2022 13:45:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BD1E061265;
        Mon, 15 Aug 2022 20:45:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8646C433D6;
        Mon, 15 Aug 2022 20:45:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660596345;
        bh=o3wlLHJ0FeVKurwv53Nfr7pBx/G+aKgzwMVRwDgmasU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hLYZVuKEszrUl6xNnFK5ddjZuyquhADE44TltucuZNMqsL2gDbhU3MQUKhpG8NdQ+
         V0s8/JrENEuDMO6QKgLG+pHtrq5na6qsnVPnt+ErYpNFzDaahQKvOBX2sl53X3IOVu
         45XbscptSuPUa6en69FQv3Jd9zErM1biOnIutRM4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chao Yu <chao.yu@oppo.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 1007/1157] f2fs: fix to check inline_data during compressed inode conversion
Date:   Mon, 15 Aug 2022 20:06:03 +0200
Message-Id: <20220815180520.102413690@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
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

[ Upstream commit 7165841d578e0592848e09dc9d131aa30be44e1b ]

When converting inode to compressed one via ioctl, it needs to check
inline_data, since inline_data flag and compressed flag are incompatible.

Fixes: 4c8ff7095bef ("f2fs: support data compression")
Signed-off-by: Chao Yu <chao.yu@oppo.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/f2fs.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index d9bbecd008d2..5c950298837f 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -4401,7 +4401,7 @@ static inline bool f2fs_lfs_mode(struct f2fs_sb_info *sbi)
 static inline bool f2fs_may_compress(struct inode *inode)
 {
 	if (IS_SWAPFILE(inode) || f2fs_is_pinned_file(inode) ||
-				f2fs_is_atomic_file(inode))
+		f2fs_is_atomic_file(inode) || f2fs_has_inline_data(inode))
 		return false;
 	return S_ISREG(inode->i_mode) || S_ISDIR(inode->i_mode);
 }
-- 
2.35.1



