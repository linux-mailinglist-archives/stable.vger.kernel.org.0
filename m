Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 940482C69FB
	for <lists+stable@lfdr.de>; Fri, 27 Nov 2020 17:46:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732067AbgK0QpS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Nov 2020 11:45:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732016AbgK0QpR (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 Nov 2020 11:45:17 -0500
Received: from mail-qt1-x842.google.com (mail-qt1-x842.google.com [IPv6:2607:f8b0:4864:20::842])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21F59C0613D1;
        Fri, 27 Nov 2020 08:45:17 -0800 (PST)
Received: by mail-qt1-x842.google.com with SMTP id l2so3619059qtq.4;
        Fri, 27 Nov 2020 08:45:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=i2g5RlcMC1OKkB3CqAd7m4FXPBG2xp6CscrhYJvT8IQ=;
        b=d/+U+xBoWnkzY6oSY6/UTe4YfzRG1Vdaxeax4mo5vWExRzt+9gDkgxJ8qz8hR30bLT
         isP7/bBPyz0nrRPVhn+IsK3DWEW+T4CMluQcQVXs8vBA2oPWVTFqf0V9uRt1bTlBeHVt
         Xrj2HExDHRkddeODw37EVMd4zT9L5g4rzzYWS/k+P50Kln82VKzBw/yzbOgUkS/mdPk8
         FQN88ONjVIxTLyVxO/hzrjdBgLaRhVWYUaQbS74ba5SQlY6U3+DD2SRThPz1HevjgZsK
         spdL1S9TfiVwG/MelDGbn0YUH1JIyBZZlhLxf54sRYLabzR7bgaD2NvVQpHwDBWB40W1
         6amA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=i2g5RlcMC1OKkB3CqAd7m4FXPBG2xp6CscrhYJvT8IQ=;
        b=UCeP0XFDqYfAn8tlldIw3opCxdjm3W/d3NSH5AQFqeTIi8Wp1/P2i9TtU8HrkoSYJ9
         9gxiKDEG9ZEB1cVSRymndwnpcyDLFvJhzgjxgSxRbaBriPGJ2qPpzjkCJp1bGwE0SJji
         czC18aJ88D77O1pGHMylBbo8c7d2/HqO2PgoLJBDd9/AZhQniCz1q+4JQM4RoCoNzouK
         AT6JnHD9O6EPeCgYOt+BUYuiQTrLvsIj5J1dsn6tzTb8AxIM8U2C4rPsN1Pv3yAoe63b
         S7/vCG7+vWA94NwusjN4uLaxeWYjxUMeZqfR0VUBjKrjqFle+w7oXw8dF1FsyYWvRisx
         ERDw==
X-Gm-Message-State: AOAM533qiMddJpWgvDe3dfoabuTHqKP5dhT2KNGtXbCNLBKa71k6LATc
        Y8lr6deZRAtrNQp1XXvAqO4=
X-Google-Smtp-Source: ABdhPJxomW0x5v3VHRl2dIe53Fo/I1cPCmB84rDG2E5XqOMhOlBIZpAuzlB32NK9iCslNbwCBpvedg==
X-Received: by 2002:aed:3025:: with SMTP id 34mr9047908qte.39.1606495516323;
        Fri, 27 Nov 2020 08:45:16 -0800 (PST)
Received: from localhost.localdomain ([2804:14c:482:c91:9ce8:56e7:5368:ece8])
        by smtp.gmail.com with ESMTPSA id u13sm6072786qta.87.2020.11.27.08.45.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Nov 2020 08:45:15 -0800 (PST)
From:   Fabio Estevam <festevam@gmail.com>
To:     Peter.Chen@nxp.com
Cc:     gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        Fabio Estevam <festevam@gmail.com>, stable@vger.kernel.org
Subject: [PATCH] usb: chipidea: ci_hdrc_imx: Pass DISABLE_STREAMING flag to imx6ul
Date:   Fri, 27 Nov 2020 13:44:52 -0300
Message-Id: <20201127164452.3830-1-festevam@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

According to the i.MX6UL Errata document:
https://www.nxp.com/docs/en/errata/IMX6ULCE.pdf

ERR007881 also affects i.MX6UL, so pass the CI_HDRC_DISABLE_STREAMING
flag to workaround the issue.

Cc: <stable@vger.kernel.org>
Fixes: 52fe568e5d71 ("usb: chipidea: imx: add imx6ul usb support")
Signed-off-by: Fabio Estevam <festevam@gmail.com>
---
 drivers/usb/chipidea/ci_hdrc_imx.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/chipidea/ci_hdrc_imx.c b/drivers/usb/chipidea/ci_hdrc_imx.c
index 25c65accf089..e111009cc49e 100644
--- a/drivers/usb/chipidea/ci_hdrc_imx.c
+++ b/drivers/usb/chipidea/ci_hdrc_imx.c
@@ -57,7 +57,8 @@ static const struct ci_hdrc_imx_platform_flag imx6sx_usb_data = {
 
 static const struct ci_hdrc_imx_platform_flag imx6ul_usb_data = {
 	.flags = CI_HDRC_SUPPORTS_RUNTIME_PM |
-		CI_HDRC_TURN_VBUS_EARLY_ON,
+		CI_HDRC_TURN_VBUS_EARLY_ON |
+		CI_HDRC_DISABLE_STREAMING,
 };
 
 static const struct ci_hdrc_imx_platform_flag imx7d_usb_data = {
-- 
2.17.1

