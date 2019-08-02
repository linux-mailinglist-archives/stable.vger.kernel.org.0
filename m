Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A8337F931
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 15:27:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393433AbfHBNZb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 09:25:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:36216 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391319AbfHBNZa (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 2 Aug 2019 09:25:30 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5FAA021841;
        Fri,  2 Aug 2019 13:25:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564752329;
        bh=qP8vCx5KYpcvlcNbOBJpV72B0xJIr42ZOgtEcRP7yIU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KlpuOquiL9ENyRGbdvbpgO/KJ3Z+muHERIpTJZHqX2K64iVp1p8odgU2BvRALKa8Z
         Ddbyb2l33dmd7+/+OmIJ71t/8g8dneKBKBJnAP/eKgBRkVh8YEpu3FljbWsoUQ1Rum
         PrP3FEopiQ+nHTa9YSggX+KtmqV/KSyzD2c5AbKQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wenwen Wang <wenwen@cs.uga.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.14 27/30] test_firmware: fix a memory leak bug
Date:   Fri,  2 Aug 2019 09:24:19 -0400
Message-Id: <20190802132422.13963-27-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190802132422.13963-1-sashal@kernel.org>
References: <20190802132422.13963-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wenwen Wang <wenwen@cs.uga.edu>

[ Upstream commit d4fddac5a51c378c5d3e68658816c37132611e1f ]

In test_firmware_init(), the buffer pointed to by the global pointer
'test_fw_config' is allocated through kzalloc(). Then, the buffer is
initialized in __test_firmware_config_init(). In the case that the
initialization fails, the following execution in test_firmware_init() needs
to be terminated with an error code returned to indicate this failure.
However, the allocated buffer is not freed on this execution path, leading
to a memory leak bug.

To fix the above issue, free the allocated buffer before returning from
test_firmware_init().

Signed-off-by: Wenwen Wang <wenwen@cs.uga.edu>
Link: https://lore.kernel.org/r/1563084696-6865-1-git-send-email-wang6495@umn.edu
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/test_firmware.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/lib/test_firmware.c b/lib/test_firmware.c
index f978aebe60c5b..2e5e18bbfd28e 100644
--- a/lib/test_firmware.c
+++ b/lib/test_firmware.c
@@ -895,8 +895,11 @@ static int __init test_firmware_init(void)
 		return -ENOMEM;
 
 	rc = __test_firmware_config_init();
-	if (rc)
+	if (rc) {
+		kfree(test_fw_config);
+		pr_err("could not init firmware test config: %d\n", rc);
 		return rc;
+	}
 
 	rc = misc_register(&test_fw_misc_device);
 	if (rc) {
-- 
2.20.1

