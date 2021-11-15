Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAED9451E3D
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 01:32:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351348AbhKPAfa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 19:35:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:47888 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344783AbhKOTZ3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:25:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D899E636C8;
        Mon, 15 Nov 2021 19:04:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637003067;
        bh=reufAu6yogWRdslKweeyV7v5Tl/MKvbnnDnoqxorVr4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IecYc2mSERvxGYkScvprs2rratPPPGN6yToIJohA9C/kWnoCu+3bdZn4mIIgcQ5k1
         qdP5T7CF7aa/pNgGWjpAuMsDAqzfAoB98I2iwTgHfIJVbOo5O++8GbMoWCbuU0UyA1
         n3FmxONGbJgPn+rWnwb1OIwd5PVp8qhrRCjwbM7I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Lee Jones <lee.jones@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 798/917] mfd: core: Add missing of_node_put for loop iteration
Date:   Mon, 15 Nov 2021 18:04:53 +0100
Message-Id: <20211115165456.028853188@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>

[ Upstream commit 002be81140075e17a1ebd5c3c55e356fbab0ddad ]

Early exits from for_each_child_of_node() should decrement the
node reference counter.  Reported by Coccinelle:

  drivers/mfd/mfd-core.c:197:2-24: WARNING:
    Function "for_each_child_of_node" should have of_node_put() before goto around lines 209.

Fixes: c94bb233a9fe ("mfd: Make MFD core code Device Tree and IRQ domain aware")
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Link: https://lore.kernel.org/r/20210528115126.18370-1-krzysztof.kozlowski@canonical.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/mfd-core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/mfd/mfd-core.c b/drivers/mfd/mfd-core.c
index 79f5c6a18815a..684a011a63968 100644
--- a/drivers/mfd/mfd-core.c
+++ b/drivers/mfd/mfd-core.c
@@ -198,6 +198,7 @@ static int mfd_add_device(struct device *parent, int id,
 			if (of_device_is_compatible(np, cell->of_compatible)) {
 				/* Ignore 'disabled' devices error free */
 				if (!of_device_is_available(np)) {
+					of_node_put(np);
 					ret = 0;
 					goto fail_alias;
 				}
@@ -205,6 +206,7 @@ static int mfd_add_device(struct device *parent, int id,
 				ret = mfd_match_of_node_to_dev(pdev, np, cell);
 				if (ret == -EAGAIN)
 					continue;
+				of_node_put(np);
 				if (ret)
 					goto fail_alias;
 
-- 
2.33.0



