Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5015B499A88
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:55:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1573426AbiAXVoz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:44:55 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:54704 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1455653AbiAXVfu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:35:50 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E3644612D6;
        Mon, 24 Jan 2022 21:35:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3A71C340E4;
        Mon, 24 Jan 2022 21:35:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643060149;
        bh=c+uXVpEUnHmPsK3iUyPSRcXmijXiLM2c/xPdjDxUO1c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TQPehGL/13D+lqZaEZLMCljDNvkN+5+JvfAqODoh49DAxAzdLShFzkDPlN2aNgJcC
         pPtEHsu+fPfSjt5DaxbRyRb8GT7Li1Ez0/imZZp+pIqpN7e2a7zhry9PxgoLUCk4SW
         LSHRF2VQ9V1h4cdz/ghGdGjrySMJDFghov7Gi4m4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Peng Fan <peng.fan@nxp.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>
Subject: [PATCH 5.16 0855/1039] remoteproc: imx_rproc: Fix a resource leak in the remove function
Date:   Mon, 24 Jan 2022 19:44:04 +0100
Message-Id: <20220124184154.023924763@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

commit 4da96175014be67c846fd274eace08066e525d75 upstream.

'priv->workqueue' is destroyed in the error handling path of the probe but
not in the remove function.

Add the missing call to release some resources.

Cc: stable <stable@vger.kernel.org>
Fixes: 2df7062002d0 ("remoteproc: imx_proc: enable virtio/mailbox")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Reviewed-by: Peng Fan <peng.fan@nxp.com>
Tested-by: Peng Fan <peng.fan@nxp.com>
Link: https://lore.kernel.org/r/d28ca94a4031bd7297d47c2164e18885a5a6ec19.1634366546.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/remoteproc/imx_rproc.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/remoteproc/imx_rproc.c
+++ b/drivers/remoteproc/imx_rproc.c
@@ -804,6 +804,7 @@ static int imx_rproc_remove(struct platf
 	clk_disable_unprepare(priv->clk);
 	rproc_del(rproc);
 	imx_rproc_free_mbox(rproc);
+	destroy_workqueue(priv->workqueue);
 	rproc_free(rproc);
 
 	return 0;


