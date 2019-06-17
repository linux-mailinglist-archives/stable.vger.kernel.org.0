Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 162AD49455
	for <lists+stable@lfdr.de>; Mon, 17 Jun 2019 23:38:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728849AbfFQVTm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jun 2019 17:19:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:43464 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728872AbfFQVTi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Jun 2019 17:19:38 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6623520B1F;
        Mon, 17 Jun 2019 21:19:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560806377;
        bh=zUIkRL2+2N6TejLuqB/35gmEd3f/CWpfpIxNm+H4+/s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wuvjMgRTc9kZACIdBe+2iQDjEGNNGL0Fuz57h3q4bCPt/3n7YZRnBYWyNrwxGK8Kr
         22bxiAaOeiWrg5gj6kErcruxQjstpk4uA58EMPgtPi2W8rK/YTFmFNcdpltjuArTmC
         6WznH9GYCZujOh/FI0WEjtWJ4DJn7qrKkcCDFIEU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Russell King <rmk+kernel@armlinux.org.uk>,
        Wolfram Sang <wsa@the-dreams.de>, stable@kernel.org
Subject: [PATCH 5.1 030/115] i2c: acorn: fix i2c warning
Date:   Mon, 17 Jun 2019 23:08:50 +0200
Message-Id: <20190617210801.522416261@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190617210759.929316339@linuxfoundation.org>
References: <20190617210759.929316339@linuxfoundation.org>
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
 


