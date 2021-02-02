Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE96F30BFF9
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 14:48:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232538AbhBBNrK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 08:47:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:36548 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232860AbhBBNpa (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Feb 2021 08:45:30 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 39DE964F84;
        Tue,  2 Feb 2021 13:41:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612273274;
        bh=287o8lMaMnF2uQOEMzuc3rIck8XODejiSOvh+ikc0kw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Naoh2068/jNm95aA1a6KYN0Vap20f6clWVYS8o6cs99IVi3qNiY0dONuuVCQYG7F2
         oiz2mQJkSXVshTK7eKHa7+mNExye3JRwBJxvcbHT3p5hVIm1q3wpbjxntrtkyNnB/Z
         4aVg7sNzE/RA1Hf5qh1rBVpFTqpik8IR+wIlg7Rs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Matthias Reichl <hias@horus.com>,
        Sean Young <sean@mess.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 5.10 014/142] media: rc: ite-cir: fix min_timeout calculation
Date:   Tue,  2 Feb 2021 14:36:17 +0100
Message-Id: <20210202132958.293070012@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210202132957.692094111@linuxfoundation.org>
References: <20210202132957.692094111@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Matthias Reichl <hias@horus.com>

commit e1def45b5291278590bc3033cc518bf5c964a18d upstream.

Commit 528222d853f92 ("media: rc: harmonize infrared durations to
microseconds") missed to switch the min_timeout calculation from ns
to us. This resulted in a minimum timeout of 1.2 seconds instead of 1.2ms,
leading to large delays and long key repeats.

Fix this by applying proper ns->us conversion.

Cc: stable@vger.kernel.org
Fixes: 528222d853f92 ("media: rc: harmonize infrared durations to microseconds")
Signed-off-by: Matthias Reichl <hias@horus.com>
Signed-off-by: Sean Young <sean@mess.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/rc/ite-cir.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/media/rc/ite-cir.c
+++ b/drivers/media/rc/ite-cir.c
@@ -1551,7 +1551,7 @@ static int ite_probe(struct pnp_dev *pde
 	rdev->s_rx_carrier_range = ite_set_rx_carrier_range;
 	/* FIFO threshold is 17 bytes, so 17 * 8 samples minimum */
 	rdev->min_timeout = 17 * 8 * ITE_BAUDRATE_DIVISOR *
-			    itdev->params.sample_period;
+			    itdev->params.sample_period / 1000;
 	rdev->timeout = IR_DEFAULT_TIMEOUT;
 	rdev->max_timeout = 10 * IR_DEFAULT_TIMEOUT;
 	rdev->rx_resolution = ITE_BAUDRATE_DIVISOR *


