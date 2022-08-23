Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0877C59DB64
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:19:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244091AbiHWKpH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 06:45:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350994AbiHWKmx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 06:42:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7061FAA4F9;
        Tue, 23 Aug 2022 02:10:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7208560EFB;
        Tue, 23 Aug 2022 09:10:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A64EC433B5;
        Tue, 23 Aug 2022 09:10:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661245818;
        bh=uW7eY63ZhSgsE1wQj23d5+bX5fq600O+sVk+bqkRiew=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rLEBzOLE8IvyN1Cq+w1HKyAQVbPrrChJ+hOw6Uyuyx+RpXEyFsUtZKpLLgfcw+sp2
         7ccnXTtbg2IGHrKzYsSulcBqnbRVdC0RaCdYW8MPrNg+oynVFn6Ir41YLLWwyYaf4/
         fEDE+LSLjzYtW0JAquixGZZ90cod72Xpl5jqW+lE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mikulas Patocka <mpatocka@redhat.com>,
        Mike Snitzer <snitzer@kernel.org>
Subject: [PATCH 4.19 199/287] dm writecache: set a default MAX_WRITEBACK_JOBS
Date:   Tue, 23 Aug 2022 10:26:08 +0200
Message-Id: <20220823080107.545184357@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080100.268827165@linuxfoundation.org>
References: <20220823080100.268827165@linuxfoundation.org>
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

commit ca7dc242e358e46d963b32f9d9dd829785a9e957 upstream.

dm-writecache has the capability to limit the number of writeback jobs
in progress. However, this feature was off by default. As such there
were some out-of-memory crashes observed when lowering the low
watermark while the cache is full.

This commit enables writeback limit by default. It is set to 256MiB or
1/16 of total system memory, whichever is smaller.

Cc: stable@vger.kernel.org
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-writecache.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/md/dm-writecache.c
+++ b/drivers/md/dm-writecache.c
@@ -20,7 +20,7 @@
 
 #define HIGH_WATERMARK			50
 #define LOW_WATERMARK			45
-#define MAX_WRITEBACK_JOBS		0
+#define MAX_WRITEBACK_JOBS		min(0x10000000 / PAGE_SIZE, totalram_pages / 16)
 #define ENDIO_LATENCY			16
 #define WRITEBACK_LATENCY		64
 #define AUTOCOMMIT_BLOCKS_SSD		65536


