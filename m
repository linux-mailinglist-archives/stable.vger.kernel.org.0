Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 976D456FB4E
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 11:28:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232375AbiGKJ2m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 05:28:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232373AbiGKJ2J (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 05:28:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D187065D4A;
        Mon, 11 Jul 2022 02:15:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1895EB80CEF;
        Mon, 11 Jul 2022 09:15:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66D89C34115;
        Mon, 11 Jul 2022 09:15:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657530946;
        bh=W8/U7RwBnc4bjGCMnrC47ATNXOlB1KpgtdGMePTGKuo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JeC3ZXeqQS3jLUSVS+3rZarJzq5xz50vvvapDFMKlMjAW7vRtQrkzOF6bQv1v8OsT
         H1e78waiISvdu5EsCocoei3gi68dL+zMeFuB2SzLAQsq5CDRQmHdtuye7WOn9nImDT
         c+9JYvmkvRjikv9s12FFkmPBVZf0WNxqbc4V9TC4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yue Hu <huyue2@coolpad.com>,
        David Howells <dhowells@redhat.com>,
        Gao Xiang <hsiangkao@linux.alibaba.com>,
        Jeffle Xu <jefflexu@linux.alibaba.com>,
        Jeff Layton <jlayton@kernel.org>
Subject: [PATCH 5.18 042/112] fscache: Fix if condition in fscache_wait_on_volume_collision()
Date:   Mon, 11 Jul 2022 11:06:42 +0200
Message-Id: <20220711090550.767202252@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220711090549.543317027@linuxfoundation.org>
References: <20220711090549.543317027@linuxfoundation.org>
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

From: Yue Hu <huyue2@coolpad.com>

commit bf17455b9cbd4b10bf30d39c047307e1d774fb1a upstream.

After waiting for the volume to complete the acquisition with timeout,
the if condition under which potential volume collision occurs should be
acquire the volume is still pending rather than not pending so that we
will continue to wait until the pending flag is cleared. Also, use the
existing test pending wrapper directly instead of test_bit().

Fixes: 62ab63352350 ("fscache: Implement volume registration")
Signed-off-by: Yue Hu <huyue2@coolpad.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Reviewed-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Reviewed-by: Jeffle Xu <jefflexu@linux.alibaba.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Link: https://listman.redhat.com/archives/linux-cachefs/2022-May/006918.html
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/fscache/volume.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/fscache/volume.c
+++ b/fs/fscache/volume.c
@@ -143,7 +143,7 @@ static void fscache_wait_on_volume_colli
 {
 	wait_var_event_timeout(&candidate->flags,
 			       !fscache_is_acquire_pending(candidate), 20 * HZ);
-	if (!fscache_is_acquire_pending(candidate)) {
+	if (fscache_is_acquire_pending(candidate)) {
 		pr_notice("Potential volume collision new=%08x old=%08x",
 			  candidate->debug_id, collidee_debug_id);
 		fscache_stat(&fscache_n_volumes_collision);
@@ -182,7 +182,7 @@ static bool fscache_hash_volume(struct f
 	hlist_bl_add_head(&candidate->hash_link, h);
 	hlist_bl_unlock(h);
 
-	if (test_bit(FSCACHE_VOLUME_ACQUIRE_PENDING, &candidate->flags))
+	if (fscache_is_acquire_pending(candidate))
 		fscache_wait_on_volume_collision(candidate, collidee_debug_id);
 	return true;
 


