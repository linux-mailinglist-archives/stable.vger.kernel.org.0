Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D8F54BE591
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 19:00:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353250AbiBUJsX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 04:48:23 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:56768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351132AbiBUJmo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 04:42:44 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 399173335D;
        Mon, 21 Feb 2022 01:17:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id BA8FACE0E76;
        Mon, 21 Feb 2022 09:17:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0F23C340E9;
        Mon, 21 Feb 2022 09:17:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645435072;
        bh=4/ma2ZF00qjEG7nCuaP9vuHb1u63RSWI+qRUAE66LXQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cSEuEkopwUyEc/hjqx45yS8KXP2ZN1hZpZlw5y0npiU1ihxVeoO8lm7sIOKjfQcFn
         vwyuePXwxk0SB+/QZcmwtSTURG1yGep5V3jNu+gNmL/YEjCEdzgJ20xY3wEi5IcKLm
         H0TBzVEp3j+/EldYZW283w8muTspKEHH6Qa0tkek=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mario Limonciello <mario.limonciello@amd.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 034/227] platform/x86: amd-pmc: Correct usage of SMU version
Date:   Mon, 21 Feb 2022 09:47:33 +0100
Message-Id: <20220221084935.996720783@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220221084934.836145070@linuxfoundation.org>
References: <20220221084934.836145070@linuxfoundation.org>
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

From: Mario Limonciello <mario.limonciello@amd.com>

[ Upstream commit b8fb0d9b47660ddb8a8256412784aad7cee9f21a ]

Yellow carp has been outputting versions like `1093.24.0`, but this
is supposed to be 69.24.0. That is the MSB is being interpreted
incorrectly.

The MSB is not part of the major version, but has generally been
treated that way thus far.  It's actually the program, and used to
distinguish between two programs from a similar family but different
codebase.

Link: https://patchwork.freedesktop.org/patch/469993/
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Link: https://lore.kernel.org/r/20220120174439.12770-1-mario.limonciello@amd.com
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/amd-pmc.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/platform/x86/amd-pmc.c b/drivers/platform/x86/amd-pmc.c
index 230593ae5d6de..8c74733530e3d 100644
--- a/drivers/platform/x86/amd-pmc.c
+++ b/drivers/platform/x86/amd-pmc.c
@@ -117,9 +117,10 @@ struct amd_pmc_dev {
 	u32 cpu_id;
 	u32 active_ips;
 /* SMU version information */
-	u16 major;
-	u16 minor;
-	u16 rev;
+	u8 smu_program;
+	u8 major;
+	u8 minor;
+	u8 rev;
 	struct device *dev;
 	struct mutex lock; /* generic mutex lock */
 #if IS_ENABLED(CONFIG_DEBUG_FS)
@@ -166,11 +167,13 @@ static int amd_pmc_get_smu_version(struct amd_pmc_dev *dev)
 	if (rc)
 		return rc;
 
-	dev->major = (val >> 16) & GENMASK(15, 0);
+	dev->smu_program = (val >> 24) & GENMASK(7, 0);
+	dev->major = (val >> 16) & GENMASK(7, 0);
 	dev->minor = (val >> 8) & GENMASK(7, 0);
 	dev->rev = (val >> 0) & GENMASK(7, 0);
 
-	dev_dbg(dev->dev, "SMU version is %u.%u.%u\n", dev->major, dev->minor, dev->rev);
+	dev_dbg(dev->dev, "SMU program %u version is %u.%u.%u\n",
+		dev->smu_program, dev->major, dev->minor, dev->rev);
 
 	return 0;
 }
-- 
2.34.1



