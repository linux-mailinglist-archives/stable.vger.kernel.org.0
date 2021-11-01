Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C5894416C4
	for <lists+stable@lfdr.de>; Mon,  1 Nov 2021 10:27:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232241AbhKAJ2x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 05:28:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:59239 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231979AbhKAJ1N (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Nov 2021 05:27:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E6D0061101;
        Mon,  1 Nov 2021 09:22:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635758555;
        bh=TrunEkdmAKOzzNzNkO/1rXEfuJn2an1GuGMg5jY4mek=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WmazCPAQqOj38TUL48MSr3b7rsbwor/62yekEDJtGM4ZMBFLl4ZWjNzrUvOKGP+f7
         lvgNC2B1MGVc/f5ABKw7Le6t5a9yNubLng6nDWQbYknf6k5W0OpRBXTi+i0Px70ESr
         ipwEq2/eHyHOCno1U0aT4p9fJPWh8N55LC7bv+/Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 12/51] nfc: port100: fix using -ERRNO as command type mask
Date:   Mon,  1 Nov 2021 10:17:16 +0100
Message-Id: <20211101082503.473282718@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211101082500.203657870@linuxfoundation.org>
References: <20211101082500.203657870@linuxfoundation.org>
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
@@ -1003,11 +1003,11 @@ static u64 port100_get_command_type_mask
 
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


