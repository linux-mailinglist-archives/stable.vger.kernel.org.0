Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A35345C109
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:11:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346251AbhKXNOQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:14:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:53912 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348036AbhKXNMZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:12:25 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7068061A7F;
        Wed, 24 Nov 2021 12:42:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637757760;
        bh=ekGkWyvr1AOi1A4EPhmMoP6o15FOejt0ou6yPowyidI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sMaJfiEv7g5UkSb7imjei2eyHri3wyc3tLuIN2dVKR9sgoUXgxK6qHRjvxjaMigCc
         mx38YxTmO8W7retKHugvPfB0z1o7aBfjki56RVcFBeCa29k7wGVfSj8pU2V8845hfO
         QwEwmLotX+FgrCOmr4KzeeAWYtz2lGlS8sMDlrAc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Luis Chamberlain <mcgrof@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 268/323] firmware_loader: fix pre-allocated buf built-in firmware use
Date:   Wed, 24 Nov 2021 12:57:38 +0100
Message-Id: <20211124115727.922086375@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.822024889@linuxfoundation.org>
References: <20211124115718.822024889@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 24410a0d6df07..cfa5e598a0dc8 100644
--- a/drivers/base/firmware_loader/main.c
+++ b/drivers/base/firmware_loader/main.c
@@ -97,12 +97,15 @@ static struct firmware_cache fw_cache;
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
@@ -114,9 +117,7 @@ static bool fw_get_builtin_firmware(struct firmware *fw, const char *name,
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



