Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5FE460BB55
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 22:56:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233930AbiJXU4U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 16:56:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233989AbiJXU4D (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 16:56:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 495562C4C9E;
        Mon, 24 Oct 2022 12:02:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E8CB1B815B4;
        Mon, 24 Oct 2022 12:10:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4930DC43142;
        Mon, 24 Oct 2022 12:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666613408;
        bh=G1iDAf3f6Jpdzk94UbQC3Rkti0Ys811hQbx2+MSiH9k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CuPfMEny0Ift32isBMGhUf5Sb8cc6xfGJa3gcHy3iLipCswGQZ2pl8DhXaq8Aroxd
         DcV6cKisSGwUm6ZlY2C+3WwXBBkfBWYmwW7e1YZqVWib86lAm7322XgW8Z0ETNfzsW
         ZypnnrzQH1BF4mDYNLY64oW0T7iCggLKT47TUEAQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zheyu Ma <zheyuma97@gmail.com>,
        Robert Foss <robert.foss@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 095/255] drm/bridge: megachips: Fix a null pointer dereference bug
Date:   Mon, 24 Oct 2022 13:30:05 +0200
Message-Id: <20221024113005.647585310@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113002.471093005@linuxfoundation.org>
References: <20221024113002.471093005@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zheyu Ma <zheyuma97@gmail.com>

[ Upstream commit 1ff673333d46d2c1b053ebd0c1c7c7c79e36943e ]

When removing the module we will get the following warning:

[   31.911505] i2c-core: driver [stdp2690-ge-b850v3-fw] unregistered
[   31.912484] general protection fault, probably for non-canonical address 0xdffffc0000000001: 0000 [#1] PREEMPT SMP KASAN PTI
[   31.913338] KASAN: null-ptr-deref in range [0x0000000000000008-0x000000000000000f]
[   31.915280] RIP: 0010:drm_bridge_remove+0x97/0x130
[   31.921825] Call Trace:
[   31.922533]  stdp4028_ge_b850v3_fw_remove+0x34/0x60 [megachips_stdpxxxx_ge_b850v3_fw]
[   31.923139]  i2c_device_remove+0x181/0x1f0

The two bridges (stdp2690, stdp4028) do not probe at the same time, so
the driver does not call ge_b850v3_resgiter() when probing, causing the
driver to try to remove the object that has not been initialized.

Fix this by checking whether both the bridges are probed.

Fixes: 11632d4aa2b3 ("drm/bridge: megachips: Ensure both bridges are probed before registration")
Signed-off-by: Zheyu Ma <zheyuma97@gmail.com>
Signed-off-by: Robert Foss <robert.foss@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20220830073450.1897020-1-zheyuma97@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/megachips-stdpxxxx-ge-b850v3-fw.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/bridge/megachips-stdpxxxx-ge-b850v3-fw.c b/drivers/gpu/drm/bridge/megachips-stdpxxxx-ge-b850v3-fw.c
index 5302dd90a7a5..b72f6f541d4e 100644
--- a/drivers/gpu/drm/bridge/megachips-stdpxxxx-ge-b850v3-fw.c
+++ b/drivers/gpu/drm/bridge/megachips-stdpxxxx-ge-b850v3-fw.c
@@ -279,7 +279,9 @@ static void ge_b850v3_lvds_remove(void)
 	 * This check is to avoid both the drivers
 	 * removing the bridge in their remove() function
 	 */
-	if (!ge_b850v3_lvds_ptr)
+	if (!ge_b850v3_lvds_ptr ||
+	    !ge_b850v3_lvds_ptr->stdp2690_i2c ||
+		!ge_b850v3_lvds_ptr->stdp4028_i2c)
 		goto out;
 
 	drm_bridge_remove(&ge_b850v3_lvds_ptr->bridge);
-- 
2.35.1



