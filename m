Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41B2A206566
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 23:50:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387869AbgFWUCh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:02:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:39882 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387826AbgFWUCe (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:02:34 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0618E20E65;
        Tue, 23 Jun 2020 20:02:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592942553;
        bh=doYIYC1XTHjd9FMy2qF65QBoTFvrKESJox7WLeKKOXU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y/cjwCf1Qj5j1IxaJouWRlRf8RaeusGD/95Vd4TMyvBQGXCoiMx2WOLQwCIeNvrPd
         ww+2zht2XA55XPkPdxmtfvRvyMnGAHfXQfvrL5whD3tbEP4bRK/owlnqIRc1K/wNEX
         EjXhTSb1R52S8vFKMiuVelL/V3bb37pINm2db6w0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 044/477] misc: fastrpc: Fix an incomplete memory release in fastrpc_rpmsg_probe()
Date:   Tue, 23 Jun 2020 21:50:41 +0200
Message-Id: <20200623195409.688974397@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195407.572062007@linuxfoundation.org>
References: <20200623195407.572062007@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>

[ Upstream commit 0978de9fc7335c73934ab8fac189fb4cb3f23191 ]

fastrpc_channel_ctx is not freed if misc_register() fails, this would
lead to a memory leak. Fix this leak by adding kfree in misc_register()
error path.

Fixes: 278d56f970ae ("misc: fastrpc: Reference count channel context")
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/20200511162722.2552-1-srinivas.kandagatla@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/fastrpc.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/misc/fastrpc.c b/drivers/misc/fastrpc.c
index e3e085e33d46b..9065d3e71ff76 100644
--- a/drivers/misc/fastrpc.c
+++ b/drivers/misc/fastrpc.c
@@ -1613,8 +1613,10 @@ static int fastrpc_rpmsg_probe(struct rpmsg_device *rpdev)
 					    domains[domain_id]);
 	data->miscdev.fops = &fastrpc_fops;
 	err = misc_register(&data->miscdev);
-	if (err)
+	if (err) {
+		kfree(data);
 		return err;
+	}
 
 	kref_init(&data->refcount);
 
-- 
2.25.1



