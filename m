Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F705C91D5
	for <lists+stable@lfdr.de>; Wed,  2 Oct 2019 21:15:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730007AbfJBTLp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Oct 2019 15:11:45 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:35582 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729194AbfJBTIM (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Oct 2019 15:08:12 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1iFjyr-00035r-Cv; Wed, 02 Oct 2019 20:08:09 +0100
Received: from ben by deadeye with local (Exim 4.92.1)
        (envelope-from <ben@decadent.org.uk>)
        id 1iFjyo-0003dn-Gr; Wed, 02 Oct 2019 20:08:06 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Joakim Zhang" <qiangqing.zhang@nxp.com>,
        "Dong Aisheng" <aisheng.dong@nxp.com>,
        "Marc Kleine-Budde" <mkl@pengutronix.de>
Date:   Wed, 02 Oct 2019 20:06:51 +0100
Message-ID: <lsq.1570043211.365040761@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 49/87] can: flexcan: fix timeout when set small bitrate
In-Reply-To: <lsq.1570043210.379046399@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.75-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Joakim Zhang <qiangqing.zhang@nxp.com>

commit 247e5356a709eb49a0d95ff2a7f07dac05c8252c upstream.

Current we can meet timeout issue when setting a small bitrate like
10000 as follows on i.MX6UL EVK board (ipg clock = 66MHZ, per clock =
30MHZ):

| root@imx6ul7d:~# ip link set can0 up type can bitrate 10000

A link change request failed with some changes committed already.
Interface can0 may have been left with an inconsistent configuration,
please check.

| RTNETLINK answers: Connection timed out

It is caused by calling of flexcan_chip_unfreeze() timeout.

Originally the code is using usleep_range(10, 20) for unfreeze
operation, but the patch (8badd65 can: flexcan: avoid calling
usleep_range from interrupt context) changed it into udelay(10) which is
only a half delay of before, there're also some other delay changes.

After double to FLEXCAN_TIMEOUT_US to 100 can fix the issue.

Meanwhile, Rasmus Villemoes reported that even with a timeout of 100,
flexcan_probe() fails on the MPC8309, which requires a value of at least
140 to work reliably. 250 works for everyone.

Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
Reviewed-by: Dong Aisheng <aisheng.dong@nxp.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
[bwh: Backported to 3.16: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/can/flexcan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/can/flexcan.c
+++ b/drivers/net/can/flexcan.c
@@ -157,7 +157,7 @@
 
 #define FLEXCAN_MB_CODE_MASK		(0xf0ffffff)
 
-#define FLEXCAN_TIMEOUT_US             (50)
+#define FLEXCAN_TIMEOUT_US		(250)
 
 /*
  * FLEXCAN hardware feature flags

