Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E12A923A469
	for <lists+stable@lfdr.de>; Mon,  3 Aug 2020 14:26:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727873AbgHCM0r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Aug 2020 08:26:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:52288 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728415AbgHCM0p (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Aug 2020 08:26:45 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 28DF1204EC;
        Mon,  3 Aug 2020 12:26:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596457603;
        bh=ZDt/Zl6117SPnQ8nKwlwPrgsijr9OdQmhrm1hTPLeCU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y8I7HH81LCfFjfRGyaEBsGisaok2EXugZtf/pCiAYY/417jJyCfXoDRrVKXmrRxwl
         mOXWGU2Ds2irrBxlrbYI+Lqlqq3o7FzUQGbf3UF5UtHSC0pZTR7t30iEyzQUVl6oOE
         qRTj3cYIago51XgLlzpzcsnKIhyDZ7pu8xLXJa1s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Oded Gabbay <oded.gabbay@gmail.com>,
        Tomer Tayar <ttayar@habana.ai>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 101/120] habanalabs: prevent possible out-of-bounds array access
Date:   Mon,  3 Aug 2020 14:19:19 +0200
Message-Id: <20200803121907.823809165@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200803121902.860751811@linuxfoundation.org>
References: <20200803121902.860751811@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oded Gabbay <oded.gabbay@gmail.com>

[ Upstream commit cea7a0449ea3fa4883bf5dc8397f000d6b67d6cd ]

Queue index is received from the user. Therefore, we must validate it
before using it to access the queue props array.

Signed-off-by: Oded Gabbay <oded.gabbay@gmail.com>
Reviewed-by: Tomer Tayar <ttayar@habana.ai>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/habanalabs/command_submission.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/misc/habanalabs/command_submission.c b/drivers/misc/habanalabs/command_submission.c
index 409276b6374d7..e7c8e7473226f 100644
--- a/drivers/misc/habanalabs/command_submission.c
+++ b/drivers/misc/habanalabs/command_submission.c
@@ -425,11 +425,19 @@ static int validate_queue_index(struct hl_device *hdev,
 	struct asic_fixed_properties *asic = &hdev->asic_prop;
 	struct hw_queue_properties *hw_queue_prop;
 
+	/* This must be checked here to prevent out-of-bounds access to
+	 * hw_queues_props array
+	 */
+	if (chunk->queue_index >= HL_MAX_QUEUES) {
+		dev_err(hdev->dev, "Queue index %d is invalid\n",
+			chunk->queue_index);
+		return -EINVAL;
+	}
+
 	hw_queue_prop = &asic->hw_queues_props[chunk->queue_index];
 
-	if ((chunk->queue_index >= HL_MAX_QUEUES) ||
-			(hw_queue_prop->type == QUEUE_TYPE_NA)) {
-		dev_err(hdev->dev, "Queue index %d is invalid\n",
+	if (hw_queue_prop->type == QUEUE_TYPE_NA) {
+		dev_err(hdev->dev, "Queue index %d is not applicable\n",
 			chunk->queue_index);
 		return -EINVAL;
 	}
-- 
2.25.1



