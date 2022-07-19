Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FA2C579AC4
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 14:18:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238048AbiGSMSp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 08:18:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239086AbiGSMRb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 08:17:31 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C8B8564EC;
        Tue, 19 Jul 2022 05:06:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 007A7B81A8F;
        Tue, 19 Jul 2022 12:06:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 606D7C341CA;
        Tue, 19 Jul 2022 12:06:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658232374;
        bh=UuXp9ScCxXV7pCnMZ/CiD185HnQCTfcQfkHUVFyHhJI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WgchxtNJL8HyYaMZDY71pZPNAou08VPb912Mn5oOgZ3WmSamIl03UiJNJ9gD7+SdG
         aG06boQ6oIncnh2pUfR3bO0Yob6d/kgAtKyMjEzpQLW3kYtXvWCNEoL6joSjGBRU+p
         7+9XVKFaMCCAZiWXYomSSDOySEKq0GYHuRcOL730=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Steven Price <steven.price@arm.com>,
        Dmitry Osipenko <dmitry.osipenko@collabora.com>
Subject: [PATCH 5.10 018/112] drm/panfrost: Put mapping instead of shmem obj on panfrost_mmu_map_fault_addr() error
Date:   Tue, 19 Jul 2022 13:53:11 +0200
Message-Id: <20220719114627.750832934@linuxfoundation.org>
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

commit fb6e0637ab7ebd8e61fe24f4d663c4bae99cfa62 upstream.

When panfrost_mmu_map_fault_addr() fails, the BO's mapping should be
unreferenced and not the shmem object which backs the mapping.

Cc: stable@vger.kernel.org
Fixes: bdefca2d8dc0 ("drm/panfrost: Add the panfrost_gem_mapping concept")
Reviewed-by: Steven Price <steven.price@arm.com>
Signed-off-by: Dmitry Osipenko <dmitry.osipenko@collabora.com>
Signed-off-by: Steven Price <steven.price@arm.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20220630200601.1884120-2-dmitry.osipenko@collabora.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/panfrost/panfrost_mmu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/panfrost/panfrost_mmu.c
+++ b/drivers/gpu/drm/panfrost/panfrost_mmu.c
@@ -491,7 +491,7 @@ err_map:
 err_pages:
 	drm_gem_shmem_put_pages(&bo->base);
 err_bo:
-	drm_gem_object_put(&bo->base.base);
+	panfrost_gem_mapping_put(bomapping);
 	return ret;
 }
 


