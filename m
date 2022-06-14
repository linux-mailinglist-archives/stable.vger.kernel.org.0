Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0AD3954A497
	for <lists+stable@lfdr.de>; Tue, 14 Jun 2022 04:09:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351839AbiFNCH4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 22:07:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352180AbiFNCHS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 22:07:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB03A35854;
        Mon, 13 Jun 2022 19:06:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7540160A56;
        Tue, 14 Jun 2022 02:06:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6D9AC341C4;
        Tue, 14 Jun 2022 02:05:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655172360;
        bh=o4xZ5Na3RkwWIDOlYsfRkLahEYmnqPKWG46lPr0m57E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MoWKQFQRl5wBvO80H+QM7P8apAKzz/R+1Ng/XN0vvX+KJUz10rr+YbAz2EUwxWjyR
         XD1G1T128EuGWd2DMaA6JOWVkRQijkFCvcmQlUy1/SRziyLkyA5wdyFtAa2qd4/ei+
         HRRJGAhtpId5PTDfvuMl/fmm9Kh0FcvGCPZAKiApnCJbn8geYYS1UDibLFHyfoJ89s
         1G6p+ATcGfF/nB0gOn687DHMCIBd9Ymf1y85vz7m2hE51DwyCGwQ2HhxNtlUlmttNu
         c/FCwHRykZ380Y7eelOhaXI/4GtUZBSEdUdSL/ChcH11D/1vbkWujFWoiwhC52AUlB
         iv/BMOlr/3rXA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Duke Lee <krnhotwings@gmail.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>, dvhart@infradead.org,
        platform-driver-x86@vger.kernel.org
Subject: [PATCH AUTOSEL 5.18 47/47] platform/x86/intel: hid: Add Surface Go to VGBS allow list
Date:   Mon, 13 Jun 2022 22:04:40 -0400
Message-Id: <20220614020441.1098348-47-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220614020441.1098348-1-sashal@kernel.org>
References: <20220614020441.1098348-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Duke Lee <krnhotwings@gmail.com>

[ Upstream commit d4fe9cc4ff8656704b58cfd9363d7c3c9d65e519 ]

The Surface Go reports Chassis Type 9 (Laptop,) so the device needs to be
added to dmi_vgbs_allow_list to enable tablet mode when an attached Type
Cover is folded back.

BugLink: https://github.com/linux-surface/linux-surface/issues/837
Signed-off-by: Duke Lee <krnhotwings@gmail.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Link: https://lore.kernel.org/r/20220607213654.5567-1-krnhotwings@gmail.com
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/intel/hid.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/platform/x86/intel/hid.c b/drivers/platform/x86/intel/hid.c
index 216d31e3403d..79cff1fc675c 100644
--- a/drivers/platform/x86/intel/hid.c
+++ b/drivers/platform/x86/intel/hid.c
@@ -122,6 +122,12 @@ static const struct dmi_system_id dmi_vgbs_allow_list[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "HP Spectre x360 Convertible 15-df0xxx"),
 		},
 	},
+	{
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Microsoft Corporation"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Surface Go"),
+		},
+	},
 	{ }
 };
 
-- 
2.35.1

