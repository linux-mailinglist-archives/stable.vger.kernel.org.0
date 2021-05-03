Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3B8D3714D1
	for <lists+stable@lfdr.de>; Mon,  3 May 2021 14:02:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233851AbhECMBa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 May 2021 08:01:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:35490 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233765AbhECMA4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 May 2021 08:00:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7F49361283;
        Mon,  3 May 2021 12:00:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620043203;
        bh=GNDs1cHSIOpWJJ1zWV9tBpZIqgq0ZTeZZHmtFBVglxA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LZ++L6eXLTy/L2QXPxZxOVOk0VGH6FBK0Zyxy/uJxKpV3IXk6gxvuJCaIEvgSQBh3
         tGPEsH3vjU5IDEUYBwYZ70FCtweM6r2386d08BgL2ZhUDjOGLCGff4sN8RP6FWxUDQ
         3GGrg7plJsRTetmizdo5HPNHS7SOKvrhNURM+XOM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Phillip Potter <phil@philpotter.co.uk>,
        Jacek Anaszewski <jacek.anaszewski@gmail.com>,
        stable <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 09/69] leds: lp5523: check return value of lp5xx_read and jump to cleanup code
Date:   Mon,  3 May 2021 13:56:36 +0200
Message-Id: <20210503115736.2104747-10-gregkh@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210503115736.2104747-1-gregkh@linuxfoundation.org>
References: <20210503115736.2104747-1-gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Phillip Potter <phil@philpotter.co.uk>

Check return value of lp5xx_read and if non-zero, jump to code at end of
the function, causing lp5523_stop_all_engines to be executed before
returning the error value up the call chain. This fixes the original
commit (248b57015f35) which was reverted due to the University of Minnesota
problems.

Cc: Jacek Anaszewski <jacek.anaszewski@gmail.com>
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Phillip Potter <phil@philpotter.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/leds/leds-lp5523.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/leds/leds-lp5523.c b/drivers/leds/leds-lp5523.c
index 5036d7d5f3d4..b1590cb4a188 100644
--- a/drivers/leds/leds-lp5523.c
+++ b/drivers/leds/leds-lp5523.c
@@ -305,7 +305,9 @@ static int lp5523_init_program_engine(struct lp55xx_chip *chip)
 
 	/* Let the programs run for couple of ms and check the engine status */
 	usleep_range(3000, 6000);
-	lp55xx_read(chip, LP5523_REG_STATUS, &status);
+	ret = lp55xx_read(chip, LP5523_REG_STATUS, &status);
+	if (ret)
+		goto out;
 	status &= LP5523_ENG_STATUS_MASK;
 
 	if (status != LP5523_ENG_STATUS_MASK) {
-- 
2.31.1

