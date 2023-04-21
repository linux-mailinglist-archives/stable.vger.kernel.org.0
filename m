Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DFD16EAC26
	for <lists+stable@lfdr.de>; Fri, 21 Apr 2023 15:59:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230074AbjDUN7H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Apr 2023 09:59:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232575AbjDUN64 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 Apr 2023 09:58:56 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC3E8107
        for <stable@vger.kernel.org>; Fri, 21 Apr 2023 06:58:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1682085534; x=1713621534;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=3jfBbg24oEULWwy+AIIHfFv+ouyGM4YFzTJ4RlhhYag=;
  b=nTgHw48NQ9GySW6NfFGrlz6Kb9N+k71qjEJX/eCiofgyv1PL8IW3psZk
   +pgmutdpz5yPBE9XkTd07UP8YvwlftPhzjM7L6x30OW5+ZltFAJi9Neip
   efM9hpy6nRs6RrPbbL6aDnPk7aEgHCQvjV54UHFo7+Iv1XfxiTHEPZHp4
   bU4+6ly6IjDJhdhcxYYWR8iFpkVCsqsX+Jx+kcy3pJfHFKKEUPxUk+zL8
   mFzngVvehr8SINSfC29L+5nL9HQ8SNXMernzOTgA2xijeoH8i0XRBOROD
   7+B+K1Htmyp0gFjxaoGpaJUjL+0YzJ706ngS5tA+98AYJGNuAaml0HQz/
   g==;
X-IronPort-AV: E=Sophos;i="5.99,214,1677567600"; 
   d="scan'208";a="210133210"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 21 Apr 2023 06:58:54 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Fri, 21 Apr 2023 06:58:53 -0700
Received: from wendy.microchip.com (10.10.115.15) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server id 15.1.2507.21 via Frontend
 Transport; Fri, 21 Apr 2023 06:58:52 -0700
From:   Conor Dooley <conor.dooley@microchip.com>
To:     <stable@vger.kernel.org>
CC:     <conor@kernel.org>, <conor.dooley@microchip.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Greentime Hu <greentime.hu@sifive.com>,
        Zong Li <zong.li@sifive.com>,
        Palmer Dabbelt <palmer@rivosinc.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0/3] sifive ccache error handling backports for 5.15
Date:   Fri, 21 Apr 2023 14:58:15 +0100
Message-ID: <20230421-scam-karma-3de5bf7904b3@wendy>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=838; i=conor.dooley@microchip.com; h=from:subject:message-id; bh=3jfBbg24oEULWwy+AIIHfFv+ouyGM4YFzTJ4RlhhYag=; b=owGbwMvMwCFWscWwfUFT0iXG02pJDClO0yquXErXmLavKOyh88Qzu8S5GpanLeSptNq2Zu2LiX/U 7Q75dZSyMIhxMMiKKbIk3u5rkVr/x2WHc89bmDmsTCBDGLg4BWAiycGMDMu8LXK/rHrn+GndokMPPy zyuv63/M5fvo6Fhf/yjB4uOlbJ8N/DUPDABdcb+VtPfmN/uT9ZU6f/7Fejg8KtzE1vvb9I3GAAAA==
X-Developer-Key: i=conor.dooley@microchip.com; a=openpgp; fpr=F9ECA03CF54F12CD01F1655722E2C55B37CF380C
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Following up on:
https://lore.kernel.org/stable/20230412-mustang-machine-e9fccdb6b81c@wendy/

Here's some backports that do pull back the rename of the driver and
Kconfig symbol etc.

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

