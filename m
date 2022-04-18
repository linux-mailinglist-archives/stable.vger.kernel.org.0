Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94F355050E9
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 14:27:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235409AbiDRM36 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 08:29:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239937AbiDRM3J (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 08:29:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 930EB201B3;
        Mon, 18 Apr 2022 05:22:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 08CB260F01;
        Mon, 18 Apr 2022 12:22:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 051DAC385A7;
        Mon, 18 Apr 2022 12:22:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650284574;
        bh=vw5g965VP8FLCYRwwPQsS1+F0iBPTx9Iey1xGBy+ma4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f2+HF7BL10V/4Z9lExqTA2loTP4vvI0BhyW+CrAupCp8N25oC1PxlnkU7Obkb64ud
         mW1R2vQOBTfG0025gOloPALCyUAvDaGtZHhdDhcZ0jmHEH43H5bZhvnTJH7FHUC9sY
         9NMIVherJhIpsiXAY7r3MnDKc/yJrdg/JaHUuz8A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 132/219] btrfs: do not warn for free space inode in cow_file_range
Date:   Mon, 18 Apr 2022 14:11:41 +0200
Message-Id: <20220418121210.590174074@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121203.462784814@linuxfoundation.org>
References: <20220418121203.462784814@linuxfoundation.org>
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

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit a7d16d9a07bbcb7dcd5214a1bea75c808830bc0d ]

This is a long time leftover from when I originally added the free space
inode, the point was to catch cases where we weren't honoring the NOCOW
flag.  However there exists a race with relocation, if we allocate our
free space inode in a block group that is about to be relocated, we
could trigger the COW path before the relocation has the opportunity to
find the extents and delete the free space cache.  In production where
we have auto-relocation enabled we're seeing this WARN_ON_ONCE() around
5k times in a 2 week period, so not super common but enough that it's at
the top of our metrics.

We're properly handling the error here, and with us phasing out v1 space
cache anyway just drop the WARN_ON_ONCE.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/inode.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 85daae70afda..9547088a9306 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1130,7 +1130,6 @@ static noinline int cow_file_range(struct btrfs_inode *inode,
 	int ret = 0;
 
 	if (btrfs_is_free_space_inode(inode)) {
-		WARN_ON_ONCE(1);
 		ret = -EINVAL;
 		goto out_unlock;
 	}
-- 
2.35.1



