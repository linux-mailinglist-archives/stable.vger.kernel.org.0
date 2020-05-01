Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 982C31C1669
	for <lists+stable@lfdr.de>; Fri,  1 May 2020 16:08:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728847AbgEANsJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 May 2020 09:48:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:43440 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729169AbgEANml (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 1 May 2020 09:42:41 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BC6B2208DB;
        Fri,  1 May 2020 13:42:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588340561;
        bh=I4wRL5poyl2fmkwPf1N4wKbUFGDbAZST9yu47/9xtN0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HiMPLvNSatZzDunN2V39jKaJ9LPX/u1EG9Iq/q9YtVHAbDm83iGsLQzCBBNj3yQCe
         f7lEci4/dBBBh5s0usxLRlXnf+3hZgPQCAxzjsTR+wqKmMqB4iyZuNaZtB2tL5uWql
         kpFvteZVwyaHbDyXT4m5RM2n9x/QaQHCYiC5zm0I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Holger=20Hoffst=C3=A4tte?= 
        <holger@applied-asynchrony.com>, Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 5.6 032/106] hwmon: (drivetemp) Return -ENODATA for invalid temperatures
Date:   Fri,  1 May 2020 15:23:05 +0200
Message-Id: <20200501131547.822255949@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200501131543.421333643@linuxfoundation.org>
References: <20200501131543.421333643@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guenter Roeck <linux@roeck-us.net>

commit ed08ebb7124e90a99420bb913d602907d377d03d upstream.

Holger Hoffstätte observed that Samsung 850 Pro may return invalid
temperatures for a short period of time after resume. Return -ENODATA
to userspace if this is observed.

Fixes:  5b46903d8bf3 ("hwmon: Driver for disk and solid state drives with temperature sensors")
Reported-by: Holger Hoffstätte <holger@applied-asynchrony.com>
Cc: Holger Hoffstätte <holger@applied-asynchrony.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hwmon/drivetemp.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/hwmon/drivetemp.c
+++ b/drivers/hwmon/drivetemp.c
@@ -264,12 +264,18 @@ static int drivetemp_get_scttemp(struct
 		return err;
 	switch (attr) {
 	case hwmon_temp_input:
+		if (!temp_is_valid(buf[SCT_STATUS_TEMP]))
+			return -ENODATA;
 		*val = temp_from_sct(buf[SCT_STATUS_TEMP]);
 		break;
 	case hwmon_temp_lowest:
+		if (!temp_is_valid(buf[SCT_STATUS_TEMP_LOWEST]))
+			return -ENODATA;
 		*val = temp_from_sct(buf[SCT_STATUS_TEMP_LOWEST]);
 		break;
 	case hwmon_temp_highest:
+		if (!temp_is_valid(buf[SCT_STATUS_TEMP_HIGHEST]))
+			return -ENODATA;
 		*val = temp_from_sct(buf[SCT_STATUS_TEMP_HIGHEST]);
 		break;
 	default:


