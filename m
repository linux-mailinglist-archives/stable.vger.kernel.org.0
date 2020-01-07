Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 394A01331EB
	for <lists+stable@lfdr.de>; Tue,  7 Jan 2020 22:05:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728908AbgAGVF2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jan 2020 16:05:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:51926 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728882AbgAGVF0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jan 2020 16:05:26 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EC1C820678;
        Tue,  7 Jan 2020 21:05:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578431126;
        bh=ilUlpS6b8CkWE6NVzT1vSP9pLE58/XUubI2KGW9kMUM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rTF6sHj7dR2zzzes3ccX39clXzb7kcL7juWxLWWkSkjFdEsRZ6hoKxCdUPNHWk0d3
         2LxWJlFZCuYNGLnDNnEoW65RUfA9yt5inGR5LilFtaDeUYTS8eUMd0UsdcjPHQqFAH
         xPKXwNDOw5i7UjyWTpyg3haDQhN83LlgRhKl+ArQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Leonard Crestez <leonard.crestez@nxp.com>,
        Matthias Kaehlcke <mka@chromium.org>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 008/115] PM / devfreq: Set scaling_max_freq to max on OPP notifier error
Date:   Tue,  7 Jan 2020 21:53:38 +0100
Message-Id: <20200107205245.059589063@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200107205240.283674026@linuxfoundation.org>
References: <20200107205240.283674026@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Leonard Crestez <leonard.crestez@nxp.com>

[ Upstream commit e7cc792d00049c874010b398a27c3cc7bc8fef34 ]

The devfreq_notifier_call functions will update scaling_min_freq and
scaling_max_freq when the OPP table is updated.

If fetching the maximum frequency fails then scaling_max_freq remains
set to zero which is confusing. Set to ULONG_MAX instead so we don't
need special handling for this case in other places.

Signed-off-by: Leonard Crestez <leonard.crestez@nxp.com>
Reviewed-by: Matthias Kaehlcke <mka@chromium.org>
Reviewed-by: Chanwoo Choi <cw00.choi@samsung.com>
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/devfreq/devfreq.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/devfreq/devfreq.c b/drivers/devfreq/devfreq.c
index 34e297f28fc2..a47e76a62287 100644
--- a/drivers/devfreq/devfreq.c
+++ b/drivers/devfreq/devfreq.c
@@ -547,8 +547,10 @@ static int devfreq_notifier_call(struct notifier_block *nb, unsigned long type,
 		goto out;
 
 	devfreq->scaling_max_freq = find_available_max_freq(devfreq);
-	if (!devfreq->scaling_max_freq)
+	if (!devfreq->scaling_max_freq) {
+		devfreq->scaling_max_freq = ULONG_MAX;
 		goto out;
+	}
 
 	err = update_devfreq(devfreq);
 
-- 
2.20.1



