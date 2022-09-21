Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32F6F5C031B
	for <lists+stable@lfdr.de>; Wed, 21 Sep 2022 18:00:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231889AbiIUQAe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Sep 2022 12:00:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232148AbiIUP6a (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Sep 2022 11:58:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F3E0A1A54;
        Wed, 21 Sep 2022 08:52:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 37F9E6314A;
        Wed, 21 Sep 2022 15:50:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 396ACC433D6;
        Wed, 21 Sep 2022 15:50:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663775446;
        bh=IAXrtAU0MtO/djsOcVtVb20xhEmQ0ugsq4ceoUOnJMc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eLvdlJusYhHO+jO7WfhGtE0k1ysWog+BZQv6iA8ab82TRB35qnbkve6OZqQBQ7ODP
         dADhpoiOF8GKvWZ65AS9/OfwjGUJJcojIlZhDurG1N4ccGC2ZKXHx3svS+6w42zuXK
         A8G0EZxIUoeeDlOtGJKGFN9nJKFNVy4VmPpp1rHY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alex Hung <alex.hung@canonical.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 10/39] platform/x86/intel: hid: add quirk to support Surface Go 3
Date:   Wed, 21 Sep 2022 17:46:15 +0200
Message-Id: <20220921153646.084870883@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220921153645.663680057@linuxfoundation.org>
References: <20220921153645.663680057@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alex Hung <alex.hung@canonical.com>

[ Upstream commit 01e16cb67cce68afaeb9c7bed72299036dbb0bc1 ]

Similar to other systems Surface Go 3 requires a DMI quirk to enable
5 button array for power and volume buttons.

Buglink: https://github.com/linux-surface/linux-surface/issues/595

Cc: stable@vger.kernel.org
Signed-off-by: Alex Hung <alex.hung@canonical.com>
Link: https://lore.kernel.org/r/20211203212810.2666508-1-alex.hung@canonical.com
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/intel-hid.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/platform/x86/intel-hid.c b/drivers/platform/x86/intel-hid.c
index 8a0cd5bf0065..cebddefba2f4 100644
--- a/drivers/platform/x86/intel-hid.c
+++ b/drivers/platform/x86/intel-hid.c
@@ -93,6 +93,13 @@ static const struct dmi_system_id button_array_table[] = {
 			DMI_MATCH(DMI_PRODUCT_FAMILY, "ThinkPad X1 Tablet Gen 2"),
 		},
 	},
+	{
+		.ident = "Microsoft Surface Go 3",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Microsoft Corporation"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Surface Go 3"),
+		},
+	},
 	{ }
 };
 
-- 
2.35.1



