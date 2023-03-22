Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 739196C56F8
	for <lists+stable@lfdr.de>; Wed, 22 Mar 2023 21:11:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232087AbjCVULO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Mar 2023 16:11:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232221AbjCVUKU (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Mar 2023 16:10:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A24217B3B8;
        Wed, 22 Mar 2023 13:03:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A3DD8B81DF5;
        Wed, 22 Mar 2023 20:02:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A68D7C433EF;
        Wed, 22 Mar 2023 20:02:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679515353;
        bh=gwZeTobWjHLpgBTWbj4APQvG09DaIVkhU3OdBi/H7V4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S1ylc4uJWLltMkXmh88RBUhbUH1aa3iynlid8iR2gJNkDuNOupvLWFnSlAituKXQq
         crCzL4eKmZykcE8O6K5Ot9lGrkgPSUOtnZsOGb9g6BWL3QVd9NZaMpa90TyfnELBUq
         s4QIyvdUAyYTj6gy7gBoOtUOl6PMjqDH+jPmp0tYmvlmElr3XQFEZfEKtm6A77MMH0
         pZQIC+2iDvao5t0VAZiLgybF3JrAoRMj11ogVkdysIdaxtBDP2llsKKh7eISdlM3OT
         KZYVZ9zBWA3PHsVOy6XdTJYz0S7mOAVSm4vfEEHaJJvMrmrqCp43b5dj1lpmyc/sjW
         fgb5iNhSJX/uA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wei Chen <harperchen1110@gmail.com>, Helge Deller <deller@gmx.de>,
        Sasha Levin <sashal@kernel.org>, mbroemme@libmpq.org,
        linux-fbdev@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.10 08/12] fbdev: intelfb: Fix potential divide by zero
Date:   Wed, 22 Mar 2023 16:02:02 -0400
Message-Id: <20230322200207.1997367-8-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230322200207.1997367-1-sashal@kernel.org>
References: <20230322200207.1997367-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wei Chen <harperchen1110@gmail.com>

[ Upstream commit d823685486a3446d061fed7c7d2f80af984f119a ]

Variable var->pixclock is controlled by user and can be assigned
to zero. Without proper check, divide by zero would occur in
intelfbhw_validate_mode and intelfbhw_mode_to_hw.

Error out if var->pixclock is zero.

Signed-off-by: Wei Chen <harperchen1110@gmail.com>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/intelfb/intelfbdrv.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/video/fbdev/intelfb/intelfbdrv.c b/drivers/video/fbdev/intelfb/intelfbdrv.c
index a9579964eaba8..8a703adfa9360 100644
--- a/drivers/video/fbdev/intelfb/intelfbdrv.c
+++ b/drivers/video/fbdev/intelfb/intelfbdrv.c
@@ -1214,6 +1214,9 @@ static int intelfb_check_var(struct fb_var_screeninfo *var,
 
 	dinfo = GET_DINFO(info);
 
+	if (!var->pixclock)
+		return -EINVAL;
+
 	/* update the pitch */
 	if (intelfbhw_validate_mode(dinfo, var) != 0)
 		return -EINVAL;
-- 
2.39.2

