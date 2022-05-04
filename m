Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D175351A712
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 18:58:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350932AbiEDRBs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 13:01:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355605AbiEDRAR (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 13:00:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2B8F4B438;
        Wed,  4 May 2022 09:51:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ABFCA617E7;
        Wed,  4 May 2022 16:51:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1041C385A4;
        Wed,  4 May 2022 16:51:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651683103;
        bh=nMML2so8EdmjRvi1bx9EPmflZxJh2Wa6JT2EQtbEGSM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UbPSuXLmJDgNKokLWmxznFZr4zbgadgp2EL9e67IgrlyFW5Lgm9ZF+GixH8cZZUPo
         hZAAk7yjYrwDMCGHs6UtLWGiC1JpltmnzZCvjh+AoYXKXpOWXa4cyeRbXNR4j7ownf
         WfUAgHlwDJuHWqHYk4KQtUdQr+VLRNxKteLIcodk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        Hans Holmberg <hans.holmberg@wdc.com>
Subject: [PATCH 5.10 107/129] zonefs: Clear inode information flags on inode creation
Date:   Wed,  4 May 2022 18:44:59 +0200
Message-Id: <20220504153029.503397862@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220504153021.299025455@linuxfoundation.org>
References: <20220504153021.299025455@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Damien Le Moal <damien.lemoal@opensource.wdc.com>

commit 694852ead287a3433126e7ebda397b242dc99624 upstream.

Ensure that the i_flags field of struct zonefs_inode_info is cleared to
0 when initializing a zone file inode, avoiding seeing the flag
ZONEFS_ZONE_OPEN being incorrectly set.

Fixes: b5c00e975779 ("zonefs: open/close zone on file open/close")
Cc: <stable@vger.kernel.org>
Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Reviewed-by: Hans Holmberg <hans.holmberg@wdc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/zonefs/super.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/zonefs/super.c
+++ b/fs/zonefs/super.c
@@ -1163,6 +1163,7 @@ static struct inode *zonefs_alloc_inode(
 	mutex_init(&zi->i_truncate_mutex);
 	init_rwsem(&zi->i_mmap_sem);
 	zi->i_wr_refcnt = 0;
+	zi->i_flags = 0;
 
 	return &zi->i_vnode;
 }


