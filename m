Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DED61500F05
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 15:22:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244199AbiDNNXt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 09:23:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244082AbiDNNXT (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 09:23:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E10BF939B3;
        Thu, 14 Apr 2022 06:18:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9163FB82982;
        Thu, 14 Apr 2022 13:18:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08252C385A1;
        Thu, 14 Apr 2022 13:18:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649942289;
        bh=n4XZKIqAnxf38ktFeInvlW1RzeqznHZYpBRS8tv0/98=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0iXJffWkWGfM+CGjoQZF0DiWVqCsO82uh1fFjobvsro3BegsqUjUpet5ArbfrTXZb
         LzWqRuLMz15Hyu1uv+oKLS98pH4xz0WUbl72HNU+hmHFgBP4O824H0Z0MnP0fUtx7k
         +gCpgko8xuE7Km3u0escVsV9Iq60N3XZC4P/Zs+w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        Igor Zhbanov <i.zhbanov@omprussia.ru>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 083/338] clocksource: acpi_pm: fix return value of __setup handler
Date:   Thu, 14 Apr 2022 15:09:46 +0200
Message-Id: <20220414110841.262752861@linuxfoundation.org>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <20220414110838.883074566@linuxfoundation.org>
References: <20220414110838.883074566@linuxfoundation.org>
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

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit 6a861abceecb68497dd82a324fee45a5332dcece ]

__setup() handlers should return 1 to obsolete_checksetup() in
init/main.c to indicate that the boot option has been handled.
A return of 0 causes the boot option/value to be listed as an Unknown
kernel parameter and added to init's (limited) environment strings.

The __setup() handler interface isn't meant to handle negative return
values -- they are non-zero, so they mean "handled" (like a return
value of 1 does), but that's just a quirk. So return 1 from
parse_pmtmr(). Also print a warning message if kstrtouint() returns
an error.

Fixes: 6b148507d3d0 ("pmtmr: allow command line override of ioport")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reported-by: Igor Zhbanov <i.zhbanov@omprussia.ru>
Link: lore.kernel.org/r/64644a2f-4a20-bab3-1e15-3b2cdd0defe3@omprussia.ru
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clocksource/acpi_pm.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/clocksource/acpi_pm.c b/drivers/clocksource/acpi_pm.c
index 1961e3539b57..05cc8d4e49ad 100644
--- a/drivers/clocksource/acpi_pm.c
+++ b/drivers/clocksource/acpi_pm.c
@@ -230,8 +230,10 @@ static int __init parse_pmtmr(char *arg)
 	int ret;
 
 	ret = kstrtouint(arg, 16, &base);
-	if (ret)
-		return ret;
+	if (ret) {
+		pr_warn("PMTMR: invalid 'pmtmr=' value: '%s'\n", arg);
+		return 1;
+	}
 
 	pr_info("PMTMR IOPort override: 0x%04x -> 0x%04x\n", pmtmr_ioport,
 		base);
-- 
2.34.1



