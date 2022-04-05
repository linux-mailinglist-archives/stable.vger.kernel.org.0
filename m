Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0ECD4F27EE
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 10:09:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232471AbiDEIJq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:09:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236003AbiDEIBB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:01:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCE0B49FB3;
        Tue,  5 Apr 2022 00:59:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 95A98B81B18;
        Tue,  5 Apr 2022 07:59:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3008C340EE;
        Tue,  5 Apr 2022 07:58:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649145540;
        bh=DqpbXeSy2wz6V4vXfGJ2xZky/5rTxcMKW6nSQNRNDwA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RrJyibYJ2JlzQr9GmK110m3SkwHDdWVl93a1Y/UN5RnQ23mcZFWvWlIYeKlCy6213
         lStInfXjL0Id7bY0RvN4yfqCz/ecE8/haVbd/DDbGThKP8FplOa/xMX4ycOeFvX4+4
         zqyrZWBjihqphgnqfBBnS2Nxmbrjchn6a1H5rpyo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
        Jani Nikula <jani.nikula@intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0442/1126] drm/locking: fix drm_modeset_acquire_ctx kernel-doc
Date:   Tue,  5 Apr 2022 09:19:49 +0200
Message-Id: <20220405070420.597737979@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Jani Nikula <jani.nikula@intel.com>

[ Upstream commit 6f043b5969a4d6d385ca429388ded37e30e0d179 ]

The stack_depot member was added without kernel-doc, leading to below
warning. Fix it.

./include/drm/drm_modeset_lock.h:74: warning: Function parameter or
member 'stack_depot' not described in 'drm_modeset_acquire_ctx'

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Fixes: cd06ab2fd48f ("drm/locking: add backtrace for locking contended locks without backoff")
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Tested-by: Stephen Rothwell <sfr@canb.auug.org.au>
Link: https://patchwork.freedesktop.org/patch/msgid/20220120094856.3004147-1-jani.nikula@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/drm/drm_modeset_lock.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/drm/drm_modeset_lock.h b/include/drm/drm_modeset_lock.h
index b84693fbd2b5..ec4f543c3d95 100644
--- a/include/drm/drm_modeset_lock.h
+++ b/include/drm/drm_modeset_lock.h
@@ -34,6 +34,7 @@ struct drm_modeset_lock;
  * struct drm_modeset_acquire_ctx - locking context (see ww_acquire_ctx)
  * @ww_ctx: base acquire ctx
  * @contended: used internally for -EDEADLK handling
+ * @stack_depot: used internally for contention debugging
  * @locked: list of held locks
  * @trylock_only: trylock mode used in atomic contexts/panic notifiers
  * @interruptible: whether interruptible locking should be used.
-- 
2.34.1



