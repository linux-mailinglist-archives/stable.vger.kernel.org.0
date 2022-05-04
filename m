Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22D7751AA27
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 19:19:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356785AbiEDRVx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 13:21:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357498AbiEDRPE (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 13:15:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6ECA54F9E;
        Wed,  4 May 2022 09:58:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 27F5E618B4;
        Wed,  4 May 2022 16:58:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7250CC385A5;
        Wed,  4 May 2022 16:58:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651683518;
        bh=bvN0Q2KeQ+lFGhU9gqxM4MpeW6/hWRogBqaVHPcl+dA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ewt90gjRwPBk5B9/yW7LWJKUrYufgBnQMC89mWrzwgqb2dQ5EK06ttE5HgiQp+j2+
         GfqYUze4avv/ZhAFEUjbTQNSpW82cZH0Puyv+Y6NrFY+Cw2K+7nY/ABasR2ZJr8ZST
         H2NvDIp8RZPut/LDXaAaXePGRqXH11olNTSuTJ9g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Filipe Manana <fdmanana@suse.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.17 193/225] btrfs: fix leaked plug after failure syncing log on zoned filesystems
Date:   Wed,  4 May 2022 18:47:11 +0200
Message-Id: <20220504153127.459522306@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220504153110.096069935@linuxfoundation.org>
References: <20220504153110.096069935@linuxfoundation.org>
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

From: Filipe Manana <fdmanana@suse.com>

commit 50ff57888d0b13440e7f4cde05dc339ee8d0f1f8 upstream.

On a zoned filesystem, if we fail to allocate the root node for the log
root tree while syncing the log, we end up returning without finishing
the IO plug we started before, resulting in leaking resources as we
have started writeback for extent buffers of a log tree before. That
allocation failure, which typically is either -ENOMEM or -ENOSPC, is not
fatal and the fsync can safely fallback to a full transaction commit.

So release the IO plug if we fail to allocate the extent buffer for the
root of the log root tree when syncing the log on a zoned filesystem.

Fixes: 3ddebf27fcd3a9 ("btrfs: zoned: reorder log node allocation on zoned filesystem")
CC: stable@vger.kernel.org # 5.15+
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/tree-log.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -3225,6 +3225,7 @@ int btrfs_sync_log(struct btrfs_trans_ha
 			ret = btrfs_alloc_log_tree_node(trans, log_root_tree);
 			if (ret) {
 				mutex_unlock(&fs_info->tree_root->log_mutex);
+				blk_finish_plug(&plug);
 				goto out;
 			}
 		}


