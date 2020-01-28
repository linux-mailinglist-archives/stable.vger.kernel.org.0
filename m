Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D9A7614BAB5
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 15:41:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729240AbgA1OPp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 09:15:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:38546 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730158AbgA1OPn (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 09:15:43 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 90E5C20678;
        Tue, 28 Jan 2020 14:15:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580220943;
        bh=SJ5RdmOGfQs5mLEPAX0sUe3M8Uc/nvXTm72BCGqymo8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BgC+sctN4NBONc0rcZuYv5R3tUY6Ywq8ZzPLtCHLku8TOAem29yRlxhVB5KPysbwD
         5Xn1PhPt9LD7P92taVQGwg8A9hto/Y1GwewtSr2TCixYbVHAQl7AjZjKOx0kbZdRpc
         R3fV0UJFpo3VCyS2T44CB5DFJzLyTP4ilARov97I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 025/271] Input: nomadik-ske-keypad - fix a loop timeout test
Date:   Tue, 28 Jan 2020 15:02:54 +0100
Message-Id: <20200128135854.542869074@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200128135852.449088278@linuxfoundation.org>
References: <20200128135852.449088278@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 4d8f727b83bcd6702c2d210330872c9122d2d360 ]

The loop exits with "timeout" set to -1 not to 0.

Fixes: 1158f0f16224 ("Input: add support for Nomadik SKE keypad controller")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/keyboard/nomadik-ske-keypad.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/input/keyboard/nomadik-ske-keypad.c b/drivers/input/keyboard/nomadik-ske-keypad.c
index 8567ee47761e1..ae3b045570740 100644
--- a/drivers/input/keyboard/nomadik-ske-keypad.c
+++ b/drivers/input/keyboard/nomadik-ske-keypad.c
@@ -100,7 +100,7 @@ static int __init ske_keypad_chip_init(struct ske_keypad *keypad)
 	while ((readl(keypad->reg_base + SKE_RIS) != 0x00000000) && timeout--)
 		cpu_relax();
 
-	if (!timeout)
+	if (timeout == -1)
 		return -EINVAL;
 
 	/*
-- 
2.20.1



