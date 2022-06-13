Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36A5B548A57
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:07:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244569AbiFMKvM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 06:51:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245056AbiFMKtk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 06:49:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D4172E9D9;
        Mon, 13 Jun 2022 03:27:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A7E23B80E94;
        Mon, 13 Jun 2022 10:27:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 077A8C34114;
        Mon, 13 Jun 2022 10:27:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655116034;
        bh=GVBoC3ONwbd18zu1JOv8mlw0ejjz+jFPu3hUDCp8mUM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cwDT0fP0uRX7331Kr/FaSyHVAlTS7ZKl03T/nIsFls7KEMdvKhbqCVFzPIvVIATOE
         60goLNor4e9tcjHdLm79lfiK2AF9pCP8aZinGCQJcHmOPr3FWMHu5swrcqvrs68jfp
         8o8TeUjpPoD6If/UoE10ed9vNr4iQkrtoXzzOrAU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nikolay Borisov <nborisov@suse.com>,
        Qu Wenruo <wqu@suse.com>, David Sterba <dsterba@suse.com>
Subject: [PATCH 5.4 010/411] btrfs: add "0x" prefix for unsupported optional features
Date:   Mon, 13 Jun 2022 12:04:43 +0200
Message-Id: <20220613094928.804598824@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094928.482772422@linuxfoundation.org>
References: <20220613094928.482772422@linuxfoundation.org>
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
@@ -2927,7 +2927,7 @@ int open_ctree(struct super_block *sb,
 		~BTRFS_FEATURE_INCOMPAT_SUPP;
 	if (features) {
 		btrfs_err(fs_info,
-		    "cannot mount because of unsupported optional features (%llx)",
+		    "cannot mount because of unsupported optional features (0x%llx)",
 		    features);
 		err = -EINVAL;
 		goto fail_csum;
@@ -2965,7 +2965,7 @@ int open_ctree(struct super_block *sb,
 		~BTRFS_FEATURE_COMPAT_RO_SUPP;
 	if (!sb_rdonly(sb) && features) {
 		btrfs_err(fs_info,
-	"cannot mount read-write because of unsupported optional features (%llx)",
+	"cannot mount read-write because of unsupported optional features (0x%llx)",
 		       features);
 		err = -EINVAL;
 		goto fail_csum;


