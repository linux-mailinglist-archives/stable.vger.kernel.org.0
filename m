Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2559D60A1AC
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 13:32:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230274AbiJXLcI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 07:32:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230175AbiJXLcA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 07:32:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F45756B85;
        Mon, 24 Oct 2022 04:31:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2B84B61259;
        Mon, 24 Oct 2022 11:31:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 374A7C433D6;
        Mon, 24 Oct 2022 11:31:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666611113;
        bh=BTxUk6zOdn4AF72fGjbFRugsG+1T5LCy1r/WeFDOWhM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q0fs3t7ufewgnLj0weFPFfygZl7GHa46I+NpSmi56yHdNa7mMJH4x7J46Tpum5l4x
         yS6P4i5DvnB5JnNTepo+ZQMmXXnu4PJETrmLcLMtUwUKO7Eqaz2d9iyjmtzRaX++Gt
         qVRfwXJTjIF26ElDeWc5T/G1U3IVXS1EWQHhH6lU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nikos Tsironis <ntsironis@arrikto.com>,
        Mike Snitzer <snitzer@kernel.org>
Subject: [PATCH 6.0 14/20] dm clone: Fix typo in block_device format specifier
Date:   Mon, 24 Oct 2022 13:31:16 +0200
Message-Id: <20221024112934.999774239@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024112934.415391158@linuxfoundation.org>
References: <20221024112934.415391158@linuxfoundation.org>
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

From: Nikos Tsironis <ntsironis@arrikto.com>

commit 5434ee8d28575b2e784bd5b4dbfc912e5da90759 upstream.

Use %pg for printing the block device name, instead of %pd.

Fixes: 385411ffba0c ("dm: stop using bdevname")
Cc: stable@vger.kernel.org # v5.18+
Signed-off-by: Nikos Tsironis <ntsironis@arrikto.com>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-clone-target.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-clone-target.c b/drivers/md/dm-clone-target.c
index 811b0a5379d0..2f1cc66d2641 100644
--- a/drivers/md/dm-clone-target.c
+++ b/drivers/md/dm-clone-target.c
@@ -2035,7 +2035,7 @@ static void disable_passdown_if_not_supported(struct clone *clone)
 		reason = "max discard sectors smaller than a region";
 
 	if (reason) {
-		DMWARN("Destination device (%pd) %s: Disabling discard passdown.",
+		DMWARN("Destination device (%pg) %s: Disabling discard passdown.",
 		       dest_dev, reason);
 		clear_bit(DM_CLONE_DISCARD_PASSDOWN, &clone->flags);
 	}
-- 
2.38.1



