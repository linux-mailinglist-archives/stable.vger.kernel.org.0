Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41F93680FC6
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 14:56:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236650AbjA3N4t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 08:56:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236653AbjA3N4r (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 08:56:47 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB58B39CC1
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 05:56:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 74C2561011
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 13:56:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74953C4339B;
        Mon, 30 Jan 2023 13:56:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675087005;
        bh=QdssKlFzWDLRUEv02AgProgRolZ7zh8D1JL4qG+PcqA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xY34XxsHi+1I9vLgB4JFoCPN6+ic3O34NUObJSE3zSkTIw1qQ9sHJ13Fh7ub8pJ+I
         41VPlj3H0Eq5oAM2PB91HjHYtMTMaQnN4kUNrVDIcKtbiRqOW6xFJGJF/KAJ7vKuuP
         47ww+lgZKnJ2tmRYUVoi/nAMlvuIbZwCCB0TGZYE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Stephen Rothwell <sfr@canb.auug.org.au>,
        =?UTF-8?q?Ma=C3=ADra=20Canal?= <mcanal@igalia.com>,
        Maxime Ripard <maxime@cerno.tech>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 067/313] drm/vc4: bo: Fix unused variable warning
Date:   Mon, 30 Jan 2023 14:48:22 +0100
Message-Id: <20230130134339.796765407@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134336.532886729@linuxfoundation.org>
References: <20230130134336.532886729@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maxime Ripard <maxime@cerno.tech>

[ Upstream commit 83a7f8e4899fb4cd77c787a3373f3e82b49a080f ]

Commit 07a2975c65f2 ("drm/vc4: bo: Fix drmm_mutex_init memory hog")
removed the only use of the ret variable, but didn't remove the
variable itself leading to a unused variable warning.

Remove that variable.

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Fixes: 07a2975c65f2 ("drm/vc4: bo: Fix drmm_mutex_init memory hog")
Reviewed-by: Maíra Canal <mcanal@igalia.com>
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Link: https://patchwork.freedesktop.org/patch/msgid/20230113154637.1704116-1-maxime@cerno.tech
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vc4/vc4_bo.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/gpu/drm/vc4/vc4_bo.c b/drivers/gpu/drm/vc4/vc4_bo.c
index ab2573525d77..ce0ea446bd70 100644
--- a/drivers/gpu/drm/vc4/vc4_bo.c
+++ b/drivers/gpu/drm/vc4/vc4_bo.c
@@ -395,7 +395,6 @@ struct drm_gem_object *vc4_create_object(struct drm_device *dev, size_t size)
 {
 	struct vc4_dev *vc4 = to_vc4_dev(dev);
 	struct vc4_bo *bo;
-	int ret;
 
 	if (WARN_ON_ONCE(vc4->is_vc5))
 		return ERR_PTR(-ENODEV);
-- 
2.39.0



