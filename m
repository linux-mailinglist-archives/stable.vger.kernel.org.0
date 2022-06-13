Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8990548F5B
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:22:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383654AbiFMO05 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 10:26:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383979AbiFMOYZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 10:24:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54B0B95B2;
        Mon, 13 Jun 2022 04:46:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E5331612AC;
        Mon, 13 Jun 2022 11:46:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9282C34114;
        Mon, 13 Jun 2022 11:46:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655120777;
        bh=EGleJe67j/wtenNzkr2evwCWXHHiKXNmVSepmgjzxS8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HWr7m1hUCGixl2vKFIQizGDSVDuImffPfcpMaZE9Wgkm8OtSx4jKziqAlmq1NgW6z
         2P5xvMsSYV8sgo40p35rP4Pg4x/dEF07rJ9ez/dJBSrbV01s1s4Tb2Amfckq2tkI5B
         3Gdj5HWbZUTsoSFYAbGekG0wHqLe8VDgWBjMooKo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chao Yu <chao.yu@oppo.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 154/298] f2fs: fix to tag gcing flag on page during file defragment
Date:   Mon, 13 Jun 2022 12:10:48 +0200
Message-Id: <20220613094929.607849575@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094924.913340374@linuxfoundation.org>
References: <20220613094924.913340374@linuxfoundation.org>
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
index 29cd65f7c9eb..a2b7dead68e0 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -2679,6 +2679,7 @@ static int f2fs_defragment_range(struct f2fs_sb_info *sbi,
 			}
 
 			set_page_dirty(page);
+			set_page_private_gcing(page);
 			f2fs_put_page(page, 1);
 
 			idx++;
-- 
2.35.1



