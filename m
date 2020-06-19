Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CFD52015AC
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 18:31:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389921AbgFSOzE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 10:55:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:49796 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389920AbgFSOzC (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 10:55:02 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A0F1421556;
        Fri, 19 Jun 2020 14:55:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592578502;
        bh=5dr3/E5uEsN9OBtHtX5x2lJSF9gcAv4pYuxes95uq4A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=biYEthR+hklg1dM8BdMcMcntZCQAoC5xDOlCvEzjYxE6HigIiEc1f+fz0zRqP26ig
         quTFWf4IdYUbev5gIKe9Zm8jBEQ72RoqfzFCfX8wRyGCFxFvPCYGaBdoAP+fmlBOls
         viOT08jgRSJqwLFIg7WC9yfeNLu/DVR9v4xbhuQ8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 4.19 046/267] PM: runtime: clk: Fix clk_pm_runtime_get() error path
Date:   Fri, 19 Jun 2020 16:30:31 +0200
Message-Id: <20200619141651.105716983@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141648.840376470@linuxfoundation.org>
References: <20200619141648.840376470@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

commit 64c7d7ea22d86cacb65d0c097cc447bc0e6d8abd upstream.

clk_pm_runtime_get() assumes that the PM-runtime usage counter will
be dropped by pm_runtime_get_sync() on errors, which is not the case,
so PM-runtime references to devices acquired by the former are leaked
on errors returned by the latter.

Fix this by modifying clk_pm_runtime_get() to drop the reference if
pm_runtime_get_sync() returns an error.

Fixes: 9a34b45397e5 clk: Add support for runtime PM
Cc: 4.15+ <stable@vger.kernel.org> # 4.15+
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reviewed-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/clk/clk.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -101,7 +101,11 @@ static int clk_pm_runtime_get(struct clk
 		return 0;
 
 	ret = pm_runtime_get_sync(core->dev);
-	return ret < 0 ? ret : 0;
+	if (ret < 0) {
+		pm_runtime_put_noidle(core->dev);
+		return ret;
+	}
+	return 0;
 }
 
 static void clk_pm_runtime_put(struct clk_core *core)


