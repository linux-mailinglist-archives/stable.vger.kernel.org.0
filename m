Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B573959DD1C
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:27:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358544AbiHWLwY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 07:52:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358953AbiHWLvX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 07:51:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36747D3997;
        Tue, 23 Aug 2022 02:32:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 65520613EF;
        Tue, 23 Aug 2022 09:32:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55514C433D6;
        Tue, 23 Aug 2022 09:32:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661247124;
        bh=Y+qlWdUnCH0Y1VPWF46YVC7tY1kSdFucqEmRWPIB3ck=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iV2uKrEsawv0hZ1iNI9/2KSETpoyuQe8RpLkIykGHWLX0LnRbdQyaiKVc4F2N35a3
         rg+e8rxw+bIN31etQ/fPx3JZyQFyh6ShQ2CAgJCvqtzoeP2JByUj0NMBEd91Vwy2jV
         IiXx6DVYCGL1mGsPNvAK2vUnjVkB5P3cdeqjPUeU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Louis Peens <louis.peens@corigine.com>,
        Yu Xiao <yu.xiao@corigine.com>,
        Simon Horman <simon.horman@corigine.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.4 324/389] nfp: ethtool: fix the display error of `ethtool -m DEVNAME`
Date:   Tue, 23 Aug 2022 10:26:42 +0200
Message-Id: <20220823080129.056893794@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080115.331990024@linuxfoundation.org>
References: <20220823080115.331990024@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yu Xiao <yu.xiao@corigine.com>

commit 4ae97cae07e15d41e5c0ebabba64c6eefdeb0bbe upstream.

The port flag isn't set to `NFP_PORT_CHANGED` when using
`ethtool -m DEVNAME` before, so the port state (e.g. interface)
cannot be updated. Therefore, it caused that `ethtool -m DEVNAME`
sometimes cannot read the correct information.

E.g. `ethtool -m DEVNAME` cannot work when load driver before plug
in optical module, as the port interface is still NONE without port
update.

Now update the port state before sending info to NIC to ensure that
port interface is correct (latest state).

Fixes: 61f7c6f44870 ("nfp: implement ethtool get module EEPROM")
Reviewed-by: Louis Peens <louis.peens@corigine.com>
Signed-off-by: Yu Xiao <yu.xiao@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
Link: https://lore.kernel.org/r/20220802093355.69065-1-simon.horman@corigine.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
@@ -1127,6 +1127,8 @@ nfp_port_get_module_info(struct net_devi
 	u8 data;
 
 	port = nfp_port_from_netdev(netdev);
+	/* update port state to get latest interface */
+	set_bit(NFP_PORT_CHANGED, &port->flags);
 	eth_port = nfp_port_get_eth_port(port);
 	if (!eth_port)
 		return -EOPNOTSUPP;


