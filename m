Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7C4D548454
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 12:16:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235714AbiFMKOQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 06:14:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236228AbiFMKOL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 06:14:11 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69C18BFA;
        Mon, 13 Jun 2022 03:14:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id CE1D2CE1162;
        Mon, 13 Jun 2022 10:14:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B00EDC34114;
        Mon, 13 Jun 2022 10:14:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655115247;
        bh=5jYTeBqo3oU6BgHoauTf9S850Trge8WOmBNu5k1P8tU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DGLLUfdWgFU2bZsdOlIPEoK39j5Dg0jlEWEkWC1GKzyqYiVisJiXPtHGmM/7T7s2r
         ws8y84Lu0sqQ9siRdaeu67sycStDuDqiafZsrBt3Yuu/xdN0+1OO+Y4v5/FXvC6ute
         R5PO8utCdNpOUSP/wW3HuPeLwwaELUM+693efVPA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nikolay Borisov <nborisov@suse.com>,
        Qu Wenruo <wqu@suse.com>, David Sterba <dsterba@suse.com>
Subject: [PATCH 4.9 004/167] btrfs: add "0x" prefix for unsupported optional features
Date:   Mon, 13 Jun 2022 12:07:58 +0200
Message-Id: <20220613094841.753640147@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094840.720778945@linuxfoundation.org>
References: <20220613094840.720778945@linuxfoundation.org>
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

From: Qu Wenruo <wqu@suse.com>

commit d5321a0fa8bc49f11bea0b470800962c17d92d8f upstream.

The following error message lack the "0x" obviously:

  cannot mount because of unsupported optional features (4000)

Add the prefix to make it less confusing. This can happen on older
kernels that try to mount a filesystem with newer features so it makes
sense to backport to older trees.

CC: stable@vger.kernel.org # 4.14+
Reviewed-by: Nikolay Borisov <nborisov@suse.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/disk-io.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2716,7 +2716,7 @@ int open_ctree(struct super_block *sb,
 		~BTRFS_FEATURE_INCOMPAT_SUPP;
 	if (features) {
 		btrfs_err(fs_info,
-		    "cannot mount because of unsupported optional features (%llx)",
+		    "cannot mount because of unsupported optional features (0x%llx)",
 		    features);
 		err = -EINVAL;
 		goto fail_alloc;
@@ -2769,7 +2769,7 @@ int open_ctree(struct super_block *sb,
 		~BTRFS_FEATURE_COMPAT_RO_SUPP;
 	if (!(sb->s_flags & MS_RDONLY) && features) {
 		btrfs_err(fs_info,
-	"cannot mount read-write because of unsupported optional features (%llx)",
+	"cannot mount read-write because of unsupported optional features (0x%llx)",
 		       features);
 		err = -EINVAL;
 		goto fail_alloc;


