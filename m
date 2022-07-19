Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C139579DAA
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 14:53:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241803AbiGSMxl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 08:53:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242101AbiGSMxS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 08:53:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EBE6904D6;
        Tue, 19 Jul 2022 05:20:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3BDC6618C1;
        Tue, 19 Jul 2022 12:20:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3282DC341CA;
        Tue, 19 Jul 2022 12:20:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658233248;
        bh=66f3skRYNfi9yrdyObdqkz6c99BBdcZAdjSEBBsMkS0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z2AeH4I/Etry+nEvWMTjXR7poYfzUlHtHocSpCD1XVJ2gychR+0xSVprpwtt9W+dS
         MbbGeNd3BrymojVlfU6WBh/xw48Hy5JOdwhjjJkfRcPJDisCF949JrHGpU7sanH8Md
         dw/LsoUYhXPVbpajD5m/VAk2M0FKklD7lS0LSfbY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alyssa Rosenzweig <alyssa.rosenzweig@collabora.com>,
        Steven Price <steven.price@arm.com>,
        Dmitry Osipenko <dmitry.osipenko@collabora.com>
Subject: [PATCH 5.18 030/231] drm/panfrost: Fix shrinker list corruption by madvise IOCTL
Date:   Tue, 19 Jul 2022 13:51:55 +0200
Message-Id: <20220719114716.612560197@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719114714.247441733@linuxfoundation.org>
References: <20220719114714.247441733@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Osipenko <dmitry.osipenko@collabora.com>

commit 9fc33eaaa979d112d10fea729edcd2a2e21aa912 upstream.

Calling madvise IOCTL twice on BO causes memory shrinker list corruption
and crashes kernel because BO is already on the list and it's added to
the list again, while BO should be removed from the list before it's
re-added. Fix it.

Cc: stable@vger.kernel.org
Fixes: 013b65101315 ("drm/panfrost: Add madvise and shrinker support")
Acked-by: Alyssa Rosenzweig <alyssa.rosenzweig@collabora.com>
Reviewed-by: Steven Price <steven.price@arm.com>
Signed-off-by: Dmitry Osipenko <dmitry.osipenko@collabora.com>
Signed-off-by: Steven Price <steven.price@arm.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20220630200601.1884120-3-dmitry.osipenko@collabora.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/panfrost/panfrost_drv.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/panfrost/panfrost_drv.c
+++ b/drivers/gpu/drm/panfrost/panfrost_drv.c
@@ -432,8 +432,8 @@ static int panfrost_ioctl_madvise(struct
 
 	if (args->retained) {
 		if (args->madv == PANFROST_MADV_DONTNEED)
-			list_add_tail(&bo->base.madv_list,
-				      &pfdev->shrinker_list);
+			list_move_tail(&bo->base.madv_list,
+				       &pfdev->shrinker_list);
 		else if (args->madv == PANFROST_MADV_WILLNEED)
 			list_del_init(&bo->base.madv_list);
 	}


