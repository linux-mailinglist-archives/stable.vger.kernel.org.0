Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25B6920106F
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 17:31:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404796AbgFSPa0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 11:30:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:34204 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404788AbgFSPaW (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:30:22 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2F4C820771;
        Fri, 19 Jun 2020 15:30:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592580621;
        bh=QN44B5NjpaGuNWBUkEo8AlBVX8FksItPDzsjMKTnT0k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D4fJThrZdc+kjJN364J93WPJgrJXlnqqKDTopOR66Z2TtusuHru6XVCTkQthEjTCO
         e/4JJ931TpSle6jQDw1qrdU+DzQZE9s2OkutfpjEzcXK+UxdQmg4z1rrktUo+sZlXl
         zSpI83G2Iw9kThbNo4IwrYzXtE2/y3nSh/TGY1u4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Wei Yongjun <weiyongjun1@huawei.com>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.7 320/376] gnss: sirf: fix error return code in sirf_probe()
Date:   Fri, 19 Jun 2020 16:33:58 +0200
Message-Id: <20200619141725.479947044@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141710.350494719@linuxfoundation.org>
References: <20200619141710.350494719@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wei Yongjun <weiyongjun1@huawei.com>

commit 43d7ce70ae43dd8523754b17f567417e0e75dbce upstream.

Fix to return a negative error code from the error handling
case instead of 0, as done elsewhere in this function.

This avoids a use-after-free in case the driver is later unbound.

Fixes: d2efbbd18b1e ("gnss: add driver for sirfstar-based receivers")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
[ johan: amend commit message; mention potential use-after-free ]
Cc: stable <stable@vger.kernel.org>	# 4.19
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gnss/sirf.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/gnss/sirf.c
+++ b/drivers/gnss/sirf.c
@@ -439,14 +439,18 @@ static int sirf_probe(struct serdev_devi
 
 	data->on_off = devm_gpiod_get_optional(dev, "sirf,onoff",
 			GPIOD_OUT_LOW);
-	if (IS_ERR(data->on_off))
+	if (IS_ERR(data->on_off)) {
+		ret = PTR_ERR(data->on_off);
 		goto err_put_device;
+	}
 
 	if (data->on_off) {
 		data->wakeup = devm_gpiod_get_optional(dev, "sirf,wakeup",
 				GPIOD_IN);
-		if (IS_ERR(data->wakeup))
+		if (IS_ERR(data->wakeup)) {
+			ret = PTR_ERR(data->wakeup);
 			goto err_put_device;
+		}
 
 		ret = regulator_enable(data->vcc);
 		if (ret)


