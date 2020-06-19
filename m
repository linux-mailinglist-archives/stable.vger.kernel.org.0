Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A85A9200BC1
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 16:38:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387755AbgFSOhf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 10:37:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:54430 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387747AbgFSOhd (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 10:37:33 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8B6282070A;
        Fri, 19 Jun 2020 14:37:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592577453;
        bh=+Gcw09n/bPKMcv+/4kI3NujXaSsob+ZVOBmDqpwRikY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o5F8yzmWMKMvMWg2XT6SFHeGufrh+SFRhwCNeth9v8M67lK1YyBIWCOCAi8TVVahD
         qpK++jovGJVKj3ajuy2JV20LsnIinEKM/aqlWYm7rgjJz/xiMMHF5qq7EhQ6/YFlJO
         gYm/B4CxhOx0Chglh4ROWlsdsQ1G4KMuMovmORCs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        Sean Young <sean@mess.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 056/101] media: dvb: return -EREMOTEIO on i2c transfer failure.
Date:   Fri, 19 Jun 2020 16:32:45 +0200
Message-Id: <20200619141616.982604983@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141614.001544111@linuxfoundation.org>
References: <20200619141614.001544111@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

[ Upstream commit 96f3a9392799dd0f6472648a7366622ffd0989f3 ]

Currently when i2c transfers fail the error return -EREMOTEIO
is assigned to err but then later overwritten when the tuner
attach call is made.  Fix this by returning early with the
error return code -EREMOTEIO on i2c transfer failure errors.

If the transfer fails, an uninitialized value will be read from b2.

Addresses-Coverity: ("Unused value")

Fixes: fbfee8684ff2 ("V4L/DVB (5651): Dibusb-mb: convert pll handling to properly use dvb-pll")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: Sean Young <sean@mess.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/dvb-usb/dibusb-mb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/usb/dvb-usb/dibusb-mb.c b/drivers/media/usb/dvb-usb/dibusb-mb.c
index a4ac37e0e98b..d888e27dad3c 100644
--- a/drivers/media/usb/dvb-usb/dibusb-mb.c
+++ b/drivers/media/usb/dvb-usb/dibusb-mb.c
@@ -84,7 +84,7 @@ static int dibusb_tuner_probe_and_attach(struct dvb_usb_adapter *adap)
 
 	if (i2c_transfer(&adap->dev->i2c_adap, msg, 2) != 2) {
 		err("tuner i2c write failed.");
-		ret = -EREMOTEIO;
+		return -EREMOTEIO;
 	}
 
 	if (adap->fe_adap[0].fe->ops.i2c_gate_ctrl)
-- 
2.25.1



