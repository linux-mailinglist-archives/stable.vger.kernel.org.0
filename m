Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E82A8579E0F
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 14:57:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242449AbiGSM5a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 08:57:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242373AbiGSM4p (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 08:56:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D29E29A6BC;
        Tue, 19 Jul 2022 05:22:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 583E56177D;
        Tue, 19 Jul 2022 12:22:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27424C341C6;
        Tue, 19 Jul 2022 12:22:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658233370;
        bh=zKIcPj/nHoDO6f2KADrbWiID08iXNMAscwYuS32iCW4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IPoCtUbe8y5f5Jn7gUnUg33+RF1QbLTVn/fWjOy3cBZFRdbjJj2is/7AoSeb942z+
         NQiOFY18hTQ28+bU7uPnTmE8y8D+i86rl64ZcaG+Auo5KHd3QfX8YzRVor6Kn8c0h+
         jyq0vTJCbZNFWqO8hvptxnhAAxIBJI6s83HI753s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Matthew Auld <matthew.auld@intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 100/231] drm/i915/selftests: fix a couple IS_ERR() vs NULL tests
Date:   Tue, 19 Jul 2022 13:53:05 +0200
Message-Id: <20220719114723.102635040@linuxfoundation.org>
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

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 896dcabd1f8f613c533d948df17408c41f8929f5 ]

The shmem_pin_map() function doesn't return error pointers, it returns
NULL.

Fixes: be1cb55a07bf ("drm/i915/gt: Keep a no-frills swappable copy of the default context state")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Matthew Auld <matthew.auld@intel.com>
Signed-off-by: Matthew Auld <matthew.auld@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20220708094104.GL2316@kadam
(cherry picked from commit d50f5a109cf4ed50c5b575c1bb5fc3bd17b23308)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/gt/selftest_lrc.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/i915/gt/selftest_lrc.c b/drivers/gpu/drm/i915/gt/selftest_lrc.c
index 21c29d315cc0..9d42a7c67a8c 100644
--- a/drivers/gpu/drm/i915/gt/selftest_lrc.c
+++ b/drivers/gpu/drm/i915/gt/selftest_lrc.c
@@ -155,8 +155,8 @@ static int live_lrc_layout(void *arg)
 			continue;
 
 		hw = shmem_pin_map(engine->default_state);
-		if (IS_ERR(hw)) {
-			err = PTR_ERR(hw);
+		if (!hw) {
+			err = -ENOMEM;
 			break;
 		}
 		hw += LRC_STATE_OFFSET / sizeof(*hw);
@@ -331,8 +331,8 @@ static int live_lrc_fixed(void *arg)
 			continue;
 
 		hw = shmem_pin_map(engine->default_state);
-		if (IS_ERR(hw)) {
-			err = PTR_ERR(hw);
+		if (!hw) {
+			err = -ENOMEM;
 			break;
 		}
 		hw += LRC_STATE_OFFSET / sizeof(*hw);
-- 
2.35.1



