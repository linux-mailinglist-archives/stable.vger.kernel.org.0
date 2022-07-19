Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB235579E44
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 15:01:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242238AbiGSM7K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 08:59:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242477AbiGSM6e (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 08:58:34 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 866F95F10C;
        Tue, 19 Jul 2022 05:23:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1D12EB81B10;
        Tue, 19 Jul 2022 12:23:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 809A1C385A5;
        Tue, 19 Jul 2022 12:23:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658233419;
        bh=T750x+VhZsZMYNY0oaiE3SyflqHPJnBA4N1zMOZhvHE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YmTzwA0AQROWGfBZf5MFxBx9p3DgS914CRwWu6TdBZXXgQNmtIBivMXGvciQqEr1a
         b5bwqd44u0OGMzaxWTieeIrXHoGiQj+DdRUJO0JN6O18Ii/j6smB29IsbXSGT5YBXS
         vkPccuBuPUNdGVZfWPsFARZ7Nimw2Zn8zlryRBWg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrzej Hajda <andrzej.hajda@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 090/231] drm/i915/gvt: IS_ERR() vs NULL bug in intel_gvt_update_reg_whitelist()
Date:   Tue, 19 Jul 2022 13:52:55 +0200
Message-Id: <20220719114722.325130692@linuxfoundation.org>
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

[ Upstream commit e87197fbd137c888fd6c871c72fe7e89445dd015 ]

The shmem_pin_map() function returns NULL, it doesn't return error
pointers.

Fixes: 97ea656521c8 ("drm/i915/gvt: Parse default state to update reg whitelist")
Reviewed-by: Andrzej Hajda <andrzej.hajda@intel.com>
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Zhenyu Wang <zhenyuw@linux.intel.com>
Link: http://patchwork.freedesktop.org/patch/msgid/Ysftoia2BPUyqVcD@kili
Acked-by: Zhenyu Wang <zhenyuw@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/gvt/cmd_parser.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/i915/gvt/cmd_parser.c b/drivers/gpu/drm/i915/gvt/cmd_parser.c
index 2459213b6c87..f49c1e8b8df7 100644
--- a/drivers/gpu/drm/i915/gvt/cmd_parser.c
+++ b/drivers/gpu/drm/i915/gvt/cmd_parser.c
@@ -3117,9 +3117,9 @@ void intel_gvt_update_reg_whitelist(struct intel_vgpu *vgpu)
 			continue;
 
 		vaddr = shmem_pin_map(engine->default_state);
-		if (IS_ERR(vaddr)) {
-			gvt_err("failed to map %s->default state, err:%zd\n",
-				engine->name, PTR_ERR(vaddr));
+		if (!vaddr) {
+			gvt_err("failed to map %s->default state\n",
+				engine->name);
 			return;
 		}
 
-- 
2.35.1



