Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 651742F65A
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:55:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728022AbfE3EzX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 00:55:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:46760 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728009AbfE3DKQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:10:16 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7747724481;
        Thu, 30 May 2019 03:10:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559185815;
        bh=W3deDqBV973O01uZLmx5KBYNQkKfVaEZ3DxcfVjdSI0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K1Pth8+B/LG4yUxyEYNzNsN9hEo+KyXDUZbrPuWjV/iI/AJ+mlu5NOH1679bRdi5b
         nouOmQSoNd5MIn8bYj6N8/viDMbgdzwJTKOxQYy95+CvvBiwM31fMQSt02KZfDNYyl
         N+Z88BImvkarYSMf7uP9l0qNLziOI3TAh7k7nXzM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mariusz Bialonczyk <manio@skyboo.net>,
        Jean-Francois Dagenais <jeff.dagenais@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 107/405] w1: fix the resume command API
Date:   Wed, 29 May 2019 20:01:45 -0700
Message-Id: <20190530030546.416704217@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030540.291644921@linuxfoundation.org>
References: <20190530030540.291644921@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 62909da8aca048ecf9fbd7e484e5100608f40a63 ]

>From the DS2408 datasheet [1]:
"Resume Command function checks the status of the RC flag and, if it is set,
 directly transfers control to the control functions, similar to a Skip ROM
 command. The only way to set the RC flag is through successfully executing
 the Match ROM, Search ROM, Conditional Search ROM, or Overdrive-Match ROM
 command"

The function currently works perfectly fine in a multidrop bus, but when we
have only a single slave connected, then only a Skip ROM is used and Match
ROM is not called at all. This is leading to problems e.g. with single one
DS2408 connected, as the Resume Command is not working properly and the
device is responding with failing results after the Resume Command.

This commit is fixing this by using a Skip ROM instead in those cases.
The bandwidth / performance advantage is exactly the same.

Refs:
[1] https://datasheets.maximintegrated.com/en/ds/DS2408.pdf

Signed-off-by: Mariusz Bialonczyk <manio@skyboo.net>
Reviewed-by: Jean-Francois Dagenais <jeff.dagenais@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/w1/w1_io.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/w1/w1_io.c b/drivers/w1/w1_io.c
index 0364d3329c526..3516ce6718d94 100644
--- a/drivers/w1/w1_io.c
+++ b/drivers/w1/w1_io.c
@@ -432,8 +432,7 @@ int w1_reset_resume_command(struct w1_master *dev)
 	if (w1_reset_bus(dev))
 		return -1;
 
-	/* This will make only the last matched slave perform a skip ROM. */
-	w1_write_8(dev, W1_RESUME_CMD);
+	w1_write_8(dev, dev->slave_count > 1 ? W1_RESUME_CMD : W1_SKIP_ROM);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(w1_reset_resume_command);
-- 
2.20.1



