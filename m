Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EFA623A60D
	for <lists+stable@lfdr.de>; Mon,  3 Aug 2020 14:44:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728847AbgHCMoL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Aug 2020 08:44:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:54604 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728737AbgHCM20 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Aug 2020 08:28:26 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CE6E9207DF;
        Mon,  3 Aug 2020 12:28:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596457705;
        bh=8dsC/cTUUWFMRDDnC5VWZkXw703a+7EhD/xyNN/90Ww=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BH7PDv+AnkxRaQrxojDCMNI47PdvEyBmclEMkG674W3jo9uiBwZhLs1e+NFTdoptV
         /M2V5rk1HPD4zoABJ/ikHHApnIkLrmIsOW+QshEMkBcHdXAH71hzeq031geKKhgQiX
         V/epuJiAl0Vb51ZCeYYPN2b0nXlj7oye+hO4Db60=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paul Cercueil <paul@crapouillou.net>,
        Sam Ravnborg <sam@ravnborg.org>,
        =?UTF-8?q?Noralf=20Tr=C3=B8nnes?= <noralf@tronnes.org>
Subject: [PATCH 5.4 27/90] drm/dbi: Fix SPI Type 1 (9-bit) transfer
Date:   Mon,  3 Aug 2020 14:18:49 +0200
Message-Id: <20200803121858.938327468@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200803121857.546052424@linuxfoundation.org>
References: <20200803121857.546052424@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paul Cercueil <paul@crapouillou.net>

commit 900ab59e2621053b009f707f80b2c19ce0af5dee upstream.

The function mipi_dbi_spi1_transfer() will transfer its payload as 9-bit
data, the 9th (MSB) bit being the data/command bit. In order to do that,
it unpacks the 8-bit values into 16-bit values, then sets the 9th bit if
the byte corresponds to data, clears it otherwise. The 7 MSB are
padding. The array of now 16-bit values is then passed to the SPI core
for transfer.

This function was broken since its introduction, as the length of the
SPI transfer was set to the payload size before its conversion, but the
payload doubled in size due to the 8-bit -> 16-bit conversion.

Fixes: 02dd95fe3169 ("drm/tinydrm: Add MIPI DBI support")
Cc: <stable@vger.kernel.org> # 5.4+
Signed-off-by: Paul Cercueil <paul@crapouillou.net>
Reviewed-by: Sam Ravnborg <sam@ravnborg.org>
Reviewed-by: Noralf Trønnes <noralf@tronnes.org>
Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20200703141341.1266263-1-paul@crapouillou.net
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/drm_mipi_dbi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/drm_mipi_dbi.c
+++ b/drivers/gpu/drm/drm_mipi_dbi.c
@@ -937,7 +937,7 @@ static int mipi_dbi_spi1_transfer(struct
 			}
 		}
 
-		tr.len = chunk;
+		tr.len = chunk * 2;
 		len -= chunk;
 
 		ret = spi_sync(spi, &m);


