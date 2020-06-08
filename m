Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97A501F27FE
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 01:55:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730294AbgFHXZq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 19:25:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:52506 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731519AbgFHXZo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jun 2020 19:25:44 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0AA7220801;
        Mon,  8 Jun 2020 23:25:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591658743;
        bh=Q1MnH9RZEWmo/MLTr/txxuhrn1OC1QQbfLP0JeFzoCs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K9UrIuhOEqFRmywn8q9fpAxEWVe3BivcI1a27OMgfeVwgefb3/fI3zM2IqKlCzXmS
         yToHalQn3lw6WOPweILyYJW8pKaX+2BVflmiNgYFbIg/HN8S5T+UI/1IHMSeDWicwZ
         wI+gj1lZBihPP6BxLY+iarc6qnFnv3fREtD8G5Vg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Colin Ian King <colin.king@canonical.com>,
        Sean Young <sean@mess.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 30/72] media: dvb: return -EREMOTEIO on i2c transfer failure.
Date:   Mon,  8 Jun 2020 19:24:18 -0400
Message-Id: <20200608232500.3369581-30-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608232500.3369581-1-sashal@kernel.org>
References: <20200608232500.3369581-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index a0057641cc86..c55180912c3a 100644
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

