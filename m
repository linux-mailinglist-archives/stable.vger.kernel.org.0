Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D978B4513AB
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 20:53:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348600AbhKOTyS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 14:54:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:44598 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343790AbhKOTWD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:22:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CD7D063394;
        Mon, 15 Nov 2021 18:46:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637001988;
        bh=NwVAEw8pXSnNnlI6Ody0seAk24M1eBgAHYUa5YFC+Pg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YPnU7ONBAhYeB88ktqUVHFL5v0lajMrLnWITcFJ6obla/Drb3MzjzZcUvgzGJZPjk
         +5GuPoDNO9d6RuMpY2NW0Z2m6koiQo68TXcOt3QsbSw+iXqtZmmvteWxio7K7Ghu/N
         2VMI8o9Hs9pJnxdsrN8tM504QQgktEL3H/t8M7Rk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        Sean Young <sean@mess.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 379/917] media: cxd2880-spi: Fix a null pointer dereference on error handling path
Date:   Mon, 15 Nov 2021 17:57:54 +0100
Message-Id: <20211115165441.617631115@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
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
index b91a1e845b972..506f52c1af101 100644
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



