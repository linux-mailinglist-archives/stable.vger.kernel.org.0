Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 274F85AAF5D
	for <lists+stable@lfdr.de>; Fri,  2 Sep 2022 14:37:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237020AbiIBMg6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Sep 2022 08:36:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237022AbiIBMgS (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Sep 2022 08:36:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D03CDF4E9;
        Fri,  2 Sep 2022 05:28:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1C9C7620B6;
        Fri,  2 Sep 2022 12:28:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1191BC433D6;
        Fri,  2 Sep 2022 12:28:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662121729;
        bh=GTRHNUjiLIuDq28pzbsM/VXRXBn3isvL/+qqfFlwepA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TqsvRHYmM+n97QOZVikbv7S9zm8q4YHWhFBmtK5QBxTBKvz+A6SqhRay4UJGm/fHn
         3+MrC705A4jV94duxdNA8vQ5JrwYW3KUsnon/+Eh6XK1NKnm12xcO7eFaY+sWKnVE/
         gFi0CrO0OlT41dxrzsR9cgI5WwO+IFSiDGZjqvDA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mikulas Patocka <mpatocka@redhat.com>,
        Guoqing Jiang <guoqing.jiang@linux.dev>,
        Song Liu <song@kernel.org>
Subject: [PATCH 5.4 46/77] md: call __md_stop_writes in md_stop
Date:   Fri,  2 Sep 2022 14:18:55 +0200
Message-Id: <20220902121405.184054467@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220902121403.569927325@linuxfoundation.org>
References: <20220902121403.569927325@linuxfoundation.org>
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
@@ -6094,6 +6094,7 @@ void md_stop(struct mddev *mddev)
 	/* stop the array and free an attached data structures.
 	 * This is called from dm-raid
 	 */
+	__md_stop_writes(mddev);
 	__md_stop(mddev);
 	bioset_exit(&mddev->bio_set);
 	bioset_exit(&mddev->sync_set);


