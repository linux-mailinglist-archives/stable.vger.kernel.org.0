Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 173AA2345C
	for <lists+stable@lfdr.de>; Mon, 20 May 2019 14:42:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388818AbfETM0J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 May 2019 08:26:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:41476 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389240AbfETM0I (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 May 2019 08:26:08 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E5FAA20815;
        Mon, 20 May 2019 12:26:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558355167;
        bh=HJ83EpvGaSB8dlnWS/5e9hEeIskXwATrWvNOid9MVsE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rLt19VKkI0Q9VcU7YnbLEqJfXvwU9ECZOxdTPOy1YdI3HmaYxafl8hzFWgA02TxdR
         diboy6OUbZiXQuBBBZu/dyGWtcBo7AdyTdtRGSWwa5YiTfXVL1r2+GjplEyZLeofdd
         m6Cu6co+6kl3ZWIlPz5glH0AtxvE8+UNeg5d5vPI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Robin Murphy <robin.murphy@arm.com>,
        Katsuhiro Suzuki <katsuhiro@katsuster.net>,
        Heiko Stuebner <heiko@sntech.de>
Subject: [PATCH 5.0 005/123] arm64: dts: rockchip: fix IO domain voltage setting of APIO5 on rockpro64
Date:   Mon, 20 May 2019 14:13:05 +0200
Message-Id: <20190520115245.677274811@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190520115245.439864225@linuxfoundation.org>
References: <20190520115245.439864225@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Katsuhiro Suzuki <katsuhiro@katsuster.net>

commit 798689e45190756c2eca6656ee4c624370a5012a upstream.

This patch fixes IO domain voltage setting that is related to
audio_gpio3d4a_ms (bit 1) of GRF_IO_VSEL.

This is because RockPro64 schematics P.16 says that regulator
supplies 3.0V power to APIO5_VDD. So audio_gpio3d4a_ms bit should
be clear (means 3.0V). Power domain map is saying different thing
(supplies 1.8V) but I believe P.16 is actual connectings.

Fixes: e4f3fb490967 ("arm64: dts: rockchip: add initial dts support for Rockpro64")
Cc: stable@vger.kernel.org
Suggested-by: Robin Murphy <robin.murphy@arm.com>
Signed-off-by: Katsuhiro Suzuki <katsuhiro@katsuster.net>
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm64/boot/dts/rockchip/rk3399-rockpro64.dts |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/boot/dts/rockchip/rk3399-rockpro64.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3399-rockpro64.dts
@@ -489,7 +489,7 @@
 	status = "okay";
 
 	bt656-supply = <&vcc1v8_dvp>;
-	audio-supply = <&vcca1v8_codec>;
+	audio-supply = <&vcc_3v0>;
 	sdmmc-supply = <&vcc_sdio>;
 	gpio1830-supply = <&vcc_3v0>;
 };


