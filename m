Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D440101456
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 06:32:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729458AbfKSFcw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:32:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:53262 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729456AbfKSFcw (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:32:52 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 05F8D21783;
        Tue, 19 Nov 2019 05:32:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574141571;
        bh=fTe/6jv6vp2P2ZrGxFtNky6NeEAfIueFoy7sJP/UR2c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MpkXx4AG63W3WHap3Q+BEeQT71MEoljTR5P8b6FgTE3+QtUQEFg+1EkOdYpDOeVe5
         UVyyVA4yOnyDaBM5iEZ4V4bMe/Z3mof55ng+p94AILNXJorLMrQgrVGZL+jRpN8mrp
         mIJQnt47cfm/jhmiEBxHt+s5ExS98pUSyC/GT3vo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Niklas Cassel <niklas.cassel@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Andy Gross <andy.gross@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 206/422] soc: qcom: wcnss_ctrl: Avoid string overflow
Date:   Tue, 19 Nov 2019 06:16:43 +0100
Message-Id: <20191119051411.937179384@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119051400.261610025@linuxfoundation.org>
References: <20191119051400.261610025@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Niklas Cassel <niklas.cassel@linaro.org>

[ Upstream commit 4c96ed170d658d8826d94edec8ac93ee777981a2 ]

'chinfo.name' is used as a NUL-terminated string, but using strncpy() with
the length equal to the buffer size may result in lack of the termination:

drivers//soc/qcom/wcnss_ctrl.c: In function 'qcom_wcnss_open_channel':
drivers//soc/qcom/wcnss_ctrl.c:284:2: warning: 'strncpy' specified bound 32 equals destination size [-Wstringop-truncation]
  strncpy(chinfo.name, name, sizeof(chinfo.name));
  ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

This changes it to use the safer strscpy() instead.

Signed-off-by: Niklas Cassel <niklas.cassel@linaro.org>
Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Andy Gross <andy.gross@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/qcom/wcnss_ctrl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/soc/qcom/wcnss_ctrl.c b/drivers/soc/qcom/wcnss_ctrl.c
index df3ccb30bc2dd..373400dd816d6 100644
--- a/drivers/soc/qcom/wcnss_ctrl.c
+++ b/drivers/soc/qcom/wcnss_ctrl.c
@@ -281,7 +281,7 @@ struct rpmsg_endpoint *qcom_wcnss_open_channel(void *wcnss, const char *name, rp
 	struct rpmsg_channel_info chinfo;
 	struct wcnss_ctrl *_wcnss = wcnss;
 
-	strncpy(chinfo.name, name, sizeof(chinfo.name));
+	strscpy(chinfo.name, name, sizeof(chinfo.name));
 	chinfo.src = RPMSG_ADDR_ANY;
 	chinfo.dst = RPMSG_ADDR_ANY;
 
-- 
2.20.1



