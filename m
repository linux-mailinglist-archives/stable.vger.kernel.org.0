Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA87D2E3F06
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:38:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2504799AbgL1Ocq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:32:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:40716 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2504793AbgL1Ocp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:32:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 542DE20791;
        Mon, 28 Dec 2020 14:32:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165924;
        bh=oEpAsOXC8JAkhskm4KmIIR73+oZa6SuIWEHqgz7/hek=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ouOOfjDnlgu2ceX+5bbGEndA0GrjTrhVKap/SAnlrIBqjJ1yZhB5KU9COPhCfq7eZ
         TBJWQ8vZKukQ7WRKg6Y0G/mk8R92XWXo7omxOamZsq7neFhmla7Eqw7gJqBA/BL6R7
         a/tN33w8GVx/NbtjLUhCy0A1jymyo9sF6BQN+FbM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Machek <pavel@denx.de>,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Krzysztof Kozlowski <krzk@kernel.org>
Subject: [PATCH 5.10 703/717] memory: renesas-rpc-if: Return correct value to the caller of rpcif_manual_xfer()
Date:   Mon, 28 Dec 2020 13:51:41 +0100
Message-Id: <20201228125054.665891197@linuxfoundation.org>
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

commit a0453f4ed066cae651b3119ed11f52d31dae1eca upstream.

In the error path of rpcif_manual_xfer() the value of ret is overwritten
by value returned by reset_control_reset() function and thus returning
incorrect value to the caller.

This patch makes sure the correct value is returned to the caller of
rpcif_manual_xfer() by dropping the overwrite of ret in error path.
Also now we ignore the value returned by reset_control_reset() in the
error path and instead print a error message when it fails.

Fixes: ca7d8b980b67f ("memory: add Renesas RPC-IF driver")
Reported-by: Pavel Machek <pavel@denx.de>
Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Reviewed-by: Sergei Shtylyov <sergei.shtylyov@gmail.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Pavel Machek (CIP) <pavel@denx.de>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20201126191146.8753-2-prabhakar.mahadev-lad.rj@bp.renesas.com
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/memory/renesas-rpc-if.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/memory/renesas-rpc-if.c
+++ b/drivers/memory/renesas-rpc-if.c
@@ -508,7 +508,8 @@ exit:
 	return ret;
 
 err_out:
-	ret = reset_control_reset(rpc->rstc);
+	if (reset_control_reset(rpc->rstc))
+		dev_err(rpc->dev, "Failed to reset HW\n");
 	rpcif_hw_init(rpc, rpc->bus_size == 2);
 	goto exit;
 }


