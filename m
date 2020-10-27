Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6529A29C377
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 18:47:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1822079AbgJ0Rqp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 13:46:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:52208 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2901788AbgJ0O01 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:26:27 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 85D26207C3;
        Tue, 27 Oct 2020 14:26:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603808787;
        bh=h3lhKVwNNqO84gRm1v6CxPFXZOUV0dnlo5dbHzA65SM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nUeAyACD81McX038kc+rD3+wy8xSEBxdzZ3HZzZ8iEVrZXVmewBajfhTA/iv/d5xT
         mnMxUf3H0FCJZQO7qmzzaNJjrkxSzCaDx6I9nCVgRC3yiITEG8ZzA4m8dBL3ZFzKwY
         a1GDp9bm1RU+r3Rwfj7FrJE4KM9p45k8Z2na1KTM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dinghao Liu <dinghao.liu@zju.edu.cn>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 224/264] media: venus: core: Fix runtime PM imbalance in venus_probe
Date:   Tue, 27 Oct 2020 14:54:42 +0100
Message-Id: <20201027135441.195776903@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135430.632029009@linuxfoundation.org>
References: <20201027135430.632029009@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dinghao Liu <dinghao.liu@zju.edu.cn>

[ Upstream commit bbe516e976fce538db96bd2b7287df942faa14a3 ]

pm_runtime_get_sync() increments the runtime PM usage counter even
when it returns an error code. Thus a pairing decrement is needed on
the error handling path to keep the counter balanced. For other error
paths after this call, things are the same.

Fix this by adding pm_runtime_put_noidle() after 'err_runtime_disable'
label. But in this case, the error path after pm_runtime_put_sync()
will decrease PM usage counter twice. Thus add an extra
pm_runtime_get_noresume() in this path to balance PM counter.

Signed-off-by: Dinghao Liu <dinghao.liu@zju.edu.cn>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/qcom/venus/core.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/qcom/venus/core.c b/drivers/media/platform/qcom/venus/core.c
index 60069869596cb..168f5af6abcc2 100644
--- a/drivers/media/platform/qcom/venus/core.c
+++ b/drivers/media/platform/qcom/venus/core.c
@@ -321,8 +321,10 @@ static int venus_probe(struct platform_device *pdev)
 		goto err_dev_unregister;
 
 	ret = pm_runtime_put_sync(dev);
-	if (ret)
+	if (ret) {
+		pm_runtime_get_noresume(dev);
 		goto err_dev_unregister;
+	}
 
 	return 0;
 
@@ -333,6 +335,7 @@ static int venus_probe(struct platform_device *pdev)
 err_venus_shutdown:
 	venus_shutdown(dev);
 err_runtime_disable:
+	pm_runtime_put_noidle(dev);
 	pm_runtime_set_suspended(dev);
 	pm_runtime_disable(dev);
 	hfi_destroy(core);
-- 
2.25.1



