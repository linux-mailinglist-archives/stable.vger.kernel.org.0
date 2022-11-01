Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA7486148E5
	for <lists+stable@lfdr.de>; Tue,  1 Nov 2022 12:31:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230464AbiKALbM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 07:31:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229944AbiKALal (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 07:30:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BA2E63F9;
        Tue,  1 Nov 2022 04:29:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D293AB81CC6;
        Tue,  1 Nov 2022 11:29:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A186DC433C1;
        Tue,  1 Nov 2022 11:29:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667302158;
        bh=e8tBsfk9EYh1neUMVjssmIJU9k1CMFsjsde1Uilgo88=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=To6Gz/mzR5sl1yK8wueU1ymrCjZF7kYU4axgjQLGkNe8Q1aegLdeOXzyFD1FFezud
         89YYtpiZebaWuFnABLgTcs/y9fQlpvkMuI5ohMECsGNOf7VXhhzXps7NUTYMI826g4
         QRCanvt0YD7m0zWQrxBUtxYEntMqjyzO2JtBWXZkMeASkDXGlXuji+2871VeSiiN01
         ZdoT9wp2jJIBsDU2EfV6iidrf/00o86ignd8To7i5XAjkC2v3/exAmex5ilXdwxjWW
         //VUUoxxft29CrK+aPFQM8DJaY6MBUWwzJe/qljM5yVnbCvcwT0D7J/d88VBstwyc4
         Xj+CN+jbesLoQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>, linux-block@vger.kernel.org
Subject: [PATCH AUTOSEL 6.0 34/34] bio: safeguard REQ_ALLOC_CACHE bio put
Date:   Tue,  1 Nov 2022 07:27:26 -0400
Message-Id: <20221101112726.799368-34-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221101112726.799368-1-sashal@kernel.org>
References: <20221101112726.799368-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Begunkov <asml.silence@gmail.com>

[ Upstream commit d4347d50407daea6237872281ece64c4bdf1ec99 ]

bio_put() with REQ_ALLOC_CACHE assumes that it's executed not from
an irq context. Let's add a warning if the invariant is not respected,
especially since there is a couple of places removing REQ_POLLED by hand
without also clearing REQ_ALLOC_CACHE.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/558d78313476c4e9c233902efa0092644c3d420a.1666122465.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/bio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/bio.c b/block/bio.c
index 77e3b764a078..fc2364cf1775 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -741,7 +741,7 @@ void bio_put(struct bio *bio)
 			return;
 	}
 
-	if (bio->bi_opf & REQ_ALLOC_CACHE) {
+	if ((bio->bi_opf & REQ_ALLOC_CACHE) && !WARN_ON_ONCE(in_interrupt())) {
 		struct bio_alloc_cache *cache;
 
 		bio_uninit(bio);
-- 
2.35.1

