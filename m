Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA1FD261D99
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 21:39:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731236AbgIHTji (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 15:39:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:43440 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730771AbgIHPyo (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Sep 2020 11:54:44 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1027423D39;
        Tue,  8 Sep 2020 15:36:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599579415;
        bh=jM6IB0v+v1V4/B12e5UVcDfxYlq6ajKbVOXUjhGpzwk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gNqzvqMg+0d+O6Q5asU4ovo1H2nDSFUCCujRmetiQivrGL4VrZ84050iUa1M6j6Oe
         +QH+TarNHs7jZLVjjMhAgL/+7BZiBDQfy/I9zVKldkFBMOAFOHTYEaXGgQIohFEiMm
         AIxecoK/xw4drRIZsGh3AvaxHkUqhhZH6BvCLL7g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>,
        Michael Chan <michael.chan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 068/186] bnxt_en: Check for zero dir entries in NVRAM.
Date:   Tue,  8 Sep 2020 17:23:30 +0200
Message-Id: <20200908152244.954126578@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200908152241.646390211@linuxfoundation.org>
References: <20200908152241.646390211@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vasundhara Volam <vasundhara-v.volam@broadcom.com>

[ Upstream commit dbbfa96ad920c50d58bcaefa57f5f33ceef9d00e ]

If firmware goes into unstable state, HWRM_NVM_GET_DIR_INFO firmware
command may return zero dir entries. Return error in such case to
avoid zero length dma buffer request.

Fixes: c0c050c58d84 ("bnxt_en: New Broadcom ethernet driver.")
Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
index dcb3f61af7ab0..309b73a665ba2 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
@@ -2270,6 +2270,9 @@ static int bnxt_get_nvram_directory(struct net_device *dev, u32 len, u8 *data)
 	if (rc != 0)
 		return rc;
 
+	if (!dir_entries || !entry_length)
+		return -EIO;
+
 	/* Insert 2 bytes of directory info (count and size of entries) */
 	if (len < 2)
 		return -EINVAL;
-- 
2.25.1



