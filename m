Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B88F222F3E2
	for <lists+stable@lfdr.de>; Mon, 27 Jul 2020 17:32:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729044AbgG0Pc2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jul 2020 11:32:28 -0400
Received: from mailout10.rmx.de ([94.199.88.75]:34180 "EHLO mailout10.rmx.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728965AbgG0Pc2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Jul 2020 11:32:28 -0400
X-Greylist: delayed 1955 seconds by postgrey-1.27 at vger.kernel.org; Mon, 27 Jul 2020 11:32:27 EDT
Received: from kdin01.retarus.com (kdin01.dmz1.retloc [172.19.17.48])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mailout10.rmx.de (Postfix) with ESMTPS id 4BFjdd30Rvz36nt;
        Mon, 27 Jul 2020 16:59:49 +0200 (CEST)
Received: from mta.arri.de (unknown [217.111.95.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by kdin01.retarus.com (Postfix) with ESMTPS id 4BFjd050Rmz2xFT;
        Mon, 27 Jul 2020 16:59:16 +0200 (CEST)
Received: from N95HX1G2.wgnetz.xx (192.168.54.121) by mta.arri.de
 (192.168.100.104) with Microsoft SMTP Server (TLS) id 14.3.408.0; Mon, 27 Jul
 2020 16:59:16 +0200
From:   Christian Eggers <ceggers@arri.de>
To:     Jonathan Cameron <jic23@kernel.org>
CC:     Christian Eggers <ceggers@arri.de>, <stable@vger.kernel.org>,
        "Hartmut Knaack" <knaack.h@gmx.de>,
        Lars-Peter Clausen <lars@metafoo.de>,
        "Peter Meerwald-Stadler" <pmeerw@pmeerw.net>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>,
        <linux-iio@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/2] iio: trigger: hrtimer: Disable irqs before calling iio_trigger_poll()
Date:   Mon, 27 Jul 2020 16:58:59 +0200
Message-ID: <20200727145900.4563-1-ceggers@arri.de>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [192.168.54.121]
X-RMX-ID: 20200727-165916-4BFjd050Rmz2xFT-0@kdin01
X-RMX-SOURCE: 217.111.95.66
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

iio_trigger_poll() calls generic_handle_irq(). This function expects to
be run with local IRQs disabled.

Signed-off-by: Christian Eggers <ceggers@arri.de>
Cc: stable@vger.kernel.org
---
 drivers/iio/trigger/iio-trig-hrtimer.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/iio/trigger/iio-trig-hrtimer.c b/drivers/iio/trigger/iio-trig-hrtimer.c
index f59bf8d58586..2fe8a5c1484e 100644
--- a/drivers/iio/trigger/iio-trig-hrtimer.c
+++ b/drivers/iio/trigger/iio-trig-hrtimer.c
@@ -89,7 +89,9 @@ static enum hrtimer_restart iio_hrtimer_trig_handler(struct hrtimer *timer)
 	info = container_of(timer, struct iio_hrtimer_info, timer);
 
 	hrtimer_forward_now(timer, info->period);
+	local_irq_disable();
 	iio_trigger_poll(info->swt.trigger);
+	local_irq_enable();
 
 	return HRTIMER_RESTART;
 }
-- 
Christian Eggers
Embedded software developer

Arnold & Richter Cine Technik GmbH & Co. Betriebs KG
Sitz: Muenchen - Registergericht: Amtsgericht Muenchen - Handelsregisternummer: HRA 57918
Persoenlich haftender Gesellschafter: Arnold & Richter Cine Technik GmbH
Sitz: Muenchen - Registergericht: Amtsgericht Muenchen - Handelsregisternummer: HRB 54477
Geschaeftsfuehrer: Dr. Michael Neuhaeuser; Stephan Schenk; Walter Trauninger; Markus Zeiler

