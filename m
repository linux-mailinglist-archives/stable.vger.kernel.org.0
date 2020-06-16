Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D1C61FB6BD
	for <lists+stable@lfdr.de>; Tue, 16 Jun 2020 17:43:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730313AbgFPPj5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Jun 2020 11:39:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:53828 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730006AbgFPPjx (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Jun 2020 11:39:53 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8A75B20C56;
        Tue, 16 Jun 2020 15:39:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592321993;
        bh=6pBozKCjOHj7AkZeu8lezbDBJZhgI7O2YCTuNLUPR2U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pS7gnx1SWiactv0l67uABneufoaUHEhD7rr8p1eU5LHjYezg6OCS1LVQ8hrx8ixoC
         18EZChaaOzEKw41ftYMMfKty1iDYJvVzOGFmU+TutnsSBtvVSRjjGH7rVANsK+7t8x
         aDy8T7JMTbXa6YqfMYCE78mXi8xE8MvJ+gH7YMgY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.4 077/134] PM: runtime: clk: Fix clk_pm_runtime_get() error path
Date:   Tue, 16 Jun 2020 17:34:21 +0200
Message-Id: <20200616153104.461808830@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200616153100.633279950@linuxfoundation.org>
References: <20200616153100.633279950@linuxfoundation.org>
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
@@ -114,7 +114,11 @@ static int clk_pm_runtime_get(struct clk
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


