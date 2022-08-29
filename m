Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01FB35A4A05
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 13:32:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232067AbiH2LcN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 07:32:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232448AbiH2LbL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 07:31:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0562CDECB;
        Mon, 29 Aug 2022 04:18:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 748A8B80E4C;
        Mon, 29 Aug 2022 11:18:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9E53C433D6;
        Mon, 29 Aug 2022 11:18:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661771903;
        bh=zpdNrj2zHCU5PomsNNUW8dpMs4P00W/7ROzjCZuz0As=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kdd3e5uGlGDoQXBnnHWnawnzg64f18RRCKeXZSGFu2PJt5QTVj0xR4bwZE6EqCLd+
         uxzTH9eSHsIRqNOm6D5lkkVOkTenVn+NfVE7jXLs/dfmxXBqEXYHi91ciuxVu1nAhp
         P8sQKYJd6FFt8ZYyxlvwQyxvScuLCT0lwhGRdqZM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guoqing Jiang <guoqing.jiang@linux.dev>,
        Song Liu <song@kernel.org>
Subject: [PATCH 5.19 135/158] Revert "md-raid: destroy the bitmap after destroying the thread"
Date:   Mon, 29 Aug 2022 12:59:45 +0200
Message-Id: <20220829105814.746029478@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220829105808.828227973@linuxfoundation.org>
References: <20220829105808.828227973@linuxfoundation.org>
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

From: Guoqing Jiang <guoqing.jiang@linux.dev>

commit 1d258758cf06a0734482989911d184dd5837ed4e upstream.

This reverts commit e151db8ecfb019b7da31d076130a794574c89f6f. Because it
obviously breaks clustered raid as noticed by Neil though it fixed KASAN
issue for dm-raid, let's revert it and fix KASAN issue in next commit.

[1]. https://lore.kernel.org/linux-raid/a6657e08-b6a7-358b-2d2a-0ac37d49d23a@linux.dev/T/#m95ac225cab7409f66c295772483d091084a6d470

Fixes: e151db8ecfb0 ("md-raid: destroy the bitmap after destroying the thread")
Signed-off-by: Guoqing Jiang <guoqing.jiang@linux.dev>
Signed-off-by: Song Liu <song@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/md.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -6244,11 +6244,11 @@ static void mddev_detach(struct mddev *m
 static void __md_stop(struct mddev *mddev)
 {
 	struct md_personality *pers = mddev->pers;
+	md_bitmap_destroy(mddev);
 	mddev_detach(mddev);
 	/* Ensure ->event_work is done */
 	if (mddev->event_work.func)
 		flush_workqueue(md_misc_wq);
-	md_bitmap_destroy(mddev);
 	spin_lock(&mddev->lock);
 	mddev->pers = NULL;
 	spin_unlock(&mddev->lock);


