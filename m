Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14751304A68
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 21:44:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731376AbhAZFF2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Jan 2021 00:05:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:41854 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731395AbhAYSzv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Jan 2021 13:55:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6A6E0206E5;
        Mon, 25 Jan 2021 18:55:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611600911;
        bh=SQc3nBFL0NCJTc5IkCd0Cqx8M4i4sWedKovUs/8iX7Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J1yewgmE29hUBXBRjvrsd/ZrMl4ls2bURGxLsZnbhUaCYlqiJ/2d3j0Ka2ekB77se
         mbR4RDm7XUNsIJ+ei8O4Hq5NOCLytSay5ISuOG7GDNVytMKeVInj3fS6szj9SZE5gc
         zxQcF6LGm12LU+G7JkfWaeebBGsNk9ImeBm8p/no=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Martin Kepplinger <martin.kepplinger@puri.sm>,
        Georgi Djakov <georgi.djakov@linaro.org>
Subject: [PATCH 5.10 199/199] interconnect: imx8mq: Use icc_sync_state
Date:   Mon, 25 Jan 2021 19:40:21 +0100
Message-Id: <20210125183224.566786282@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210125183216.245315437@linuxfoundation.org>
References: <20210125183216.245315437@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Martin Kepplinger <martin.kepplinger@puri.sm>

commit 67288f74d4837b82ef937170da3389b0779c17be upstream.

Add the icc_sync_state callback to notify the framework when consumers
are probed and the bandwidth doesn't have to be kept at maximum anymore.

Signed-off-by: Martin Kepplinger <martin.kepplinger@puri.sm>
Suggested-by: Georgi Djakov <georgi.djakov@linaro.org>
Fixes: 7d3b0b0d8184 ("interconnect: qcom: Use icc_sync_state")
Link: https://lore.kernel.org/r/20201210100906.18205-6-martin.kepplinger@puri.sm
Signed-off-by: Georgi Djakov <georgi.djakov@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/interconnect/imx/imx8mq.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/interconnect/imx/imx8mq.c
+++ b/drivers/interconnect/imx/imx8mq.c
@@ -7,6 +7,7 @@
 
 #include <linux/module.h>
 #include <linux/platform_device.h>
+#include <linux/interconnect-provider.h>
 #include <dt-bindings/interconnect/imx8mq.h>
 
 #include "imx.h"
@@ -94,6 +95,7 @@ static struct platform_driver imx8mq_icc
 	.remove = imx8mq_icc_remove,
 	.driver = {
 		.name = "imx8mq-interconnect",
+		.sync_state = icc_sync_state,
 	},
 };
 


