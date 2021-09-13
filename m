Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AC8C4094F4
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 16:35:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345292AbhIMOgi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 10:36:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:51900 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347540AbhIMOem (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 10:34:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8B9CC61BD1;
        Mon, 13 Sep 2021 13:53:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631541197;
        bh=kdMDeZOAHr7wVMaFI+ckBHlPCR//dK5lxel0Y49RD5A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HFwaJHSe+GJRpCmOeoqaQhaZM8Ds9BwV32P4TvcYK/1b2wW22xK34Is738286/Whp
         BWBD2GZs2BHR0ENF9WJ8YIlbJmDz1DMQQN5vasAh4FXu5HV7HnfpSW3LA35AVVJvoa
         PIqHq2bSNvdUaRPhXxTGqI/MwpVHX0jdg/82uANg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 170/334] net: dsa: tag_sja1105: optionally build as module when switch driver is module if PTP is enabled
Date:   Mon, 13 Sep 2021 15:13:44 +0200
Message-Id: <20210913131119.093497499@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131113.390368911@linuxfoundation.org>
References: <20210913131113.390368911@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit f8b17a0bd96065e4511858689916bb729dbb881b ]

TX timestamps are sent by SJA1110 as Ethernet packets containing
metadata, so they are received by the tagging driver but must be
processed by the switch driver - the one that is stateful since it
keeps the TX timestamp queue.

This means that there is an sja1110_process_meta_tstamp() symbol
exported by the switch driver which is called by the tagging driver.

There is a shim definition for that function when the switch driver is
not compiled, which does nothing, but that shim is not effective when
the tagging protocol driver is built-in and the switch driver is a
module, because built-in code cannot call symbols exported by modules.

So add an optional dependency between the tagger and the switch driver,
if PTP support is enabled in the switch driver. If PTP is not enabled,
sja1110_process_meta_tstamp() will translate into the shim "do nothing
with these meta frames" function.

Fixes: 566b18c8b752 ("net: dsa: sja1105: implement TX timestamping for SJA1110")
Reported-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/dsa/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/dsa/Kconfig b/net/dsa/Kconfig
index bca1b5d66df2..970906eb5b2c 100644
--- a/net/dsa/Kconfig
+++ b/net/dsa/Kconfig
@@ -138,6 +138,7 @@ config NET_DSA_TAG_LAN9303
 
 config NET_DSA_TAG_SJA1105
 	tristate "Tag driver for NXP SJA1105 switches"
+	depends on (NET_DSA_SJA1105 && NET_DSA_SJA1105_PTP) || !NET_DSA_SJA1105 || !NET_DSA_SJA1105_PTP
 	select PACKING
 	help
 	  Say Y or M if you want to enable support for tagging frames with the
-- 
2.30.2



