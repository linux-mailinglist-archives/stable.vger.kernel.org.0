Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65CE86B8794
	for <lists+stable@lfdr.de>; Tue, 14 Mar 2023 02:28:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229769AbjCNB14 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Mar 2023 21:27:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229516AbjCNB14 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Mar 2023 21:27:56 -0400
Received: from mo-csw.securemx.jp (mo-csw1115.securemx.jp [210.130.202.157])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84A7874DE3;
        Mon, 13 Mar 2023 18:27:53 -0700 (PDT)
Received: by mo-csw.securemx.jp (mx-mo-csw1115) id 32E1RcOP022424; Tue, 14 Mar 2023 10:27:39 +0900
X-Iguazu-Qid: 2wHHyxo6xdj2qNxgHZ
X-Iguazu-QSIG: v=2; s=0; t=1678757258; q=2wHHyxo6xdj2qNxgHZ; m=jUFMGdD6i8+Pcq2xlmGPGyF2McvGdZj+Mi001AENZK4=
Received: from imx2-a.toshiba.co.jp (imx2-a.toshiba.co.jp [106.186.93.35])
        by relay.securemx.jp (mx-mr1111) id 32E1Rash005412
        (version=TLSv1.2 cipher=AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 14 Mar 2023 10:27:37 +0900
From:   Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
To:     Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Samu Onkalo <samu.p.onkalo@nokia.com>
Cc:     linux-kernel@vger.kernel.org,
        Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>,
        stable@vger.kernel.org
Subject: [PATCH] misc: apds990x: Remove unnecessary return code in apds990x_power_state_show()
Date:   Tue, 14 Mar 2023 10:27:32 +0900
X-TSB-HOP2: ON
Message-Id: <20230314012732.2267077-1-nobuhiro1.iwamatsu@toshiba.co.jp>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

In apds990x_power_state_show(), the return value of sprintf is returned, so
'return 0' is unnecessary. This remove 'return 0'.

Fixes: 92b1f84d46b2 ("drivers/misc: driver for APDS990X ALS and proximity sensors")
Cc: stable@vger.kernel.org
Signed-off-by: Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
---
 drivers/misc/apds990x.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/misc/apds990x.c b/drivers/misc/apds990x.c
index 0024503ea6db..6de6dc3c122f 100644
--- a/drivers/misc/apds990x.c
+++ b/drivers/misc/apds990x.c
@@ -984,7 +984,6 @@ static ssize_t apds990x_power_state_show(struct device *dev,
 				   struct device_attribute *attr, char *buf)
 {
 	return sprintf(buf, "%d\n", !pm_runtime_suspended(dev));
-	return 0;
 }
 
 static ssize_t apds990x_power_state_store(struct device *dev,
-- 
2.39.2


