Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BC501AC3A0
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 15:46:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439560AbgDPNqO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 09:46:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:59974 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392290AbgDPNqK (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 09:46:10 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 507352076D;
        Thu, 16 Apr 2020 13:46:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587044769;
        bh=ZIcAg89D5twlHgvCRgZyM3HhzVVvVDgs3ml5dsPPPn8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PCjEzSIyM72zgoDTbfRbjZBykvu54vI6A76Mz+jkJETtoXzR2QXpJuN+KCow7yPsU
         10lYKYOVf6x1+P06+CwGaZZY5XPrdmD1jsDFoiv/O5pMh5xiI3Zz91/fVFXUV5QyJ/
         cURCcz567RINhV+66+Qo5EXju7v5o6jLknFXNQ90=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 5.4 087/232] media: venus: firmware: Ignore secure call error on first resume
Date:   Thu, 16 Apr 2020 15:23:01 +0200
Message-Id: <20200416131325.885035660@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200416131316.640996080@linuxfoundation.org>
References: <20200416131316.640996080@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stanimir Varbanov <stanimir.varbanov@linaro.org>

commit 2632e7b618a7730969f9782593c29ca53553aa22 upstream.

With the latest cleanup in qcom scm driver the secure monitor
call for setting the remote processor state returns EINVAL when
it is called for the first time and after another scm call
auth_and_reset. The error returned from scm call could be ignored
because the state transition is already done in auth_and_reset.

Acked-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Cc: stable@vger.kernel.org
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/platform/qcom/venus/firmware.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/drivers/media/platform/qcom/venus/firmware.c
+++ b/drivers/media/platform/qcom/venus/firmware.c
@@ -44,8 +44,14 @@ static void venus_reset_cpu(struct venus
 
 int venus_set_hw_state(struct venus_core *core, bool resume)
 {
-	if (core->use_tz)
-		return qcom_scm_set_remote_state(resume, 0);
+	int ret;
+
+	if (core->use_tz) {
+		ret = qcom_scm_set_remote_state(resume, 0);
+		if (resume && ret == -EINVAL)
+			ret = 0;
+		return ret;
+	}
 
 	if (resume)
 		venus_reset_cpu(core);


