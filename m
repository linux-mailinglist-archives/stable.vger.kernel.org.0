Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8783237CB7A
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:57:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242741AbhELQfi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:35:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:42822 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241269AbhELQ06 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:26:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BB38861482;
        Wed, 12 May 2021 15:51:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620834664;
        bh=SbmBVnWx0ZTxTl+SNx37/2ZOjZ/08SaEapoZDvz6vhU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kDDVRnPdiC4XEDsYzco2hVpL/KpDcxQw5iJ1TSPiN7f9U9ESyBFh8P61AESMnzoyU
         d2RyrmiDR/7XuD7p19sdYEu2rFWbqPN5exjmClrHlMdHXqG8Uv1wjKS6BIkS1sJpNk
         TxGIlbfhpFBpBboTYAzLFKmMqELn5sR8INl5y6FM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Leo Yan <leo.yan@linaro.org>,
        Mike Leach <mike.leach@linaro.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>
Subject: [PATCH 5.12 005/677] coresight: etm-perf: Fix define build issue when built as module
Date:   Wed, 12 May 2021 16:40:51 +0200
Message-Id: <20210512144837.391014154@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Leach <mike.leach@linaro.org>

commit 9204ff94868496f2d9b8b173af52ec455160c364 upstream.

CONFIG_CORESIGHT_SOURCE_ETM4X is undefined when built as module,
CONFIG_CORESIGHT_SOURCE_ETM4X_MODULE is defined instead.

Therefore code in format_attr_contextid_show() not correctly complied
when coresight built as module.

Use IS_ENABLED(CONFIG_CORESIGHT_SOURCE_ETM4X) to correct this.

Link: https://lore.kernel.org/r/20210414194808.22872-1-mike.leach@linaro.org
Fixes: 88f11864cf1d ("coresight: etm-perf: Support PID tracing for kernel at EL2")
Reviewed-by: Leo Yan <leo.yan@linaro.org>
Signed-off-by: Mike Leach <mike.leach@linaro.org>
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210415202404.945368-2-mathieu.poirier@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hwtracing/coresight/coresight-etm-perf.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/hwtracing/coresight/coresight-etm-perf.c
+++ b/drivers/hwtracing/coresight/coresight-etm-perf.c
@@ -52,7 +52,7 @@ static ssize_t format_attr_contextid_sho
 {
 	int pid_fmt = ETM_OPT_CTXTID;
 
-#if defined(CONFIG_CORESIGHT_SOURCE_ETM4X)
+#if IS_ENABLED(CONFIG_CORESIGHT_SOURCE_ETM4X)
 	pid_fmt = is_kernel_in_hyp_mode() ? ETM_OPT_CTXTID2 : ETM_OPT_CTXTID;
 #endif
 	return sprintf(page, "config:%d\n", pid_fmt);


