Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB8BB5051C2
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 14:41:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236278AbiDRMl4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 08:41:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240988AbiDRMjw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 08:39:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 373B41D0D0;
        Mon, 18 Apr 2022 05:31:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C88B1610F4;
        Mon, 18 Apr 2022 12:31:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8414C385A9;
        Mon, 18 Apr 2022 12:31:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650285101;
        bh=t7MW28y9bnZxfYQjVUSmpEWDf75vE61ViCQNbKTnzN8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TsgYJaxN1OLevYTbK93xklrHdhjkENcqPMpzBlRuID1Pdk0lJVtFKrlOh6xL4U6on
         pbxj8Qaa+Rndlbm8VTjg6mDjKXvGO4INjLWiYMXo881xjlvZDlt7AL8ZRCbrRuvT/u
         GaOKWtlRQsWh6eYFGbKnHwOzpen3F9NqIK0Ar2uo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
        Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 104/189] block: fix offset/size check in bio_trim()
Date:   Mon, 18 Apr 2022 14:12:04 +0200
Message-Id: <20220418121203.454230323@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121200.312988959@linuxfoundation.org>
References: <20220418121200.312988959@linuxfoundation.org>
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

From: Ming Lei <ming.lei@redhat.com>

[ Upstream commit 8535c0185d14ea41f0efd6a357961b05daf6687e ]

Unit of bio->bi_iter.bi_size is bytes, but unit of offset/size
is sector.

Fix the above issue in checking offset/size in bio_trim().

Fixes: e83502ca5f1e ("block: fix argument type of bio_trim()")
Cc: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Link: https://lore.kernel.org/r/20220414084443.1736850-1-ming.lei@redhat.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/bio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/bio.c b/block/bio.c
index 25f1ed261100..8906c9856a7d 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -1552,7 +1552,7 @@ EXPORT_SYMBOL(bio_split);
 void bio_trim(struct bio *bio, sector_t offset, sector_t size)
 {
 	if (WARN_ON_ONCE(offset > BIO_MAX_SECTORS || size > BIO_MAX_SECTORS ||
-			 offset + size > bio->bi_iter.bi_size))
+			 offset + size > bio_sectors(bio)))
 		return;
 
 	size <<= 9;
-- 
2.35.1



