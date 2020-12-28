Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6ADAF2E3ED0
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:33:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2504821AbgL1Oct (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:32:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:40776 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2504812AbgL1Ocs (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:32:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3404D208B6;
        Mon, 28 Dec 2020 14:32:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165927;
        bh=JTOq2aEU0ZWooTYDgXao8lvG8zqtcoMDAX26rbdrnlA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ksZ4gyUwax7bcD2QlzdQv53ZXAH/emcdtHQf5xKONxASxdCALiOo5ON/aJmbVZysk
         bp9Ayy8YF2m8cczwMS4R7tr4xjvk1nNaMIwJhmOw2DQUK2/jIOGbT38P1/DiFGyxh9
         qi7eauZMEsygFVVinpHpEuL7+tLv0/Mfk0GgF2AM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        Krzysztof Kozlowski <krzk@kernel.org>
Subject: [PATCH 5.10 704/717] memory: renesas-rpc-if: Fix unbalanced pm_runtime_enable in rpcif_{enable,disable}_rpm
Date:   Mon, 28 Dec 2020 13:51:42 +0100
Message-Id: <20201228125054.715581873@linuxfoundation.org>
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

From: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>

commit 61a6d854b9555b420fbfae62ef26baa8b9493b32 upstream.

rpcif_enable_rpm calls pm_runtime_enable, so rpcif_disable_rpm needs to
call pm_runtime_disable and not pm_runtime_put_sync.

Fixes: ca7d8b980b67f ("memory: add Renesas RPC-IF driver")
Reported-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Reviewed-by: Sergei Shtylyov <sergei.shtylyov@gmail.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20201126191146.8753-3-prabhakar.mahadev-lad.rj@bp.renesas.com
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/memory/renesas-rpc-if.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/memory/renesas-rpc-if.c
+++ b/drivers/memory/renesas-rpc-if.c
@@ -212,7 +212,7 @@ EXPORT_SYMBOL(rpcif_enable_rpm);
 
 void rpcif_disable_rpm(struct rpcif *rpc)
 {
-	pm_runtime_put_sync(rpc->dev);
+	pm_runtime_disable(rpc->dev);
 }
 EXPORT_SYMBOL(rpcif_disable_rpm);
 


