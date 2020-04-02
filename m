Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 131B519C9BC
	for <lists+stable@lfdr.de>; Thu,  2 Apr 2020 21:17:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388896AbgDBTRJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Apr 2020 15:17:09 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:40270 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388888AbgDBTRJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Apr 2020 15:17:09 -0400
Received: by mail-wm1-f65.google.com with SMTP id a81so4925596wmf.5
        for <stable@vger.kernel.org>; Thu, 02 Apr 2020 12:17:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=eCvdfM93gNYyZjObZ9PQdmlbZuh+Svcu/m1gBXqJ96Y=;
        b=Qix6T9Kyg5RDl9HLBhmyCiuI01npLR8lXx8DZ7NGaI0agoxoyfOObFXTrol5btD5To
         qQ8rgSk6fgDd6hEppPFkOwApPrnx1cHxOng4a6hQBbU/B/qDn6/bV/NvLSPYkmZzHJNt
         0fUKB9CeZyzs6P7jZZ43OSk+Zvoliz7+wwdy2ljZ22LEV8Ovw8RkYE4/j0oUU4S/a6Ks
         vHhnFNZewJkqdhMMGxqpQtHPdTc+fPvEMhkAmYf6zGaMhJxBzEZq9B2JK/WBeqO7sTZG
         ARcCDLTsgV6P1VmGZ+OLC+sxfPuSYP+5wzmfEv7SK6PBzBlgBIZzS+5Y1OtUnwvkBDtp
         2fUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=eCvdfM93gNYyZjObZ9PQdmlbZuh+Svcu/m1gBXqJ96Y=;
        b=P8lMBGOz8pZf1WpY4ZD1JmsRtKgBSwQXndMFm0eoqtwluraOm5E4MuAg+gIZLUlTl8
         Ow0hu26UYv+Ry3naVhkemCJdhlWswsEywLNNElVZerLh0zFjscI6LVGxWwW9SudGyp0D
         IoH9m47kUvdDdpeDUfYRosGLiaHVixUeLr21sy68nXi+5Z/202JdUutwwzKMdHo600gh
         P24uK87dnIVJvHaqiSzQr4oS7ft19ccnUaEcpa3fDXrpQJ1S4qhUXkS0dLYGHYVCWdnZ
         27B3IVT1ivsuSViMk3DO5owmVp4yAZMubErtDZPA5HS69wWmsieQp/hG8+/O/L9X7iY9
         oCbg==
X-Gm-Message-State: AGi0PuYgvLeXONaffgbwSOKS8wYqDeh4BkdzTJ9AGPdZmceQFCp5V+HM
        YuB5W/k7bOg4DVKpAhHxRRrpGEKmu1r3TQ==
X-Google-Smtp-Source: APiQypJXYagUU/Z/e04zDgEUsGfwF6190R87khbB2DsuUnE9AvfhqjxIh/9uexIGYf3oUUMMYx90SA==
X-Received: by 2002:a1c:3943:: with SMTP id g64mr4814080wma.9.1585855026192;
        Thu, 02 Apr 2020 12:17:06 -0700 (PDT)
Received: from localhost.localdomain ([95.149.164.95])
        by smtp.gmail.com with ESMTPSA id y1sm879050wmd.14.2020.04.02.12.17.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Apr 2020 12:17:05 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Subject: [PATCH 4.9 12/24] wil6210: increase firmware ready timeout
Date:   Thu,  2 Apr 2020 20:17:35 +0100
Message-Id: <20200402191747.789097-12-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200402191747.789097-1-lee.jones@linaro.org>
References: <20200402191747.789097-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hamad Kadmany <hkadmany@codeaurora.org>

[ Upstream commit 6ccae584014ef7074359eb4151086beef66ecfa9 ]

Firmware ready event may take longer than
current timeout in some scenarios, for example
with multiple RFs connected where each
requires an initial calibration.

Increase the timeout to support these scenarios.

Signed-off-by: Hamad Kadmany <hkadmany@codeaurora.org>
Signed-off-by: Maya Erez <merez@codeaurora.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/net/wireless/ath/wil6210/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/wil6210/main.c b/drivers/net/wireless/ath/wil6210/main.c
index f8bce58d48ccd..12b4c6f003726 100644
--- a/drivers/net/wireless/ath/wil6210/main.c
+++ b/drivers/net/wireless/ath/wil6210/main.c
@@ -803,7 +803,7 @@ static void wil_bl_crash_info(struct wil6210_priv *wil, bool is_err)
 
 static int wil_wait_for_fw_ready(struct wil6210_priv *wil)
 {
-	ulong to = msecs_to_jiffies(1000);
+	ulong to = msecs_to_jiffies(2000);
 	ulong left = wait_for_completion_timeout(&wil->wmi_ready, to);
 
 	if (0 == left) {
-- 
2.25.1

