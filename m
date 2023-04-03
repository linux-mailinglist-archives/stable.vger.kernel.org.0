Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40B676D4AC2
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 16:50:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233972AbjDCOuK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 10:50:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233829AbjDCOts (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 10:49:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53328280EF
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 07:49:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1EE8B61F53
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 14:48:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F168C433D2;
        Mon,  3 Apr 2023 14:48:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680533328;
        bh=2AC7GPNx/CQVbkxhE8DKBShGd2Ym1rSArirjGCjbPMk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xcn4VdcA7cpvnGdesCSts4QYHfV5dxXw5F21k2j+Z7WGPxM8Ke1vEJUkTZSdIpS4G
         DZjHffmPo3WavnOM6D6XvBpJLV7KsZA/sB0TDJNJXZRyoIaPpnzE6E4rso7QtoJtws
         GEs0neCC4soAkC9IODzxNaEfcWr3ciuGe47wHBnY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.2 141/187] io_uring/rsrc: fix rogue rsrc node grabbing
Date:   Mon,  3 Apr 2023 16:09:46 +0200
Message-Id: <20230403140420.646066045@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140416.015323160@linuxfoundation.org>
References: <20230403140416.015323160@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Begunkov <asml.silence@gmail.com>

commit 4ff0b50de8cabba055efe50bbcb7506c41a69835 upstream.

We should not be looking at ctx->rsrc_node and anyhow modifying the node
without holding uring_lock, grabbing references in such a way is not
safe either.

Cc: stable@vger.kernel.org
Fixes: 5106dd6e74ab6 ("io_uring: propagate issue_flags state down to file assignment")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/1202ede2d7bb90136e3482b2b84aad9ed483e5d6.1680098433.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/rsrc.h |   12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

--- a/io_uring/rsrc.h
+++ b/io_uring/rsrc.h
@@ -144,15 +144,13 @@ static inline void io_req_set_rsrc_node(
 					unsigned int issue_flags)
 {
 	if (!req->rsrc_node) {
-		req->rsrc_node = ctx->rsrc_node;
+		io_ring_submit_lock(ctx, issue_flags);
 
-		if (!(issue_flags & IO_URING_F_UNLOCKED)) {
-			lockdep_assert_held(&ctx->uring_lock);
+		lockdep_assert_held(&ctx->uring_lock);
 
-			io_charge_rsrc_node(ctx);
-		} else {
-			percpu_ref_get(&req->rsrc_node->refs);
-		}
+		req->rsrc_node = ctx->rsrc_node;
+		io_charge_rsrc_node(ctx);
+		io_ring_submit_unlock(ctx, issue_flags);
 	}
 }
 


