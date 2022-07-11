Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA87556FBA3
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 11:33:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232465AbiGKJdb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 05:33:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232743AbiGKJdA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 05:33:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86BF778DC1;
        Mon, 11 Jul 2022 02:17:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C55FE61227;
        Mon, 11 Jul 2022 09:17:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D169AC34115;
        Mon, 11 Jul 2022 09:17:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657531061;
        bh=YYUyytMC0pUftyIXjxoK3jnBzW0leo2WLvAhxuXrFMw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=npD0GjuXEakmizbNC47q/fXRmf2R4axDAY6wJ267dh5pN8RXl6msi/Z5x4ikruypm
         LO1WZBmSo7SH8y6vZtrxqpvkEfE6yPrYloh0Kojn/u8kyAWXody+1SZY+AdlAjLbyP
         ZijuMZFNXu8oTigwiRzXsglxdzdS1xqazHkYbiRE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Ira Weiny <ira.weiny@intel.com>,
        Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 5.18 032/112] cxl: Fix cleanup of port devices on failure to probe driver.
Date:   Mon, 11 Jul 2022 11:06:32 +0200
Message-Id: <20220711090550.479566633@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220711090549.543317027@linuxfoundation.org>
References: <20220711090549.543317027@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jonathan Cameron <Jonathan.Cameron@huawei.com>

commit db9a3a35d31ea337331f0e6e07e04bcd52642894 upstream.

The device is created, and then there is a check if a driver succesfully
bound to it. In event of failing the bind (e.g. failure in cxl_port_probe())
the device is left registered. When a bus rescan later occurs, fresh
devices are created leading to a multiple device representing the same
underlying hardware. Bad things may follow and at very least we have far too many
devices.

Fix by ensuring autoremove is registered if the device create succeeds,
but doesn't depend on sucessful binding to a driver.

Bug was observed as side effect of incorrect ownership in
[PATCH v9 6/9] cxl/port: Read CDAT table
but will result from any failure to in cxl_port_probe().

Fixes: 8dd2bc0f8e02 ("cxl/mem: Add the cxl_mem driver")
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Reviewed-by: Ira Weiny <ira.weiny@intel.com>
Link: https://lore.kernel.org/r/20220609134519.11668-1-Jonathan.Cameron@huawei.com
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/cxl/mem.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/cxl/mem.c
+++ b/drivers/cxl/mem.c
@@ -46,6 +46,7 @@ static int create_endpoint(struct cxl_me
 {
 	struct cxl_dev_state *cxlds = cxlmd->cxlds;
 	struct cxl_port *endpoint;
+	int rc;
 
 	endpoint = devm_cxl_add_port(&parent_port->dev, &cxlmd->dev,
 				     cxlds->component_reg_phys, parent_port);
@@ -54,13 +55,17 @@ static int create_endpoint(struct cxl_me
 
 	dev_dbg(&cxlmd->dev, "add: %s\n", dev_name(&endpoint->dev));
 
+	rc = cxl_endpoint_autoremove(cxlmd, endpoint);
+	if (rc)
+		return rc;
+
 	if (!endpoint->dev.driver) {
 		dev_err(&cxlmd->dev, "%s failed probe\n",
 			dev_name(&endpoint->dev));
 		return -ENXIO;
 	}
 
-	return cxl_endpoint_autoremove(cxlmd, endpoint);
+	return 0;
 }
 
 /**


