Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFAF16AEB34
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:41:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232041AbjCGRlQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:41:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231931AbjCGRkx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:40:53 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2B6E52916
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:37:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A4C27B8191D
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:37:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F02ABC4339B;
        Tue,  7 Mar 2023 17:37:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678210625;
        bh=JrVWWq4sJZRZXrAVy48HDbLoRW87VOhunRrH9CHQNvc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BN9P3fj+x7Z8yw+X0DPV/0AzRxKlm2yNZ0np6ZurMdIp4e3gYznKAdylCFT/k6Rtd
         nPlfQSDTmkt5aukIoQbdnsujlGXfZcEoNc5c6OEXTXJxy6bH9vfoZLqYK5fplZ+WiM
         os+oWJdZlTlDId0837o9jmEPxr2pWznryxqPGe2k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Arnd Bergmann <arnd@arndb.de>,
        Robert Foss <robert.foss@linaro.org>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0602/1001] media: camss: csiphy-3ph: avoid undefined behavior
Date:   Tue,  7 Mar 2023 17:56:14 +0100
Message-Id: <20230307170047.639474305@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 05fb9ace34b8645cb76f7e3a21b5c7b754329cae ]

Marking a case of the switch statement as unreachable means the
compiler treats it as undefined behavior, which is then caught by
an objtool warning:

drivers/media/platform/qcom/camss/camss-csiphy-3ph-1-0.o: warning: objtool: csiphy_lanes_enable() falls through to next function csiphy_lanes_disable()

Instead of simply continuing execution at a random place of the
driver, print a warning and return from to the caller, which
makes it possible to understand what happens and avoids the
warning.

Fixes: 53655d2a0ff2 ("media: camss: csiphy-3ph: add support for SM8250 CSI DPHY")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Robert Foss <robert.foss@linaro.org>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/qcom/camss/camss-csiphy-3ph-1-0.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/qcom/camss/camss-csiphy-3ph-1-0.c b/drivers/media/platform/qcom/camss/camss-csiphy-3ph-1-0.c
index 451a4c9b3d30d..04baa80494c66 100644
--- a/drivers/media/platform/qcom/camss/camss-csiphy-3ph-1-0.c
+++ b/drivers/media/platform/qcom/camss/camss-csiphy-3ph-1-0.c
@@ -429,7 +429,8 @@ static void csiphy_gen2_config_lanes(struct csiphy_device *csiphy,
 		array_size = ARRAY_SIZE(lane_regs_sm8250[0]);
 		break;
 	default:
-		unreachable();
+		WARN(1, "unknown cspi version\n");
+		return;
 	}
 
 	for (l = 0; l < 5; l++) {
-- 
2.39.2



