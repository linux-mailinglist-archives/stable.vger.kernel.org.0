Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E29865AAE90
	for <lists+stable@lfdr.de>; Fri,  2 Sep 2022 14:25:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236281AbiIBMZl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Sep 2022 08:25:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236293AbiIBMZH (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Sep 2022 08:25:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF9A1D7404;
        Fri,  2 Sep 2022 05:23:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 69440620FD;
        Fri,  2 Sep 2022 12:22:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C3E1C433C1;
        Fri,  2 Sep 2022 12:22:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662121363;
        bh=WynDvxHoxmJta2Gj6rL0/fOVSZIoA7wkQqCFBQ7arEg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uAdHX4ZboBBlGd/X1pS1qgObQJRuNOGby6uX/QhCqJ5G3N8BX9vOacfUs+0tHI0xt
         XmlpxorTaOcDXq3TDelgfjsp8MkFvJFTBGm/r4jctyQqu5gawFOdO3x4adLks6kXVV
         iPjy0AMXKiLFJOO6aP/CmpodeqBoOoAE3kLihZxY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mikulas Patocka <mpatocka@redhat.com>,
        Guoqing Jiang <guoqing.jiang@linux.dev>,
        Song Liu <song@kernel.org>
Subject: [PATCH 4.14 25/42] md: call __md_stop_writes in md_stop
Date:   Fri,  2 Sep 2022 14:18:49 +0200
Message-Id: <20220902121359.669121787@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220902121358.773776406@linuxfoundation.org>
References: <20220902121358.773776406@linuxfoundation.org>
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

commit 0dd84b319352bb8ba64752d4e45396d8b13e6018 upstream.

>From the link [1], we can see raid1d was running even after the path
raid_dtr -> md_stop -> __md_stop.

Let's stop write first in destructor to align with normal md-raid to
fix the KASAN issue.

[1]. https://lore.kernel.org/linux-raid/CAPhsuW5gc4AakdGNdF8ubpezAuDLFOYUO_sfMZcec6hQFm8nhg@mail.gmail.com/T/#m7f12bf90481c02c6d2da68c64aeed4779b7df74a

Fixes: 48df498daf62 ("md: move bitmap_destroy to the beginning of __md_stop")
Reported-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Guoqing Jiang <guoqing.jiang@linux.dev>
Signed-off-by: Song Liu <song@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/md.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -5908,6 +5908,7 @@ void md_stop(struct mddev *mddev)
 	/* stop the array and free an attached data structures.
 	 * This is called from dm-raid
 	 */
+	__md_stop_writes(mddev);
 	__md_stop(mddev);
 	if (mddev->bio_set)
 		bioset_free(mddev->bio_set);


