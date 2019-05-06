Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 895AC14F60
	for <lists+stable@lfdr.de>; Mon,  6 May 2019 17:11:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726699AbfEFOel (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 May 2019 10:34:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:54432 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726714AbfEFOek (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 May 2019 10:34:40 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 67DE42087F;
        Mon,  6 May 2019 14:34:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557153279;
        bh=5Wpg1agI8//aA/QefpiJ/R9ESJljWz2kdcAj1ftvmkk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XO3bqW3dPWpWs8/+9/dNQ1YyebpT5pjyQFtQwgdIM3rBtl3CRxFPK66hnLo99LWVu
         dEeUt7Oy2pAwmAhFt4a2V+Ta9oYeT2Ou4HGT4hTp5sIe0QBSnTFAXTkMRMAbYalJJI
         FfPiLlmqDAiA9blP98KPG8DQhDUiqGqExr/C0GVs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "Sasha Levin (Microsoft)" <sashal@kernel.org>
Subject: [PATCH 5.0 030/122] rtc: sh: Fix invalid alarm warning for non-enabled alarm
Date:   Mon,  6 May 2019 16:31:28 +0200
Message-Id: <20190506143057.500954018@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190506143054.670334917@linuxfoundation.org>
References: <20190506143054.670334917@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 15d82d22498784966df8e4696174a16b02cc1052 ]

When no alarm has been programmed on RSK-RZA1, an error message is
printed during boot:

    rtc rtc0: invalid alarm value: 2019-03-14T255:255:255

sh_rtc_read_alarm_value() returns 0xff when querying a hardware alarm
field that is not enabled.  __rtc_read_alarm() validates the received
alarm values, and fills in missing fields when needed.
While 0xff is handled fine for the year, month, and day fields, and
corrected as considered being out-of-range, this is not the case for the
hour, minute, and second fields, where -1 is expected for missing
fields.

Fix this by returning -1 instead, as this value is handled fine for all
fields.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin (Microsoft) <sashal@kernel.org>
---
 drivers/rtc/rtc-sh.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/rtc/rtc-sh.c b/drivers/rtc/rtc-sh.c
index d417b203cbc5..1d3de2a3d1a4 100644
--- a/drivers/rtc/rtc-sh.c
+++ b/drivers/rtc/rtc-sh.c
@@ -374,7 +374,7 @@ static int sh_rtc_set_time(struct device *dev, struct rtc_time *tm)
 static inline int sh_rtc_read_alarm_value(struct sh_rtc *rtc, int reg_off)
 {
 	unsigned int byte;
-	int value = 0xff;	/* return 0xff for ignored values */
+	int value = -1;			/* return -1 for ignored values */
 
 	byte = readb(rtc->regbase + reg_off);
 	if (byte & AR_ENB) {
-- 
2.20.1



