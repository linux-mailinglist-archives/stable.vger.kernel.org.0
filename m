Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A263331BF1
	for <lists+stable@lfdr.de>; Tue,  9 Mar 2021 01:52:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229582AbhCIAwI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Mar 2021 19:52:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbhCIAvb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Mar 2021 19:51:31 -0500
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6ABDC06174A
        for <stable@vger.kernel.org>; Mon,  8 Mar 2021 16:51:30 -0800 (PST)
Received: by mail-pg1-x536.google.com with SMTP id g4so7599941pgj.0
        for <stable@vger.kernel.org>; Mon, 08 Mar 2021 16:51:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1ksnBHcq8a191mL7cykc1zhhIaT0z+FlFZs1orBbPpo=;
        b=SEVrioc6CJijxj68aYqqGPqqqLIi73KcAX1c0bFlryrsieX7bpHNpfqHF/7Mo3uUr4
         fMvbWTMYQ1798PN8QzOuRmwnnd58/Tb4yrHzgxr9BOZVl5L0b3rV7QCT6zBObFxlkXyN
         7LRl/oXQjfCQ1EMz8CmcH/8dOQkYTgTCtqkrh676VK7Nws2qMZcirbkg4SC2QnvOF+Xl
         D+m+VjrhVLLy6BZ+LZdretjC64cDrlxbJ1zIXH3ubTJfTTvS+0gtiECSXkMq3WVrT/PO
         ci+UeLDOJa4MAGv83UrpQsLxmwiMcutgwzN5/Vk/tDNbmqkAFbk1ehdTmBmiQdxw5Tlo
         IYQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1ksnBHcq8a191mL7cykc1zhhIaT0z+FlFZs1orBbPpo=;
        b=NMGP9T8mr/kQqNoZcG12cE8qxGJnKGrReqiyuDZf+/0JwNhHkiqNcGSoGKn1fdId93
         yfw5gOE5eb1O/c67aTUnq24uQqIjrlN6cJckFDWzlbR/Bcc/Dsa1U0ZtBRKQlx9eWQET
         msKdEVRMC3AjymH588h+6y6Cst/479SH2mr0lAQ4F44mSxfcmQU9tojx8IrPswBewSAi
         hTPujwwS0cMr0pKb7qIYjoxso+T4oGcSDb5FixN8mOGZiGPezTDV0uLW2L3Dz4Tp3QK+
         dU/BsK8UwdGarN8Zjep7LtGbg/xQCSa3Xrjf5kHp6GVr2UgwMuzeHYHS+McvQP+4YqFR
         GuQA==
X-Gm-Message-State: AOAM531ijlxc0w1cQXXnM56JApOf3AYbXp6Ve8KiTpSjyAgsz/ABUxZu
        ntapXN6z2SlHoO83EtPbguJKaDJYXp0=
X-Google-Smtp-Source: ABdhPJx+yx3/zD5W7fmbRtu+0DdvGxB0etDkyCxIkW5P4GER+cfJhLfCsK7TOGanBsjrH1DI1OALfQ==
X-Received: by 2002:a62:1911:0:b029:1ed:b722:3b50 with SMTP id 17-20020a6219110000b02901edb7223b50mr1254481pfz.70.1615251090428;
        Mon, 08 Mar 2021 16:51:30 -0800 (PST)
Received: from localhost.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id i25sm10632269pgb.33.2021.03.08.16.51.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Mar 2021 16:51:30 -0800 (PST)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-nvme@lists.infradead.org
Cc:     emilne@redhat.com, James Smart <jsmart2021@gmail.com>,
        stable@vger.kernel.org, Nigel Kirkland <nkirkland2304@gmail.com>
Subject: [PATCH v2] nvme-fc: fix racing controller reset and create association
Date:   Mon,  8 Mar 2021 16:51:26 -0800
Message-Id: <20210309005126.58460-1-jsmart2021@gmail.com>
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
after the ctrl state transition to NVME_CTRL_CONNECTING, causing
any outstanding io (used to initialize the controller) to fail and
cause problems for connect_work.

Add a state check to only schedule error work if not in the RESETTING
state.

Fixes: 19fce0470f05 ("nvme-fc: avoid calling _nvme_fc_abort_outstanding_ios from interrupt context")
Cc: <stable@vger.kernel.org> # v5.10+

Signed-off-by: Nigel Kirkland <nkirkland2304@gmail.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>

---
v2: clean up typo in commit header
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

