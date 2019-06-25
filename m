Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5CFDC54C9E
	for <lists+stable@lfdr.de>; Tue, 25 Jun 2019 12:45:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727053AbfFYKp1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jun 2019 06:45:27 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:59204 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726521AbfFYKp1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Jun 2019 06:45:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Sender:Content-Transfer-Encoding:
        Content-Type:MIME-Version:Message-Id:Date:Subject:Cc:To:From:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=sUS/Rj3HoIchY4p0FVb8gSZ1mGDuL0t8MHtwKYpLND8=; b=AxajUndzjjUXCSMPUV5JMzMlN
        2H+BpoB4+g5wRdeG9R3PEP0yRCVzGsihgSiyDfOeh/ZfX7Q0cRtoWGo9IKC2d0EuXL+j9AAsik/rQ
        j0VCuXVIt9Trl5nfKLFPB9R4vYuv8DZkboQ3dciDUXFBDqe9pHe9KcJJM2tQj3NIacBnBDeaNaLaW
        U5SH777lUw/QWlKAERYpXlOFZkt6jcRY+sAZHK47uhBnOqNETm8p05qcsHnd73fFgRPIcEqccE6W1
        5wCpD334d7OwdlM8NieXxoCbW0PsYqMkqSVAcf+yIItjd3z4rLWc9ReacrmxwvwmBtZRPXklaXMtK
        CeERhQA2Q==;
Received: from 177.205.71.220.dynamic.adsl.gvt.net.br ([177.205.71.220] helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1hfix5-00057S-9f; Tue, 25 Jun 2019 10:45:27 +0000
Received: from mchehab by bombadil.infradead.org with local (Exim 4.92)
        (envelope-from <mchehab@bombadil.infradead.org>)
        id 1hfix2-0006dZ-7X; Tue, 25 Jun 2019 07:45:24 -0300
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To:     Linux Media Mailing List <linux-media@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        =?UTF-8?q?Ari=20Kohtam=C3=A4ki?= <ari.kohtamaki@gmail.com>,
        stable@vger.kernel.org
Subject: [PATCH] media: stv0297: fix frequency range limit
Date:   Tue, 25 Jun 2019 07:45:20 -0300
Message-Id: <75d72b7851d00297d8bb37e0064d1a109bd0d483.1561459518.git.mchehab+samsung@kernel.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

There was a typo at the lower frequency limit for a DVB-C
card, causing the driver to fail while tuning channels at the
VHF range.

https://bugzilla.kernel.org/show_bug.cgi?id=202083

Fixes: f1b1eabff0eb ("media: dvb: represent min/max/step/tolerance freqs in Hz")
Reported-by: Ari Kohtamäki <ari.kohtamaki@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
---
 drivers/media/dvb-frontends/stv0297.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/dvb-frontends/stv0297.c b/drivers/media/dvb-frontends/stv0297.c
index dac396c95a59..6d5962d5697a 100644
--- a/drivers/media/dvb-frontends/stv0297.c
+++ b/drivers/media/dvb-frontends/stv0297.c
@@ -682,7 +682,7 @@ static const struct dvb_frontend_ops stv0297_ops = {
 	.delsys = { SYS_DVBC_ANNEX_A },
 	.info = {
 		 .name = "ST STV0297 DVB-C",
-		 .frequency_min_hz = 470 * MHz,
+		 .frequency_min_hz = 47 * MHz,
 		 .frequency_max_hz = 862 * MHz,
 		 .frequency_stepsize_hz = 62500,
 		 .symbol_rate_min = 870000,
-- 
2.21.0

