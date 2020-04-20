Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D980F1B09DD
	for <lists+stable@lfdr.de>; Mon, 20 Apr 2020 14:42:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728286AbgDTMmt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Apr 2020 08:42:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:36010 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728281AbgDTMms (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Apr 2020 08:42:48 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D70642072B;
        Mon, 20 Apr 2020 12:42:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587386568;
        bh=+YTUwla6O7ssMXw5d7M6LSEs07RMDzftrFuWJsm1zo0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L/0N4wsFUowFHc9PsLUf0ZqXbJNcwaZerl7aoP3ReFlrHphQLqG+Vziw2qEtwyJwf
         kG5Lu/BIgA4b2MvcQkmtXfNLddeJtjYA1gtZxvLGBROqC0nhFrN3YQLHezBZO2ymSB
         pIsGVpPutdTl2dWEQVnFGDQNTUT2PvMTKEAFLoCs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dmitry Yakunin <zeil@yandex-team.ru>,
        Konstantin Khlebnikov <khlebnikov@yandex-team.ru>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.6 10/71] net: revert default NAPI poll timeout to 2 jiffies
Date:   Mon, 20 Apr 2020 14:38:24 +0200
Message-Id: <20200420121510.571780205@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200420121508.491252919@linuxfoundation.org>
References: <20200420121508.491252919@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>

[ Upstream commit a4837980fd9fa4c70a821d11831698901baef56b ]

For HZ < 1000 timeout 2000us rounds up to 1 jiffy but expires randomly
because next timer interrupt could come shortly after starting softirq.

For commonly used CONFIG_HZ=1000 nothing changes.

Fixes: 7acf8a1e8a28 ("Replace 2 jiffies with sysctl netdev_budget_usecs to enable softirq tuning")
Reported-by: Dmitry Yakunin <zeil@yandex-team.ru>
Signed-off-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/dev.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4140,7 +4140,8 @@ EXPORT_SYMBOL(netdev_max_backlog);
 
 int netdev_tstamp_prequeue __read_mostly = 1;
 int netdev_budget __read_mostly = 300;
-unsigned int __read_mostly netdev_budget_usecs = 2000;
+/* Must be at least 2 jiffes to guarantee 1 jiffy timeout */
+unsigned int __read_mostly netdev_budget_usecs = 2 * USEC_PER_SEC / HZ;
 int weight_p __read_mostly = 64;           /* old backlog weight */
 int dev_weight_rx_bias __read_mostly = 1;  /* bias for backlog weight */
 int dev_weight_tx_bias __read_mostly = 1;  /* bias for output_queue quota */


