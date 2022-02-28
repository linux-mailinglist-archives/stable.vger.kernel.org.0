Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 970524C7721
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 19:11:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239739AbiB1SLm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 13:11:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241455AbiB1SJz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 13:09:55 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B7EBB45BC;
        Mon, 28 Feb 2022 09:50:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B1E2360915;
        Mon, 28 Feb 2022 17:50:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1141C340E7;
        Mon, 28 Feb 2022 17:50:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646070601;
        bh=BLTmIppxTsWdWze0CZzsQG7uFrPoMqr09GCc5EhtdPY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=evRiHM5R7JUuk5QeFvmnkRbF7ql9ZQ7HSpKZLLcqqL0JlIhMkQxfZZ0AuDORcSA/T
         R3v8kQo8F0iJNAp9bJOJXXMM/j3p0iIKn5qWm2FVZCmU4axJlvTBRaSGjKyNcOvnj0
         5JMRLF1xadrv59DGiv2VavR0uu/6PWKbvaKm7HdA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sven Peter <sven@svenpeter.dev>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.16 148/164] tps6598x: clear int mask on probe failure
Date:   Mon, 28 Feb 2022 18:25:10 +0100
Message-Id: <20220228172413.258312561@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220228172359.567256961@linuxfoundation.org>
References: <20220228172359.567256961@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

commit aba2081e0a9c977396124aa6df93b55ed5912b19 upstream.

The interrupt mask is enabled before any potential failure points in
the driver, which can leave a failure path where we exit with
interrupts enabled but the device not live. This causes an infinite
stream of interrupts on an Apple M1 Pro laptop on USB-C.

Add a failure label that's used post enabling interrupts, where we
mask them again before returning an error.

Suggested-by: Sven Peter <sven@svenpeter.dev>
Cc: stable <stable@vger.kernel.org>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Link: https://lore.kernel.org/r/e6b80669-20f3-06e7-9ed5-8951a9c6db6f@kernel.dk
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/tipd/core.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/typec/tipd/core.c b/drivers/usb/typec/tipd/core.c
index 6d27a5b5e3ca..7ffcda94d323 100644
--- a/drivers/usb/typec/tipd/core.c
+++ b/drivers/usb/typec/tipd/core.c
@@ -761,12 +761,12 @@ static int tps6598x_probe(struct i2c_client *client)
 
 	ret = tps6598x_read32(tps, TPS_REG_STATUS, &status);
 	if (ret < 0)
-		return ret;
+		goto err_clear_mask;
 	trace_tps6598x_status(status);
 
 	ret = tps6598x_read32(tps, TPS_REG_SYSTEM_CONF, &conf);
 	if (ret < 0)
-		return ret;
+		goto err_clear_mask;
 
 	/*
 	 * This fwnode has a "compatible" property, but is never populated as a
@@ -855,7 +855,8 @@ static int tps6598x_probe(struct i2c_client *client)
 	usb_role_switch_put(tps->role_sw);
 err_fwnode_put:
 	fwnode_handle_put(fwnode);
-
+err_clear_mask:
+	tps6598x_write64(tps, TPS_REG_INT_MASK1, 0);
 	return ret;
 }
 
-- 
2.35.1



