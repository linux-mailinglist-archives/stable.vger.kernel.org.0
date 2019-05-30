Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 52C2D2F021
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:01:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731472AbfE3EBG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 00:01:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:50346 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731463AbfE3DSM (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:18:12 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 652FC2475A;
        Thu, 30 May 2019 03:18:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186292;
        bh=40Dw/r2+ge0n1REOJJdhybpmlif7X0HbTBKF0F7o8gk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hPA8k5a0+IkhRklimmDSYX4j4E9/TvGtYeEd2yxlf5yHz+yBJGjWYZQZi/Ora1LY0
         TQSEWL2WgXIW1KzdQoqe6LqAURXmx2cSxz5Bj3VhO3wS+FlVzyDSUU4MyuG1Hb5c3r
         Zxg5I9HN+dSX4xvIvDy3ccfazqBkDjeh7qKrMKD8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kangjie Lu <kjlu@umn.edu>,
        Mukesh Ojha <mojha@codeaurora.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 224/276] thunderbolt: property: Fix a missing check of kzalloc
Date:   Wed, 29 May 2019 20:06:22 -0700
Message-Id: <20190530030539.120474383@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030523.133519668@linuxfoundation.org>
References: <20190530030523.133519668@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 6183d5a51866f3acdeeb66b75e87d44025b01a55 ]

No check is enforced for the return value of kzalloc,
which may lead to NULL-pointer dereference.

The patch fixes this issue.

Signed-off-by: Kangjie Lu <kjlu@umn.edu>
Reviewed-by: Mukesh Ojha <mojha@codeaurora.org>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thunderbolt/property.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/thunderbolt/property.c b/drivers/thunderbolt/property.c
index 8fe913a95b4ad..67fd0b5551ded 100644
--- a/drivers/thunderbolt/property.c
+++ b/drivers/thunderbolt/property.c
@@ -581,7 +581,12 @@ int tb_property_add_text(struct tb_property_dir *parent, const char *key,
 		return -ENOMEM;
 
 	property->length = size / 4;
-	property->value.data = kzalloc(size, GFP_KERNEL);
+	property->value.text = kzalloc(size, GFP_KERNEL);
+	if (!property->value.text) {
+		kfree(property);
+		return -ENOMEM;
+	}
+
 	strcpy(property->value.text, text);
 
 	list_add_tail(&property->list, &parent->properties);
-- 
2.20.1



