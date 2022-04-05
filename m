Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7927F4F3434
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 15:25:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355774AbiDEKWB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 06:22:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347740AbiDEJ2O (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:28:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56938DFDC3;
        Tue,  5 Apr 2022 02:15:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 30F00615E5;
        Tue,  5 Apr 2022 09:15:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43451C385A0;
        Tue,  5 Apr 2022 09:15:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649150127;
        bh=fyksP8iHCy9RFz7uy483NgCx3ENE00nut1rH8XRHy80=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T8CDZTLMOll9vHT3rLL7FWvjpJVcH2y0XEpF4QKXOs6RZAkoG6GszVOGW121zH2Kb
         69Fc4T1b/uK8BI5l2R+pje02BTWq+4OKPT2/b1UxGPLFr6aDOL1V+Xzh8knPJXB/kO
         6N9Zf71CKiF/wini30aQlOQG4OrQ8viCZULdsmuY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tom Rix <trix@redhat.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 5.16 0925/1017] can: mcp251xfd: mcp251xfd_register_get_dev_id(): fix return of error value
Date:   Tue,  5 Apr 2022 09:30:38 +0200
Message-Id: <20220405070421.674752162@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
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
@@ -2706,7 +2706,7 @@ mcp251xfd_register_get_dev_id(const stru
  out_kfree_buf_rx:
 	kfree(buf_rx);
 
-	return 0;
+	return err;
 }
 
 #define MCP251XFD_QUIRK_ACTIVE(quirk) \


