Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4744E664A07
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 19:29:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238962AbjAJS3M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 13:29:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239250AbjAJS2G (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 13:28:06 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE68D2AD5
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 10:23:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 98D16B81901
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 18:23:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFC47C433EF;
        Tue, 10 Jan 2023 18:23:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673375011;
        bh=N8HJ+T5jY+UZW58ZDvi7qE4zwhFcAun3bV5rgnrnhi0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RxdGn2Bh1kvonk5P4N6rrbComXyGq1et96AcDr5JmHuTkeoz/G5pJn82UESfyk349
         nOtuTlVGc3Ptd9+tH3YhV8LvWQiCLnIEUGw2t0IHIYT4so8vblScN2hZTIZukk4ZkJ
         v5LS5Gj2Pv44VcoA16YExiWdZn2xo5CVbTBGvOPc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Chao Yu <chao@kernel.org>,
        Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 5.15 048/290] f2fs: allow to read node block after shutdown
Date:   Tue, 10 Jan 2023 19:02:20 +0100
Message-Id: <20230110180033.261361002@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180031.620810905@linuxfoundation.org>
References: <20230110180031.620810905@linuxfoundation.org>
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

From: Jaegeuk Kim <jaegeuk@kernel.org>

commit e6ecb142429183cef4835f31d4134050ae660032 upstream.

If block address is still alive, we should give a valid node block even after
shutdown. Otherwise, we can see zero data when reading out a file.

Cc: stable@vger.kernel.org
Fixes: 83a3bfdb5a8a ("f2fs: indicate shutdown f2fs to allow unmount successfully")
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/node.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -1357,8 +1357,7 @@ static int read_node_page(struct page *p
 		return err;
 
 	/* NEW_ADDR can be seen, after cp_error drops some dirty node pages */
-	if (unlikely(ni.blk_addr == NULL_ADDR || ni.blk_addr == NEW_ADDR) ||
-			is_sbi_flag_set(sbi, SBI_IS_SHUTDOWN)) {
+	if (unlikely(ni.blk_addr == NULL_ADDR || ni.blk_addr == NEW_ADDR)) {
 		ClearPageUptodate(page);
 		return -ENOENT;
 	}


