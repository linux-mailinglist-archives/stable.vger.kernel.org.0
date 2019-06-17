Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 21159492DD
	for <lists+stable@lfdr.de>; Mon, 17 Jun 2019 23:25:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729978AbfFQVYm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jun 2019 17:24:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:50454 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728841AbfFQVYl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Jun 2019 17:24:41 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 65C8A21019;
        Mon, 17 Jun 2019 21:24:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560806680;
        bh=zUIkRL2+2N6TejLuqB/35gmEd3f/CWpfpIxNm+H4+/s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HSkhgjuY0fiuqif8x/kzcbDE+OSvU/BkEvRsYUsaIwIcAonBcWL4W4KKHSTf0wfkO
         urf7bKsBoLy68sA9LeIZxb6H5i6k3TiRis6jB4PNhlhiwDfxaw+19+OjZadJCAipHA
         Fyig9y0Vx5H7f5yIUR4v6LIxO8rRWaqMbk0buCPU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Russell King <rmk+kernel@armlinux.org.uk>,
        Wolfram Sang <wsa@the-dreams.de>, stable@kernel.org
Subject: [PATCH 4.19 20/75] i2c: acorn: fix i2c warning
Date:   Mon, 17 Jun 2019 23:09:31 +0200
Message-Id: <20190617210753.632805954@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190617210752.799453599@linuxfoundation.org>
References: <20190617210752.799453599@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Russell King <rmk+kernel@armlinux.org.uk>

commit ca21f851cc9643af049226d57fabc3c883ea648e upstream.

The Acorn i2c driver (for RiscPC) triggers the "i2c adapter has no name"
warning in the I2C core driver, resulting in the RTC being inaccessible.
Fix this.

Fixes: 2236baa75f70 ("i2c: Sanity checks on adapter registration")
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
Cc: stable@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/i2c/busses/i2c-acorn.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/i2c/busses/i2c-acorn.c
+++ b/drivers/i2c/busses/i2c-acorn.c
@@ -81,6 +81,7 @@ static struct i2c_algo_bit_data ioc_data
 
 static struct i2c_adapter ioc_ops = {
 	.nr			= 0,
+	.name			= "ioc",
 	.algo_data		= &ioc_data,
 };
 


