Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07DF61C78BB
	for <lists+stable@lfdr.de>; Wed,  6 May 2020 19:54:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728718AbgEFRyg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 May 2020 13:54:36 -0400
Received: from mail.baikalelectronics.com ([87.245.175.226]:33130 "EHLO
        mail.baikalelectronics.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728803AbgEFRyg (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 May 2020 13:54:36 -0400
X-Greylist: delayed 602 seconds by postgrey-1.27 at vger.kernel.org; Wed, 06 May 2020 13:54:34 EDT
Received: from localhost (unknown [127.0.0.1])
        by mail.baikalelectronics.ru (Postfix) with ESMTP id D1D928000CF8;
        Wed,  6 May 2020 17:44:30 +0000 (UTC)
X-Virus-Scanned: amavisd-new at baikalelectronics.ru
Received: from mail.baikalelectronics.ru ([127.0.0.1])
        by localhost (mail.baikalelectronics.ru [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id dpFA3fEHy6Gk; Wed,  6 May 2020 20:44:29 +0300 (MSK)
From:   <Sergey.Semin@baikalelectronics.ru>
To:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Matthias Kaehlcke <mka@chromium.org>
CC:     Serge Semin <Sergey.Semin@baikalelectronics.ru>,
        Serge Semin <fancer.lancer@gmail.com>,
        Alexey Malahov <Alexey.Malahov@baikalelectronics.ru>,
        Paul Burton <paulburton@kernel.org>,
        Ralf Baechle <ralf@linux-mips.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Rob Herring <robh+dt@kernel.org>, <linux-mips@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <stable@vger.kernel.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Frederic Weisbecker <frederic@kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Yue Hu <huyue2@yulong.com>,
        <linux-pm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 20/20] cpufreq: Return zero on success in boost sw setting
Date:   Wed, 6 May 2020 20:42:38 +0300
Message-ID: <20200506174238.15385-21-Sergey.Semin@baikalelectronics.ru>
In-Reply-To: <20200506174238.15385-1-Sergey.Semin@baikalelectronics.ru>
References: <20200306124807.3596F80307C2@mail.baikalelectronics.ru>
 <20200506174238.15385-1-Sergey.Semin@baikalelectronics.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-ClientProxiedBy: MAIL.baikal.int (192.168.51.25) To mail (192.168.51.25)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Serge Semin <Sergey.Semin@baikalelectronics.ru>

Recent commit e61a41256edf ("cpufreq: dev_pm_qos_update_request() can
return 1 on success") fixed a problem when active policies traverse
was falsely stopped due to invalidly treating the non-zero return value
from freq_qos_update_request() method as an error. Yes, that function
can return positive values if the requested update actually took place.
The current problem is that the returned value is then passed to the
return cell of the cpufreq_boost_set_sw() (set_boost callback) method.
This value is then also analyzed for being non-zero, which is also
treated as having an error. As a result during the boost activation
we'll get an error returned while having the QOS frequency update
successfully performed. Fix this by returning a negative value from the
cpufreq_boost_set_sw() if actual error was encountered and zero
otherwise treating any positive values as the successful operations
completion.

Fixes: 18c49926c4bf ("cpufreq: Add QoS requests for userspace constraints")
Signed-off-by: Serge Semin <Sergey.Semin@baikalelectronics.ru>
Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Alexey Malahov <Alexey.Malahov@baikalelectronics.ru>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Paul Burton <paulburton@kernel.org>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Rob Herring <robh+dt@kernel.org>
Cc: linux-mips@vger.kernel.org
Cc: devicetree@vger.kernel.org
Cc: stable@vger.kernel.org
---
 drivers/cpufreq/cpufreq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 045f9fe157ce..5870cdca88cf 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -2554,7 +2554,7 @@ static int cpufreq_boost_set_sw(int state)
 			break;
 	}
 
-	return ret;
+	return ret < 0 ? ret : 0;
 }
 
 int cpufreq_boost_trigger_state(int state)
-- 
2.25.1

