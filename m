Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2BE4604299
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 13:08:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233475AbiJSLH6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 07:07:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232316AbiJSLHZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 07:07:25 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9981C176533;
        Wed, 19 Oct 2022 03:36:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 2E4CCCE21B5;
        Wed, 19 Oct 2022 09:11:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EB3EC433D6;
        Wed, 19 Oct 2022 09:11:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666170711;
        bh=92eQYMkXiqh2tRjqU7wqolS9xclS+SWR5TXgeWI09vw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wjkqqDX8PXNsjHC3svv8D21Ru4ZL0s62HyXsIAIQ93Q9jWt+qjGqwi1O0aVtQwud2
         vUmQBfzOhmQVwcPvX4CZ0iEbSFvCJdL+QpmdgymreADyrvaHApHEjF1oI5aiZAcZUD
         9pyJeUf3+aBy2jhBgJfQ8KF8yc9XqiyMqm+wrUWA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sebastian S <iam@decentr.al>,
        Mario Limonciello <mario.limonciello@amd.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        Travis Glenn Hansen <travisghansen@yahoo.com>
Subject: [PATCH 6.0 759/862] ASoC: amd: yc: Add Lenovo Yoga Slim 7 Pro X to quirks table
Date:   Wed, 19 Oct 2022 10:34:06 +0200
Message-Id: <20221019083323.444904947@linuxfoundation.org>
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

From: Mario Limonciello <mario.limonciello@amd.com>

[ Upstream commit 2232b2dd8cd4f1e6d554b2c3f6899ce36f791b67 ]

Lenovo Yoga Slim 7 Pro X has an ACP DMIC that isn't specified in the
ASL or existing quirk list.  Add it to the quirk table to let DMIC
work on these systems.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=216299
Tested-by: Sebastian S <iam@decentr.al>
Reported-and-tested-by: Travis Glenn Hansen <travisghansen@yahoo.com>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Link: https://lore.kernel.org/r/20220920201436.19734-3-mario.limonciello@amd.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/yc/acp6x-mach.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/sound/soc/amd/yc/acp6x-mach.c b/sound/soc/amd/yc/acp6x-mach.c
index 5eab3baf3573..2cb50d5cf1a9 100644
--- a/sound/soc/amd/yc/acp6x-mach.c
+++ b/sound/soc/amd/yc/acp6x-mach.c
@@ -171,6 +171,13 @@ static const struct dmi_system_id yc_acp_quirk_table[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "21J6"),
 		}
 	},
+	{
+		.driver_data = &acp6x_card,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "LENOVO"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "82"),
+		}
+	},
 	{
 		.driver_data = &acp6x_card,
 		.matches = {
-- 
2.35.1



