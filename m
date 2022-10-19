Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6AED603F5E
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 11:31:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233671AbiJSJbS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 05:31:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233706AbiJSJ3J (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 05:29:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B03FEE9840;
        Wed, 19 Oct 2022 02:12:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 98B5E6170D;
        Wed, 19 Oct 2022 09:03:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE16BC433D6;
        Wed, 19 Oct 2022 09:03:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666170183;
        bh=7DGMLTKFsU7+7Ad+NpWJf8+q3b2TJwi8QfsrxUDd5oo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ckOTFgtcUZD80Rai45v3NCemAHznQ9lL6rqElUH8/scEYfm/CyVN3nyrI5P70hYTH
         cVIBTC2Mh7Lze7YpvjBnce2IfUUz0hh3cd5Ss/kAo/Lmx7/Ok232KQkE9Ugz/2i2Oc
         GnEFqn2T/EXf69o69y4PkdTAqNv2gvgQ1PI+tYLw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 557/862] drivers: serial: jsm: fix some leaks in probe
Date:   Wed, 19 Oct 2022 10:30:44 +0200
Message-Id: <20221019083314.583713096@linuxfoundation.org>
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
index 0ea799bf8dbb..417a5b6bffc3 100644
--- a/drivers/tty/serial/jsm/jsm_driver.c
+++ b/drivers/tty/serial/jsm/jsm_driver.c
@@ -211,7 +211,8 @@ static int jsm_probe_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 		break;
 	default:
-		return -ENXIO;
+		rc = -ENXIO;
+		goto out_kfree_brd;
 	}
 
 	rc = request_irq(brd->irq, brd->bd_ops->intr, IRQF_SHARED, "JSM", brd);
-- 
2.35.1



