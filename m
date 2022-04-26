Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEA7550F42E
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 10:32:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345071AbiDZIf2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 04:35:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345354AbiDZIec (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 04:34:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8432374867;
        Tue, 26 Apr 2022 01:27:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1B70E6179E;
        Tue, 26 Apr 2022 08:27:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FE22C385A0;
        Tue, 26 Apr 2022 08:27:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650961627;
        bh=eHIuRoQIdPxgG8oN0IWERZQhX1NYrprx+LxNoPGH7wY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fPGWZPo3MAUWuWEmhO8XBeSQ5MQ8CuL/Lh63MkSF6/hSr5AclzXrYBfpHA6I9c/0D
         mDMq+KUHkA2LCzW6L7CxIHTUA85ln7puaW8gP44EEx9nVUXHQp0Lz+WDgUd/LUXlv0
         vcgKFXKNgXOy6WOQw42OU60coD45fPvcOY/lCAto=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mikulas Patocka <mpatocka@redhat.com>,
        Mike Snitzer <snitzer@kernel.org>
Subject: [PATCH 4.19 05/53] dm integrity: fix memory corruption when tag_size is less than digest size
Date:   Tue, 26 Apr 2022 10:20:45 +0200
Message-Id: <20220426081735.813142442@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220426081735.651926456@linuxfoundation.org>
References: <20220426081735.651926456@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mikulas Patocka <mpatocka@redhat.com>

commit 08c1af8f1c13bbf210f1760132f4df24d0ed46d6 upstream.

It is possible to set up dm-integrity in such a way that the
"tag_size" parameter is less than the actual digest size. In this
situation, a part of the digest beyond tag_size is ignored.

In this case, dm-integrity would write beyond the end of the
ic->recalc_tags array and corrupt memory. The corruption happened in
integrity_recalc->integrity_sector_checksum->crypto_shash_final.

Fix this corruption by increasing the tags array so that it has enough
padding at the end to accomodate the loop in integrity_recalc() being
able to write a full digest size for the last member of the tags
array.

Cc: stable@vger.kernel.org # v4.19+
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-integrity.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -3504,6 +3504,7 @@ try_smaller_buffer:
 	}
 
 	if (ic->sb->flags & cpu_to_le32(SB_FLAG_RECALCULATING)) {
+		size_t recalc_tags_size;
 		if (!ic->internal_hash) {
 			r = -EINVAL;
 			ti->error = "Recalculate is only valid with internal hash";
@@ -3522,8 +3523,10 @@ try_smaller_buffer:
 			r = -ENOMEM;
 			goto bad;
 		}
-		ic->recalc_tags = kvmalloc_array(RECALC_SECTORS >> ic->sb->log2_sectors_per_block,
-						 ic->tag_size, GFP_KERNEL);
+		recalc_tags_size = (RECALC_SECTORS >> ic->sb->log2_sectors_per_block) * ic->tag_size;
+		if (crypto_shash_digestsize(ic->internal_hash) > ic->tag_size)
+			recalc_tags_size += crypto_shash_digestsize(ic->internal_hash) - ic->tag_size;
+		ic->recalc_tags = kvmalloc(recalc_tags_size, GFP_KERNEL);
 		if (!ic->recalc_tags) {
 			ti->error = "Cannot allocate tags for recalculating";
 			r = -ENOMEM;


