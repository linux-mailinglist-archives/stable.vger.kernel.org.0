Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB6CE541D1B
	for <lists+stable@lfdr.de>; Wed,  8 Jun 2022 00:08:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357054AbiFGWI0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 18:08:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382206AbiFGWG4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 18:06:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 078AE2534C5;
        Tue,  7 Jun 2022 12:16:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 97D2161922;
        Tue,  7 Jun 2022 19:16:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A428AC385A2;
        Tue,  7 Jun 2022 19:16:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654629400;
        bh=KiuypoSUd6NP4ZOZhLO+Q6SdpDwgU1oyK6PAXpq4hFg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IVUVRtjKAGq7jppZ2bXXVDtjXM/Gvty2BY2ccYKE6a4ZDAy7q1EkytPo5qNhWBuok
         ZtEfu2SjKgE7Ea+wzJ2fy7K5zWAsmJLBRuK17jG6vDftt+hVlRc0qnDeiIuaY0KR3z
         MwcbyiN5W9dPzJ146htl/zVz67T06WP+MKdVaS8A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mario Limonciello <mario.limonciello@amd.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Jassi Brar <jaswinder.singh@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 637/879] mailbox: pcc: Fix an invalid-load caught by the address sanitizer
Date:   Tue,  7 Jun 2022 19:02:35 +0200
Message-Id: <20220607165021.338940803@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
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



