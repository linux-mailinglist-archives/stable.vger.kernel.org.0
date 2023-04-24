Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E65276EC89C
	for <lists+stable@lfdr.de>; Mon, 24 Apr 2023 11:19:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231590AbjDXJTr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Apr 2023 05:19:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231438AbjDXJTo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Apr 2023 05:19:44 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C153E55
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 02:19:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1682327983; x=1713863983;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=cvkJ6N5X/gGfLrdqtFuKO8TZN1+hTJud0TxKl6hMf2k=;
  b=cb9uIlnKP+yZY2Rl6hpnMBDy00oTFnmP3XiMFDUQHHTRB09WMl6tt5YB
   FhCFBnMViUxuJL7UDoZVdWo/J0edgkcFUnsfqLMK2fs23zwxIEVxURqPe
   caMrdRqw1VritZKiob7+azfSdyBLss8PMA7DhWDLNy/SZruMAresoV4wq
   TPWSD4zN6seCQBkNdLEzjjAMdxUr2jXtUzmyrUZxECmtoSgW93U+C3VXx
   NcQB/ev5Od4xO0pxfp0jRnqjn5raR/drqlqvBcctK8RG6Kt3wNoVDmM2w
   ZXbGw0xAADB5rLezja+jks0F86CvyHdd/oMnl0ScvRwhVNqANQrdOiAO1
   g==;
X-IronPort-AV: E=Sophos;i="5.99,222,1677567600"; 
   d="scan'208";a="222256046"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 24 Apr 2023 02:19:42 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 24 Apr 2023 02:19:41 -0700
Received: from wendy.microchip.com (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.2507.21 via Frontend
 Transport; Mon, 24 Apr 2023 02:19:40 -0700
From:   Conor Dooley <conor.dooley@microchip.com>
To:     <stable@vger.kernel.org>
CC:     <conor@kernel.org>, <conor.dooley@microchip.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Greentime Hu <greentime.hu@sifive.com>,
        Zong Li <zong.li@sifive.com>,
        Palmer Dabbelt <palmer@rivosinc.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 v2 0/3] sifive ccache error handling backports for 5.15
Date:   Mon, 24 Apr 2023 10:19:01 +0100
Message-ID: <20230424-slingshot-knelt-7a2f81b422a3@wendy>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=886; i=conor.dooley@microchip.com; h=from:subject:message-id; bh=cvkJ6N5X/gGfLrdqtFuKO8TZN1+hTJud0TxKl6hMf2k=; b=owGbwMvMwCFWscWwfUFT0iXG02pJDClunm08r2e/emz99IKE6IfAa8sby1+0XFij/9OJcdKjt6LL Nn3N6ShlYRDjYJAVU2RJvN3XIrX+j8sO5563MHNYmUCGMHBxCsBE1t1mZJjx7bZju96Zi9Kh/+dHJz Nylh9IqFOWNK7YZ64dOU+v+gEjw8qcD7LK7MtWNEmvPXKzxvXEQ+4GxpfzUo+zac+3mzczjBUA
X-Developer-Key: i=conor.dooley@microchip.com; a=openpgp; fpr=F9ECA03CF54F12CD01F1655722E2C55B37CF380C
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Following up on:
https://lore.kernel.org/stable/20230412-mustang-machine-e9fccdb6b81c@wendy/

Here's some backports that do pull back the rename of the driver and
Kconfig symbol etc.

Changes in v2:
- use the right hash for 2/3

CC: stable@vger.kernel.org
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Greentime Hu <greentime.hu@sifive.com>
CC: Zong Li <zong.li@sifive.com>
CC: Palmer Dabbelt <palmer@rivosinc.com>
CC: Sasha Levin <sashal@kernel.org>

Yang Yingliang (3):
  soc: sifive: l2_cache: fix missing iounmap() in error path in
    sifive_l2_init()
  soc: sifive: l2_cache: fix missing free_irq() in error path in
    sifive_l2_init()
  soc: sifive: l2_cache: fix missing of_node_put() in sifive_l2_init()

 drivers/soc/sifive/sifive_l2_cache.c | 27 +++++++++++++++++++++------
 1 file changed, 21 insertions(+), 6 deletions(-)

-- 
2.39.2

