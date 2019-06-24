Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD5F950861
	for <lists+stable@lfdr.de>; Mon, 24 Jun 2019 12:18:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730830AbfFXKQz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jun 2019 06:16:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:54492 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730824AbfFXKQz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Jun 2019 06:16:55 -0400
Received: from localhost (f4.8f.5177.ip4.static.sl-reverse.com [119.81.143.244])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8513F205C9;
        Mon, 24 Jun 2019 10:16:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561371414;
        bh=aRhkgb5S/u+8oZ/KpUkEYewDKFzT6/mr7blE20Y2cvg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VLi20MqGP2vdnDLpbiIcizM1J1YEiaB12qR64ewTKKS7rdg2W4OHYrkLyOAQ7bgW1
         6Rq9umkCvHLAtpqlfJlStGxo/LNdtna27sQFeVufdQBID+ObpvAN8FcHRgL608/8kj
         vftyVcFWH9wXxZDCdtFf+weJjkroeHRKcrK3VBz0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Joakim Zhang <qiangqing.zhang@nxp.com>,
        Dong Aisheng <aisheng.dong@nxp.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 5.1 094/121] can: flexcan: fix timeout when set small bitrate
Date:   Mon, 24 Jun 2019 17:57:06 +0800
Message-Id: <20190624092325.579672385@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190624092320.652599624@linuxfoundation.org>
References: <20190624092320.652599624@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
Cc: linux-stable <stable@vger.kernel.org>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/can/flexcan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/can/flexcan.c
+++ b/drivers/net/can/flexcan.c
@@ -166,7 +166,7 @@
 #define FLEXCAN_MB_CNT_LENGTH(x)	(((x) & 0xf) << 16)
 #define FLEXCAN_MB_CNT_TIMESTAMP(x)	((x) & 0xffff)
 
-#define FLEXCAN_TIMEOUT_US		(50)
+#define FLEXCAN_TIMEOUT_US		(250)
 
 /* FLEXCAN hardware feature flags
  *


