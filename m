Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7F17540CF1
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 20:44:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353231AbiFGSoM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 14:44:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353340AbiFGSmF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 14:42:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2102B187047;
        Tue,  7 Jun 2022 10:59:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 79A7F61680;
        Tue,  7 Jun 2022 17:58:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B5DAC34119;
        Tue,  7 Jun 2022 17:58:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654624738;
        bh=c1AB+XbePk8ulWNOw7j8RQe1KAN3ETCnKQhtQ248d0w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WDd1I+Qb+WAnVhYRWf709n1KGiyMnuSHfQCTtXnWgLMjAZIhui4jl7k4E1AI/CvKE
         +pF4MpQ1YNB0imKT0d1QceG1FPfbkhdtB1DHqGqBPJ3JYnw9R+XN/15yBmvdxrc9Cx
         yr+p8LQTwgjOOWDZF3JNVbI74e5mq5sI9LRkwBSSL5fvWg7d9PPCOKywANzPVwnYZY
         RAeePMKy1Plg1dgdrnrKmYhSmkp1kSHHWwxzEmZ8SHyesX8dsJB1aUO+GrC1atFeWY
         rQWHRnzMLGTNPAHEcjkBpHBgL9Sb/ue9qySJ3IRAWeUDrsHYhegMymMlsANFT/bTiw
         Z7Ds+Sun50fUw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Huang Guobin <huangguobin4@huawei.com>,
        Jiri Slaby <jirislaby@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-serial@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 06/38] tty: Fix a possible resource leak in icom_probe
Date:   Tue,  7 Jun 2022 13:58:01 -0400
Message-Id: <20220607175835.480735-6-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220607175835.480735-1-sashal@kernel.org>
References: <20220607175835.480735-1-sashal@kernel.org>
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

From: Huang Guobin <huangguobin4@huawei.com>

[ Upstream commit ee157a79e7c82b01ae4c25de0ac75899801f322c ]

When pci_read_config_dword failed, call pci_release_regions() and
pci_disable_device() to recycle the resource previously allocated.

Reviewed-by: Jiri Slaby <jirislaby@kernel.org>
Signed-off-by: Huang Guobin <huangguobin4@huawei.com>
Link: https://lore.kernel.org/r/20220331091005.3290753-1-huangguobin4@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/icom.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/tty/serial/icom.c b/drivers/tty/serial/icom.c
index 94c8281ddb5f..74b325c344da 100644
--- a/drivers/tty/serial/icom.c
+++ b/drivers/tty/serial/icom.c
@@ -1503,7 +1503,7 @@ static int icom_probe(struct pci_dev *dev,
 	retval = pci_read_config_dword(dev, PCI_COMMAND, &command_reg);
 	if (retval) {
 		dev_err(&dev->dev, "PCI Config read FAILED\n");
-		return retval;
+		goto probe_exit0;
 	}
 
 	pci_write_config_dword(dev, PCI_COMMAND,
-- 
2.35.1

