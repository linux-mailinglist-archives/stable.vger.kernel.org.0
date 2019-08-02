Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D3C87F8C7
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 15:22:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393768AbfHBNWg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 09:22:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:32954 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393417AbfHBNWf (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 2 Aug 2019 09:22:35 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0DAFC20644;
        Fri,  2 Aug 2019 13:22:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564752154;
        bh=bzZ0UBe6eTaQ9SsWN0eEA6OkXmcqxkCaOQ+baQptsjs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QfYka8pVdwkot3WEK4U+zGs41MaRFT8ws1uP0Jf/73wvqKGOCPNMvh5gYnMxV+mWh
         bXgq/SOgxuXhnLpQOi5IMEbTFhdRetTzl9XUO0IyqKertX1rWOnwMA05klVo8KIHMx
         fLbbeoBY3LMvXUI1crEP8NN6DTU4WHtM1+mYk7y0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wenwen Wang <wenwen@cs.uga.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.2 67/76] test_firmware: fix a memory leak bug
Date:   Fri,  2 Aug 2019 09:19:41 -0400
Message-Id: <20190802131951.11600-67-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190802131951.11600-1-sashal@kernel.org>
References: <20190802131951.11600-1-sashal@kernel.org>
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
index 83ea6c4e623cf..6ca97a63b3d6b 100644
--- a/lib/test_firmware.c
+++ b/lib/test_firmware.c
@@ -886,8 +886,11 @@ static int __init test_firmware_init(void)
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

