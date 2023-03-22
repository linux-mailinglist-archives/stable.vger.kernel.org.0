Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 010D06C56E0
	for <lists+stable@lfdr.de>; Wed, 22 Mar 2023 21:10:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231935AbjCVUK0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Mar 2023 16:10:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232001AbjCVUJw (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Mar 2023 16:09:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A21D2CC78;
        Wed, 22 Mar 2023 13:03:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BFB42B81DFB;
        Wed, 22 Mar 2023 20:03:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8471C4339C;
        Wed, 22 Mar 2023 20:03:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679515383;
        bh=H2fvv6Sn/nwtQj7JD929f6vx9acoQ8RQKgq2U3QvaLY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L3thXqPgNW4dF2u8cwq4mH7VhDZUrwX6s9j2jbqYzUrEOktkgdTICnRJimK/QAQYp
         UTF3hUIg+pAi0IC3/deThUcjRBlWHcgzu1hgvP8QH4FA5JuPIEQcedX/n/DO9QBKRV
         jbIILGPy7LCEk/9yYaMnqrG2yO1POM+XJqRoJQOvKPa5xbdyDOUPuKSNakuBqQm4GP
         t20XLuCEWeBZiT1ywrXZ9p+ezMLDE1EK3dtonjfRy9bZxZuvv2RvDMqNLMc33uSmvP
         ABz0ZPpztHh9uBInPW9JqlQEY0mi7jlEuZ1UC/Erdm7hJ0DQ8VOhp/XVRZCEdFx7r6
         MrHelroOxZ0Rg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wei Chen <harperchen1110@gmail.com>, Helge Deller <deller@gmx.de>,
        Sasha Levin <sashal@kernel.org>, mbroemme@libmpq.org,
        linux-fbdev@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.4 7/9] fbdev: intelfb: Fix potential divide by zero
Date:   Wed, 22 Mar 2023 16:02:39 -0400
Message-Id: <20230322200242.1997527-7-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230322200242.1997527-1-sashal@kernel.org>
References: <20230322200242.1997527-1-sashal@kernel.org>
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
index a76c61512c608..274e6bb4a9610 100644
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

