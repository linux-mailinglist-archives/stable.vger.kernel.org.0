Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A96255197C
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 15:06:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243520AbiFTNAW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 09:00:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243209AbiFTM5s (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 08:57:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28F6419294;
        Mon, 20 Jun 2022 05:55:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9EED1B811A0;
        Mon, 20 Jun 2022 12:55:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFC60C3411B;
        Mon, 20 Jun 2022 12:55:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655729714;
        bh=o4xZ5Na3RkwWIDOlYsfRkLahEYmnqPKWG46lPr0m57E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s97uI+Nv5mlVsE35GqlvdJfD5ARMgKdg4l0AXsK0ZNoEqB6C+c2SvfRbqaExsa8gS
         1eHzhYDXbqJiIXU70GytL/wn2c4Nw18SVQViLWJn6iWYPbMQ6UX7DDf0OsMeXQ40/+
         ZzTHGBDshsHl8Vc2ULLoxJysz9FoVUGSBJr9guio=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Duke Lee <krnhotwings@gmail.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 051/141] platform/x86/intel: hid: Add Surface Go to VGBS allow list
Date:   Mon, 20 Jun 2022 14:49:49 +0200
Message-Id: <20220620124731.043914458@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220620124729.509745706@linuxfoundation.org>
References: <20220620124729.509745706@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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



