Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF6A4441669
	for <lists+stable@lfdr.de>; Mon,  1 Nov 2021 10:22:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232782AbhKAJY6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 05:24:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:59154 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231901AbhKAJXk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Nov 2021 05:23:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A6C0661101;
        Mon,  1 Nov 2021 09:20:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635758455;
        bh=j16t0ctCD5BX5QKAYLGDPEG43aYiyhjPdluF9usODhM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jG+0ZJyYDZ/DJ9PRZZJZk48ynZwytTnLvfhdBgQNSLQH75Cp6Tn0gUVUlLe9MF+OO
         7DBXc7tIRWm3xn55YDXfrA1BRcu51pP1O9Tq3BpxAZrwasCT0TEcxH193SDF662bjd
         5FK7Xofc8XE4ovBFoA0Bt+UEnvTSW9G+q7QU+JTo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.14 09/25] nfc: port100: fix using -ERRNO as command type mask
Date:   Mon,  1 Nov 2021 10:17:21 +0100
Message-Id: <20211101082449.226807061@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211101082447.070493993@linuxfoundation.org>
References: <20211101082447.070493993@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>

commit 2195f2062e4cc93870da8e71c318ef98a1c51cef upstream.

During probing, the driver tries to get a list (mask) of supported
command types in port100_get_command_type_mask() function.  The value
is u64 and 0 is treated as invalid mask (no commands supported).  The
function however returns also -ERRNO as u64 which will be interpret as
valid command mask.

Return 0 on every error case of port100_get_command_type_mask(), so the
probing will stop.

Cc: <stable@vger.kernel.org>
Fixes: 0347a6ab300a ("NFC: port100: Commands mechanism implementation")
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nfc/port100.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/nfc/port100.c
+++ b/drivers/nfc/port100.c
@@ -1012,11 +1012,11 @@ static u64 port100_get_command_type_mask
 
 	skb = port100_alloc_skb(dev, 0);
 	if (!skb)
-		return -ENOMEM;
+		return 0;
 
 	resp = port100_send_cmd_sync(dev, PORT100_CMD_GET_COMMAND_TYPE, skb);
 	if (IS_ERR(resp))
-		return PTR_ERR(resp);
+		return 0;
 
 	if (resp->len < 8)
 		mask = 0;


