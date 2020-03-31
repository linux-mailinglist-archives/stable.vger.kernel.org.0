Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF5CE198FD9
	for <lists+stable@lfdr.de>; Tue, 31 Mar 2020 11:07:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730682AbgCaJGy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Mar 2020 05:06:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:48458 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731185AbgCaJGx (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 31 Mar 2020 05:06:53 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 99A5E20787;
        Tue, 31 Mar 2020 09:06:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585645612;
        bh=BJdtZt8wNQKTcjtxEhtdcuqLz5fEjrH+VTKBedAi40c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zA7fw+pfIYuESv0neQ/wpCQ8odu7WL7WX3xganga0A7fnLHWOJDvPPItfP3PxzxgC
         6G6NyGzyOukNbr7PRRXqSRHFeQTz/W1tS1w7cythV6FWPYvc2O98t0UokUpH1rpZbk
         /wmTvm4fNJQoQAgLdmhIadhkYp9rUO8Piqn7AfXI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 5.5 106/170] soc: samsung: chipid: Fix return value on non-Exynos platforms
Date:   Tue, 31 Mar 2020 10:58:40 +0200
Message-Id: <20200331085435.452193790@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200331085423.990189598@linuxfoundation.org>
References: <20200331085423.990189598@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marek Szyprowski <m.szyprowski@samsung.com>

commit c8042d1e5cb3e654b47447229ace3cd092a8fc27 upstream.

Correct the probe return value to -ENODEV on non-Exynos platforms.

Link: https://lore.kernel.org/r/20200316175652.5604-4-krzk@kernel.org
Fixes: 02fb29882d5c ("soc: samsung: chipid: Drop "syscon" compatible requirement")
Cc: <stable@vger.kernel.org>
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/soc/samsung/exynos-chipid.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/soc/samsung/exynos-chipid.c
+++ b/drivers/soc/samsung/exynos-chipid.c
@@ -59,7 +59,7 @@ static int __init exynos_chipid_early_in
 	syscon = of_find_compatible_node(NULL, NULL,
 					 "samsung,exynos4210-chipid");
 	if (!syscon)
-		return ENODEV;
+		return -ENODEV;
 
 	regmap = device_node_to_regmap(syscon);
 	of_node_put(syscon);


