Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE47850EBD4
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 00:22:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237911AbiDYWZK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Apr 2022 18:25:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343632AbiDYVwV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Apr 2022 17:52:21 -0400
Received: from phobos.denx.de (phobos.denx.de [IPv6:2a01:238:438b:c500:173d:9f52:ddab:ee01])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0887E3AA52
        for <stable@vger.kernel.org>; Mon, 25 Apr 2022 14:49:14 -0700 (PDT)
Received: from tr.lan (ip-86-49-12-201.net.upcbroadband.cz [86.49.12.201])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: marex@denx.de)
        by phobos.denx.de (Postfix) with ESMTPSA id C1D64807DF;
        Mon, 25 Apr 2022 23:49:11 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
        s=phobos-20191101; t=1650923352;
        bh=G+IpC+mJLycr4caIcIYyZQrIEE0dcvOzhT4id6b+Dic=;
        h=From:To:Cc:Subject:Date:From;
        b=ZXIWI4bA8FvSD6fS5k8B22rfRgIzP6yIGEueYcdz7DZrdeW1R4Hy/sBOHNnASEbzu
         NbxdNqNRWFr2nkRGIxVlzY0vjM7/rrXruU6YYuHnuqsaT4phCHnU0XBUrWtajLGHT3
         vSt1BS8rytcwS8qx5EUR/5JZzKG3KDSKWyFC3gW+J/0p10T3HDd38p6GYSp2YegxwT
         A5bEL72iJdKo2XtMfuyAmMo8BtlVBrzr5LPG54JgSjBTfDzjIZh+x535FfXGbKNfp/
         e32XPMbnwJEvspHFpSEOVz8sZH53wk5eslfivc5ZvXqUf7ekqd2PrOkZ69cjTg5XdX
         k7O4Bm71Rktpw==
From:   Marek Vasut <marex@denx.de>
To:     stable@vger.kernel.org
Cc:     Marek Vasut <marex@denx.de>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH] Revert "net: micrel: fix KS8851_MLL Kconfig"
Date:   Mon, 25 Apr 2022 23:48:59 +0200
Message-Id: <20220425214859.256650-1-marex@denx.de>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: clamav-milter 0.103.5 at phobos.denx.de
X-Virus-Status: Clean
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This reverts commit 1ff5359afa5ec0dd09fe76183dc4fa24b50e4125.

The upstream commit c3efcedd272a ("net: micrel: fix KS8851_MLL Kconfig")
depends on e5f31552674e ("ethernet: fix PTP_1588_CLOCK dependencies")
which is not part of Linux 5.10.y . Revert the aforementioned commit to
prevent breakage in 5.10.y .

Signed-off-by: Marek Vasut <marex@denx.de>
Cc: David S. Miller <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Sasha Levin <sashal@kernel.org>
Cc: <stable@vger.kernel.org> # 5.10.x
---
 drivers/net/ethernet/micrel/Kconfig | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/micrel/Kconfig b/drivers/net/ethernet/micrel/Kconfig
index 9ceb7e1fb169..42bc014136fe 100644
--- a/drivers/net/ethernet/micrel/Kconfig
+++ b/drivers/net/ethernet/micrel/Kconfig
@@ -37,7 +37,6 @@ config KS8851
 config KS8851_MLL
 	tristate "Micrel KS8851 MLL"
 	depends on HAS_IOMEM
-	depends on PTP_1588_CLOCK_OPTIONAL
 	select MII
 	select CRC32
 	select EEPROM_93CX6
-- 
2.35.1

