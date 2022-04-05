Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6185C4F3488
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 15:38:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245601AbiDEI40 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:56:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241017AbiDEIcn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:32:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0BECB0D2B;
        Tue,  5 Apr 2022 01:25:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3D2F260FF7;
        Tue,  5 Apr 2022 08:25:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50A7FC385A2;
        Tue,  5 Apr 2022 08:25:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649147157;
        bh=nbFqaPYyQR/5ihhSgwK8SB/D6DYw3WttpGCHsWSfH9E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wULrhrt8qmxwztTv8uCTm5thCWFbiEnJBynWRfwfDkK+c9sFyONLxJzrRNWXf3tqh
         qMT2tezf7lz5Xe4STXwSf+455FUKQfY5KIYHtR3krcy53lxCLLNFP/kkSk9DWi/H7z
         NfVmWR5CJKPvmlZzg0ntUE1zPxwZ9Szy7n9HA61c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tom Rix <trix@redhat.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 5.17 1022/1126] can: mcp251xfd: mcp251xfd_register_get_dev_id(): fix return of error value
Date:   Tue,  5 Apr 2022 09:29:29 +0200
Message-Id: <20220405070437.482312421@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
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
@@ -1657,7 +1657,7 @@ mcp251xfd_register_get_dev_id(const stru
  out_kfree_buf_rx:
 	kfree(buf_rx);
 
-	return 0;
+	return err;
 }
 
 #define MCP251XFD_QUIRK_ACTIVE(quirk) \


