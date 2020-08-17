Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B932246A93
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 17:38:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730616AbgHQPin (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 11:38:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:46794 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730274AbgHQPik (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:38:40 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A8C5622C9F;
        Mon, 17 Aug 2020 15:38:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597678719;
        bh=tUg0ufDbgldg0Nz5MOqtxis8bznVshMzTik0MI4PymY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MQUTkzeuXF2qanupwFryL1p9+CE2fNNDQTPWdjEd/U6aunqBaAUPDdKmE/vhkHznB
         lbyqu79UPvyvfO1BT1xy6uYMlJelTzRpfBQpG+C+wZyNIoTi2CNbyjJ97vFprYXzrr
         1BxlL1ilujEbpQzjeaEtGz3cP1ja6PL0SVC68huo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Andrew Lunn <andrew@lunn.ch>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 5.8 431/464] cpufreq: dt: fix oops on armada37xx
Date:   Mon, 17 Aug 2020 17:16:24 +0200
Message-Id: <20200817143854.426668767@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143833.737102804@linuxfoundation.org>
References: <20200817143833.737102804@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ivan Kokshaysky <ink@jurassic.park.msu.ru>

commit 10470dec3decaf5ed3c596f85debd7c42777ae12 upstream.

Commit 0c868627e617e43a295d8 (cpufreq: dt: Allow platform specific
intermediate callbacks) added two function pointers to the
struct cpufreq_dt_platform_data. However, armada37xx_cpufreq_driver_init()
has this struct (pdata) located on the stack and uses only "suspend"
and "resume" fields. So these newly added "get_intermediate" and
"target_intermediate" pointers are uninitialized and contain arbitrary
non-null values, causing all kinds of trouble.

For instance, here is an oops on espressobin after an attempt to change
the cpefreq governor:

[   29.174554] Unable to handle kernel execute from non-executable memory at virtual address ffff00003f87bdc0
...
[   29.269373] pc : 0xffff00003f87bdc0
[   29.272957] lr : __cpufreq_driver_target+0x138/0x580
...

Fixed by zeroing out pdata before use.

Cc: <stable@vger.kernel.org> # v5.7+
Signed-off-by: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/cpufreq/armada-37xx-cpufreq.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/cpufreq/armada-37xx-cpufreq.c
+++ b/drivers/cpufreq/armada-37xx-cpufreq.c
@@ -456,6 +456,7 @@ static int __init armada37xx_cpufreq_dri
 	/* Now that everything is setup, enable the DVFS at hardware level */
 	armada37xx_cpufreq_enable_dvfs(nb_pm_base);
 
+	memset(&pdata, 0, sizeof(pdata));
 	pdata.suspend = armada37xx_cpufreq_suspend;
 	pdata.resume = armada37xx_cpufreq_resume;
 


