Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B167059A494
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 20:05:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353774AbiHSQq2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 12:46:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353878AbiHSQpN (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 12:45:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96944112F87;
        Fri, 19 Aug 2022 09:11:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A4AB6B8281F;
        Fri, 19 Aug 2022 16:10:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC2B2C433D6;
        Fri, 19 Aug 2022 16:10:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660925428;
        bh=NPl2U7eM+HNX3Ua15rTQW/pJV3+CI40vDLK3tV0Og70=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GCSZY5EJTtqo/9AZxN/wb/XAPxgy/b3sz5r4VA7XTs73lSekY6qlDKOMnXzsnk2ao
         9KxpRL/2T4MimNsSrHMWVk+MG03XqeM7Be16mMIZRmX4MhpPgTwfwjSOb9afSP2Wku
         8sQUib1v4jHvOE7GzN84oCE54svK102KXlt97RPM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mikulas Patocka <mpatocka@redhat.com>,
        Mike Snitzer <snitzer@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 488/545] dm writecache: set a default MAX_WRITEBACK_JOBS
Date:   Fri, 19 Aug 2022 17:44:18 +0200
Message-Id: <20220819153851.280330203@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220819153829.135562864@linuxfoundation.org>
References: <20220819153829.135562864@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mikulas Patocka <mpatocka@redhat.com>

[ Upstream commit ca7dc242e358e46d963b32f9d9dd829785a9e957 ]

dm-writecache has the capability to limit the number of writeback jobs
in progress. However, this feature was off by default. As such there
were some out-of-memory crashes observed when lowering the low
watermark while the cache is full.

This commit enables writeback limit by default. It is set to 256MiB or
1/16 of total system memory, whichever is smaller.

Cc: stable@vger.kernel.org
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-writecache.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-writecache.c b/drivers/md/dm-writecache.c
index 9d6ae3e64285..13cc318db012 100644
--- a/drivers/md/dm-writecache.c
+++ b/drivers/md/dm-writecache.c
@@ -20,7 +20,7 @@
 
 #define HIGH_WATERMARK			50
 #define LOW_WATERMARK			45
-#define MAX_WRITEBACK_JOBS		0
+#define MAX_WRITEBACK_JOBS		min(0x10000000 / PAGE_SIZE, totalram_pages() / 16)
 #define ENDIO_LATENCY			16
 #define WRITEBACK_LATENCY		64
 #define AUTOCOMMIT_BLOCKS_SSD		65536
-- 
2.35.1



