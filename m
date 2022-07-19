Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F16C579ADA
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 14:20:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236631AbiGSMUb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 08:20:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239587AbiGSMTf (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 08:19:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87ACA58874;
        Tue, 19 Jul 2022 05:07:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 98E0BB81B2C;
        Tue, 19 Jul 2022 12:06:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08355C341C6;
        Tue, 19 Jul 2022 12:06:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658232406;
        bh=TUEZca48WL3fXZha1QOFriX2mICYwGrA7prQ5bSVqUk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jnB8J1Wi29BNNf9N0v4k+Bqqh9zahFMMuCTkWeKLNs/O3tHADdS/7hiIMPWSdeODV
         z7lktFpGprhqaY8H6Bvttzl/R0Y5Nzu/Mse8DUqE5h4IusLO9vZOEDZWyuA5ZKgkWS
         auUiQwo0Vb/+5FIeyiX/sL1/7FEtCXt0NaObKNV4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alyssa Rosenzweig <alyssa.rosenzweig@collabora.com>,
        Steven Price <steven.price@arm.com>,
        Dmitry Osipenko <dmitry.osipenko@collabora.com>
Subject: [PATCH 5.10 019/112] drm/panfrost: Fix shrinker list corruption by madvise IOCTL
Date:   Tue, 19 Jul 2022 13:53:12 +0200
Message-Id: <20220719114627.846889705@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719114626.156073229@linuxfoundation.org>
References: <20220719114626.156073229@linuxfoundation.org>
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
@@ -427,8 +427,8 @@ static int panfrost_ioctl_madvise(struct
 
 	if (args->retained) {
 		if (args->madv == PANFROST_MADV_DONTNEED)
-			list_add_tail(&bo->base.madv_list,
-				      &pfdev->shrinker_list);
+			list_move_tail(&bo->base.madv_list,
+				       &pfdev->shrinker_list);
 		else if (args->madv == PANFROST_MADV_WILLNEED)
 			list_del_init(&bo->base.madv_list);
 	}


