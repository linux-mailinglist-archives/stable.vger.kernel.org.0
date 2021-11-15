Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02EB9450B90
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 18:22:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237482AbhKORZl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 12:25:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:50936 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237786AbhKORYD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 12:24:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E6A2761BF9;
        Mon, 15 Nov 2021 17:16:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636996592;
        bh=SQUIl27+J9GshuXiioMTfQ3qYx8UPi7VAJfE5Hkkalg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a7+X1O7Fw7cOvLqERQXz7LhUboy7TST6tPjXozYV0rmHSboSIw36E8SW2nD5n125c
         MqSA5NI7VdY5EcixotTe9s2r3bg5CSobGDct0TMJ0CAQeUIh2IcxMG83brXVbaHo/Y
         Edxr18rbDpB2Wauqydm1WDv7CD0QRYWclqZGcC3E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        Sean Young <sean@mess.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 196/355] media: cxd2880-spi: Fix a null pointer dereference on error handling path
Date:   Mon, 15 Nov 2021 18:02:00 +0100
Message-Id: <20211115165320.106007222@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165313.549179499@linuxfoundation.org>
References: <20211115165313.549179499@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

[ Upstream commit 11b982e950d2138e90bd120501df10a439006ff8 ]

Currently the null pointer check on dvb_spi->vcc_supply is inverted and
this leads to only null values of the dvb_spi->vcc_supply being passed
to the call of regulator_disable causing null pointer dereferences.
Fix this by only calling regulator_disable if dvb_spi->vcc_supply is
not null.

Addresses-Coverity: ("Dereference after null check")

Fixes: dcb014582101 ("media: cxd2880-spi: Fix an error handling path")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: Sean Young <sean@mess.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/spi/cxd2880-spi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/spi/cxd2880-spi.c b/drivers/media/spi/cxd2880-spi.c
index 93194f03764d2..11273be702b6e 100644
--- a/drivers/media/spi/cxd2880-spi.c
+++ b/drivers/media/spi/cxd2880-spi.c
@@ -618,7 +618,7 @@ fail_frontend:
 fail_attach:
 	dvb_unregister_adapter(&dvb_spi->adapter);
 fail_adapter:
-	if (!dvb_spi->vcc_supply)
+	if (dvb_spi->vcc_supply)
 		regulator_disable(dvb_spi->vcc_supply);
 fail_regulator:
 	kfree(dvb_spi);
-- 
2.33.0



