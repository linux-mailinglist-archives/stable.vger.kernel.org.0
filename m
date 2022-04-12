Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4241B4FDA73
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 12:50:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353118AbiDLHqW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:46:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356959AbiDLHjg (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:39:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3760728E33;
        Tue, 12 Apr 2022 00:10:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 75CCE6157E;
        Tue, 12 Apr 2022 07:10:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82C2CC385A5;
        Tue, 12 Apr 2022 07:10:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649747437;
        bh=htaFqnftVObrnN1B1DrLIaFhG697hzt0hv0PLXg/hdQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Rzs9fC5u8kMA7Poha9SykkhkN1mnOp8jrnR2gYoAT5cWwZlUGGaBYtkKrgnaq6bA6
         E2eGIrfSUNl9utKFBj86NeUxSgBYcgJAkHrrzUeKRjKADh49wVj+a09zvfFIlbL5EA
         CHskQgImjDzLaG2u2omYK9e6yZ1zj2BfbLNCTqAA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Kevin Tang <kevin3.tang@gmail.com>,
        Javier Martinez Canillas <javierm@redhat.com>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 080/343] drm/sprd: fix potential NULL dereference
Date:   Tue, 12 Apr 2022 08:28:18 +0200
Message-Id: <20220412062953.409337667@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062951.095765152@linuxfoundation.org>
References: <20220412062951.095765152@linuxfoundation.org>
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

From: Kevin Tang <kevin3.tang@gmail.com>

[ Upstream commit 8668658aebb0a19d877d5a81c004baf716c4aaa6 ]

'drm' could be null in sprd_drm_shutdown, and drm_warn maybe dereference
it, remove this warning log.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Kevin Tang <kevin3.tang@gmail.com>
Reviewed-by: Javier Martinez Canillas <javierm@redhat.com>
Acked-by: Thomas Zimmermann <tzimmermann@suse.de>
Link: https://lore.kernel.org/all/20220117084044.9210-1-kevin3.tang@gmail.com

v1 -> v2:
- Split checking platform_get_resource() return value to a separate patch
- Use dev_warn() instead of removing the warning log

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/sprd/sprd_drm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/sprd/sprd_drm.c b/drivers/gpu/drm/sprd/sprd_drm.c
index a077e2d4d721..af2be97d5ed0 100644
--- a/drivers/gpu/drm/sprd/sprd_drm.c
+++ b/drivers/gpu/drm/sprd/sprd_drm.c
@@ -155,7 +155,7 @@ static void sprd_drm_shutdown(struct platform_device *pdev)
 	struct drm_device *drm = platform_get_drvdata(pdev);
 
 	if (!drm) {
-		drm_warn(drm, "drm device is not available, no shutdown\n");
+		dev_warn(&pdev->dev, "drm device is not available, no shutdown\n");
 		return;
 	}
 
-- 
2.35.1



