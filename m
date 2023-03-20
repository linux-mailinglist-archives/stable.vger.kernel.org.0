Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94CD96C19D6
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 16:38:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233188AbjCTPiw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 11:38:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233146AbjCTPi1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 11:38:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5296414492
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 08:30:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8081A61561
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 15:29:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D10BC433EF;
        Mon, 20 Mar 2023 15:29:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679326191;
        bh=WZcpLRaJ38rETLsEeDRuOU7hG1w5FdMNAeoi3tqxS4I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MXKO18d1gYlR7e49XoUYdqSzqxTPMcIO7Iwx2P0nrksZUTca6Ak3kmuSU7YfgudIl
         ACbSph/O/9fo1T/nai5EAKk5Q3DYLl16hnGvx/PMe6WxV46LwoxeJjrK5Y9xaj0gnX
         JbW8HuoGZOQw7qht+PasXnNI3z3xUhiNf/EWrjv0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        "Radu Pirea (OSS)" <radu-nicolae.pirea@oss.nxp.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.2 194/211] net: phy: nxp-c45-tja11xx: fix MII_BASIC_CONFIG_REV bit
Date:   Mon, 20 Mar 2023 15:55:29 +0100
Message-Id: <20230320145521.653487824@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145513.305686421@linuxfoundation.org>
References: <20230320145513.305686421@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Radu Pirea (OSS) <radu-nicolae.pirea@oss.nxp.com>

commit 8ba572052a4b8fe5b205854d27e54e3486049b71 upstream.

According to the TJA1103 user manual, the bit for the reversed role in MII
or RMII modes is bit 4.

Cc: <stable@vger.kernel.org> # 5.15+
Fixes: b050f2f15e04 ("phy: nxp-c45: add driver for tja1103")
Signed-off-by: Radu Pirea (OSS) <radu-nicolae.pirea@oss.nxp.com>
Link: https://lore.kernel.org/r/20230309100111.1246214-1-radu-nicolae.pirea@oss.nxp.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/phy/nxp-c45-tja11xx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/phy/nxp-c45-tja11xx.c
+++ b/drivers/net/phy/nxp-c45-tja11xx.c
@@ -79,7 +79,7 @@
 #define SGMII_ABILITY			BIT(0)
 
 #define VEND1_MII_BASIC_CONFIG		0xAFC6
-#define MII_BASIC_CONFIG_REV		BIT(8)
+#define MII_BASIC_CONFIG_REV		BIT(4)
 #define MII_BASIC_CONFIG_SGMII		0x9
 #define MII_BASIC_CONFIG_RGMII		0x7
 #define MII_BASIC_CONFIG_RMII		0x5


