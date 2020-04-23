Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD1BB1B659E
	for <lists+stable@lfdr.de>; Thu, 23 Apr 2020 22:40:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726840AbgDWUka (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Apr 2020 16:40:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726183AbgDWUka (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Apr 2020 16:40:30 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4ADB6C09B042
        for <stable@vger.kernel.org>; Thu, 23 Apr 2020 13:40:30 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id x17so7492628wrt.5
        for <stable@vger.kernel.org>; Thu, 23 Apr 2020 13:40:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2pZHt+hAsIb+Y7qJYHv626ADWtS8jmmdGfuI//hKgVk=;
        b=qzoOo3I8cRfX6MkdFJqq6RfvQNTBNZpPZezGm0Z9Q48HYA5S8TgKbjZ72D7+H7HZ0B
         HbomgluFtve7s8MNbFZnVLMzUlZaSfWN8N9KP7CPtvmxNpvER3cRN72pab2BTmSzSgp9
         l3uULjj0sYtZZgDcyYIW8CI3hJwPkooYNI7P64SKzPqtgishpp7gxHR596IU6zuuj8YZ
         Rj/C0OEwDHxdXbkxb/ElCVE3MgcEPNuufDS7XbFRPfm8tpOmVhsGVhyySyXS2+lAQjQh
         F+jv0bEOI5DgrLGwrsaeeOq1UXWZbj1mSaZfb5wDgm4RRpznz6XOTr72Vj+FUwIu9kPe
         Ot3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2pZHt+hAsIb+Y7qJYHv626ADWtS8jmmdGfuI//hKgVk=;
        b=k2QFj9OQu7S/T1Y7zbS7+vgqNQ5PdEwE0NzD6yUrXLESkQoT5htG9orE0tpsTLiDrT
         CthbZBDhEineIuxcKrjp3D3s1Edas07JFKT3Bk/5t24MWS5AtJrBMGss0dNPfqcs/tQ2
         uGSVq2BVUU7nPNAIuZcerGof13Gy/GMR3V6lN7GnsHyUDON42jiMh6scYw6MgcALLAUr
         loplcJcbcLM940LAPVePdbopIu4SMkV6++U8MX8oAyBQ4xslrFveUum2DTe47ey5bB9y
         7GaosIIqFxPhklGqfTjxa91z6LQwVZywMXgrVPERRm0oJXJCDU4uozbjQqaWzeMzGxK4
         NLGg==
X-Gm-Message-State: AGi0PuYkgOzqffcNHC0NL2EhlOfli+gMVOjcJNbUzvwY1fvkvk+K0rro
        Y/NW1ZAuSUw4tzaWRHfa0EjbOvvCBHg=
X-Google-Smtp-Source: APiQypIDRhLgw4MqKyYW9y98lRjr3X48PX1AA28NrNsAN/Hw0p0TJpPP7LZ9Ls6tGiVyxGbKRKfTSQ==
X-Received: by 2002:adf:e986:: with SMTP id h6mr6915217wrm.256.1587674428816;
        Thu, 23 Apr 2020 13:40:28 -0700 (PDT)
Received: from localhost.localdomain ([2.31.163.63])
        by smtp.gmail.com with ESMTPSA id u17sm5933726wra.63.2020.04.23.13.40.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Apr 2020 13:40:28 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Cc:     Hamad Kadmany <hkadmany@codeaurora.org>,
        Maya Erez <merez@codeaurora.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 4.4 09/16] wil6210: increase firmware ready timeout
Date:   Thu, 23 Apr 2020 21:40:07 +0100
Message-Id: <20200423204014.784944-10-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200423204014.784944-1-lee.jones@linaro.org>
References: <20200423204014.784944-1-lee.jones@linaro.org>
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
index f09fafaaaf1a3..c377937aae1c4 100644
--- a/drivers/net/wireless/ath/wil6210/main.c
+++ b/drivers/net/wireless/ath/wil6210/main.c
@@ -741,7 +741,7 @@ static void wil_bl_crash_info(struct wil6210_priv *wil, bool is_err)
 
 static int wil_wait_for_fw_ready(struct wil6210_priv *wil)
 {
-	ulong to = msecs_to_jiffies(1000);
+	ulong to = msecs_to_jiffies(2000);
 	ulong left = wait_for_completion_timeout(&wil->wmi_ready, to);
 
 	if (0 == left) {
-- 
2.25.1

