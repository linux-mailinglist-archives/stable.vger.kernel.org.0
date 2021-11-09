Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55B3644B61A
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 23:22:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242016AbhKIWZS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Nov 2021 17:25:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:40832 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343769AbhKIWV3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Nov 2021 17:21:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 73D306128E;
        Tue,  9 Nov 2021 22:18:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636496292;
        bh=W+AmS8/JMVZC3xZfY0CjrOobJuawsCHHZdpidwTZVCI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V5m6BXS4r9Oc+awV1RGHBjgWfk58AESBmdVm/jrYJK/2AFYoGMovN/dURVzMZHdnC
         eTKHUxHAf62zEuCYAbQ4jH3aItKjXqlUlr1RMu6PKNRMxcsjIQ+I3vQSul6zLG7BCW
         L/PWFP3Ho9enIotfQj0ZUDdmk4T+v3+ZDaGFZwxsotKcAm4j9Xf6pFLEQUfsjKHFhN
         XWg/Ho8OOI+vITJ38gs4YX4pynkJvpjPCJCredmLiyfHXs/Y01lf5tuwcr0sUS5dWC
         V5xXo8/QHv/jA6Fzf863c4eRBl4EPZibYB93Wkm9IWUOddqeElNv2onePHQaRWYNdk
         5H3p/uDqOuVSA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Luis Chamberlain <mcgrof@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.15 49/82] firmware_loader: fix pre-allocated buf built-in firmware use
Date:   Tue,  9 Nov 2021 17:16:07 -0500
Message-Id: <20211109221641.1233217-49-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211109221641.1233217-1-sashal@kernel.org>
References: <20211109221641.1233217-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Luis Chamberlain <mcgrof@kernel.org>

[ Upstream commit f7a07f7b96033df7709042ff38e998720a3f7119 ]

The firmware_loader can be used with a pre-allocated buffer
through the use of the API calls:

  o request_firmware_into_buf()
  o request_partial_firmware_into_buf()

If the firmware was built-in and present, our current check
for if the built-in firmware fits into the pre-allocated buffer
does not return any errors, and we proceed to tell the caller
that everything worked fine. It's a lie and no firmware would
end up being copied into the pre-allocated buffer. So if the
caller trust the result it may end up writing a bunch of 0's
to a device!

Fix this by making the function that checks for the pre-allocated
buffer return non-void. Since the typical use case is when no
pre-allocated buffer is provided make this return successfully
for that case. If the built-in firmware does *not* fit into the
pre-allocated buffer size return a failure as we should have
been doing before.

I'm not aware of users of the built-in firmware using the API
calls with a pre-allocated buffer, as such I doubt this fixes
any real life issue. But you never know... perhaps some oddball
private tree might use it.

In so far as upstream is concerned this just fixes our code for
correctness.

Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
Link: https://lore.kernel.org/r/20210917182226.3532898-2-mcgrof@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/firmware_loader/main.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/base/firmware_loader/main.c b/drivers/base/firmware_loader/main.c
index bdbedc6660a87..ef904b8b112e6 100644
--- a/drivers/base/firmware_loader/main.c
+++ b/drivers/base/firmware_loader/main.c
@@ -100,12 +100,15 @@ static struct firmware_cache fw_cache;
 extern struct builtin_fw __start_builtin_fw[];
 extern struct builtin_fw __end_builtin_fw[];
 
-static void fw_copy_to_prealloc_buf(struct firmware *fw,
+static bool fw_copy_to_prealloc_buf(struct firmware *fw,
 				    void *buf, size_t size)
 {
-	if (!buf || size < fw->size)
-		return;
+	if (!buf)
+		return true;
+	if (size < fw->size)
+		return false;
 	memcpy(buf, fw->data, fw->size);
+	return true;
 }
 
 static bool fw_get_builtin_firmware(struct firmware *fw, const char *name,
@@ -117,9 +120,7 @@ static bool fw_get_builtin_firmware(struct firmware *fw, const char *name,
 		if (strcmp(name, b_fw->name) == 0) {
 			fw->size = b_fw->size;
 			fw->data = b_fw->data;
-			fw_copy_to_prealloc_buf(fw, buf, size);
-
-			return true;
+			return fw_copy_to_prealloc_buf(fw, buf, size);
 		}
 	}
 
-- 
2.33.0

