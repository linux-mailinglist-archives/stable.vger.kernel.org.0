Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 620611DB6C8
	for <lists+stable@lfdr.de>; Wed, 20 May 2020 16:27:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727050AbgETO1Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 May 2020 10:27:25 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:32944 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726966AbgETOW1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 May 2020 10:22:27 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jbPbv-00035n-Su; Wed, 20 May 2020 15:22:19 +0100
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1jbPbv-007DRX-Em; Wed, 20 May 2020 15:22:19 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Sebastian Reichel" <sebastian.reichel@collabora.com>,
        "Dan Carpenter" <dan.carpenter@oracle.com>
Date:   Wed, 20 May 2020 15:14:14 +0100
Message-ID: <lsq.1589984008.883412615@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 46/99] power: supply: sbs-battery: Fix a signedness
 bug in sbs_get_battery_capacity()
In-Reply-To: <lsq.1589984008.673931885@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.84-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@oracle.com>

commit eb368de6de32925c65a97c1e929a31cae2155aee upstream.

The "mode" variable is an enum and in this context GCC treats it as an
unsigned int so the error handling is never triggered.

Fixes: 51d075660457 ("bq20z75: Add support for charge properties")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
[bwh: Backported to 3.16: adjust filename, context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/power/sbs-battery.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/power/sbs-battery.c
+++ b/drivers/power/sbs-battery.c
@@ -400,7 +400,7 @@ static int sbs_get_battery_capacity(stru
 		mode = BATTERY_MODE_AMPS;
 
 	mode = sbs_set_battery_mode(client, mode);
-	if (mode < 0)
+	if ((int)mode < 0)
 		return mode;
 
 	ret = sbs_read_word_data(client, sbs_data[reg_offset].addr);

