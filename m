Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F01350F603
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 10:55:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230345AbiDZIp4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 04:45:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346870AbiDZIp1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 04:45:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 818967DAA4;
        Tue, 26 Apr 2022 01:36:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3EC3DB81D09;
        Tue, 26 Apr 2022 08:36:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 758C1C385A0;
        Tue, 26 Apr 2022 08:36:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650962162;
        bh=70qI1yjsoDgEU4yMqhafU1+UfBm/Xmzov+B9musjrjM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QrsMleYuf64SZnN9G9ghYNShZh2RqCDNt+C23bse3D8rSWLzQDg8PE3zLXD09/F/y
         XNdQgql5tvyBci7I43Sf74v9etcsxFDHsOCWe9g8ObYbJ/e03UH9cgNt0r5p7xZrtC
         uvZIiuSw8gjNQmlVNm8TMqwuG6EYQyeeNnTR1rv4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Marek Vasut <marex@denx.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 86/86] Revert "net: micrel: fix KS8851_MLL Kconfig"
Date:   Tue, 26 Apr 2022 10:21:54 +0200
Message-Id: <20220426081743.697134831@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220426081741.202366502@linuxfoundation.org>
References: <20220426081741.202366502@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marek Vasut <marex@denx.de>

This reverts commit 1ff5359afa5ec0dd09fe76183dc4fa24b50e4125 which is
commit c3efcedd272aa6dd5929e20cf902a52ddaa1197a upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/micrel/Kconfig |    1 -
 1 file changed, 1 deletion(-)

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


