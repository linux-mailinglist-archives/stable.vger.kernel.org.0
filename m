Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86B82603F1B
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 11:27:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233333AbiJSJ1o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 05:27:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233257AbiJSJ0i (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 05:26:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C892E5ED6;
        Wed, 19 Oct 2022 02:11:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1548761820;
        Wed, 19 Oct 2022 08:56:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29F08C433D6;
        Wed, 19 Oct 2022 08:56:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666169792;
        bh=OzLtw84/qExOO0VigNtqfN9GRq/sTIKWBf6EPPnoyMA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BdYmqAWEjrWOIA3A8jC/Z6pdqwblNDkk6+1FtpoRUcMjZa9SOaJEhuZyJSB2KBAiC
         dx3yA5NSZngKd3iA5BZG7jynSiX3n7b3xIbVQ0Ifj+4YmZtlrDX6+7UDB5ZL3S7jCF
         qCz1WztmXxtQ6H+n1HcY2UdHbHPPOTW0PbampecA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zheyu Ma <zheyuma97@gmail.com>,
        Robert Foss <robert.foss@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 378/862] drm/bridge: megachips: Fix a null pointer dereference bug
Date:   Wed, 19 Oct 2022 10:27:45 +0200
Message-Id: <20221019083306.681697756@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index cce98bf2a4e7..72248a565579 100644
--- a/drivers/gpu/drm/bridge/megachips-stdpxxxx-ge-b850v3-fw.c
+++ b/drivers/gpu/drm/bridge/megachips-stdpxxxx-ge-b850v3-fw.c
@@ -296,7 +296,9 @@ static void ge_b850v3_lvds_remove(void)
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



