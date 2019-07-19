Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF1486E308
	for <lists+stable@lfdr.de>; Fri, 19 Jul 2019 11:01:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726029AbfGSJBn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jul 2019 05:01:43 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:57274 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725798AbfGSJBm (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Jul 2019 05:01:42 -0400
Received: from 61-220-137-37.hinet-ip.hinet.net ([61.220.137.37] helo=hwang4-Vostro-5390.taipei.internal)
        by youngberry.canonical.com with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
        (Exim 4.76)
        (envelope-from <hui.wang@canonical.com>)
        id 1hoOlo-0002ps-JB; Fri, 19 Jul 2019 09:01:41 +0000
From:   Hui Wang <hui.wang@canonical.com>
To:     linux-input@vger.kernel.org
Cc:     dmitry.torokhov@gmail.com, stable@vger.kernel.org
Subject: [PATCH] Input: alps - Fix a mismatch between a condition check and its comment
Date:   Fri, 19 Jul 2019 17:01:35 +0800
Message-Id: <20190719090135.17811-1-hui.wang@canonical.com>
X-Mailer: git-send-email 2.17.1
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

In the function alps_is_cs19_trackpoint(), we check if the param[1] is
in the 0x20~0x2f range, but the code we wrote for this checking is not
correct:
(param[1] & 0x20) does not mean param[1] is in the range of 0x20~0x2f,
it also means the param[1] is in the range of 0x30~0x3f, 0x60~0x6f...

Now fix it with a new condition checking ((param[1] & 0xf0) == 0x20).

Fixes: 7e4935ccc323 ("Input: alps - don't handle ALPS cs19 trackpoint-only device")
Cc: stable@vger.kernel.org
Signed-off-by: Hui Wang <hui.wang@canonical.com>
---
 drivers/input/mouse/alps.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/input/mouse/alps.c b/drivers/input/mouse/alps.c
index 62ffea00902a..34700eda0429 100644
--- a/drivers/input/mouse/alps.c
+++ b/drivers/input/mouse/alps.c
@@ -2876,7 +2876,7 @@ static bool alps_is_cs19_trackpoint(struct psmouse *psmouse)
 	 * trackpoint-only devices have their variant_ids equal
 	 * TP_VARIANT_ALPS and their firmware_ids are in 0x20~0x2f range.
 	 */
-	return param[0] == TP_VARIANT_ALPS && (param[1] & 0x20);
+	return param[0] == TP_VARIANT_ALPS && ((param[1] & 0xf0) == 0x20);
 }
 
 static int alps_identify(struct psmouse *psmouse, struct alps_data *priv)
-- 
2.17.1

