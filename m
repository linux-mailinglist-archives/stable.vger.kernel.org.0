Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6590A54869A
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 17:57:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351927AbiFMMUf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 08:20:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357344AbiFMMTX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 08:19:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7925D5643B;
        Mon, 13 Jun 2022 04:02:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 76B8AB80E93;
        Mon, 13 Jun 2022 11:02:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3AE9C34114;
        Mon, 13 Jun 2022 11:02:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655118170;
        bh=hRGWsqzjKnMuK3JfTJG3FS+Mpovkt+WKMV9fQyy9qCc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BPHhKCsOJQ7Ftsj2hGIagI0B7dn6zGy3GTo3y2bJiE59fOqjjx7bWFwgxl7iMNrF2
         dRzlCOliDAURcy0b7tUPJkXvRmMyDvda1Bc6kELHZDbHa7owSJv7uV0ozKN8chpMmd
         8Kjp7NrmdmHoc2U4yZhKRMJB6pra+OcicJA3JZaw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiri Slaby <jirislaby@kernel.org>,
        Huang Guobin <huangguobin4@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 251/287] tty: Fix a possible resource leak in icom_probe
Date:   Mon, 13 Jun 2022 12:11:15 +0200
Message-Id: <20220613094931.625473972@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094923.832156175@linuxfoundation.org>
References: <20220613094923.832156175@linuxfoundation.org>
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
index ad374f7c476d..cb950c78d66d 100644
--- a/drivers/tty/serial/icom.c
+++ b/drivers/tty/serial/icom.c
@@ -1501,7 +1501,7 @@ static int icom_probe(struct pci_dev *dev,
 	retval = pci_read_config_dword(dev, PCI_COMMAND, &command_reg);
 	if (retval) {
 		dev_err(&dev->dev, "PCI Config read FAILED\n");
-		return retval;
+		goto probe_exit0;
 	}
 
 	pci_write_config_dword(dev, PCI_COMMAND,
-- 
2.35.1



