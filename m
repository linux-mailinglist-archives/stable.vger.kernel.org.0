Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91C5424B857
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 13:18:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728834AbgHTLR5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 07:17:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:39894 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730305AbgHTKIL (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 06:08:11 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DB0002067C;
        Thu, 20 Aug 2020 10:08:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597918091;
        bh=eQHLXXOPZUp7EIkYRyaxbfJIa9qUIejXd8pgy1zPkpw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kig3JS05NB8j78q/npjXo0ZpNpOAivYzE+yAJb06PSfA6oda4Bi5F5lN/K5CKslUn
         nGof1UgmPtW2xDS47lLIb4tea6WuX1FzM7Y668nu4Go3FsZyMrVr7AToHGKWntYadk
         30orXFvDNNJCLoFdavmcwIWqFqnEoFPYIwNHQpvU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Alain Volmat <alain.volmat@st.com>,
        Wolfram Sang <wsa@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 022/228] i2c: slave: improve sanity check when registering
Date:   Thu, 20 Aug 2020 11:19:57 +0200
Message-Id: <20200820091608.641986122@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091607.532711107@linuxfoundation.org>
References: <20200820091607.532711107@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wolfram Sang <wsa+renesas@sang-engineering.com>

[ Upstream commit 1b1be3bf27b62f5abcf85c6f3214bdb9c7526685 ]

Add check for ERR_PTR and simplify code while here.

Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Reviewed-by: Alain Volmat <alain.volmat@st.com>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/i2c-core-slave.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/i2c/i2c-core-slave.c b/drivers/i2c/i2c-core-slave.c
index 4a78c65e99713..21051aba39e3a 100644
--- a/drivers/i2c/i2c-core-slave.c
+++ b/drivers/i2c/i2c-core-slave.c
@@ -22,10 +22,8 @@ int i2c_slave_register(struct i2c_client *client, i2c_slave_cb_t slave_cb)
 {
 	int ret;
 
-	if (!client || !slave_cb) {
-		WARN(1, "insufficient data\n");
+	if (WARN(IS_ERR_OR_NULL(client) || !slave_cb, "insufficient data\n"))
 		return -EINVAL;
-	}
 
 	if (!(client->flags & I2C_CLIENT_SLAVE))
 		dev_warn(&client->dev, "%s: client slave flag not set. You might see address collisions\n",
-- 
2.25.1



