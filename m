Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CEEA4C7368
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 18:34:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238135AbiB1RfU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 12:35:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237773AbiB1Reg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 12:34:36 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE9969399C;
        Mon, 28 Feb 2022 09:31:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9B2AF61365;
        Mon, 28 Feb 2022 17:30:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2960C36AE7;
        Mon, 28 Feb 2022 17:30:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646069454;
        bh=MLtCPOzQia29se3vECjDQjwtcWHGH9cE0eyTMbvnry8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XrSdotJG68OBZMJvaGpl1JZ4SgF3ZQkSRbVVfS9Jb5xZsh9ncMgk8MLBKjPDO6q0/
         wwC8wRuNrgukEHKo2KEm+BV8ze1Jw9LXJxCPO9aN5lRI5e6QfACVC3HTueWjm7AJqB
         CXJme86T+JLVZYuGS7DzE29upaZbMpZw5Yl2aNFs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Simon Horman <simon.horman@corigine.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.4 25/53] nfp: flower: Fix a potential leak in nfp_tunnel_add_shared_mac()
Date:   Mon, 28 Feb 2022 18:24:23 +0100
Message-Id: <20220228172250.117600264@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220228172248.232273337@linuxfoundation.org>
References: <20220228172248.232273337@linuxfoundation.org>
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

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

commit 3a14d0888eb4b0045884126acc69abfb7b87814d upstream.

ida_simple_get() returns an id between min (0) and max (NFP_MAX_MAC_INDEX)
inclusive.
So NFP_MAX_MAC_INDEX (0xff) is a valid id.

In order for the error handling path to work correctly, the 'invalid'
value for 'ida_idx' should not be in the 0..NFP_MAX_MAC_INDEX range,
inclusive.

So set it to -1.

Fixes: 20cce8865098 ("nfp: flower: enable MAC address sharing for offloadable devs")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
Link: https://lore.kernel.org/r/20220218131535.100258-1-simon.horman@corigine.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c
@@ -588,8 +588,8 @@ nfp_tunnel_add_shared_mac(struct nfp_app
 			  int port, bool mod)
 {
 	struct nfp_flower_priv *priv = app->priv;
-	int ida_idx = NFP_MAX_MAC_INDEX, err;
 	struct nfp_tun_offloaded_mac *entry;
+	int ida_idx = -1, err;
 	u16 nfp_mac_idx = 0;
 
 	entry = nfp_tunnel_lookup_offloaded_macs(app, netdev->dev_addr);
@@ -663,7 +663,7 @@ err_remove_hash:
 err_free_entry:
 	kfree(entry);
 err_free_ida:
-	if (ida_idx != NFP_MAX_MAC_INDEX)
+	if (ida_idx != -1)
 		ida_simple_remove(&priv->tun.mac_off_ids, ida_idx);
 
 	return err;


