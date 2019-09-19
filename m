Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B6500B7DD6
	for <lists+stable@lfdr.de>; Thu, 19 Sep 2019 17:11:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388771AbfISPLp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Sep 2019 11:11:45 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:42670 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388084AbfISPLp (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 Sep 2019 11:11:45 -0400
Received: by mail-io1-f65.google.com with SMTP id n197so8495478iod.9;
        Thu, 19 Sep 2019 08:11:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=G1RgniGBhHx+ePsQxRnB8cqCywBk5uIA9l0Oj05OQJ8=;
        b=lluivDNTjH/IK8vsfViEiPYr0Do1I8vpk22HCMZYTG+ILPHBGU/1bjqSnlsio3o37p
         Ffgn/qq/9VwzZpCrEg1P03b2tFPYaipfRcfhiFSITFaEZ+PlQJMUsPeAXBMS28HxWRhc
         M3/1S0G6S39YYXZ5hOy5jxg5wfjGZQja/lkJlLMO+f6UZ8YZ3c6a/Vl9KYdWes3EIz0/
         CCCypwbbE7qjzKS3woIujH9Orz2G35LUbA7mNeOL5iOld4X39RBhn6VRKzJR8k+BnmtW
         vDZFVr1uSEVqB6hMFYZ6fTZi1lCTigZQU4tp4WZOCzChM0S7xDJu0eZDW2P0zPnkydIn
         E9Nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=G1RgniGBhHx+ePsQxRnB8cqCywBk5uIA9l0Oj05OQJ8=;
        b=KJXTc2mAv2b8kIs2+8ZKIOStWt1JJNPnsl95QROqgqWsCn3GGCDFYkLDBBd2vD3g76
         1ocDzKTxnG+TxyI+XVCcigQyceEBDygtMvfEK/J9ZniG0DgSy2cX3xU/CqjZbnNMsplx
         YRvQl0PZTYoNoUkvEAVY7Is46L/kfthcCQFwsV9HlcGA2JRdH+Bn7ReKf61kAzpzIIng
         5oc4dA5Jwd2297cUij7AaWN+iV52d0D3QJ7adTWDTMB4/gjEZlw3+14pqySYHn4wcwSq
         PuQ2w/mC5MsoVPKIf844l9kuoOARq53C+VEjdmI3yO087pmfHxS2Gu5CpoHHWCNPGrOa
         rIwA==
X-Gm-Message-State: APjAAAWoX8CygWF7ZAPfN4NybTf5g0lb77iZk+YXAvrRiiUFanpvkyCF
        N05J5DnBs6viXj0A+LQ7Vc8=
X-Google-Smtp-Source: APXvYqxMvRcKAwAN7dmHT4oVWvVN4P2GjI72CaFiSuSJlG+cansVsMxmMIebqpx4x4MHyTmjALktFQ==
X-Received: by 2002:a6b:fa07:: with SMTP id p7mr12316093ioh.164.1568905904288;
        Thu, 19 Sep 2019 08:11:44 -0700 (PDT)
Received: from svens-asus.arcx.com ([184.94.50.30])
        by smtp.gmail.com with ESMTPSA id e15sm6422625ioe.33.2019.09.19.08.11.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Sep 2019 08:11:43 -0700 (PDT)
From:   Sven Van Asbroeck <thesven73@gmail.com>
X-Google-Original-From: Sven Van Asbroeck <TheSven73@gmail.com>
To:     Sebastian Reichel <sre@kernel.org>
Cc:     linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable <stable@vger.kernel.org>
Subject: [PATCH v1] power: supply: ltc2941-battery-gauge: fix use-after-free
Date:   Thu, 19 Sep 2019 11:11:37 -0400
Message-Id: <20190919151137.9960-1-TheSven73@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This driver's remove path calls cancel_delayed_work().
However, that function does not wait until the work function
finishes. This could mean that the work function is still
running after the driver's remove function has finished,
which would result in a use-after-free.

Fix by calling cancel_delayed_work_sync(), which ensures that
that the work is properly cancelled, no longer running, and
unable to re-schedule itself.

This issue was detected with the help of Coccinelle.

Cc: stable <stable@vger.kernel.org>
Signed-off-by: Sven Van Asbroeck <TheSven73@gmail.com>
---
 drivers/power/supply/ltc2941-battery-gauge.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/power/supply/ltc2941-battery-gauge.c b/drivers/power/supply/ltc2941-battery-gauge.c
index da49436176cd..30a9014b2f95 100644
--- a/drivers/power/supply/ltc2941-battery-gauge.c
+++ b/drivers/power/supply/ltc2941-battery-gauge.c
@@ -449,7 +449,7 @@ static int ltc294x_i2c_remove(struct i2c_client *client)
 {
 	struct ltc294x_info *info = i2c_get_clientdata(client);
 
-	cancel_delayed_work(&info->work);
+	cancel_delayed_work_sync(&info->work);
 	power_supply_unregister(info->supply);
 	return 0;
 }
-- 
2.17.1

