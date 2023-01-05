Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F77465EB2C
	for <lists+stable@lfdr.de>; Thu,  5 Jan 2023 13:56:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232235AbjAEM4u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Jan 2023 07:56:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232691AbjAEM4s (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Jan 2023 07:56:48 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 453404D4A3
        for <stable@vger.kernel.org>; Thu,  5 Jan 2023 04:56:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DCFAB61A0A
        for <stable@vger.kernel.org>; Thu,  5 Jan 2023 12:56:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC15BC433F0;
        Thu,  5 Jan 2023 12:56:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672923407;
        bh=T6ogtEA/k+38oJHMiRWvj7T+7+jE5E9D0h7SCn0qiRo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bR+v2vyZCXXXUEqYjF88m3q43/szjvUEruyRqtByXCxafeY0Q8FOqiBzVsmJ8T3nz
         ZydiHuHAilcuB2MfIN4LOViAnnYw9PsLlDHVKqY2EvQM7LGOe41vLyIrma0VfokOA+
         bm8x3VG1DKczeU9IGTLCWKLvG/nf3FxJ7yQPW27g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jan Kara <jack@suse.cz>
Subject: [PATCH 4.9 010/251] udf: Do not bother looking for prealloc extents if i_lenExtents matches i_size
Date:   Thu,  5 Jan 2023 13:52:27 +0100
Message-Id: <20230105125335.208452354@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230105125334.727282894@linuxfoundation.org>
References: <20230105125334.727282894@linuxfoundation.org>
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


