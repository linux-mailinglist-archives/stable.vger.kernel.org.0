Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EF2B1FE8BF
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 04:51:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728507AbgFRCvG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 22:51:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:35216 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728034AbgFRBJG (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jun 2020 21:09:06 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D3E2C21BE5;
        Thu, 18 Jun 2020 01:09:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592442546;
        bh=qqcRd+xS0PYccEaXyI7kdgQx+HoKQW5xSsFSjkSRG7k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T7A2Qo3nnI5wbFSBN/LIWZapkB8bhpfV7ff4cCnn3dkPJJ6MaOpImhmvlBL8t6Iji
         /19c8JFQiaEEF+fGMI9A0eBAsan4JfJMNpODseAqfnwfwNIV9mQa1/sIGkIDflFsA+
         ortFp5IYgDsjeLcJR+pzFZYlQpj+I/wPxM4Mooqw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.7 045/388] misc: fastrpc: Fix an incomplete memory release in fastrpc_rpmsg_probe()
Date:   Wed, 17 Jun 2020 21:02:22 -0400
Message-Id: <20200618010805.600873-45-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618010805.600873-1-sashal@kernel.org>
References: <20200618010805.600873-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index e3e085e33d46..9065d3e71ff7 100644
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

