Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70A0C3833DD
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 17:04:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241616AbhEQPDC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 11:03:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:60754 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241452AbhEQPBB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 11:01:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 544B561355;
        Mon, 17 May 2021 14:27:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621261620;
        bh=IMJ8hZyHaeaxYIxJ3ChM/Z56gbfXgXe0IxNM/jf0ZWY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=immJ258L2PCvALpX/1S0Dn3b9MckEbOa7KYLgkt4COY4IjHDAz0dbeF3jiga8b98m
         IzTcJ063oSI4ouc57Lk6XWwWizvGFdox8TH2hyTKxZ43SMRfXCCyzzZVeV8+ZOPBJq
         YcGBj8z6gepB2sTS3VKwADY06Zo0A1JPHdYQnnZU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wolfram Sang <wsa@kernel.org>,
        =?UTF-8?q?Bence=20Cs=C3=B3k=C3=A1s?= <bence98@sch.bme.hu>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 041/289] i2c: Add I2C_AQ_NO_REP_START adapter quirk
Date:   Mon, 17 May 2021 15:59:26 +0200
Message-Id: <20210517140306.584198139@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140305.140529752@linuxfoundation.org>
References: <20210517140305.140529752@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bence Csókás <bence98@sch.bme.hu>

[ Upstream commit aca01415e076aa96cca0f801f4420ee5c10c660d ]

This quirk signifies that the adapter cannot do a repeated
START, it always issues a STOP condition after transfers.

Suggested-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Bence Csókás <bence98@sch.bme.hu>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/i2c.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/linux/i2c.h b/include/linux/i2c.h
index 56622658b215..a670ae129f4b 100644
--- a/include/linux/i2c.h
+++ b/include/linux/i2c.h
@@ -687,6 +687,8 @@ struct i2c_adapter_quirks {
 #define I2C_AQ_NO_ZERO_LEN_READ		BIT(5)
 #define I2C_AQ_NO_ZERO_LEN_WRITE	BIT(6)
 #define I2C_AQ_NO_ZERO_LEN		(I2C_AQ_NO_ZERO_LEN_READ | I2C_AQ_NO_ZERO_LEN_WRITE)
+/* adapter cannot do repeated START */
+#define I2C_AQ_NO_REP_START		BIT(7)
 
 /*
  * i2c_adapter is the structure used to identify a physical i2c bus along
-- 
2.30.2



