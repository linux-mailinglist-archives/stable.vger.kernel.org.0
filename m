Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FEE02409D5
	for <lists+stable@lfdr.de>; Mon, 10 Aug 2020 17:36:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728481AbgHJPgP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Aug 2020 11:36:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:33290 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728745AbgHJP1Y (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Aug 2020 11:27:24 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4612222CF7;
        Mon, 10 Aug 2020 15:27:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597073243;
        bh=gQWng/bO5oR+BA08SNco2VcnZgToS77LbevgmS+C7z4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iJ3NFIqZlN9oNRRv4uQj2NqS0Pi2hF5USVikDk2Yk4yL9BzRsCZ2uhaMG8fDIbl5t
         UVuBTLHsdhmFEY6Af62rcRwa4ovY8m6b7lud84qJhdQntR87GeIcZM1ZCLkizvOCCz
         LRxSn5HSVwIeO+tpArPDSaE1Smrx0fBs+PnRKNAU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Alain Volmat <alain.volmat@st.com>,
        Wolfram Sang <wsa@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 37/67] i2c: slave: add sanity check when unregistering
Date:   Mon, 10 Aug 2020 17:21:24 +0200
Message-Id: <20200810151811.269933247@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200810151809.438685785@linuxfoundation.org>
References: <20200810151809.438685785@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wolfram Sang <wsa+renesas@sang-engineering.com>

[ Upstream commit 8808981baf96e1b3dea1f08461e4d958aa0dbde1 ]

Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Reviewed-by: Alain Volmat <alain.volmat@st.com>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/i2c-core-slave.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/i2c/i2c-core-slave.c b/drivers/i2c/i2c-core-slave.c
index 549751347e6c7..1589179d5eb92 100644
--- a/drivers/i2c/i2c-core-slave.c
+++ b/drivers/i2c/i2c-core-slave.c
@@ -58,6 +58,9 @@ int i2c_slave_unregister(struct i2c_client *client)
 {
 	int ret;
 
+	if (IS_ERR_OR_NULL(client))
+		return -EINVAL;
+
 	if (!client->adapter->algo->unreg_slave) {
 		dev_err(&client->dev, "%s: not supported by adapter\n", __func__);
 		return -EOPNOTSUPP;
-- 
2.25.1



