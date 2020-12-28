Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 008622E3F32
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:38:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392235AbgL1OhV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:37:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:40690 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2504774AbgL1Ocm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:32:42 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8355220739;
        Mon, 28 Dec 2020 14:32:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165922;
        bh=Z8Kcy0ZJWO6UT2FhKqTFgdUpl7TCqwLddwe/UT+spO0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XDgEpY5m6f0pruJY+mHTnNma+2sxdmFTi9RRYvtKw4YYM3dCNUam++bDegVe6iQRV
         XK5EIDw/TIxaoUkipqEFFpFQYaEj87lXpnUmUONyedKcvj2Bn5QXgyWl32SJAklcMd
         rEXPLQk/+jgsjJMhKItVgLSKVN3ksqjqpDpOfxvY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Machek <pavel@denx.de>,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Krzysztof Kozlowski <krzk@kernel.org>
Subject: [PATCH 5.10 702/717] memory: renesas-rpc-if: Fix a node reference leak in rpcif_probe()
Date:   Mon, 28 Dec 2020 13:51:40 +0100
Message-Id: <20201228125054.616851738@linuxfoundation.org>
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

commit 4e6b86b409f9fc63fedb39d6e3a0202c4b0244ce upstream.

Release the node reference by calling of_node_put(flash) in the probe.

Fixes: ca7d8b980b67f ("memory: add Renesas RPC-IF driver")
Reported-by: Pavel Machek <pavel@denx.de>
Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Reviewed-by: Sergei Shtylyov <sergei.shtylyov@gmail.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Pavel Machek (CIP) <pavel@denx.de>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20201126191146.8753-4-prabhakar.mahadev-lad.rj@bp.renesas.com
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/memory/renesas-rpc-if.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/memory/renesas-rpc-if.c
+++ b/drivers/memory/renesas-rpc-if.c
@@ -560,9 +560,11 @@ static int rpcif_probe(struct platform_d
 	} else if (of_device_is_compatible(flash, "cfi-flash")) {
 		name = "rpc-if-hyperflash";
 	} else	{
+		of_node_put(flash);
 		dev_warn(&pdev->dev, "unknown flash type\n");
 		return -ENODEV;
 	}
+	of_node_put(flash);
 
 	vdev = platform_device_alloc(name, pdev->id);
 	if (!vdev)


