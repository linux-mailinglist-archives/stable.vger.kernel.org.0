Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B21CB60B789
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 21:25:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232494AbiJXTZn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 15:25:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233375AbiJXTYO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 15:24:14 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EB2650068;
        Mon, 24 Oct 2022 10:58:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 7E4DECE1354;
        Mon, 24 Oct 2022 11:52:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95766C433C1;
        Mon, 24 Oct 2022 11:52:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666612357;
        bh=O58E1AyVjyogFsMTYnODPtbKaiCqX9nWLSX/gDKhIGE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hKb00Z9Cp3JHDX0of6vQVnIO/WEUXub57KaW4nqhDQAEJ55O3+GNIO4LFbkBuySvt
         0ZEsgj1CBmha6p8KHz/4rPsAsvf9YR0zCPmhdOElUr1zq8UcxBg+tlhryhX0BjLaIn
         4AZOX5j1tVnE97xF5+dTzTh09dJreb6hTwDm3wdY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 137/210] drivers: serial: jsm: fix some leaks in probe
Date:   Mon, 24 Oct 2022 13:30:54 +0200
Message-Id: <20221024113001.439764275@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024112956.797777597@linuxfoundation.org>
References: <20221024112956.797777597@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 1d5859ef229e381f4db38dce8ed58e4bf862006b ]

This error path needs to unwind instead of just returning directly.

Fixes: 03a8482c17dd ("drivers: serial: jsm: Enable support for Digi Classic adapters")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Link: https://lore.kernel.org/r/YyxFh1+lOeZ9WfKO@kili
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/jsm/jsm_driver.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/tty/serial/jsm/jsm_driver.c b/drivers/tty/serial/jsm/jsm_driver.c
index 102d499814ac..bd4efbbb7073 100644
--- a/drivers/tty/serial/jsm/jsm_driver.c
+++ b/drivers/tty/serial/jsm/jsm_driver.c
@@ -221,7 +221,8 @@ static int jsm_probe_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 		break;
 	default:
-		return -ENXIO;
+		rc = -ENXIO;
+		goto out_kfree_brd;
 	}
 
 	rc = request_irq(brd->irq, brd->bd_ops->intr, IRQF_SHARED, "JSM", brd);
-- 
2.35.1



