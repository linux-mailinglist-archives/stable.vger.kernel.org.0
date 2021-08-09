Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3CEB3E4184
	for <lists+stable@lfdr.de>; Mon,  9 Aug 2021 10:24:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233857AbhHIIZD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Aug 2021 04:25:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233942AbhHIIZC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Aug 2021 04:25:02 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F726C0613D3
        for <stable@vger.kernel.org>; Mon,  9 Aug 2021 01:24:42 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id o11so3824705wms.0
        for <stable@vger.kernel.org>; Mon, 09 Aug 2021 01:24:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8M4d0Uxz/0+0kMFPkk4zFO2m4csYlGTmBy9HzP7nwc4=;
        b=NwUHzMjoQ5R5F5nGSCfQy+CR6Mbh323wn9co/8+otLrt9OyssZ2/yCQQ3BjkrC5KeX
         7Ok8+86VSe9mw15Q7adCt3V7xIB6wD3xm7Z7CdUCEAiZgYdHQKJYPiuASKhEzcb4GJyI
         EdpJkfIj7ATYUJSjCdbkArd3V9PZilgW6Fn9AMhwDqK8UBmernuxwus+HDPK3Y4LtBJU
         WpyDA6Q8egGhl+M5Vx6T9uKNvk/tclwvVdqyoWXOcaP/WG72g5FtalkT0N6YMAPsXC1Z
         e6mpJ45V2D1rdOmoVQb5Ayc48mgJQSgwPAy5YYXk+eYnhAaejfYC2/KxEcEfVMP1MmCb
         yGyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8M4d0Uxz/0+0kMFPkk4zFO2m4csYlGTmBy9HzP7nwc4=;
        b=N/CA1WXOXn/a3c6kKKNvqwS1KiH+zXK8CccNKntfbg3jAs2xNCJk4krg937fjM3eYK
         AzZQ0D9UKdUXAay3BhyZh5dQlnfg4dmdgcVXGqkx30tjUekNrPRWNExGgGuwxqvU03jP
         rBp0/jPt4v9gsR32qMip51UzGiBUL6BbkgfBz2OZ0ry2jx+A8b0Hueqemz8eu7gqiJSu
         XIxAPfk2VGx5zstMZi7j48IDTSYPW5R95fRlueaJ+0KaBxhzilti4ZGu/dLP3+ZVLj2k
         XLb7DQ01uFuKBa2EKHYcveYxUCCzoCCl/3ynEettU+lH4V7vliorvHIOnYDL0TDL11Oz
         o0gA==
X-Gm-Message-State: AOAM5335OajTeYFGsROr1GpkKaHnDfc3FXiBTwxOABuA/BMU8Kmiu5I8
        RQdDjiBgMCboSD6yaNwyjG6nbZrPnLy5vg==
X-Google-Smtp-Source: ABdhPJygLJ9rfKmu6JFLWSn90gDdBwp6px0wKMsk/PIlpH8+5DEJxt5ldVd8vgB+ubiXpzETQbhSJg==
X-Received: by 2002:a05:600c:2306:: with SMTP id 6mr15684677wmo.115.1628497480815;
        Mon, 09 Aug 2021 01:24:40 -0700 (PDT)
Received: from srini-hackbox.lan (cpc86377-aztw32-2-0-cust226.18-1.cable.virginm.net. [92.233.226.227])
        by smtp.gmail.com with ESMTPSA id t15sm18036371wrw.48.2021.08.09.01.24.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Aug 2021 01:24:40 -0700 (PDT)
From:   Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
To:     gregkh@linuxfoundation.org
Cc:     linux-kernel@vger.kernel.org,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        stable@vger.kernel.org
Subject: [RESEND PATCH 1/4] slimbus: messaging: start transaction ids from 1 instead of zero
Date:   Mon,  9 Aug 2021 09:24:25 +0100
Message-Id: <20210809082428.11236-2-srinivas.kandagatla@linaro.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20210809082428.11236-1-srinivas.kandagatla@linaro.org>
References: <20210809082428.11236-1-srinivas.kandagatla@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

As tid is unsigned its hard to figure out if the tid is valid or
invalid. So Start the transaction ids from 1 instead of zero
so that we could differentiate between a valid tid and invalid tids

This is useful in cases where controller would add a tid for controller
specific transfers.

Fixes: d3062a210930 ("slimbus: messaging: add slim_alloc/free_txn_tid()")
Cc: <stable@vger.kernel.org>
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
---
 drivers/slimbus/messaging.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/slimbus/messaging.c b/drivers/slimbus/messaging.c
index f2b5d347d227..6097ddc43a35 100644
--- a/drivers/slimbus/messaging.c
+++ b/drivers/slimbus/messaging.c
@@ -66,7 +66,7 @@ int slim_alloc_txn_tid(struct slim_controller *ctrl, struct slim_msg_txn *txn)
 	int ret = 0;
 
 	spin_lock_irqsave(&ctrl->txn_lock, flags);
-	ret = idr_alloc_cyclic(&ctrl->tid_idr, txn, 0,
+	ret = idr_alloc_cyclic(&ctrl->tid_idr, txn, 1,
 				SLIM_MAX_TIDS, GFP_ATOMIC);
 	if (ret < 0) {
 		spin_unlock_irqrestore(&ctrl->txn_lock, flags);
-- 
2.21.0

