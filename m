Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72E8F395BE9
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 15:24:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232163AbhEaNZx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 09:25:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:56434 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231644AbhEaNX5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 09:23:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BC38B613B9;
        Mon, 31 May 2021 13:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622467213;
        bh=V0QDUYX5OnRqA3JrdUeP+0VbvLODVnGZUntGH/PKvOY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jeelXll5K1+LYH/NXWRUTc7TPBKrT2W381tjoCHTri+Nake0KdnY82lSix/yzAmEZ
         CQDSqmaUf67EltnKadttdbUtbruGeZzCZ6+6QT/00qEP3ZR7SDJAB/wou8u5bwvNWF
         hJcjatgP2Y6DcmQCA3/2CTb1mnpQn07ffWsutxAM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Anirudh Rayabharam <mail@anirudhrb.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 40/66] net: fujitsu: fix potential null-ptr-deref
Date:   Mon, 31 May 2021 15:14:13 +0200
Message-Id: <20210531130637.526222221@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130636.254683895@linuxfoundation.org>
References: <20210531130636.254683895@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anirudh Rayabharam <mail@anirudhrb.com>

[ Upstream commit 52202be1cd996cde6e8969a128dc27ee45a7cb5e ]

In fmvj18x_get_hwinfo(), if ioremap fails there will be NULL pointer
deref. To fix this, check the return value of ioremap and return -1
to the caller in case of failure.

Cc: "David S. Miller" <davem@davemloft.net>
Acked-by: Dominik Brodowski <linux@dominikbrodowski.net>
Signed-off-by: Anirudh Rayabharam <mail@anirudhrb.com>
Link: https://lore.kernel.org/r/20210503115736.2104747-16-gregkh@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/fujitsu/fmvj18x_cs.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/fujitsu/fmvj18x_cs.c b/drivers/net/ethernet/fujitsu/fmvj18x_cs.c
index 399cfd217288..cfda55bfa811 100644
--- a/drivers/net/ethernet/fujitsu/fmvj18x_cs.c
+++ b/drivers/net/ethernet/fujitsu/fmvj18x_cs.c
@@ -548,6 +548,11 @@ static int fmvj18x_get_hwinfo(struct pcmcia_device *link, u_char *node_id)
 	return -1;
 
     base = ioremap(link->resource[2]->start, resource_size(link->resource[2]));
+    if (!base) {
+	pcmcia_release_window(link, link->resource[2]);
+	return -1;
+    }
+
     pcmcia_map_mem_page(link, link->resource[2], 0);
 
     /*
-- 
2.30.2



