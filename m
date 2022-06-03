Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD84253CF23
	for <lists+stable@lfdr.de>; Fri,  3 Jun 2022 19:54:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345648AbiFCRxs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jun 2022 13:53:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347197AbiFCRwG (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jun 2022 13:52:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C5E658380;
        Fri,  3 Jun 2022 10:50:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DCF3360A0F;
        Fri,  3 Jun 2022 17:50:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F05CCC385A9;
        Fri,  3 Jun 2022 17:50:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654278620;
        bh=rhSReVfYA015Yqcr13AeznBlSDShTNdEP+EIElwOAPE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wygI1G6kaSgCTpR/GGrpEznWnAbKY6KXGVwNqETx3kVKuCI4LH/EGZkVXjoJSn8Yb
         KH2qgaZ1PpztoRsPB3hgKtDVzakkJf6vHttrnEs+2WyZDzsAf4cSt6cgElm3uSxzhL
         SV9oplhNmgyoMvUT6IId0MlUx4CgPhs/npxlN2jw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Wilder <wilder@us.ibm.com>,
        Dylan Hung <dylan_hung@aspeedtech.com>,
        Joel Stanley <joel@jms.id.au>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 07/66] net: ftgmac100: Disable hardware checksum on AST2600
Date:   Fri,  3 Jun 2022 19:42:47 +0200
Message-Id: <20220603173820.878999533@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220603173820.663747061@linuxfoundation.org>
References: <20220603173820.663747061@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Joel Stanley <joel@jms.id.au>

[ Upstream commit 6fd45e79e8b93b8d22fb8fe22c32fbad7e9190bd ]

The AST2600 when using the i210 NIC over NC-SI has been observed to
produce incorrect checksum results with specific MTU values. This was
first observed when sending data across a long distance set of networks.

On a local network, the following test was performed using a 1MB file of
random data.

On the receiver run this script:

 #!/bin/bash
 while [ 1 ]; do
        # Zero the stats
        nstat -r  > /dev/null
        nc -l 9899 > test-file
        # Check for checksum errors
        TcpInCsumErrors=$(nstat | grep TcpInCsumErrors)
        if [ -z "$TcpInCsumErrors" ]; then
                echo No TcpInCsumErrors
        else
                echo TcpInCsumErrors = $TcpInCsumErrors
        fi
 done

On an AST2600 system:

 # nc <IP of  receiver host> 9899 < test-file

The test was repeated with various MTU values:

 # ip link set mtu 1410 dev eth0

The observed results:

 1500 - good
 1434 - bad
 1400 - good
 1410 - bad
 1420 - good

The test was repeated after disabling tx checksumming:

 # ethtool -K eth0 tx-checksumming off

And all MTU values tested resulted in transfers without error.

An issue with the driver cannot be ruled out, however there has been no
bug discovered so far.

David has done the work to take the original bug report of slow data
transfer between long distance connections and triaged it down to this
test case.

The vendor suspects this this is a hardware issue when using NC-SI. The
fixes line refers to the patch that introduced AST2600 support.

Reported-by: David Wilder <wilder@us.ibm.com>
Reviewed-by: Dylan Hung <dylan_hung@aspeedtech.com>
Signed-off-by: Joel Stanley <joel@jms.id.au>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/faraday/ftgmac100.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/faraday/ftgmac100.c b/drivers/net/ethernet/faraday/ftgmac100.c
index e1df2dc810a2..0b833572205f 100644
--- a/drivers/net/ethernet/faraday/ftgmac100.c
+++ b/drivers/net/ethernet/faraday/ftgmac100.c
@@ -1910,6 +1910,11 @@ static int ftgmac100_probe(struct platform_device *pdev)
 	/* AST2400  doesn't have working HW checksum generation */
 	if (np && (of_device_is_compatible(np, "aspeed,ast2400-mac")))
 		netdev->hw_features &= ~NETIF_F_HW_CSUM;
+
+	/* AST2600 tx checksum with NCSI is broken */
+	if (priv->use_ncsi && of_device_is_compatible(np, "aspeed,ast2600-mac"))
+		netdev->hw_features &= ~NETIF_F_HW_CSUM;
+
 	if (np && of_get_property(np, "no-hw-checksum", NULL))
 		netdev->hw_features &= ~(NETIF_F_HW_CSUM | NETIF_F_RXCSUM);
 	netdev->features |= netdev->hw_features;
-- 
2.35.1



