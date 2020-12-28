Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7510F2E406E
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:53:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2501998AbgL1OSl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:18:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:53122 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2501990AbgL1OSl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:18:41 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 49CCC2242A;
        Mon, 28 Dec 2020 14:18:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165099;
        bh=tNgvctoeVXR7xM+pBVnx4ek8DlN/hObfI0BKU4+kJ/s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qpCuGqHN3qnwfDQSSfrCK0UJqVRh5MKbiv20GN0XThreT+o7cggORFdVqWxqfp8Pv
         YQAhLzAmDEqdNcZ55zTURsqUOAJ03sZr38jl0Rc8NUGP4Rfrgwxrrw4IdHRadjg4ML
         uFrqYzUrikfyWirX55g6dXVJJoeflE4pf8BovIIs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Simon Glass <sjg@chromium.org>,
        Gwendal Grignou <gwendal@chromium.org>,
        Douglas Anderson <dianders@chromium.org>,
        Enric Balletbo i Serra <enric.balletbo@collabora.com>,
        Alexandru M Stan <amstan@chromium.org>,
        Stephen Boyd <swboyd@chromium.org>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 381/717] platform/chrome: cros_ec_spi: Dont overwrite spi::mode
Date:   Mon, 28 Dec 2020 13:46:19 +0100
Message-Id: <20201228125039.255302733@linuxfoundation.org>
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

From: Stephen Boyd <swboyd@chromium.org>

[ Upstream commit 74639cbf51d7c0304342544a83dfda354a6bd208 ]

There isn't any need to overwrite the mode here in the driver with what
has been detected by the firmware, such as DT or ACPI. In fact, if we
use the SPI CS gpio descriptor feature we will overwrite the mode with
SPI_MODE_0 where it already contains SPI_MODE_0 and more importantly
SPI_CS_HIGH. Clearing the SPI_CS_HIGH bit causes the CS line to toggle
when the device is probed when it shouldn't change, confusing the driver
and making it fail to probe. Drop the assignment and let the spi core
take care of it.

Fixes: a17d94f0b6e1 ("mfd: Add ChromeOS EC SPI driver")
Cc: Simon Glass <sjg@chromium.org>
Cc: Gwendal Grignou <gwendal@chromium.org>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Tested-by: Douglas Anderson <dianders@chromium.org>
Acked-by: Enric Balletbo i Serra <enric.balletbo@collabora.com>
Cc: Alexandru M Stan <amstan@chromium.org>
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
Reviewed-by: Simon Glass <sjg@chromium.org>
Link: https://lore.kernel.org/r/20201204193540.3047030-2-swboyd@chromium.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/chrome/cros_ec_spi.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/platform/chrome/cros_ec_spi.c b/drivers/platform/chrome/cros_ec_spi.c
index dfa1f816a45f4..f9df218fc2bbe 100644
--- a/drivers/platform/chrome/cros_ec_spi.c
+++ b/drivers/platform/chrome/cros_ec_spi.c
@@ -742,7 +742,6 @@ static int cros_ec_spi_probe(struct spi_device *spi)
 	int err;
 
 	spi->bits_per_word = 8;
-	spi->mode = SPI_MODE_0;
 	spi->rt = true;
 	err = spi_setup(spi);
 	if (err < 0)
-- 
2.27.0



