Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 738E21D848D
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 20:14:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729371AbgERSMM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 14:12:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:49528 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732695AbgERSDs (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 14:03:48 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A82DB20873;
        Mon, 18 May 2020 18:03:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589825028;
        bh=DAqFb2at6gzjG5aQG5qxZP41nD3lsCEFZqbFHAwqhUc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XayakXkVRD04H0TkwmXY9m9/WoSnZ6JCar3ti+DOzp6F9NWGLN3Gsydyyf3oEJSNZ
         sAKZegGox7ft+qY38knPQrVnQtbZXhl2QmP2E85QnZ/ffx1T6unkYu+yK8j9S/Ptwc
         /MGb7EJBUoHvqkC0wU+b0YT8DKbicJfDrjgw+1/E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.6 100/194] hwmon: (drivetemp) Fix SCT support if SCT data tables are not supported
Date:   Mon, 18 May 2020 19:36:30 +0200
Message-Id: <20200518173540.286482871@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173531.455604187@linuxfoundation.org>
References: <20200518173531.455604187@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guenter Roeck <linux@roeck-us.net>

[ Upstream commit bcb543cc3d4034da3f3fd8bc4296a26dfeadf47d ]

If SCT is supported but SCT data tables are not, the driver unnecessarily
tries to fall back to SMART. Use SCT without data tables instead in this
situation.

Fixes: 5b46903d8bf3 ("hwmon: Driver for disk and solid state drives with temperature sensors")
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/drivetemp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hwmon/drivetemp.c b/drivers/hwmon/drivetemp.c
index 9179460c2d9d5..0d4f3d97ffc61 100644
--- a/drivers/hwmon/drivetemp.c
+++ b/drivers/hwmon/drivetemp.c
@@ -346,7 +346,7 @@ static int drivetemp_identify_sata(struct drivetemp_data *st)
 	st->have_temp_highest = temp_is_valid(buf[SCT_STATUS_TEMP_HIGHEST]);
 
 	if (!have_sct_data_table)
-		goto skip_sct;
+		goto skip_sct_data;
 
 	/* Request and read temperature history table */
 	memset(buf, '\0', sizeof(st->smartdata));
-- 
2.20.1



