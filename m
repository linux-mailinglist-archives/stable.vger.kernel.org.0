Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 812AD171F02
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 15:31:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733269AbgB0ODI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 09:03:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:38152 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733258AbgB0ODF (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 09:03:05 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E05DF20801;
        Thu, 27 Feb 2020 14:03:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582812185;
        bh=M+3C6Vfw8tIQOCDP4th63PzilReHvAapp2Moe3ZV2mg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=imvHzz6m/mgbikRVcIYFrnJ0oKlVfNMR4sJZ78hoEUeYHLtHopakrMRHy4IGdF81P
         /495zF0dWKtdoNbYIYIn5cYZwJvtpO8t9GAce73wxDYEYJDZVpFuqRlArm/smt86OV
         adB8Bc4yEGfQBfesZFERoytQmzhxzqcu6Aci8wf8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 4.19 18/97] staging: vt6656: fix sign of rx_dbm to bb_pre_ed_rssi.
Date:   Thu, 27 Feb 2020 14:36:26 +0100
Message-Id: <20200227132217.607436469@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200227132214.553656188@linuxfoundation.org>
References: <20200227132214.553656188@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Malcolm Priestley <tvboxspy@gmail.com>

commit 93134df520f23f4e9998c425b8987edca7016817 upstream.

bb_pre_ed_rssi is an u8 rx_dm always returns negative signed
values add minus operator to always yield positive.

fixes issue where rx sensitivity is always set to maximum because
the unsigned numbers were always greater then 100.

Fixes: 63b9907f58f1 ("staging: vt6656: mac80211 conversion: create rx function.")
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
Link: https://lore.kernel.org/r/aceac98c-6e69-3ce1-dfec-2bf27b980221@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/vt6656/dpc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/staging/vt6656/dpc.c
+++ b/drivers/staging/vt6656/dpc.c
@@ -130,7 +130,7 @@ int vnt_rx_data(struct vnt_private *priv
 
 	vnt_rf_rssi_to_dbm(priv, *rssi, &rx_dbm);
 
-	priv->bb_pre_ed_rssi = (u8)rx_dbm + 1;
+	priv->bb_pre_ed_rssi = (u8)-rx_dbm + 1;
 	priv->current_rssi = priv->bb_pre_ed_rssi;
 
 	skb_pull(skb, 8);


