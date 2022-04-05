Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 479A94F4390
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 23:59:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380667AbiDEMYX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 08:24:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345129AbiDEKkp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 06:40:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C717D2DD5F;
        Tue,  5 Apr 2022 03:26:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 843F8B81C8B;
        Tue,  5 Apr 2022 10:25:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9156C385A0;
        Tue,  5 Apr 2022 10:25:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649154358;
        bh=fZ0+p4iMcwpif+8pcG9AucA+SY+U0ec5ESJny4FBwTk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pzxjm+U0DN71T0VHGDWUFGWyJn10bR/g5MlvgMOtDxQxCBn5Zaf6SawSB8dWECP7B
         tn4oFcyqRJEqhr9s73/+ITMRSi33zCi9rISiQystRkHCOtcCSDgNx2pE3LUun194Xj
         xBm2hZWUo+NcPSPBQ4XOW2OdWPNQyLb1UOMiA9cA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tom Rix <trix@redhat.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 5.10 551/599] can: mcp251xfd: mcp251xfd_register_get_dev_id(): fix return of error value
Date:   Tue,  5 Apr 2022 09:34:05 +0200
Message-Id: <20220405070315.236747699@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070258.802373272@linuxfoundation.org>
References: <20220405070258.802373272@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Tom Rix <trix@redhat.com>

commit fa7b514d2b2894e052b8e94c7a29feb98e90093f upstream.

Clang static analysis reports this issue:

| mcp251xfd-core.c:1813:7: warning: The left operand
|   of '&' is a garbage value
|   FIELD_GET(MCP251XFD_REG_DEVID_ID_MASK, dev_id),
|   ^                                      ~~~~~~

dev_id is set in a successful call to mcp251xfd_register_get_dev_id().
Though the status of calls made by mcp251xfd_register_get_dev_id() are
checked and handled, their status' are not returned. So return err.

Fixes: 55e5b97f003e ("can: mcp25xxfd: add driver for Microchip MCP25xxFD SPI CAN")
Link: https://lore.kernel.org/all/20220319153128.2164120-1-trix@redhat.com
Signed-off-by: Tom Rix <trix@redhat.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
+++ b/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
@@ -2578,7 +2578,7 @@ mcp251xfd_register_get_dev_id(const stru
  out_kfree_buf_rx:
 	kfree(buf_rx);
 
-	return 0;
+	return err;
 }
 
 #define MCP251XFD_QUIRK_ACTIVE(quirk) \


