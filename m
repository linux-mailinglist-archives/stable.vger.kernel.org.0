Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C262541565
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 22:35:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359446AbiFGUfo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 16:35:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377430AbiFGUdQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 16:33:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F9CA1E4514;
        Tue,  7 Jun 2022 11:35:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 82468B82380;
        Tue,  7 Jun 2022 18:35:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF4D4C385A2;
        Tue,  7 Jun 2022 18:35:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654626901;
        bh=KiuypoSUd6NP4ZOZhLO+Q6SdpDwgU1oyK6PAXpq4hFg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ehH1at4xjEGYSAp4ZiAW8VVefQSsFKJGErRemdRqQzQSM7cjT0fQ76YCDFP8Dj0QP
         NlGKK2OoaSjm1e8e0kvpWZ1hDXWU+Z5I8lnzxewWur9UMrz8coWI1kmA/4Quiqizf5
         yFfWkIa/0E4Xrzab/f1OTqtI7NsszPQRJ75DsB2A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mario Limonciello <mario.limonciello@amd.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Jassi Brar <jaswinder.singh@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 544/772] mailbox: pcc: Fix an invalid-load caught by the address sanitizer
Date:   Tue,  7 Jun 2022 19:02:16 +0200
Message-Id: <20220607165004.995044912@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164948.980838585@linuxfoundation.org>
References: <20220607164948.980838585@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Mario Limonciello <mario.limonciello@amd.com>

[ Upstream commit 369e4ef87a8f5da7c348ec2c61ec5cd726e8337a ]

`pcc_mailbox_probe` doesn't initialize all memory that has been allocated
before the first time that one of it's members `txdone_irq` may be
accessed.

This leads to a an invalid load any time that this member is accessed:
[    2.429769] UBSAN: invalid-load in drivers/mailbox/pcc.c:684:22
[    2.430324] UBSAN: invalid-load in drivers/mailbox/mailbox.c:486:12
[    4.276782] UBSAN: invalid-load in drivers/acpi/cppc_acpi.c:314:45

Link: https://bugzilla.kernel.org/show_bug.cgi?id=215587
Fixes: ce028702ddbc ("mailbox: pcc: Move bulk of PCCT parsing into pcc_mbox_probe")
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Reviewed-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Jassi Brar <jaswinder.singh@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mailbox/pcc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mailbox/pcc.c b/drivers/mailbox/pcc.c
index ed18936b8ce6..ebfa33a40fce 100644
--- a/drivers/mailbox/pcc.c
+++ b/drivers/mailbox/pcc.c
@@ -654,7 +654,7 @@ static int pcc_mbox_probe(struct platform_device *pdev)
 		goto err;
 	}
 
-	pcc_mbox_ctrl = devm_kmalloc(dev, sizeof(*pcc_mbox_ctrl), GFP_KERNEL);
+	pcc_mbox_ctrl = devm_kzalloc(dev, sizeof(*pcc_mbox_ctrl), GFP_KERNEL);
 	if (!pcc_mbox_ctrl) {
 		rc = -ENOMEM;
 		goto err;
-- 
2.35.1



