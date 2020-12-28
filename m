Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEFB22E426C
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:23:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436700AbgL1PWP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 10:22:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:35002 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391653AbgL1OBX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:01:23 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 646C120731;
        Mon, 28 Dec 2020 14:01:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164068;
        bh=GL+21FBX3yzsX00iEmSsGaFo8GODJAxDZ6ieMWTpDhE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2AKpAYImsGm1lzhQ2+pnKxCUCwjHkPkz4h+sl8mL8dTEKUZHI6+obo6S7ieAprwnU
         OpqdgSJ7+RKF+Kl1OESqztTcKtUY11p0GbzjajjPpPXvxVKpJ11AIKdP1f8+4JVFdE
         k96lhfSAY6bLuWTLoIpHrP5OttDEWKaB7xhVos4M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 017/717] rtc: pcf2127: fix pcf2127_nvmem_read/write() returns
Date:   Mon, 28 Dec 2020 13:40:15 +0100
Message-Id: <20201228125021.808913081@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit ba1c30bf3f2536f248d262c6f257b5a787305991 ]

These functions should return zero on success.  Non-zero returns are
treated as error.  On some paths, this doesn't matter but in
nvmem_cell_read() a non-zero return would be passed to ERR_PTR() and
lead to an Oops.

Fixes: d6c3029f32f7 ("rtc: pcf2127: add support for accessing internal static RAM")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Link: https://lore.kernel.org/r/20201022070451.GA2817669@mwanda
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-pcf2127.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/rtc/rtc-pcf2127.c b/drivers/rtc/rtc-pcf2127.c
index 07a5630ec841f..4d9711d51f8f3 100644
--- a/drivers/rtc/rtc-pcf2127.c
+++ b/drivers/rtc/rtc-pcf2127.c
@@ -243,10 +243,8 @@ static int pcf2127_nvmem_read(void *priv, unsigned int offset,
 	if (ret)
 		return ret;
 
-	ret = regmap_bulk_read(pcf2127->regmap, PCF2127_REG_RAM_RD_CMD,
-			       val, bytes);
-
-	return ret ?: bytes;
+	return regmap_bulk_read(pcf2127->regmap, PCF2127_REG_RAM_RD_CMD,
+				val, bytes);
 }
 
 static int pcf2127_nvmem_write(void *priv, unsigned int offset,
@@ -261,10 +259,8 @@ static int pcf2127_nvmem_write(void *priv, unsigned int offset,
 	if (ret)
 		return ret;
 
-	ret = regmap_bulk_write(pcf2127->regmap, PCF2127_REG_RAM_WRT_CMD,
-				val, bytes);
-
-	return ret ?: bytes;
+	return regmap_bulk_write(pcf2127->regmap, PCF2127_REG_RAM_WRT_CMD,
+				 val, bytes);
 }
 
 /* watchdog driver */
-- 
2.27.0



