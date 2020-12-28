Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16BCB2E3CFC
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:09:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438850AbgL1OJm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:09:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:44166 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2438847AbgL1OJm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:09:42 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 25BCA206D4;
        Mon, 28 Dec 2020 14:09:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164541;
        bh=12phwOgW9S+W836a/ph7ZBnx44NUwADRXaH5JUoPinU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s58S1XlSRuzj5xiNzyeMtdPJwVkKgCvlGq7oeKOSGsfHjIQge27+wKljIHRXXjX8G
         bjviGOjbF2nQwfTEt7PN0hJYJGoAlNX8r0QDXHJmmQ35agFB4rjq/GxFNy0GUyOjH4
         phZGfWF56EvtndMHRIsgcnrfAapDsONtO/4Y86eU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sibi Sankar <sibis@codeaurora.org>,
        Tom Rix <trix@redhat.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 181/717] soc: qcom: initialize local variable
Date:   Mon, 28 Dec 2020 13:42:59 +0100
Message-Id: <20201228125029.634313066@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tom Rix <trix@redhat.com>

[ Upstream commit a161ffe4b877721d8917e18e70461d255a090f19 ]

clang static analysis reports this problem

pdr_interface.c:596:6: warning: Branch condition evaluates
  to a garbage value
        if (!req.service_path[0])
            ^~~~~~~~~~~~~~~~~~~~

This check that req.service_path was set in an earlier loop.
However req is a stack variable and its initial value
is undefined.

So initialize req to 0.

Fixes: fbe639b44a82 ("soc: qcom: Introduce Protection Domain Restart helpers")
Reviewed-by: Sibi Sankar <sibis@codeaurora.org>
Signed-off-by: Tom Rix <trix@redhat.com>
Link: https://lore.kernel.org/r/20200819184637.15648-1-trix@redhat.com
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/qcom/pdr_interface.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/soc/qcom/pdr_interface.c b/drivers/soc/qcom/pdr_interface.c
index 088dc99f77f3f..f63135c09667f 100644
--- a/drivers/soc/qcom/pdr_interface.c
+++ b/drivers/soc/qcom/pdr_interface.c
@@ -569,7 +569,7 @@ EXPORT_SYMBOL(pdr_add_lookup);
 int pdr_restart_pd(struct pdr_handle *pdr, struct pdr_service *pds)
 {
 	struct servreg_restart_pd_resp resp;
-	struct servreg_restart_pd_req req;
+	struct servreg_restart_pd_req req = { 0 };
 	struct sockaddr_qrtr addr;
 	struct pdr_service *tmp;
 	struct qmi_txn txn;
-- 
2.27.0



