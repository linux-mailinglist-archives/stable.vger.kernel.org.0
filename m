Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 91DA188E36
	for <lists+stable@lfdr.de>; Sat, 10 Aug 2019 22:53:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727003AbfHJUwl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Aug 2019 16:52:41 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54090 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726560AbfHJUnv (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Aug 2019 16:43:51 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hwYDM-00053P-EX; Sat, 10 Aug 2019 21:43:48 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hwYDJ-0003aj-Ll; Sat, 10 Aug 2019 21:43:45 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Bartosz Golaszewski" <bgolaszewski@baylibre.com>,
        "Axel Lin" <axel.lin@ingics.com>,
        "Thierry Reding" <thierry.reding@gmail.com>
Date:   Sat, 10 Aug 2019 21:40:07 +0100
Message-ID: <lsq.1565469607.228247538@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 041/157] gpio: adnp: Fix testing wrong value in
 adnp_gpio_direction_input
In-Reply-To: <lsq.1565469607.188083258@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.72-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Axel Lin <axel.lin@ingics.com>

commit c5bc6e526d3f217ed2cc3681d256dc4a2af4cc2b upstream.

Current code test wrong value so it does not verify if the written
data is correctly read back. Fix it.
Also make it return -EPERM if read value does not match written bit,
just like it done for adnp_gpio_direction_output().

Fixes: 5e969a401a01 ("gpio: Add Avionic Design N-bit GPIO expander support")
Signed-off-by: Axel Lin <axel.lin@ingics.com>
Reviewed-by: Thierry Reding <thierry.reding@gmail.com>
Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/gpio/gpio-adnp.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/gpio/gpio-adnp.c
+++ b/drivers/gpio/gpio-adnp.c
@@ -140,8 +140,10 @@ static int adnp_gpio_direction_input(str
 	if (err < 0)
 		goto out;
 
-	if (err & BIT(pos))
-		err = -EACCES;
+	if (value & BIT(pos)) {
+		err = -EPERM;
+		goto out;
+	}
 
 	err = 0;
 

