Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E9222E401E
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:48:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2504132AbgL1OsV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:48:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:58134 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2502661AbgL1OW2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:22:28 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B4A73206D4;
        Mon, 28 Dec 2020 14:21:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165308;
        bh=b1+9m2hW3W77OgxfwQljLruGMSMrauPCbAy5KaHCl2I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iqTwa+tpVZm5hCh4D7GY0Ssp1TUS4qh+XUna+6/e62yfzzW6FCtbNsEzgCQz/zo6L
         Bdp2ERl8FzffroIKi3g24x9Kn8T93gHg++a7cgT3c/T5gZlwpbmUW5tdu7u1dUbz7Z
         2zzU0b1LwxWydj2+3jJYQieovYy+bYeNY7BYvtpw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Simon Horman <simon.horman@netronome.com>,
        Louis Peens <louis.peens@netronome.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 487/717] nfp: move indirect block cleanup to flower app stop callback
Date:   Mon, 28 Dec 2020 13:48:05 +0100
Message-Id: <20201228125044.295775785@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Simon Horman <simon.horman@netronome.com>

[ Upstream commit 5b33afee93a1e7665a5ffae027fc66f9376f4ea7 ]

The indirect block cleanup may cause control messages to be sent
if offloaded flows are present. However, by the time the flower app
cleanup callback is called txbufs are no longer available and attempts
to send control messages result in a NULL-pointer dereference in
nfp_ctrl_tx_one().

This problem may be resolved by moving the indirect block cleanup
to the stop callback, where txbufs are still available.

As suggested by Jakub Kicinski and Louis Peens.

Fixes: a1db217861f3 ("net: flow_offload: fix flow_indr_dev_unregister path")
Signed-off-by: Simon Horman <simon.horman@netronome.com>
Signed-off-by: Louis Peens <louis.peens@netronome.com>
Link: https://lore.kernel.org/r/20201216145701.30005-1-simon.horman@netronome.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/netronome/nfp/flower/main.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/flower/main.c b/drivers/net/ethernet/netronome/nfp/flower/main.c
index bb448c82cdc28..c029950a81e20 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/main.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/main.c
@@ -860,9 +860,6 @@ static void nfp_flower_clean(struct nfp_app *app)
 	skb_queue_purge(&app_priv->cmsg_skbs_low);
 	flush_work(&app_priv->cmsg_work);
 
-	flow_indr_dev_unregister(nfp_flower_indr_setup_tc_cb, app,
-				 nfp_flower_setup_indr_tc_release);
-
 	if (app_priv->flower_ext_feats & NFP_FL_FEATS_VF_RLIM)
 		nfp_flower_qos_cleanup(app);
 
@@ -951,6 +948,9 @@ static int nfp_flower_start(struct nfp_app *app)
 static void nfp_flower_stop(struct nfp_app *app)
 {
 	nfp_tunnel_config_stop(app);
+
+	flow_indr_dev_unregister(nfp_flower_indr_setup_tc_cb, app,
+				 nfp_flower_setup_indr_tc_release);
 }
 
 static int
-- 
2.27.0



