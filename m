Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95E1060AA50
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 15:32:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232655AbiJXNcG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 09:32:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236348AbiJXNaw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 09:30:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C2733FD7B;
        Mon, 24 Oct 2022 05:33:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 32F6261313;
        Mon, 24 Oct 2022 12:33:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4313DC433C1;
        Mon, 24 Oct 2022 12:33:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666614793;
        bh=nqodhHA0fSZ4fj1OvI0ZHU49pSobUpzwzF2u4uXB7xg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WmWeM7kMrNSs60bZEc8Kp0bKjGRZP1MJ8vSa5vpqHbejGK2/Lpk7GlmFJTd9ukR7O
         IDNEmJznIubNE5VcVSpwx+lxdtHCzvyoPvbt4RF/B/EY3b/MBqeIl0HwnJKGVaR/XF
         NY+nEc6ouubAx13hGBMMzvwvJPiwj1e0Ac7gGd1g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chao Yu <chao@kernel.org>,
        Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 5.10 389/390] f2fs: fix wrong condition to trigger background checkpoint correctly
Date:   Mon, 24 Oct 2022 13:33:06 +0200
Message-Id: <20221024113039.529510342@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113022.510008560@linuxfoundation.org>
References: <20221024113022.510008560@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chao Yu <chao@kernel.org>

commit cd6d697a6e2013a0a85f8b261b16c8cfd50c1f5f upstream.

In f2fs_balance_fs_bg(), it needs to check both NAT_ENTRIES and INO_ENTRIES
memory usage to decide whether we should skip background checkpoint, otherwise
we may always skip checking INO_ENTRIES memory usage, so that INO_ENTRIES may
potentially cause high memory footprint.

Fixes: 493720a48543 ("f2fs: fix to avoid REQ_TIME and CP_TIME collision")
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/segment.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -550,7 +550,7 @@ void f2fs_balance_fs_bg(struct f2fs_sb_i
 		goto do_sync;
 
 	/* checkpoint is the only way to shrink partial cached entries */
-	if (f2fs_available_free_memory(sbi, NAT_ENTRIES) ||
+	if (f2fs_available_free_memory(sbi, NAT_ENTRIES) &&
 		f2fs_available_free_memory(sbi, INO_ENTRIES))
 		return;
 


