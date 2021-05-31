Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA9C2395D4E
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 15:42:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232559AbhEaNns (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 09:43:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:44436 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232735AbhEaNlu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 09:41:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 824126146D;
        Mon, 31 May 2021 13:28:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622467698;
        bh=bPE/bkTwbqPn4/j/eEHApYSL+2En6euIwbjsMON+rxk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xW8kLRSomZCxMLMDxK6xEQ97g4i02Q02DW21mle8j96li0IGl6ehMFtDb/zx8It7E
         /pahmxVMmLQcSHhkqig8nOp/uLu9MRlq2lVcT6byut5esaXlNriUC9GcTih5imnO36
         fr9TziXsQkMD9K7Q+23vNIf0uFHp6tJZvhzZ+en8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Anirudh Rayabharam <mail@anirudhrb.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 47/79] net: fujitsu: fix potential null-ptr-deref
Date:   Mon, 31 May 2021 15:14:32 +0200
Message-Id: <20210531130637.519141089@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130636.002722319@linuxfoundation.org>
References: <20210531130636.002722319@linuxfoundation.org>
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
index a69cd19a55ae..b8fc9bbeca2c 100644
--- a/drivers/net/ethernet/fujitsu/fmvj18x_cs.c
+++ b/drivers/net/ethernet/fujitsu/fmvj18x_cs.c
@@ -547,6 +547,11 @@ static int fmvj18x_get_hwinfo(struct pcmcia_device *link, u_char *node_id)
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



