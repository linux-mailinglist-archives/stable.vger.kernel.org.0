Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1E09450EAA
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 19:17:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241060AbhKOSRn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 13:17:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:49944 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240689AbhKOSLr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:11:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A65C3633C6;
        Mon, 15 Nov 2021 17:47:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636998465;
        bh=US9g5eSyH8Vyi1KL9kcHTb9JN7vDmJepUDjhQxgmL5M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wibNjgyI1y/u7Z+KGyYBtEAFzddO/GsNfnYriXIw68gDn06WtHw6OTU8hLH8swRJB
         +FFnPLS2IaXn0yelJ6XvRGt1JfOyyTpYk53LlS6Wur84JA9igf6fGbxGFXdGepMPod
         48mAK0UqVHDQfrxENh2QWY072uuIvZSX3JgdPO2Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Lee Jones <lee.jones@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 519/575] mfd: core: Add missing of_node_put for loop iteration
Date:   Mon, 15 Nov 2021 18:04:04 +0100
Message-Id: <20211115165401.627621692@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165343.579890274@linuxfoundation.org>
References: <20211115165343.579890274@linuxfoundation.org>
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
index fc00aaccb5f72..a3a6faa99de05 100644
--- a/drivers/mfd/mfd-core.c
+++ b/drivers/mfd/mfd-core.c
@@ -210,6 +210,7 @@ static int mfd_add_device(struct device *parent, int id,
 			if (of_device_is_compatible(np, cell->of_compatible)) {
 				/* Ignore 'disabled' devices error free */
 				if (!of_device_is_available(np)) {
+					of_node_put(np);
 					ret = 0;
 					goto fail_alias;
 				}
@@ -217,6 +218,7 @@ static int mfd_add_device(struct device *parent, int id,
 				ret = mfd_match_of_node_to_dev(pdev, np, cell);
 				if (ret == -EAGAIN)
 					continue;
+				of_node_put(np);
 				if (ret)
 					goto fail_alias;
 
-- 
2.33.0



