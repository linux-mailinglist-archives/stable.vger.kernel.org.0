Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E9EE66DF7
	for <lists+stable@lfdr.de>; Fri, 12 Jul 2019 14:35:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729011AbfGLMeo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Jul 2019 08:34:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:54784 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729776AbfGLMen (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 12 Jul 2019 08:34:43 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F2EAA20645;
        Fri, 12 Jul 2019 12:34:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562934882;
        bh=QRsSF+WCZ0+JMAzHJH/vuxQnavogD9WLbjsinyx27Ys=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2JkX3/k44K3G+L6RLPO3oxjmKeY6GvRuhCy061ATi5XXImPZSL08huRt4AGt4JPFb
         Jagh427nZadsJR/lLpDluJ/KA+hFQWsM+4RFHjvPpsl76aGPk9xeEIkNEwdALtqIwT
         WdPMOxFNFeLsAS5we6Pcu8ezMlLjhWit+jl9jInc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>
Subject: [PATCH 5.2 45/61] coresight: Potential uninitialized variable in probe()
Date:   Fri, 12 Jul 2019 14:19:58 +0200
Message-Id: <20190712121623.044961135@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190712121620.632595223@linuxfoundation.org>
References: <20190712121620.632595223@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

commit 0530ef6b41e80c5cc979e0e50682302161edb6b7 upstream.

The "drvdata->atclk" clock is optional, but if it gets set to an error
pointer then we're accidentally return an uninitialized variable instead
of success.

Fixes: 78e6427b4e7b ("coresight: funnel: Support static funnel")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20190620221237.3536-6-mathieu.poirier@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hwtracing/coresight/coresight-funnel.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/hwtracing/coresight/coresight-funnel.c
+++ b/drivers/hwtracing/coresight/coresight-funnel.c
@@ -241,6 +241,7 @@ static int funnel_probe(struct device *d
 	}
 
 	pm_runtime_put(dev);
+	ret = 0;
 
 out_disable_clk:
 	if (ret && !IS_ERR_OR_NULL(drvdata->atclk))


