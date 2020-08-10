Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61A6D24097F
	for <lists+stable@lfdr.de>; Mon, 10 Aug 2020 17:33:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728384AbgHJPcv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Aug 2020 11:32:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:36954 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728678AbgHJPaN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Aug 2020 11:30:13 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 03B8522D74;
        Mon, 10 Aug 2020 15:30:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597073413;
        bh=O8uxpY19oMyTmj5VGnKGFEp+hLgqpN7HCtchkQbSam4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jiiBHXRXWpzBWbFQ7OJVPm5UgI6i58IiYUAVpp3hl01zHk8BjPbRV/mL+wSYnQb5Q
         4ItqS639oOzZNMjqKhAD3OTM5c+hphFKszxk8zT3Y6FiVC5uabRHdM3ZoHl1Vx32YG
         U7oKuV4W2jlIgcC6FpaCDPVm3gPt7NQtsiPjL0ts=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Alain Volmat <alain.volmat@st.com>,
        Wolfram Sang <wsa@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 23/48] i2c: slave: add sanity check when unregistering
Date:   Mon, 10 Aug 2020 17:21:45 +0200
Message-Id: <20200810151805.359915557@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200810151804.199494191@linuxfoundation.org>
References: <20200810151804.199494191@linuxfoundation.org>
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
index 88959c8580ce0..f2e7e373ee478 100644
--- a/drivers/i2c/i2c-core-slave.c
+++ b/drivers/i2c/i2c-core-slave.c
@@ -62,6 +62,9 @@ int i2c_slave_unregister(struct i2c_client *client)
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



