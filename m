Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA2753A0287
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 21:21:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235632AbhFHTGi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 15:06:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:44564 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236740AbhFHTDU (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 15:03:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 605A26186A;
        Tue,  8 Jun 2021 18:45:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623177925;
        bh=SiAnxwCzqUrojtkSFW7yYJ/Igf6dSNxXRc2jFffHSRo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H+xZM9SKtDXZsDVVvOsRTCSYni+PTWB2/Yd0Yjhan2qvZq2TDnZPRmgRMxBNaNW6a
         E3RKm4doN+Szkeq4VFMZInyEmLk4CJ6miwXlc7W13nhb7nFn4NJBQvq35tyCMPfyoh
         NYByeF0R3PoFkSIguDVZHFreSamkLv/WSgW3nEKg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Grant Peltier <grantpeltier93@gmail.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 005/161] hwmon: (pmbus/isl68137) remove READ_TEMPERATURE_3 for RAA228228
Date:   Tue,  8 Jun 2021 20:25:35 +0200
Message-Id: <20210608175945.656492449@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210608175945.476074951@linuxfoundation.org>
References: <20210608175945.476074951@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Grant Peltier <grantpeltier93@gmail.com>

[ Upstream commit 2a29db088c7ae7121801a0d7a60740ed2d18c4f3 ]

The initial version of the RAA228228 datasheet claimed that the device
supported READ_TEMPERATURE_3 but not READ_TEMPERATURE_1. It has since been
discovered that the datasheet was incorrect. The RAA228228 does support
READ_TEMPERATURE_1 but does not support READ_TEMPERATURE_3.

Signed-off-by: Grant Peltier <grantpeltier93@gmail.com>
Fixes: 51fb91ed5a6f ("hwmon: (pmbus/isl68137) remove READ_TEMPERATURE_1 telemetry for RAA228228")
Link: https://lore.kernel.org/r/20210514211954.GA24646@raspberrypi
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/pmbus/isl68137.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/hwmon/pmbus/isl68137.c b/drivers/hwmon/pmbus/isl68137.c
index 2bee930d3900..789242ed72e5 100644
--- a/drivers/hwmon/pmbus/isl68137.c
+++ b/drivers/hwmon/pmbus/isl68137.c
@@ -244,8 +244,8 @@ static int isl68137_probe(struct i2c_client *client)
 		info->read_word_data = raa_dmpvr2_read_word_data;
 		break;
 	case raa_dmpvr2_2rail_nontc:
-		info->func[0] &= ~PMBUS_HAVE_TEMP;
-		info->func[1] &= ~PMBUS_HAVE_TEMP;
+		info->func[0] &= ~PMBUS_HAVE_TEMP3;
+		info->func[1] &= ~PMBUS_HAVE_TEMP3;
 		fallthrough;
 	case raa_dmpvr2_2rail:
 		info->pages = 2;
-- 
2.30.2



