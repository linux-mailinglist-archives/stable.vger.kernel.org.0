Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4A15478949
	for <lists+stable@lfdr.de>; Fri, 17 Dec 2021 11:57:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235031AbhLQK5C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Dec 2021 05:57:02 -0500
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:58648 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S234947AbhLQK5A (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Dec 2021 05:57:00 -0500
Received: from pps.filterd (m0046660.ppops.net [127.0.0.1])
        by mx07-00178001.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 1BH9C3kw016917;
        Fri, 17 Dec 2021 11:56:53 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foss.st.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=selector1;
 bh=B02eMFoVQi5VwJjmK0VwVKGAzWlqSsY6ez4ElcXOvq8=;
 b=ZjjGLI9W/NwygMpZw+iQLyK3DKfmCaBhq+cy73fD7bw2lpy76vuy/3gaUtsGdHaOBPHQ
 +MHy0TzGMRZ1PsPfC52M24CZyFwVYY8Uk96RYWgdmnWdP4f7x2p3dbP5o8RaRRu8yVJo
 kVfMXH2NXYwLTBDsJ/fOuLmE0ecRFgdYC9z/2ovXxxHpI3GvqPJ+Ly7AWxVlDsgv5BtJ
 JIq+vFRK9+lsL0l9kGueCVXje5WSqMQIVeJUIy+LkQDkHd45Ge7FWSckPs+MghWHI8Qe
 V53NjjVanv+wklD9p2kgocXJasiTAp/jdEDfmidhhOp/htmIWuA3HSUrU9+ZGv0KYCQM 0A== 
Received: from beta.dmz-eu.st.com (beta.dmz-eu.st.com [164.129.1.35])
        by mx07-00178001.pphosted.com (PPS) with ESMTPS id 3d0hd82nqv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 17 Dec 2021 11:56:53 +0100
Received: from euls16034.sgp.st.com (euls16034.sgp.st.com [10.75.44.20])
        by beta.dmz-eu.st.com (STMicroelectronics) with ESMTP id E233610002A;
        Fri, 17 Dec 2021 11:56:51 +0100 (CET)
Received: from Webmail-eu.st.com (sfhdag2node2.st.com [10.75.127.5])
        by euls16034.sgp.st.com (STMicroelectronics) with ESMTP id D72EC2354AF;
        Fri, 17 Dec 2021 11:56:51 +0100 (CET)
Received: from localhost (10.75.127.50) by SFHDAG2NODE2.st.com (10.75.127.5)
 with Microsoft SMTP Server (TLS) id 15.0.1497.26; Fri, 17 Dec 2021 11:56:51
 +0100
From:   Fabrice Gasnier <fabrice.gasnier@foss.st.com>
To:     <stable@vger.kernel.org>
CC:     <sashal@kernel.org>, <gregkh@linuxfoundation.org>
Subject: [PATCH 5.4] iio: adc: stm32: fix a current leak by resetting pcsel before disabling vdda
Date:   Fri, 17 Dec 2021 11:56:32 +0100
Message-ID: <1639738592-28572-1-git-send-email-fabrice.gasnier@foss.st.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.75.127.50]
X-ClientProxiedBy: SFHDAG2NODE1.st.com (10.75.127.4) To SFHDAG2NODE2.st.com
 (10.75.127.5)
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-17_04,2021-12-16_01,2021-12-02_01
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit f711f28e71e965c0d1141c830fa7131b41abbe75 upstream.

Some I/Os are connected to ADC input channels, when the corresponding bit
in PCSEL register are set on STM32H7 and STM32MP15. This is done in the
prepare routine of stm32-adc driver.
There are constraints here, as PCSEL shouldn't be set when VDDA supply
is disabled. Enabling/disabling of VDDA supply in done via stm32-adc-core
runtime PM routines (before/after ADC is enabled/disabled).

Currently, PCSEL remains set when disabling ADC. Later on, PM runtime
can disable the VDDA supply. This creates some conditions on I/Os that
can start to leak current.
So PCSEL needs to be cleared when disabling the ADC.

Fixes: 95e339b6e85d ("iio: adc: stm32: add support for STM32H7")
Signed-off-by: Fabrice Gasnier <fabrice.gasnier@foss.st.com>
Reviewed-by: Olivier Moysan <olivier.moysan@foss.st.com>
Link: https://lore.kernel.org/r/1634905169-23762-1-git-send-email-fabrice.gasnier@foss.st.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
Backport for 5.4-stable
---
 drivers/iio/adc/stm32-adc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/iio/adc/stm32-adc.c b/drivers/iio/adc/stm32-adc.c
index 94fde39..d1bbd2b 100644
--- a/drivers/iio/adc/stm32-adc.c
+++ b/drivers/iio/adc/stm32-adc.c
@@ -933,6 +933,7 @@ static int stm32h7_adc_prepare(struct stm32_adc *adc)
 
 static void stm32h7_adc_unprepare(struct stm32_adc *adc)
 {
+	stm32_adc_writel(adc, STM32H7_ADC_PCSEL, 0);
 	stm32h7_adc_disable(adc);
 	stm32h7_adc_enter_pwr_down(adc);
 }
-- 
2.7.4

