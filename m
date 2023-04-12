Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 198776DEE76
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 10:42:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230477AbjDLIl6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 04:41:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231157AbjDLIla (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 04:41:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E53A7D9C
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 01:40:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C9FEB62FFF
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 08:40:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD9CFC433D2;
        Wed, 12 Apr 2023 08:40:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681288844;
        bh=/PTpr3PXJyhRBqFSQo1gHIjAiiw7J80Bkyf7OiUV9cA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D61kwfUdwZUVJwtg7buE00IbN+C3cbaTZx30CeP+F9s60mnPGM2x/mp/G+fDky2X8
         YVk59d+alMDyvuRiPNp4fVr/yRPeQlJGrdyM36VIbLbV4Ieyc+WFavzGfnf/CLfoYt
         FsRaFDHCStRWnO4v+Tas7tZckhAX/fDhqVSP7ZFY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Mirsad Todorovac <mirsad.todorovac@alu.unizg.hr>,
        Mark Pearson <mpearson-lenovo@squebb.ca>,
        Mario Limonciello <mario.limonciello@amd.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 038/164] platform/x86: think-lmi: Fix memory leaks when parsing ThinkStation WMI strings
Date:   Wed, 12 Apr 2023 10:32:40 +0200
Message-Id: <20230412082838.483295436@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082836.695875037@linuxfoundation.org>
References: <20230412082836.695875037@linuxfoundation.org>
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

From: Mark Pearson <mpearson-lenovo@squebb.ca>

[ Upstream commit e7d796fccdc8d17c2d21817ebe4c7bf5bbfe5433 ]

My previous commit introduced a memory leak where the item allocated
from tlmi_setting was not freed.
This commit also renames it to avoid confusion with the similarly name
variable in the same function.

Fixes: 8a02d70679fc ("platform/x86: think-lmi: Add possible_values for ThinkStation")
Reported-by: Mirsad Todorovac <mirsad.todorovac@alu.unizg.hr>
Link: https://lore.kernel.org/lkml/df26ff45-8933-f2b3-25f4-6ee51ccda7d8@gmx.de/T/
Signed-off-by: Mark Pearson <mpearson-lenovo@squebb.ca>
Link: https://lore.kernel.org/r/20230403013120.2105-1-mpearson-lenovo@squebb.ca
Tested-by: Mario Limonciello <mario.limonciello@amd.com>
Tested-by: Mirsad Goran Todorovac <mirsad.todorovac@alu.unizg.hr>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/think-lmi.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/platform/x86/think-lmi.c b/drivers/platform/x86/think-lmi.c
index 4e738ec5e6fb8..70c4ee254c43a 100644
--- a/drivers/platform/x86/think-lmi.c
+++ b/drivers/platform/x86/think-lmi.c
@@ -1459,10 +1459,10 @@ static int tlmi_analyze(void)
 			 * name string.
 			 * Try and pull that out if it's available.
 			 */
-			char *item, *optstart, *optend;
+			char *optitem, *optstart, *optend;
 
-			if (!tlmi_setting(setting->index, &item, LENOVO_BIOS_SETTING_GUID)) {
-				optstart = strstr(item, "[Optional:");
+			if (!tlmi_setting(setting->index, &optitem, LENOVO_BIOS_SETTING_GUID)) {
+				optstart = strstr(optitem, "[Optional:");
 				if (optstart) {
 					optstart += strlen("[Optional:");
 					optend = strstr(optstart, "]");
@@ -1471,6 +1471,7 @@ static int tlmi_analyze(void)
 							kstrndup(optstart, optend - optstart,
 									GFP_KERNEL);
 				}
+				kfree(optitem);
 			}
 		}
 		/*
-- 
2.39.2



