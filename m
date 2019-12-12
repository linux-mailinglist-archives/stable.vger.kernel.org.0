Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0BB1811CA20
	for <lists+stable@lfdr.de>; Thu, 12 Dec 2019 11:03:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728331AbfLLKDZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Dec 2019 05:03:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:53092 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726382AbfLLKDZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 12 Dec 2019 05:03:25 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 007E020663;
        Thu, 12 Dec 2019 10:03:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576145004;
        bh=+ffIvZ8BeZ/FGeStNiEWYPjjVkZ3X9EBtgBzndBBxZI=;
        h=Subject:To:From:Date:From;
        b=dyBrUZ95O+nX0eoJ8fMBS1/MreaSE0VL85NloohUqr4Zrc6wJElgJ2zaZIyzIz8Ok
         LJwzLDcooEgbaFDZX8Z8+cBVP/ddfeGViI0c+7zOJ6YGPzlnW3N9N+hPImh5oIk8yz
         jTOq+5PEG1jADQuhgGvSkfbXpuKrqrbMNyxXqjn8=
Subject: patch "interconnect: qcom: sdm845: Walk the list safely on node removal" added to char-misc-linus
To:     georgi.djakov@linaro.org, bjorn.andersson@linaro.org,
        digetx@gmail.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 12 Dec 2019 11:03:13 +0100
Message-ID: <157614499312358@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    interconnect: qcom: sdm845: Walk the list safely on node removal

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From b29b8113bb41285eb7ed55ce0c65017b5c0240f7 Mon Sep 17 00:00:00 2001
From: Georgi Djakov <georgi.djakov@linaro.org>
Date: Thu, 12 Dec 2019 09:53:30 +0200
Subject: interconnect: qcom: sdm845: Walk the list safely on node removal

As we will remove items off the list using list_del(), we need to use the
safe version of list_for_each_entry().

Fixes: b5d2f741077a ("interconnect: qcom: Add sdm845 interconnect provider driver")
Reported-by: Dmitry Osipenko <digetx@gmail.com>
Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Georgi Djakov <georgi.djakov@linaro.org>
Cc: <stable@vger.kernel.org> # v5.3+
Link: https://lore.kernel.org/r/20191212075332.16202-3-georgi.djakov@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/interconnect/qcom/sdm845.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/interconnect/qcom/sdm845.c b/drivers/interconnect/qcom/sdm845.c
index 502a6c22b41e..387267ee9648 100644
--- a/drivers/interconnect/qcom/sdm845.c
+++ b/drivers/interconnect/qcom/sdm845.c
@@ -868,9 +868,9 @@ static int qnoc_remove(struct platform_device *pdev)
 {
 	struct qcom_icc_provider *qp = platform_get_drvdata(pdev);
 	struct icc_provider *provider = &qp->provider;
-	struct icc_node *n;
+	struct icc_node *n, *tmp;
 
-	list_for_each_entry(n, &provider->nodes, node_list) {
+	list_for_each_entry_safe(n, tmp, &provider->nodes, node_list) {
 		icc_node_del(n);
 		icc_node_destroy(n->id);
 	}
-- 
2.24.1


