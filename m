Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5C9466CDC5
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 18:39:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235086AbjAPRjy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 12:39:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235084AbjAPRj3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 12:39:29 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 178D14C6DE
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 09:15:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A505E61077
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 17:15:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC0D0C433D2;
        Mon, 16 Jan 2023 17:15:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673889323;
        bh=7uvtiZsQiXByGYzrT7Kbuh0ZMO6iIueX7kjfodR6j/E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ovqilD4Jo4ZP85L8AHx+5oqueVzbyBeFWoHIIW6qk1vmqIA4ziZjrOrfTJfszWGIp
         Jj8pJUmVblBGqCDFZcCjBrqgXaQr09XUzH24PgNqD1IJtkw6+1YhGr96g8nu/6sZ32
         o/l0MMCH5+PoAHQ1tV3ENs0WMb5CI2hB7CbEVM9g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Szymon Heidrich <szymon.heidrich@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 314/338] usb: rndis_host: Secure rndis_query check against int overflow
Date:   Mon, 16 Jan 2023 16:53:07 +0100
Message-Id: <20230116154834.817877049@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154820.689115727@linuxfoundation.org>
References: <20230116154820.689115727@linuxfoundation.org>
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

From: Szymon Heidrich <szymon.heidrich@gmail.com>

[ Upstream commit c7dd13805f8b8fc1ce3b6d40f6aff47e66b72ad2 ]

Variables off and len typed as uint32 in rndis_query function
are controlled by incoming RNDIS response message thus their
value may be manipulated. Setting off to a unexpectetly large
value will cause the sum with len and 8 to overflow and pass
the implemented validation step. Consequently the response
pointer will be referring to a location past the expected
buffer boundaries allowing information leakage e.g. via
RNDIS_OID_802_3_PERMANENT_ADDRESS OID.

Fixes: ddda08624013 ("USB: rndis_host, various cleanups")
Signed-off-by: Szymon Heidrich <szymon.heidrich@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/rndis_host.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/usb/rndis_host.c b/drivers/net/usb/rndis_host.c
index ab41a63aa4aa..497d6bcdc276 100644
--- a/drivers/net/usb/rndis_host.c
+++ b/drivers/net/usb/rndis_host.c
@@ -267,7 +267,8 @@ static int rndis_query(struct usbnet *dev, struct usb_interface *intf,
 
 	off = le32_to_cpu(u.get_c->offset);
 	len = le32_to_cpu(u.get_c->len);
-	if (unlikely((8 + off + len) > CONTROL_BUFFER_SIZE))
+	if (unlikely((off > CONTROL_BUFFER_SIZE - 8) ||
+		     (len > CONTROL_BUFFER_SIZE - 8 - off)))
 		goto response_error;
 
 	if (*reply_len != -1 && len != *reply_len)
-- 
2.35.1



