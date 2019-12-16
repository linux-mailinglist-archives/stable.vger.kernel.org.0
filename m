Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 96B9C121789
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 19:37:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730023AbfLPSGp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 13:06:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:47156 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730020AbfLPSGo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 13:06:44 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6687120CC7;
        Mon, 16 Dec 2019 18:06:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576519603;
        bh=i5XtLVMmI+2dJcN0KwB7A+BvEXbQvtvFuu2za7XVIY0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hqzJ78b//Nu9812SeC5kvOPphbbir27/Jr/Je1XW5Q9PjqDIxaYc1jayY1WikvRKA
         +khqnOmtHcSuSiIjnWpIYrOHVhPRMsYTODx6+3zcMvS/mEwOXFZCG5B3cb67VfSt1E
         48qxOhBGY9yMVOfjo2gSsTAvSS9q5+LR0d0Y7Iek=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Will Deacon <will@kernel.org>
Subject: [PATCH 4.19 132/140] firmware: qcom: scm: Ensure a0 status code is treated as signed
Date:   Mon, 16 Dec 2019 18:50:00 +0100
Message-Id: <20191216174828.754810295@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191216174747.111154704@linuxfoundation.org>
References: <20191216174747.111154704@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Will Deacon <will@kernel.org>

commit ff34f3cce278a0982a7b66b1afaed6295141b1fc upstream.

The 'a0' member of 'struct arm_smccc_res' is declared as 'unsigned long',
however the Qualcomm SCM firmware interface driver expects to receive
negative error codes via this field, so ensure that it's cast to 'long'
before comparing to see if it is less than 0.

Cc: <stable@vger.kernel.org>
Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/firmware/qcom_scm-64.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/firmware/qcom_scm-64.c
+++ b/drivers/firmware/qcom_scm-64.c
@@ -158,7 +158,7 @@ static int qcom_scm_call(struct device *
 		kfree(args_virt);
 	}
 
-	if (res->a0 < 0)
+	if ((long)res->a0 < 0)
 		return qcom_scm_remap_error(res->a0);
 
 	return 0;


