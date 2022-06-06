Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A92053EC08
	for <lists+stable@lfdr.de>; Mon,  6 Jun 2022 19:09:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231854AbiFFM2a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Jun 2022 08:28:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236812AbiFFM23 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Jun 2022 08:28:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11C72BF4E
        for <stable@vger.kernel.org>; Mon,  6 Jun 2022 05:28:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A3377611CC
        for <stable@vger.kernel.org>; Mon,  6 Jun 2022 12:28:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B240CC385A9;
        Mon,  6 Jun 2022 12:28:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654518507;
        bh=4MAc3WcBDW/wwvM0B55dFn+o7i+oHCO+ej9xXPi+gII=;
        h=Subject:To:Cc:From:Date:From;
        b=ftNEWLPd5WUbgyd1enENO+Rk1lnDAUE/MDnJB8xS1lM0X1V/LZkpzSIBfdQ0hGVMw
         PN9MHfihaG7swJTAnvc13TmkscsTLuKQuHyL+i6x3piYiKoEJXN5GdbcFQOFFxVxEx
         u7Z/n7Hz79BkTI++FoZSL8fV7lmyadg9c2W05WL0=
Subject: FAILED: patch "[PATCH] zonefs: Clear inode information flags on inode creation" failed to apply to 5.10-stable tree
To:     damien.lemoal@opensource.wdc.com, hans.holmberg@wdc.com,
        johannes.thumshirn@wdc.com, kch@nvidia.com, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 06 Jun 2022 14:28:15 +0200
Message-ID: <16545184953543@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From b954ebba296bb2eb2e38322f17aaa6426934bd7e Mon Sep 17 00:00:00 2001
From: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Date: Tue, 12 Apr 2022 20:52:35 +0900
Subject: [PATCH] zonefs: Clear inode information flags on inode creation

Ensure that the i_flags field of struct zonefs_inode_info is cleared to
0 when initializing a zone file inode, avoiding seeing the flag
ZONEFS_ZONE_OPEN being incorrectly set.

Fixes: b5c00e975779 ("zonefs: open/close zone on file open/close")
Cc: <stable@vger.kernel.org>
Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Reviewed-by: Hans Holmberg <hans.holmberg@wdc.com>

diff --git a/fs/zonefs/super.c b/fs/zonefs/super.c
index 3614c7834007..75d8dabe0807 100644
--- a/fs/zonefs/super.c
+++ b/fs/zonefs/super.c
@@ -1142,6 +1142,7 @@ static struct inode *zonefs_alloc_inode(struct super_block *sb)
 	inode_init_once(&zi->i_vnode);
 	mutex_init(&zi->i_truncate_mutex);
 	zi->i_wr_refcnt = 0;
+	zi->i_flags = 0;
 
 	return &zi->i_vnode;
 }

