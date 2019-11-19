Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B1B01016B6
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 06:56:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728536AbfKSFw7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:52:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:50782 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731212AbfKSFw5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:52:57 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0720A21823;
        Tue, 19 Nov 2019 05:52:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574142776;
        bh=FgAEuwJeq6bU+l6jFE4Y9bLsRENUulQAqRtrvdYS76E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZOOI//ilXn0o+73ApwJUtcVt7KHaKh/GMTDOAU+t9qki9lc8nosX9qr7t9qpU2FyB
         QGWYn7zfOICDnfSkWw7w+Lk4mkijSy+v9CKg8vc4irzBfJPbRnTT5kNgsgpOOynFn3
         8XW430wbSLz4Hemf41CIdaMJufc/cJRcoDcVEtHE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Laura Abbott <labbott@redhat.com>,
        Daniel Thompson <daniel.thompson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 196/239] misc: kgdbts: Fix restrict error
Date:   Tue, 19 Nov 2019 06:19:56 +0100
Message-Id: <20191119051336.043866445@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119051255.850204959@linuxfoundation.org>
References: <20191119051255.850204959@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Laura Abbott <labbott@redhat.com>

[ Upstream commit fa0218ef733e6f247a1a3986e3eb12460064ac77 ]

kgdbts current fails when compiled with restrict:

drivers/misc/kgdbts.c: In function ‘configure_kgdbts’:
drivers/misc/kgdbts.c:1070:2: error: ‘strcpy’ source argument is the same as destination [-Werror=restrict]
  strcpy(config, opt);
  ^~~~~~~~~~~~~~~~~~~

As the error says, config is being used in both the source and destination.
Refactor the code to avoid the extra copy and put the parsing closer to
the actual location.

Signed-off-by: Laura Abbott <labbott@redhat.com>
Acked-by: Daniel Thompson <daniel.thompson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/kgdbts.c | 16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff --git a/drivers/misc/kgdbts.c b/drivers/misc/kgdbts.c
index 94cbc5c98cae6..05824ff6b9168 100644
--- a/drivers/misc/kgdbts.c
+++ b/drivers/misc/kgdbts.c
@@ -981,6 +981,12 @@ static void kgdbts_run_tests(void)
 	int nmi_sleep = 0;
 	int i;
 
+	verbose = 0;
+	if (strstr(config, "V1"))
+		verbose = 1;
+	if (strstr(config, "V2"))
+		verbose = 2;
+
 	ptr = strchr(config, 'F');
 	if (ptr)
 		fork_test = simple_strtol(ptr + 1, NULL, 10);
@@ -1064,13 +1070,6 @@ static int kgdbts_option_setup(char *opt)
 		return -ENOSPC;
 	}
 	strcpy(config, opt);
-
-	verbose = 0;
-	if (strstr(config, "V1"))
-		verbose = 1;
-	if (strstr(config, "V2"))
-		verbose = 2;
-
 	return 0;
 }
 
@@ -1082,9 +1081,6 @@ static int configure_kgdbts(void)
 
 	if (!strlen(config) || isspace(config[0]))
 		goto noconfig;
-	err = kgdbts_option_setup(config);
-	if (err)
-		goto noconfig;
 
 	final_ack = 0;
 	run_plant_and_detach_test(1);
-- 
2.20.1



