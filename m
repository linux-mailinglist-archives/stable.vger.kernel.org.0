Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD6995EA3D9
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 13:35:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235452AbiIZLez (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 07:34:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238173AbiIZLeU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 07:34:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8A386E2E2;
        Mon, 26 Sep 2022 03:43:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ED922B80972;
        Mon, 26 Sep 2022 10:43:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EB5AC433D7;
        Mon, 26 Sep 2022 10:43:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664188995;
        bh=xBh58Z4hP5/JW9QmDnwWHRoFmnAs6QTEtY4ElTwJe8c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CLFPJNX+ulF7UyOmBekEF2bM8hWfZsOUAtB+11ZxQ3LDxDQIF08h0zzajxzCZ+W7X
         d+63tn3nAsZgUylPASOD6wa0BRf5NGA5vuKE4BcgE8z24hrX4oepY2dDYn+8ZKEDy5
         9uknRYLf/CLxEoiES/8ji0RGplyV/5PIjNg9IiEw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yuezhang Mo <Yuezhang.Mo@sony.com>,
        Andy Wu <Andy.Wu@sony.com>,
        Aoyama Wataru <wataru.aoyama@sony.com>,
        Sungjong Seo <sj1557.seo@samsung.com>,
        Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 5.19 040/207] exfat: fix overflow for large capacity partition
Date:   Mon, 26 Sep 2022 12:10:29 +0200
Message-Id: <20220926100808.419018985@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100806.522017616@linuxfoundation.org>
References: <20220926100806.522017616@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yuezhang Mo <Yuezhang.Mo@sony.com>

commit 2e9ceb6728f1dc2fa4b5d08f37d88cbc49a20a62 upstream.

Using int type for sector index, there will be overflow in a large
capacity partition.

For example, if storage with sector size of 512 bytes and partition
capacity is larger than 2TB, there will be overflow.

Fixes: 1b6138385499 ("exfat: reduce block requests when zeroing a cluster")
Cc: stable@vger.kernel.org # v5.19+
Signed-off-by: Yuezhang Mo <Yuezhang.Mo@sony.com>
Reviewed-by: Andy Wu <Andy.Wu@sony.com>
Reviewed-by: Aoyama Wataru <wataru.aoyama@sony.com>
Acked-by: Sungjong Seo <sj1557.seo@samsung.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/exfat/fatent.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/exfat/fatent.c b/fs/exfat/fatent.c
index ee0b7cf51157..41ae4cce1f42 100644
--- a/fs/exfat/fatent.c
+++ b/fs/exfat/fatent.c
@@ -270,8 +270,7 @@ int exfat_zeroed_cluster(struct inode *dir, unsigned int clu)
 	struct super_block *sb = dir->i_sb;
 	struct exfat_sb_info *sbi = EXFAT_SB(sb);
 	struct buffer_head *bh;
-	sector_t blknr, last_blknr;
-	int i;
+	sector_t blknr, last_blknr, i;
 
 	blknr = exfat_cluster_to_sector(sbi, clu);
 	last_blknr = blknr + sbi->sect_per_clus;
-- 
2.37.3



