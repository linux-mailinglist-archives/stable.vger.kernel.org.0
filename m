Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72E0965131F
	for <lists+stable@lfdr.de>; Mon, 19 Dec 2022 20:27:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232207AbiLST1m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Dec 2022 14:27:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232633AbiLST1X (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Dec 2022 14:27:23 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 832FD2189
        for <stable@vger.kernel.org>; Mon, 19 Dec 2022 11:27:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 06DEE6109A
        for <stable@vger.kernel.org>; Mon, 19 Dec 2022 19:27:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12E0CC433D2;
        Mon, 19 Dec 2022 19:27:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1671478026;
        bh=UyPyFbKl9kgsXB+u9+j+M8kLM7ddd+2KPJv11peV7E4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zr/6pVbaFcrhZm8mViuQ46SZgHLfI9wJoqEUGEV4rE+rG1gLm36dYW06R9974rBVe
         I0o26LfgHsA/3CWGU41wnlzjH47XvzN4fjv34cycA0CrXra31BzpcogwwyuBLRcIwP
         ME6TR/cAFlMdbvGsWoXXSxhqa1CMAZs/y3AaJlt4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Ferry Toth <ftoth@exalondelft.nl>
Subject: [PATCH 5.15 13/17] usb: ulpi: defer ulpi_register on ulpi_read_id timeout
Date:   Mon, 19 Dec 2022 20:24:59 +0100
Message-Id: <20221219182941.140526839@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221219182940.739981110@linuxfoundation.org>
References: <20221219182940.739981110@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ferry Toth <ftoth@exalondelft.nl>

commit 8a7b31d545d3a15f0e6f5984ae16f0ca4fd76aac upstream.

Since commit 0f0101719138 ("usb: dwc3: Don't switch OTG -> peripheral
if extcon is present") Dual Role support on Intel Merrifield platform
broke due to rearranging the call to dwc3_get_extcon().

It appears to be caused by ulpi_read_id() on the first test write failing
with -ETIMEDOUT. Currently ulpi_read_id() expects to discover the phy via
DT when the test write fails and returns 0 in that case, even if DT does not
provide the phy. As a result usb probe completes without phy.

Make ulpi_read_id() return -ETIMEDOUT to its user if the first test write
fails. The user should then handle it appropriately. A follow up patch
will make dwc3_core_init() set -EPROBE_DEFER in this case and bail out.

Fixes: ef6a7bcfb01c ("usb: ulpi: Support device discovery via DT")
Cc: stable@vger.kernel.org
Acked-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Signed-off-by: Ferry Toth <ftoth@exalondelft.nl>
Link: https://lore.kernel.org/r/20221205201527.13525-2-ftoth@exalondelft.nl
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/common/ulpi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/common/ulpi.c
+++ b/drivers/usb/common/ulpi.c
@@ -206,7 +206,7 @@ static int ulpi_read_id(struct ulpi *ulp
 	/* Test the interface */
 	ret = ulpi_write(ulpi, ULPI_SCRATCH, 0xaa);
 	if (ret < 0)
-		goto err;
+		return ret;
 
 	ret = ulpi_read(ulpi, ULPI_SCRATCH);
 	if (ret < 0)


