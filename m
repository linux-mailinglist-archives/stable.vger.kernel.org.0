Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9757548AED
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:08:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378980AbiFMNqc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 09:46:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379647AbiFMNou (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 09:44:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCFD2387;
        Mon, 13 Jun 2022 04:32:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 543D960F18;
        Mon, 13 Jun 2022 11:32:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 613DCC34114;
        Mon, 13 Jun 2022 11:32:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655119939;
        bh=2pZZmn90fZNl8oQ1llHY7CXKxY/XUUSbCwhFa6pV6uM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oznKMb9YGVXDhXAktJm3Aks/rGdj7VhzXc6q1M8O2cTtRKtR6oL1dB9plsZ+b52Bm
         oXw73rHpYvaAkFmIOoJCCTPV1ksFcgNwBLa1uIN8hapEj2gCJmhTSej2DrCQXzDdMh
         f4PugjORVMFqT6bhsewP5wzKoZ6oMPF/RpGXgfQo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chao Yu <chao.yu@oppo.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 175/339] f2fs: fix to tag gcing flag on page during file defragment
Date:   Mon, 13 Jun 2022 12:10:00 +0200
Message-Id: <20220613094931.984935186@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094926.497929857@linuxfoundation.org>
References: <20220613094926.497929857@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chao Yu <chao@kernel.org>

[ Upstream commit 2d1fe8a86bf5e0663866fd0da83c2af1e1b0e362 ]

In order to garantee migrated data be persisted during checkpoint,
otherwise out-of-order persistency between data and node may cause
data corruption after SPOR.

Signed-off-by: Chao Yu <chao.yu@oppo.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/file.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index 176e97b985e6..5d1b97e852e7 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -2687,6 +2687,7 @@ static int f2fs_defragment_range(struct f2fs_sb_info *sbi,
 			}
 
 			set_page_dirty(page);
+			set_page_private_gcing(page);
 			f2fs_put_page(page, 1);
 
 			idx++;
-- 
2.35.1



