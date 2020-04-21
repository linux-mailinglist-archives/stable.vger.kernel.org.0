Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 125C61B266E
	for <lists+stable@lfdr.de>; Tue, 21 Apr 2020 14:41:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728898AbgDUMlK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Apr 2020 08:41:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728926AbgDUMlJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Apr 2020 08:41:09 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E7DFC061A41
        for <stable@vger.kernel.org>; Tue, 21 Apr 2020 05:41:08 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id t63so3379981wmt.3
        for <stable@vger.kernel.org>; Tue, 21 Apr 2020 05:41:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=92Rf6n3jfz/AKB5KQ5ygummyywSmBTVtgJ/40A7EfC4=;
        b=qINMZlr34Z67zq317QBYXWSlsITOb/RlKWRmvoH8Gq6PdOV0BzFtEXAhQBSBv/liCn
         eurB0GWRvo1s+5LzheDCWDELPEvTwxluolLEFrd8lQB6pd0Jo0833BvjwT+R1Zs/n1NG
         kVUJgpO64JQdvebtZYSsGwtM/XhEDvWON2lopyASM80gyfiT/nwKANsb6NxV/sCk9IBm
         relNjZHKUXaqCpEO4/+UcN6lG89c6Bd/eVFsHUMpDN4oPnIotJ/4JaJd0fehZUYXoKfN
         wkmLc9PZu1l1Syma9xBXBy0K5SAas26teMDz25lFW2lgRfu/TEijP8vYG7oJ35buDsLg
         stxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=92Rf6n3jfz/AKB5KQ5ygummyywSmBTVtgJ/40A7EfC4=;
        b=FuE+CRuTx2esZ6jfqtaba5LZOicwnMHi2d+e3d3L7fwYq4Fjrm9QO/OvAwvTzrcT2o
         8WMdhLtmDPassVTcyN0NFQuSpbYis+VCbXhKU3FZtXBMUUcmJ6MXIoKeMkVxiOPY8hmc
         M6oTQbMOZF9BxjLyRvW38Kx65Oa5f6mi2WuOHX9jg210kPun0SAJe+w+ywcr9URmuuuC
         02PhtMnhyaEXeL2dNQp+YWp244roZpiMy6U53ClbNugnP9jhozvn4yv8bDrP+tr3+x6e
         R9hNzLB2qVxGe2+nllE0V8wAAipq8TAsurxwwpuONUEaqwZnq1btKQyVA+bk8zTC4qfg
         /HbA==
X-Gm-Message-State: AGi0PuaEJTClSmSZsQd/z2xUDDn31pM2Ln5hyZY3K4P1pM9Rx2P9HjRL
        8MPNY2hb+3xvj4CTzjq/a3jCuuoLjuY=
X-Google-Smtp-Source: APiQypIHN3pqVFzfx06ELIg43fWXhdXcg8ZPYljnBMtv/FIfXyRbs5zgL6moeeXcWB/mGcq7Qcx6MA==
X-Received: by 2002:a05:600c:414b:: with SMTP id h11mr4673616wmm.9.1587472867159;
        Tue, 21 Apr 2020 05:41:07 -0700 (PDT)
Received: from localhost.localdomain ([2.31.163.63])
        by smtp.gmail.com with ESMTPSA id u3sm3408232wrt.93.2020.04.21.05.41.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Apr 2020 05:41:06 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Cc:     Bjorn Andersson <bjorn.andersson@linaro.org>,
        Chris Lew <clew@codeaurora.org>,
        Arun Kumar Neelakantam <aneela@codeaurora.org>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 4.14 17/24] rpmsg: glink: smem: Ensure ordering during tx
Date:   Tue, 21 Apr 2020 13:40:10 +0100
Message-Id: <20200421124017.272694-18-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200421124017.272694-1-lee.jones@linaro.org>
References: <20200421124017.272694-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bjorn Andersson <bjorn.andersson@linaro.org>

[ Upstream commit 9d32497361ff89d2fc8306407de6f04b2bfb2836 ]

Ensure the ordering of the fifo write and the update of the write index,
so that the index is not updated before the data has landed in the fifo.

Acked-By: Chris Lew <clew@codeaurora.org>
Reported-by: Arun Kumar Neelakantam <aneela@codeaurora.org>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/rpmsg/qcom_glink_smem.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/rpmsg/qcom_glink_smem.c b/drivers/rpmsg/qcom_glink_smem.c
index 69a14041ef1fe..ed616b0bc563d 100644
--- a/drivers/rpmsg/qcom_glink_smem.c
+++ b/drivers/rpmsg/qcom_glink_smem.c
@@ -181,6 +181,9 @@ static void glink_smem_tx_write(struct qcom_glink_pipe *glink_pipe,
 	if (head >= pipe->native.length)
 		head -= pipe->native.length;
 
+	/* Ensure ordering of fifo and head update */
+	wmb();
+
 	*pipe->head = cpu_to_le32(head);
 }
 
-- 
2.25.1

