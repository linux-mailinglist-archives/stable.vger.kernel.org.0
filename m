Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1DFF498E7E
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 20:44:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244183AbiAXTmQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:42:16 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:59098 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355137AbiAXTkE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:40:04 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AC34BB8119D;
        Mon, 24 Jan 2022 19:40:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5BECC340E5;
        Mon, 24 Jan 2022 19:40:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643053202;
        bh=cAsgGxHRlMgNK0AryRN0I/ANz2aq81Z9fpR9OCPmRwY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o1ECqNOoFFdGX5NY9hfFnDwNycKEleid+y2cyDIMk86eAnm3/PJm4rLpRqrtrAX8k
         W8PQQsWt6Lxz+9fqYSaM/RT7GRCvuSUZ4pjqc56c8oIhDc6lYbZFDS6/SQsvCHJ3ZX
         +acYBbM2lYZSt62DzqM1OJ8ngDKTsoZ3POhQq9j0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Suresh Udipi <sudipi@jp.adit-jv.com>,
        Michael Rodin <mrodin@de.adit-jv.com>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?= 
        <niklas.soderlund+renesas@ragnatech.se>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 5.4 276/320] media: rcar-csi2: Optimize the selection PHTW register
Date:   Mon, 24 Jan 2022 19:44:20 +0100
Message-Id: <20220124184003.361849513@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183953.750177707@linuxfoundation.org>
References: <20220124183953.750177707@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Suresh Udipi <sudipi@jp.adit-jv.com>

commit 549cc89cd09a85aaa16dc07ef3db811d5cf9bcb1 upstream.

PHTW register is selected based on default bit rate from Table[1].
for the bit rates less than or equal to 250. Currently first
value of default bit rate which is greater than or equal to
the caculated mbps is selected. This selection can be further
improved by selecting the default bit rate which is nearest to
the calculated value.

[1] specs r19uh0105ej0200-r-car-3rd-generation.pdf [Table 25.12]

Fixes: 769afd212b16 ("media: rcar-csi2: add Renesas R-Car MIPI CSI-2 receiver driver")
Signed-off-by: Suresh Udipi <sudipi@jp.adit-jv.com>
Signed-off-by: Michael Rodin <mrodin@de.adit-jv.com>
Reviewed-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/rcar-vin/rcar-csi2.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/drivers/media/platform/rcar-vin/rcar-csi2.c
+++ b/drivers/media/platform/rcar-vin/rcar-csi2.c
@@ -911,10 +911,17 @@ static int rcsi2_phtw_write_mbps(struct
 				 const struct rcsi2_mbps_reg *values, u16 code)
 {
 	const struct rcsi2_mbps_reg *value;
+	const struct rcsi2_mbps_reg *prev_value = NULL;
 
-	for (value = values; value->mbps; value++)
+	for (value = values; value->mbps; value++) {
 		if (value->mbps >= mbps)
 			break;
+		prev_value = value;
+	}
+
+	if (prev_value &&
+	    ((mbps - prev_value->mbps) <= (value->mbps - mbps)))
+		value = prev_value;
 
 	if (!value->mbps) {
 		dev_err(priv->dev, "Unsupported PHY speed (%u Mbps)", mbps);


