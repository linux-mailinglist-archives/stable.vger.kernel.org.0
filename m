Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C60B719C996
	for <lists+stable@lfdr.de>; Thu,  2 Apr 2020 21:13:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389371AbgDBTNR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Apr 2020 15:13:17 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:38536 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389367AbgDBTNR (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Apr 2020 15:13:17 -0400
Received: by mail-wr1-f68.google.com with SMTP id c7so5574298wrx.5
        for <stable@vger.kernel.org>; Thu, 02 Apr 2020 12:13:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=pGegqeDbRY6Y5f60xelQQzofEJmSdDI54qyCBBvOxXA=;
        b=Jc/X/f8xcglnIXbxh/8ywetgCOv8S38qxGvzm+NhW5UcBkOcaagEs8i+lXwYDsQr6G
         nuxomh4rkuCDPCWtkPp7JpqRt3gPNy/8PQKTUivSVDN2omM3N0BIcw1h4nVhFs2GQmn6
         g/egBalAYdl2AD8enNhsMrerIYedYialr0Man28dutksCdxXzLlEawvLVYkg+xh3C9pM
         dm7Aicx/G1NVL5WwsHbHWGwUmUq6GmQd6xiJIh9VdQQvVON0tCQhXZNMZJ2MgTHzyeIj
         wcXrdworglJcVkhT/GoopUsObyTsORdDd13itjR9gButkcPPHc6UEWbDSugIF+O4o/sT
         D+SQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pGegqeDbRY6Y5f60xelQQzofEJmSdDI54qyCBBvOxXA=;
        b=KX1GIumyJ/suI1TefPdry18LGbdj/VLl7lQZlOKEAav8mxNgnTbEY4oLJkYFtMSalh
         8nDa+uTe+qFp80WeXBZRdgUxzolx4C5eNc1g41CP+sd4z4yoRS+awPIyZNkaFT6e5sJX
         KZ3DbXAQwMEetjBczgo81aeibYzfJBsnxu3kZ8AIOOy7doKx5Bw74uy2SyZ/qDzT0AnK
         VuMGZndUWQbOJ0p2AlauZ8zsXjf5OjDXS2OLTQh79L+WuUHNZpE9MWilYnFLzW/s34J9
         j9ex80RCLZCajeFagLtgdfOhnyf5idcSPr2es8MWWOC9yXWtSFO87BUQE7MT0Y1btuV/
         8K8w==
X-Gm-Message-State: AGi0PuZiLEIe6V82qdlWNuYYmljZv5wcCX9kh3sdwDseaRm2c0oIqH5t
        OzMUjbWa4mfAerFBrDnKjbf+KCo6czPZwg==
X-Google-Smtp-Source: APiQypJDtLXwmoCh3mGeGbwRD3di1VeZZptgvNSvnPfmGO/cao+jNywZGWu5zJXX4rrCISrm5V9RRQ==
X-Received: by 2002:a5d:69c8:: with SMTP id s8mr4898044wrw.300.1585854793291;
        Thu, 02 Apr 2020 12:13:13 -0700 (PDT)
Received: from localhost.localdomain ([95.149.164.95])
        by smtp.gmail.com with ESMTPSA id y12sm5511514wrn.55.2020.04.02.12.13.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Apr 2020 12:13:12 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Subject: [PATCH 4.14 14/33] wil6210: increase firmware ready timeout
Date:   Thu,  2 Apr 2020 20:13:34 +0100
Message-Id: <20200402191353.787836-14-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200402191353.787836-1-lee.jones@linaro.org>
References: <20200402191353.787836-1-lee.jones@linaro.org>
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
index bac829aa950d5..a3dc42841526f 100644
--- a/drivers/net/wireless/ath/wil6210/main.c
+++ b/drivers/net/wireless/ath/wil6210/main.c
@@ -871,7 +871,7 @@ static void wil_bl_crash_info(struct wil6210_priv *wil, bool is_err)
 
 static int wil_wait_for_fw_ready(struct wil6210_priv *wil)
 {
-	ulong to = msecs_to_jiffies(1000);
+	ulong to = msecs_to_jiffies(2000);
 	ulong left = wait_for_completion_timeout(&wil->wmi_ready, to);
 
 	if (0 == left) {
-- 
2.25.1

