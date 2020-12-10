Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 778402D6609
	for <lists+stable@lfdr.de>; Thu, 10 Dec 2020 20:10:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390469AbgLJObA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Dec 2020 09:31:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:38778 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388474AbgLJOau (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Dec 2020 09:30:50 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Zhihao Cheng <chengzhihao1@huawei.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Wolfram Sang <wsa@kernel.org>
Subject: [PATCH 4.9 43/45] i2c: qup: Fix error return code in qup_i2c_bam_schedule_desc()
Date:   Thu, 10 Dec 2020 15:26:57 +0100
Message-Id: <20201210142604.460327484@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201210142602.361598591@linuxfoundation.org>
References: <20201210142602.361598591@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhihao Cheng <chengzhihao1@huawei.com>

commit e9acf0298c664f825e6f1158f2a97341bf9e03ca upstream.

Fix to return the error code from qup_i2c_change_state()
instaed of 0 in qup_i2c_bam_schedule_desc().

Fixes: fbf9921f8b35d9b2 ("i2c: qup: Fix error handling")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zhihao Cheng <chengzhihao1@huawei.com>
Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/i2c/busses/i2c-qup.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/i2c/busses/i2c-qup.c
+++ b/drivers/i2c/busses/i2c-qup.c
@@ -810,7 +810,8 @@ static int qup_i2c_bam_do_xfer(struct qu
 	if (ret || qup->bus_err || qup->qup_err) {
 		reinit_completion(&qup->xfer);
 
-		if (qup_i2c_change_state(qup, QUP_RUN_STATE)) {
+		ret = qup_i2c_change_state(qup, QUP_RUN_STATE);
+		if (ret) {
 			dev_err(qup->dev, "change to run state timed out");
 			goto desc_err;
 		}


