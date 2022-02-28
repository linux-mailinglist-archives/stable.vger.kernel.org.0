Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA3A94C74C4
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 18:46:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233146AbiB1Rqj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 12:46:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238586AbiB1Rpf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 12:45:35 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 684B151E71;
        Mon, 28 Feb 2022 09:37:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B8C0D6153F;
        Mon, 28 Feb 2022 17:37:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF6CFC340E7;
        Mon, 28 Feb 2022 17:37:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646069875;
        bh=D3q8cqG2Ibv+SluBi02J/zPBPdJPjyboVMnSitY9ASA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=01e+QRjFDfW8Xmx6KaFnviB3tYLttBYpA4Lc/0YRf70hFu2WHR9uF7sMCkq2ith6v
         bxjdVH1uTb6GvQXzQUJzg4UnwopdaxElxA3L7lT5WtNswSyKOBsZkMkP0ejtz327qR
         bhMeU3pUlkSn5Zs0OOLov1ZNEntjSwnpq4ThaU7s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Somnath Kotur <somnath.kotur@broadcom.com>,
        Michael Chan <michael.chan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.15 042/139] bnxt_en: Fix active FEC reporting to ethtool
Date:   Mon, 28 Feb 2022 18:23:36 +0100
Message-Id: <20220228172352.144920971@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220228172347.614588246@linuxfoundation.org>
References: <20220228172347.614588246@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Somnath Kotur <somnath.kotur@broadcom.com>

commit 84d3c83e6ea7d46cf3de3a54578af73eb24a64f2 upstream.

ethtool --show-fec <interface> does not show anything when the Active
FEC setting in the chip is set to None.  Fix it to properly return
ETHTOOL_FEC_OFF in that case.

Fixes: 8b2775890ad8 ("bnxt_en: Report FEC settings to ethtool.")
Signed-off-by: Somnath Kotur <somnath.kotur@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
@@ -1942,6 +1942,9 @@ static int bnxt_get_fecparam(struct net_
 	case PORT_PHY_QCFG_RESP_ACTIVE_FEC_FEC_RS272_IEEE_ACTIVE:
 		fec->active_fec |= ETHTOOL_FEC_LLRS;
 		break;
+	case PORT_PHY_QCFG_RESP_ACTIVE_FEC_FEC_NONE_ACTIVE:
+		fec->active_fec |= ETHTOOL_FEC_OFF;
+		break;
 	}
 	return 0;
 }


