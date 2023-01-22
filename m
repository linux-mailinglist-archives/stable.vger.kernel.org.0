Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC0FB676FC1
	for <lists+stable@lfdr.de>; Sun, 22 Jan 2023 16:24:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231375AbjAVPY6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Jan 2023 10:24:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231373AbjAVPY5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Jan 2023 10:24:57 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A59C82201C
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 07:24:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4EA6DB80B1A
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 15:24:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABF7DC433EF;
        Sun, 22 Jan 2023 15:24:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674401094;
        bh=Jj2/P4Bt4IMQcorAyQkVqfbDCKCIIxYIQz+PahnZLGY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bMzR01X+CzGP/cPYCGPlEzmt5/GFOo3TAHXnfm55Ts5lKtq5y0gHp3myckfYEvy7b
         p5vzgh634bPUDv49bwYZZvNSoa6bOWppBRONuT/5oDW98HgqDvgAaD4HEYKCgUaJWN
         hOGUjYKPGe2Zg8JAwa29v5J9mUTs3ZkpbYD98Ae8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, stable <stable@kernel.org>,
        Yang Yingliang <yangyingliang@huawei.com>
Subject: [PATCH 6.1 108/193] usb: musb: fix error return code in omap2430_probe()
Date:   Sun, 22 Jan 2023 16:03:57 +0100
Message-Id: <20230122150251.265092308@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150246.321043584@linuxfoundation.org>
References: <20230122150246.321043584@linuxfoundation.org>
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

From: Yang Yingliang <yangyingliang@huawei.com>

commit bd449ad8cee9d4b523abbdfa73e1a2a08333f331 upstream.

Before calling platform_get_resource() in omap2430_probe(), the 'ret' is
re-assgined to 0, it can't return an error code, if platform_get_resource
fails. Set the error code to -EINVAL to fix this.

Fixes: ffbe2feac59b ("usb: musb: omap2430: Fix probe regression for missing resources")
Cc: stable <stable@kernel.org>
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Link: https://lore.kernel.org/r/20221230081730.1655616-1-yangyingliang@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/musb/omap2430.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/musb/omap2430.c b/drivers/usb/musb/omap2430.c
index 476f55d1fec3..44a21ec865fb 100644
--- a/drivers/usb/musb/omap2430.c
+++ b/drivers/usb/musb/omap2430.c
@@ -411,8 +411,10 @@ static int omap2430_probe(struct platform_device *pdev)
 		memset(musb_res, 0, sizeof(*musb_res) * ARRAY_SIZE(musb_res));
 
 		res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-		if (!res)
+		if (!res) {
+			ret = -EINVAL;
 			goto err2;
+		}
 
 		musb_res[i].start = res->start;
 		musb_res[i].end = res->end;
-- 
2.39.1



