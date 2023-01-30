Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CC3D681319
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 15:28:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236034AbjA3O2U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 09:28:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236136AbjA3O2H (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 09:28:07 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A36C3E0BF
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 06:26:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ECD4561015
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 14:26:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D7B2C433D2;
        Mon, 30 Jan 2023 14:26:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675088790;
        bh=TCHGCxdMI/AsvKSENUEgm50GePMhDUjfnV0biqdO1zA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qQ3ep4uFTJLZgGobL1AeYaUK4/pt+XAqgppmkGdd6F8wFSd4NfO8zaZtA0bxu8CRm
         HRWXNv5mPO7Xocf63d0dNGsFPDC5zOzQf/B4rytqUpDBf/f3xIeocJJDyL5M8FuPKa
         2nkY9N1Xb3BM3oSelDRF+/Mi+5uKpZ2ZPARkX5UQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Karol Herbst <kherbst@redhat.com>,
        Lyude Paul <lyude@redhat.com>,
        Salvatore Bonaccorso <carnil@debian.org>,
        Computer Enthusiastic <computer.enthusiastic@gmail.com>
Subject: [PATCH 5.10 136/143] nouveau: explicitly wait on the fence in nouveau_bo_move_m2mf
Date:   Mon, 30 Jan 2023 14:53:13 +0100
Message-Id: <20230130134312.459081132@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134306.862721518@linuxfoundation.org>
References: <20230130134306.862721518@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Karol Herbst <kherbst@redhat.com>

commit 6b04ce966a738ecdd9294c9593e48513c0dc90aa upstream.

It is a bit unlcear to us why that's helping, but it does and unbreaks
suspend/resume on a lot of GPUs without any known drawbacks.

Cc: stable@vger.kernel.org # v5.15+
Closes: https://gitlab.freedesktop.org/drm/nouveau/-/issues/156
Signed-off-by: Karol Herbst <kherbst@redhat.com>
Reviewed-by: Lyude Paul <lyude@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20220819200928.401416-1-kherbst@redhat.com
Cc: Salvatore Bonaccorso <carnil@debian.org>
Cc: Computer Enthusiastic <computer.enthusiastic@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/nouveau/nouveau_bo.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/drivers/gpu/drm/nouveau/nouveau_bo.c
+++ b/drivers/gpu/drm/nouveau/nouveau_bo.c
@@ -823,6 +823,15 @@ nouveau_bo_move_m2mf(struct ttm_buffer_o
 		if (ret == 0) {
 			ret = nouveau_fence_new(chan, false, &fence);
 			if (ret == 0) {
+				/* TODO: figure out a better solution here
+				 *
+				 * wait on the fence here explicitly as going through
+				 * ttm_bo_move_accel_cleanup somehow doesn't seem to do it.
+				 *
+				 * Without this the operation can timeout and we'll fallback to a
+				 * software copy, which might take several minutes to finish.
+				 */
+				nouveau_fence_wait(fence, false, false);
 				ret = ttm_bo_move_accel_cleanup(bo,
 								&fence->base,
 								evict, false,


