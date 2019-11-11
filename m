Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D9AB1F7B94
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 19:38:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728886AbfKKShi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 13:37:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:56328 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728884AbfKKShi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 13:37:38 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 08638214E0;
        Mon, 11 Nov 2019 18:37:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573497456;
        bh=1mn7x2xDrNdCk3rqmR4q6TOQ7cme9ekfdvb759926OQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Nshhc10l+Jnja+Bwec/oiTxlacEBHGJ6/PwWAbzSk/0boW0AlGxiO/h1MJuGlhf12
         rVrzs06OvMYJ5Lfn3rf5Dl1K4mivIh2/CAm0aAT0QiAnIQJQO4HJdFz7LJZ3HcRz5O
         lfmtIrRrtP0eRp4UnVsBEu2JIHSKrKPsgARy5VGE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Zumeng Chen <zumeng.chen@gmail.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>
Subject: [PATCH 4.14 060/105] cpufreq: ti-cpufreq: add missing of_node_put()
Date:   Mon, 11 Nov 2019 19:28:30 +0100
Message-Id: <20191111181444.892881703@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191111181421.390326245@linuxfoundation.org>
References: <20191111181421.390326245@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zumeng Chen <zumeng.chen@gmail.com>

commit 248aefdcc3a7e0cfbd014946b4dead63e750e71b upstream

call of_node_put to release the refcount of np.

Signed-off-by: Zumeng Chen <zumeng.chen@gmail.com>
Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/cpufreq/ti-cpufreq.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/cpufreq/ti-cpufreq.c
+++ b/drivers/cpufreq/ti-cpufreq.c
@@ -205,6 +205,7 @@ static int ti_cpufreq_init(void)
 
 	np = of_find_node_by_path("/");
 	match = of_match_node(ti_cpufreq_of_match, np);
+	of_node_put(np);
 	if (!match)
 		return -ENODEV;
 


