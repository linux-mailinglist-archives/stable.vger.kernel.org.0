Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3DF6383239
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 16:49:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240838AbhEQOqj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 10:46:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:55126 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240549AbhEQOnj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 10:43:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7688E61954;
        Mon, 17 May 2021 14:20:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621261231;
        bh=lOLb1U/LFndGyUS9pSV47msKFv/hC0kgXkafKNJFgBg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dh0bcN0ZIgLW9OD36RXWN3k29tIPSl8HM/FnMYaTGtYZURjeGd2n5vxdzegVjOOlT
         XGjBZX6H5+ykXf1ytQigs6QyS92jdKq79ljVxISSJ3D1P+0mo7Yxp7JyKs8UF2Rh+m
         WcVRJh2Tr0YPWDFmhkbbGEE6Wcdd+5zbfED43GNY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wolfram Sang <wsa@kernel.org>,
        =?UTF-8?q?Bence=20Cs=C3=B3k=C3=A1s?= <bence98@sch.bme.hu>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 022/141] i2c: Add I2C_AQ_NO_REP_START adapter quirk
Date:   Mon, 17 May 2021 16:01:14 +0200
Message-Id: <20210517140243.511875553@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140242.729269392@linuxfoundation.org>
References: <20210517140242.729269392@linuxfoundation.org>
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
index 1361637c369d..af2b799d7a66 100644
--- a/include/linux/i2c.h
+++ b/include/linux/i2c.h
@@ -677,6 +677,8 @@ struct i2c_adapter_quirks {
 #define I2C_AQ_NO_ZERO_LEN_READ		BIT(5)
 #define I2C_AQ_NO_ZERO_LEN_WRITE	BIT(6)
 #define I2C_AQ_NO_ZERO_LEN		(I2C_AQ_NO_ZERO_LEN_READ | I2C_AQ_NO_ZERO_LEN_WRITE)
+/* adapter cannot do repeated START */
+#define I2C_AQ_NO_REP_START		BIT(7)
 
 /*
  * i2c_adapter is the structure used to identify a physical i2c bus along
-- 
2.30.2



