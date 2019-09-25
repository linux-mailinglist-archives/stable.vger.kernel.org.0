Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 05AB2BE61A
	for <lists+stable@lfdr.de>; Wed, 25 Sep 2019 22:08:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390227AbfIYUHG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 Sep 2019 16:07:06 -0400
Received: from pbmsgap02.intersil.com ([192.157.179.202]:52140 "EHLO
        pbmsgap02.intersil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727743AbfIYUHG (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 25 Sep 2019 16:07:06 -0400
X-Greylist: delayed 1144 seconds by postgrey-1.27 at vger.kernel.org; Wed, 25 Sep 2019 16:07:04 EDT
Received: from pps.filterd (pbmsgap02.intersil.com [127.0.0.1])
        by pbmsgap02.intersil.com (8.16.0.27/8.16.0.27) with SMTP id x8PJXPCI005373;
        Wed, 25 Sep 2019 15:43:54 -0400
Received: from pbmxdp03.intersil.corp (pbmxdp03.pb.intersil.com [132.158.200.224])
        by pbmsgap02.intersil.com with ESMTP id 2v60v8ae1j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 25 Sep 2019 15:43:54 -0400
Received: from pbmxdp02.intersil.corp (132.158.200.223) by
 pbmxdp03.intersil.corp (132.158.200.224) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.1531.3; Wed, 25 Sep 2019 15:43:52 -0400
Received: from localhost.localdomain (132.158.202.109) by
 pbmxdp02.intersil.corp (132.158.200.223) with Microsoft SMTP Server id
 15.1.1531.3 via Frontend Transport; Wed, 25 Sep 2019 15:43:52 -0400
From:   Chris Brandt <chris.brandt@renesas.com>
To:     Wolfram Sang <wsa@the-dreams.de>
CC:     <stable@vger.kernel.org>, <linux-i2c@vger.kernel.org>,
        <linux-renesas-soc@vger.kernel.org>,
        Chris Brandt <chris.brandt@renesas.com>,
        Chien Nguyen <chien.nguyen.eb@rvc.renesas.com>
Subject: [PATCH] i2c: riic: Clear NACK in tend isr
Date:   Wed, 25 Sep 2019 14:43:27 -0500
Message-ID: <20190925194327.28109-1-chris.brandt@renesas.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-09-25_09:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=junk_notspam policy=junk score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=589
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1909250161
X-Proofpoint-Spam-Reason: mlx
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The NACKF flag should be cleared in INTRIICNAKI interrupt processing as
description in HW manual.

This issue shows up quickly when PREEMPT_RT is applied and a device is
probed that is not plugged in (like a touchscreen controller). The result
is endless interrupts that halt system boot.

Fixes: 310c18a41450 ("i2c: riic: add driver")
Reported-by: Chien Nguyen <chien.nguyen.eb@rvc.renesas.com>
Signed-off-by: Chris Brandt <chris.brandt@renesas.com>
---
 drivers/i2c/busses/i2c-riic.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/i2c/busses/i2c-riic.c b/drivers/i2c/busses/i2c-riic.c
index f31413fd9521..800414886f6b 100644
--- a/drivers/i2c/busses/i2c-riic.c
+++ b/drivers/i2c/busses/i2c-riic.c
@@ -202,6 +202,7 @@ static irqreturn_t riic_tend_isr(int irq, void *data)
 	if (readb(riic->base + RIIC_ICSR2) & ICSR2_NACKF) {
 		/* We got a NACKIE */
 		readb(riic->base + RIIC_ICDRR);	/* dummy read */
+		riic_clear_set_bit(riic, ICSR2_NACKF, 0, RIIC_ICSR2);
 		riic->err = -ENXIO;
 	} else if (riic->bytes_left) {
 		return IRQ_NONE;
-- 
2.23.0

