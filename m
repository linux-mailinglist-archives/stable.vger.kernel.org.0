Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 432B1651326
	for <lists+stable@lfdr.de>; Mon, 19 Dec 2022 20:27:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232431AbiLST1x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Dec 2022 14:27:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232796AbiLST1c (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Dec 2022 14:27:32 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 520EC14010
        for <stable@vger.kernel.org>; Mon, 19 Dec 2022 11:27:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E3DF260FA8
        for <stable@vger.kernel.org>; Mon, 19 Dec 2022 19:27:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 068C5C433F0;
        Mon, 19 Dec 2022 19:27:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1671478044;
        bh=T6ogtEA/k+38oJHMiRWvj7T+7+jE5E9D0h7SCn0qiRo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CPCMZR76zuZ+1Wv69FMGsiT0ZjJ/xlPefUJEIIiUU8BzjC5pNq7xxWisSk+zOVOs0
         zb72zTVXFW5UvLNMOPyIBVY0YG5dRgNbV3Q6B7hlVcfFZosWtPvvr1HkLZhSHoPJxu
         YdHxrlDXor9C3dKwiuL4nGwx6aFWWu6pvr5JnKbY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jan Kara <jack@suse.cz>
Subject: [PATCH 5.15 03/17] udf: Do not bother looking for prealloc extents if i_lenExtents matches i_size
Date:   Mon, 19 Dec 2022 20:24:49 +0100
Message-Id: <20221219182940.843754714@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221219182940.739981110@linuxfoundation.org>
References: <20221219182940.739981110@linuxfoundation.org>
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

From: Jan Kara <jack@suse.cz>

commit 6ad53f0f71c52871202a7bf096feb2c59db33fc5 upstream.

If rounded block-rounded i_lenExtents matches block rounded i_size,
there are no preallocation extents. Do not bother walking extent linked
list.

CC: stable@vger.kernel.org
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/udf/truncate.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/udf/truncate.c
+++ b/fs/udf/truncate.c
@@ -127,9 +127,10 @@ void udf_discard_prealloc(struct inode *
 	uint64_t lbcount = 0;
 	int8_t etype = -1, netype;
 	struct udf_inode_info *iinfo = UDF_I(inode);
+	int bsize = 1 << inode->i_blkbits;
 
 	if (iinfo->i_alloc_type == ICBTAG_FLAG_AD_IN_ICB ||
-	    inode->i_size == iinfo->i_lenExtents)
+	    ALIGN(inode->i_size, bsize) == ALIGN(iinfo->i_lenExtents, bsize))
 		return;
 
 	epos.block = iinfo->i_location;


