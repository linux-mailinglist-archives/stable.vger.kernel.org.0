Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9D1C2C8348
	for <lists+stable@lfdr.de>; Mon, 30 Nov 2020 12:32:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727283AbgK3Lbg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Nov 2020 06:31:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726345AbgK3Lbf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Nov 2020 06:31:35 -0500
Received: from mail-qt1-x844.google.com (mail-qt1-x844.google.com [IPv6:2607:f8b0:4864:20::844])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B272CC0613D2;
        Mon, 30 Nov 2020 03:30:55 -0800 (PST)
Received: by mail-qt1-x844.google.com with SMTP id u21so1992067qtw.11;
        Mon, 30 Nov 2020 03:30:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=M+trhuPUBFP3JQwxSSGofs1PCXGPO8zUFhxjN+RxJTk=;
        b=thJv2e9CevkDgp9T99+nyHwvCqRFoB33hNNgH+NJXQkDqjbFavjlPNE6x7H0gDP7sM
         ePz0GCv8LCr5HtNk94F9riuL/c5Z6V/h3PJx9MmaJgeZSXww5AtnyMrFvWITWG68WWuY
         WUetkGkcBn7COkmcOS5fikctSpkzDBgpYvFcv4EhchgWa3i73iUOZ84RZjnJAppCYa6K
         7+QpGzZRgo87escIpsJDJu5VnyMs2gwcioyw+uNqr/5onw/m1Z1O9MsM4RklycW7KzSJ
         gcxuiHIqAh/WY/a3RVf2l5klfpdOv9fQD42R7Xy6Cj+9KKLRWFsqvSpEdPsXlUYJMRFU
         1s/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=M+trhuPUBFP3JQwxSSGofs1PCXGPO8zUFhxjN+RxJTk=;
        b=aTbJWEgAzpXHPreQHc6XSCAwHvrBiZHmqMNvAVmDE9bbBWbeuEH5Vv9LdLhO0Uolmj
         CJCxw8aIhVqbL/yMssFYHDJ7bZz1ZVNP4Q66ljVeqylHmmaXHeUVvJcKW/Ob16sJ0+Zu
         FMozNr9Y5bZb+O8AF6Gs1XKa0NeSTvcZoE7tc98+7UPKBIoOxFnupTuKk4vYmMyqaLzU
         //dLro0zaNWm05RaVaN4qZyGyLwr5yiUHPUe6Pouj9lgUm9jCR9LfGtQUKTGfYL5GUQR
         fTgsFVy+go/hIPfFzaAjJhDFBYnPfVduQOEHgtcOlrQ2hWm8OgHHIfHbb3xDu62X7pN4
         ym2Q==
X-Gm-Message-State: AOAM533pgp09li2Cz4QewRzRmJtsB4tj/f+KohZEhaN5t9An5yfpk8Oi
        N0SU/H5ukoR8J92BPI5z6uprzChGOP3Piw==
X-Google-Smtp-Source: ABdhPJyJrp5D8aX96IDFdmbDR+W80+MzTyXPsDOGHMDq4gXqm3VOwlb1wJRj0FKh3/1sPxILvU/phw==
X-Received: by 2002:ac8:4507:: with SMTP id q7mr21413019qtn.49.1606735854824;
        Mon, 30 Nov 2020 03:30:54 -0800 (PST)
Received: from localhost.localdomain ([177.194.72.74])
        by smtp.gmail.com with ESMTPSA id o13sm14307852qkm.78.2020.11.30.03.30.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Nov 2020 03:30:54 -0800 (PST)
From:   Fabio Estevam <festevam@gmail.com>
To:     gregkh@linuxfoundation.org
Cc:     Peter.Chen@nxp.com, linux-usb@vger.kernel.org,
        Fabio Estevam <festevam@gmail.com>, stable@vger.kernel.org
Subject: [PATCH v2] usb: chipidea: ci_hdrc_imx: Pass DISABLE_DEVICE_STREAMING flag to imx6ul
Date:   Mon, 30 Nov 2020 08:30:47 -0300
Message-Id: <20201130113047.9659-1-festevam@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

According to the i.MX6UL Errata document:
https://www.nxp.com/docs/en/errata/IMX6ULCE.pdf

ERR007881 also affects i.MX6UL, so pass the
CI_HDRC_DISABLE_DEVICE_STREAMING flag to workaround the issue.

Cc: <stable@vger.kernel.org>
Fixes: 52fe568e5d71 ("usb: chipidea: imx: add imx6ul usb support")
Signed-off-by: Fabio Estevam <festevam@gmail.com>
---
Changes since v1:
- Use the CI_HDRC_DISABLE_DEVICE_STREAMING flag instead - Peter

 drivers/usb/chipidea/ci_hdrc_imx.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/chipidea/ci_hdrc_imx.c b/drivers/usb/chipidea/ci_hdrc_imx.c
index 25c65accf089..5e07a0a86d11 100644
--- a/drivers/usb/chipidea/ci_hdrc_imx.c
+++ b/drivers/usb/chipidea/ci_hdrc_imx.c
@@ -57,7 +57,8 @@ static const struct ci_hdrc_imx_platform_flag imx6sx_usb_data = {
 
 static const struct ci_hdrc_imx_platform_flag imx6ul_usb_data = {
 	.flags = CI_HDRC_SUPPORTS_RUNTIME_PM |
-		CI_HDRC_TURN_VBUS_EARLY_ON,
+		CI_HDRC_TURN_VBUS_EARLY_ON |
+		CI_HDRC_DISABLE_DEVICE_STREAMING,
 };
 
 static const struct ci_hdrc_imx_platform_flag imx7d_usb_data = {
-- 
2.17.1

