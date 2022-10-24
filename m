Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7685160A625
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 14:32:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231664AbiJXMcH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 08:32:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234373AbiJXMaK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 08:30:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 058DC11A27;
        Mon, 24 Oct 2022 05:04:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 62901B811BC;
        Mon, 24 Oct 2022 11:50:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B43DBC433D7;
        Mon, 24 Oct 2022 11:50:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666612229;
        bh=p+RDls3UMSxOV4pI0uV5hNiacPwGMJMODJXouPv8m70=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pdWIoa9SISjE/4IoA9Q/E8rt6A7k1zor4VlPl8oLzbH91aKJtX6Dj/znYhXPc6cPd
         QxJtyVcQr850A3131P+t6AKX0lee/io5Rr9MH7+Mhdat7LLS/uAa4KLTA1rxq6mQFC
         xFtLNk7ZgqxJXFnoKWqlqRF7jYj16ikYXpmM3pio=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zheyu Ma <zheyuma97@gmail.com>,
        Robert Foss <robert.foss@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 101/210] drm/bridge: megachips: Fix a null pointer dereference bug
Date:   Mon, 24 Oct 2022 13:30:18 +0200
Message-Id: <20221024113000.296878970@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024112956.797777597@linuxfoundation.org>
References: <20221024112956.797777597@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
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
index 4ab7b034bfec..313c80f29972 100644
--- a/drivers/gpu/drm/bridge/megachips-stdpxxxx-ge-b850v3-fw.c
+++ b/drivers/gpu/drm/bridge/megachips-stdpxxxx-ge-b850v3-fw.c
@@ -290,7 +290,9 @@ static void ge_b850v3_lvds_remove(void)
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



