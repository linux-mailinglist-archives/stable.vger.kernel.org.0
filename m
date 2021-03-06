Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1863732FD63
	for <lists+stable@lfdr.de>; Sat,  6 Mar 2021 22:18:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229818AbhCFVRc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 6 Mar 2021 16:17:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229733AbhCFVRK (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 6 Mar 2021 16:17:10 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F81CC06174A
        for <stable@vger.kernel.org>; Sat,  6 Mar 2021 13:17:10 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id f2-20020a17090a4a82b02900c67bf8dc69so983712pjh.1
        for <stable@vger.kernel.org>; Sat, 06 Mar 2021 13:17:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rqpud1SFsFWm5tJtvYOt91rESzkjIUZuEwhsXZuiL2k=;
        b=cFRHp4GZvPkaf32JaVhyKF4FcOzwKX7QSR3qSSY6Taextb/iZn5Ru6nOQ4qmm1rzqz
         OVXWAt3quHrU3vWp+tQqT13gcfkF5kJEOP1sf0u8343N7osxXBRsVj1umBLVABgUgOvW
         SsCB+UltB1ELYNgPJDEQwBjbuYnOd8QwWKmiI+H82SoUE3IOGUjN/Z4AMXAT9YxlPwuv
         1p9wylTYC1w5/sh2YpFbV8FX1s8837kkVOMMQZCEA3dKwqbkJPx2BF78Vc6r43BPR1gK
         QezwYxOJRVUXvkDGM5ng8+yf2bv3XwSJaWauLc3TlkTy/tnMn5Hc+CM8PxKfUfQvFGev
         L0cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rqpud1SFsFWm5tJtvYOt91rESzkjIUZuEwhsXZuiL2k=;
        b=F4StwMUd2o8NC7SFj+PIM4SbD7vmO+qksmR2slTLibGuEEZ9kFQiNi/vEal0lUCdMT
         WtU6JV/++enFz6+bj1kzBcOqxkD42eqGGHswmJ318OU/lPGgns7WaQLSDRh2JsUBZHeR
         EK6sVbIr0oGTEjNHg/NvXE4qX3UHFUN8WD/Qmffki5BoD/4FUzxaD16iD6fJlNzEq2BA
         nLqvlRnw4KW7V6CN/E4rU1nST8gLr3K49tHtUIE4XD99dk6EHqAJj9COXUZxwICSVmDj
         K4kv+HwxzE6EgaoVgbHlskcu2T8YwmmhrPi2xqG9Aly/HLmigRCN9tna5ZsBLy3NHiKC
         F9Iw==
X-Gm-Message-State: AOAM533fFOyPCTF+u1CtmDH0OpgzzWijcthEAZA6ksmn5XU3DjIH0+/Q
        a0AJER7VV69I5Ur+Xn9bb64=
X-Google-Smtp-Source: ABdhPJwdsZxqpYd5tYFwhtmSjCoAl0AsAsxSuvt0qQW1GJhGbRomedna6qHCLTui41mToKdSxzcB8w==
X-Received: by 2002:a17:90a:2e06:: with SMTP id q6mr13610439pjd.222.1615065429776;
        Sat, 06 Mar 2021 13:17:09 -0800 (PST)
Received: from localhost.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id i22sm6282926pjz.56.2021.03.06.13.17.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 06 Mar 2021 13:17:09 -0800 (PST)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-nvme@lists.infradead.org
Cc:     emilne@redhat.com, James Smart <jsmart2021@gmail.com>,
        stable@vger.kernel.org, Nigel Kirkland <nkirkland2304@gmail.com>
Subject: [PATCH] nvme-fc: fix racing controller reset and create association
Date:   Sat,  6 Mar 2021 13:16:58 -0800
Message-Id: <20210306211658.67604-1-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Recent patch to prevent calling __nvme_fc_abort_outstanding_ios in
interrupt context results in a possible race condition. A controller
reset results in errored io completions, which schedules error
work. The change of error work to a work element allows it to fire
after the ctrl state transition tion to NVME_CTRL_CONNECTING, causing
any outstanding io (used to initialize the controller) to fail and
cause problems for connect_work.

Add a state check to only schedule error work if not in the RESETTING
state.

Fixes: 19fce0470f05 ("nvme-fc: avoid calling _nvme_fc_abort_outstanding_ios from interrupt context")
Cc: <stable@vger.kernel.org> # v5.10+

Signed-off-by: Nigel Kirkland <nkirkland2304@gmail.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/nvme/host/fc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nvme/host/fc.c b/drivers/nvme/host/fc.c
index 20dadd86e981..0f92bd12123e 100644
--- a/drivers/nvme/host/fc.c
+++ b/drivers/nvme/host/fc.c
@@ -2055,7 +2055,7 @@ nvme_fc_fcpio_done(struct nvmefc_fcp_req *req)
 		nvme_fc_complete_rq(rq);
 
 check_error:
-	if (terminate_assoc)
+	if (terminate_assoc && ctrl->ctrl.state != NVME_CTRL_RESETTING)
 		queue_work(nvme_reset_wq, &ctrl->ioerr_work);
 }
 
-- 
2.26.2

