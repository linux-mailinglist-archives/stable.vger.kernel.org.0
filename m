Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13EA25AEB79
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 16:26:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239333AbiIFN5V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 09:57:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239303AbiIFNzU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 09:55:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76C8881B0D;
        Tue,  6 Sep 2022 06:42:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 94FA66154D;
        Tue,  6 Sep 2022 13:42:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2062C433C1;
        Tue,  6 Sep 2022 13:42:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662471724;
        bh=9NaT+Ucncp9R8d9zkaYHvrw5dKkulO1MkaoufhZdDZM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hF9fi10zflu2gLcyQuSXCUdtJ2ubrXlGlQDqpNZ7QWEfQn+hq+N8m3VR0O416ueba
         oRGLoZdnQyFu3874OQeD6HXDh56J3wLMROiv2X9MpuC6sXLHbLD7UrSRWG9EIGdRLx
         XBKIPfFq88KqibPt+NuyO3mXjZgOQGRvhtilA9eE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alex Williamson <alex.williamson@redhat.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 017/155] drm/i915/gvt: Fix Comet Lake
Date:   Tue,  6 Sep 2022 15:29:25 +0200
Message-Id: <20220906132830.147730561@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220906132829.417117002@linuxfoundation.org>
References: <20220906132829.417117002@linuxfoundation.org>
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

From: Alex Williamson <alex.williamson@redhat.com>

[ Upstream commit b75ef35bb57791a5d675699ed4a40c870d1da12f ]

Prior to the commit below the GAMT_CHKN_BIT_REG address was setup for
devices matching (D_KBL | D_CFL), where intel_gvt_get_device_type()
returns D_CFL for either Coffee Lake or Comet Lake.  Include the missed
platform.`

Link: https://lore.kernel.org/all/20220808142711.02d16782.alex.williamson@redhat.com
Fixes: e0f74ed4634d ("i915/gvt: Separate the MMIO tracking table from GVT-g")
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Zhenyu Wang <zhenyuw@linux.intel.com>
Link: http://patchwork.freedesktop.org/patch/msgid/166016852965.780835.10366587502693016900.stgit@omen
Reviewed-by: Zhenyu Wang <zhenyuw@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/intel_gvt_mmio_table.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/intel_gvt_mmio_table.c b/drivers/gpu/drm/i915/intel_gvt_mmio_table.c
index 72dac1718f3e7..6163aeaee9b98 100644
--- a/drivers/gpu/drm/i915/intel_gvt_mmio_table.c
+++ b/drivers/gpu/drm/i915/intel_gvt_mmio_table.c
@@ -1074,7 +1074,8 @@ static int iterate_skl_plus_mmio(struct intel_gvt_mmio_table_iter *iter)
 	MMIO_D(GEN8_HDC_CHICKEN1);
 	MMIO_D(GEN9_WM_CHICKEN3);
 
-	if (IS_KABYLAKE(dev_priv) || IS_COFFEELAKE(dev_priv))
+	if (IS_KABYLAKE(dev_priv) ||
+	    IS_COFFEELAKE(dev_priv) || IS_COMETLAKE(dev_priv))
 		MMIO_D(GAMT_CHKN_BIT_REG);
 	if (!IS_BROXTON(dev_priv))
 		MMIO_D(GEN9_CTX_PREEMPT_REG);
-- 
2.35.1



