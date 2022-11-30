Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A68163E03D
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 19:55:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231586AbiK3Sy7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 13:54:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231580AbiK3Sy4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 13:54:56 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6266E63D7E
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 10:54:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F283561D4F
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 18:54:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D123C433D6;
        Wed, 30 Nov 2022 18:54:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669834495;
        bh=kvC0Z+fVlasbVd49flBfW11BiU3Ncul9eSuZ9lZcK9w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bvBkuZCCZ1awgNO96zmYf/qTRvIVSA6FATpuM3aKORlSiY1v3eSO24X/MprHANobB
         LXWoiUiOE5nnNQnKRffMKgbEpmHatNw38tyKhNxekLZh/b7uo+NEvpQEAXOJW58xQp
         2Vw2HDb2wKBekBrLuf00qeBY2XVlpME936E0Fs1w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Qu Wenruo <wqu@suse.com>, Christoph Hellwig <hch@lst.de>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 6.0 275/289] btrfs: zoned: fix missing endianness conversion in sb_write_pointer
Date:   Wed, 30 Nov 2022 19:24:20 +0100
Message-Id: <20221130180550.335743094@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180544.105550592@linuxfoundation.org>
References: <20221130180544.105550592@linuxfoundation.org>
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

From: Christoph Hellwig <hch@lst.de>

commit c51f0e6a1254b3ac2d308e1c6fd8fb936992b455 upstream.

generation is an on-disk __le64 value, so use btrfs_super_generation to
convert it to host endian before comparing it.

Fixes: 12659251ca5d ("btrfs: implement log-structured superblock for ZONED mode")
CC: stable@vger.kernel.org # 5.15+
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/zoned.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -134,7 +134,8 @@ static int sb_write_pointer(struct block
 			super[i] = page_address(page[i]);
 		}
 
-		if (super[0]->generation > super[1]->generation)
+		if (btrfs_super_generation(super[0]) >
+		    btrfs_super_generation(super[1]))
 			sector = zones[1].start;
 		else
 			sector = zones[0].start;


