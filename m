Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 704465936AE
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 21:25:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244906AbiHOTCz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 15:02:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245434AbiHOTCA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 15:02:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B19064BD3E;
        Mon, 15 Aug 2022 11:33:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4494E61029;
        Mon, 15 Aug 2022 18:33:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47559C433D6;
        Mon, 15 Aug 2022 18:33:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660588395;
        bh=SQUrOBXqf5/aHpf7ZBuGXQqIx9y/uHaCHkNS/jJXmJE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vD4zXs8quGPRvjTLMk+QlU06gX0HHGQT+kOAjTRdbiH+dYZVCS9OIeZSIl0yZXfLL
         PfezLyKheExbwfjxMSKg14Y/iUiu3i0hFjPPl8DRk2R9TpcGC/NAqe/1hUMe04c84P
         nauhkBTxTFKFup82saz5R/N1gReT/CYWimso/Z6U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Chang <David.Chang@amd.com>,
        Mario Limonciello <mario.limonciello@amd.com>,
        Basavaraj Natikar <Basavaraj.Natikar@amd.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 388/779] HID: amd_sfh: Dont show client init failed as error when discovery fails
Date:   Mon, 15 Aug 2022 20:00:32 +0200
Message-Id: <20220815180353.880699617@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
User-Agent: quilt/0.67
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

[ Upstream commit e51d8d3ea3d773334d2c047c8d1623dba66f592a ]

When sensor discovery fails, this means that the system doesn't have
any sensors connected and a user should only be notified at most one time.
A message is already displayed at WARN level of "failed to discover,
sensors not enabled".  It's pointless to show that the client init failed
at ERR level for the same condition.

Check the return code and don't display this message in those conditions.

Fixes: b5d7f43e97da ("HID: amd_sfh: Add support for sensor discovery")
Reported-by: David Chang <David.Chang@amd.com>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Acked-by: Basavaraj Natikar <Basavaraj.Natikar@amd.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/amd-sfh-hid/amd_sfh_pcie.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/hid/amd-sfh-hid/amd_sfh_pcie.c b/drivers/hid/amd-sfh-hid/amd_sfh_pcie.c
index ae8f1f2536e9..13a4db42cd7a 100644
--- a/drivers/hid/amd-sfh-hid/amd_sfh_pcie.c
+++ b/drivers/hid/amd-sfh-hid/amd_sfh_pcie.c
@@ -323,7 +323,8 @@ static int amd_mp2_pci_probe(struct pci_dev *pdev, const struct pci_device_id *i
 	rc = amd_sfh_hid_client_init(privdata);
 	if (rc) {
 		amd_sfh_clear_intr(privdata);
-		dev_err(&pdev->dev, "amd_sfh_hid_client_init failed\n");
+		if (rc != -EOPNOTSUPP)
+			dev_err(&pdev->dev, "amd_sfh_hid_client_init failed\n");
 		return rc;
 	}
 
-- 
2.35.1



