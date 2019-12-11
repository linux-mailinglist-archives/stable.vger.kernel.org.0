Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 84BE511B713
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 17:05:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731319AbfLKQFN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 11:05:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:35376 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731252AbfLKPMy (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:12:54 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 602BB24658;
        Wed, 11 Dec 2019 15:12:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077173;
        bh=6FNxpNp+hoECWh0+kePorVfjimC+84RVOjnjeC0s1uw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TUkoghtiwHlIPopKBDHFb+GSA5EU9e/Z7qhay6R96U5gHWkwhNT3mQuernbc/pW6u
         5rbZOFFQLUSaYaFaWf4QD+sPG7o9zr8TmY7c8yJ2lr+YjTNGT4S15bBiatVKN8ByxE
         TQWW30I4+Mgdg/G85MrSxIZIIx8iQs5XimLRT9lY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wen Yang <wenyang@linux.alibaba.com>,
        Wolfram Sang <wsa@the-dreams.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 043/105] i2c: core: fix use after free in of_i2c_notify
Date:   Wed, 11 Dec 2019 16:05:32 +0100
Message-Id: <20191211150238.151620396@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191211150221.153659747@linuxfoundation.org>
References: <20191211150221.153659747@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wen Yang <wenyang@linux.alibaba.com>

[ Upstream commit a4c2fec16f5e6a5fee4865e6e0e91e2bc2d10f37 ]

We can't use "adap->dev" after it has been freed.

Fixes: 5bf4fa7daea6 ("i2c: break out OF support into separate file")
Signed-off-by: Wen Yang <wenyang@linux.alibaba.com>
Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/i2c-core-of.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/i2c/i2c-core-of.c b/drivers/i2c/i2c-core-of.c
index d1c48dec7118e..9b2fce4906c41 100644
--- a/drivers/i2c/i2c-core-of.c
+++ b/drivers/i2c/i2c-core-of.c
@@ -250,14 +250,14 @@ static int of_i2c_notify(struct notifier_block *nb, unsigned long action,
 		}
 
 		client = of_i2c_register_device(adap, rd->dn);
-		put_device(&adap->dev);
-
 		if (IS_ERR(client)) {
 			dev_err(&adap->dev, "failed to create client for '%pOF'\n",
 				 rd->dn);
+			put_device(&adap->dev);
 			of_node_clear_flag(rd->dn, OF_POPULATED);
 			return notifier_from_errno(PTR_ERR(client));
 		}
+		put_device(&adap->dev);
 		break;
 	case OF_RECONFIG_CHANGE_REMOVE:
 		/* already depopulated? */
-- 
2.20.1



