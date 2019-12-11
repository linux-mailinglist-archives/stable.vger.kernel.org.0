Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 33BE111B062
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 16:22:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732309AbfLKPWQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:22:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:52792 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732285AbfLKPWM (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:22:12 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6EC012073D;
        Wed, 11 Dec 2019 15:22:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077731;
        bh=4YMkOe683UOMZtkpg1G3VQoM/kKp2ul1XEn7gRyO554=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bEnurgXQsNGTRv8G7rnr2vFAAAvvti8r0ZFqCfhJwtcAbq9KwLCeDuwfV0p7rQoRH
         OFdyncR7iHgwIFvPz5KY8okbT0RoUA40SXqG716o5kj7AYDoRYs2q+N/X/pltuIjSI
         /CSYuz7WV6jfI0bFCR+gMuru8wREhrE4lXsfc7yw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 112/243] slimbus: ngd: Fix build error on x86
Date:   Wed, 11 Dec 2019 16:04:34 +0100
Message-Id: <20191211150346.691630639@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191211150339.185439726@linuxfoundation.org>
References: <20191211150339.185439726@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>

[ Upstream commit 458a445deb9c9fb13cec46fe9b179a84d2ff514f ]

on non DT platforms like x86 of_match_node is set to NULL, dereferencing
directly would throw an error.
Fix this by doing this in two steps, get the match then the data.

Reported-by: Greg KH <gregkh@linuxfoundation.org>
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/slimbus/qcom-ngd-ctrl.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/slimbus/qcom-ngd-ctrl.c b/drivers/slimbus/qcom-ngd-ctrl.c
index d72f8eed2e8b7..9221ba7b78637 100644
--- a/drivers/slimbus/qcom-ngd-ctrl.c
+++ b/drivers/slimbus/qcom-ngd-ctrl.c
@@ -1326,11 +1326,12 @@ static int of_qcom_slim_ngd_register(struct device *parent,
 {
 	const struct ngd_reg_offset_data *data;
 	struct qcom_slim_ngd *ngd;
+	const struct of_device_id *match;
 	struct device_node *node;
 	u32 id;
 
-	data = of_match_node(qcom_slim_ngd_dt_match, parent->of_node)->data;
-
+	match = of_match_node(qcom_slim_ngd_dt_match, parent->of_node);
+	data = match->data;
 	for_each_available_child_of_node(parent->of_node, node) {
 		if (of_property_read_u32(node, "reg", &id))
 			continue;
-- 
2.20.1



