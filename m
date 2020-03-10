Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 40BD417FC1A
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 14:18:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731310AbgCJNKS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 09:10:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:59598 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731313AbgCJNKR (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 09:10:17 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CFD462468C;
        Tue, 10 Mar 2020 13:10:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583845816;
        bh=MjftV02fkHbcXmGv+eBttb48zfa/BdDIjySLYODfq0E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jeSQRKbX1xr0cKzZCSseKo0o/kx2h9mw7zmXjOZUyuBFRBNdG94od/QuzGNmQ7C4X
         w7mzNHM4q2aCmoOdcfQAHxFWgQZKGaQFnkLeoImlF5XTeHTlaPt26sVYOYIKAap2Hx
         ztXdFlCrkdIx5G1clk6EE+u0bSxhIzuPvGKDd/bI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dragos Tarcatu <dragos_tarcatu@mentor.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 4.14 111/126] ASoC: topology: Fix memleak in soc_tplg_link_elems_load()
Date:   Tue, 10 Mar 2020 13:42:12 +0100
Message-Id: <20200310124210.649737497@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200310124203.704193207@linuxfoundation.org>
References: <20200310124203.704193207@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dragos Tarcatu <dragos_tarcatu@mentor.com>

commit 2b2d5c4db732c027a14987cfccf767dac1b45170 upstream.

If soc_tplg_link_config() fails, _link needs to be freed in case of
topology ABI version mismatch. However the current code is returning
directly and ends up leaking memory in this case.
This patch fixes that.

Fixes: 593d9e52f9bb ("ASoC: topology: Add support to configure existing physical DAI links")
Signed-off-by: Dragos Tarcatu <dragos_tarcatu@mentor.com>
Link: https://lore.kernel.org/r/20200207185325.22320-2-dragos_tarcatu@mentor.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/soc-topology.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/sound/soc/soc-topology.c
+++ b/sound/soc/soc-topology.c
@@ -2177,8 +2177,11 @@ static int soc_tplg_link_elems_load(stru
 		}
 
 		ret = soc_tplg_link_config(tplg, _link);
-		if (ret < 0)
+		if (ret < 0) {
+			if (!abi_match)
+				kfree(_link);
 			return ret;
+		}
 
 		/* offset by version-specific struct size and
 		 * real priv data size


