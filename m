Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 94708186328
	for <lists+stable@lfdr.de>; Mon, 16 Mar 2020 03:43:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729822AbgCPCk4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 15 Mar 2020 22:40:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:36828 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729644AbgCPCdu (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 15 Mar 2020 22:33:50 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5629820724;
        Mon, 16 Mar 2020 02:33:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584326030;
        bh=4yw0STCK+C5NSsvnEalgO/FdaunLe8EGQsfjZzCvPV8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2CmbMjB+TdZ93JJL8T+7UnqTaV0vlCUS2KDz5Bh0rgn+9mOsmCHhVSq20QF7vNMQk
         ETat+uSDNrJY7qN3lzF8t3qcdkMWUPcQGokHhIUuHB398CkdHa/MLHuuYFjrCe2zZi
         Dk6qB0SsJnmiPEL5xvZuSjqNh5tRH0DzaVPVpESg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Daniel Axtens <dja@axtens.net>,
        "Igor M. Liplianin" <liplianin@netup.ru>,
        Kees Cook <keescook@chromium.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.5 25/41] altera-stapl: altera_get_note: prevent write beyond end of 'key'
Date:   Sun, 15 Mar 2020 22:33:03 -0400
Message-Id: <20200316023319.749-25-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200316023319.749-1-sashal@kernel.org>
References: <20200316023319.749-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Axtens <dja@axtens.net>

[ Upstream commit 3745488e9d599916a0b40d45d3f30e3d4720288e ]

altera_get_note is called from altera_init, where key is kzalloc(33).

When the allocation functions are annotated to allow the compiler to see
the sizes of objects, and with FORTIFY_SOURCE, we see:

In file included from drivers/misc/altera-stapl/altera.c:14:0:
In function ‘strlcpy’,
    inlined from ‘altera_init’ at drivers/misc/altera-stapl/altera.c:2189:5:
include/linux/string.h:378:4: error: call to ‘__write_overflow’ declared with attribute error: detected write beyond size of object passed as 1st parameter
    __write_overflow();
    ^~~~~~~~~~~~~~~~~~

That refers to this code in altera_get_note:

    if (key != NULL)
            strlcpy(key, &p[note_strings +
                            get_unaligned_be32(
                            &p[note_table + (8 * i)])],
                    length);

The error triggers because the length of 'key' is 33, but the copy
uses length supplied as the 'length' parameter, which is always
256. Split the size parameter into key_len and val_len, and use the
appropriate length depending on what is being copied.

Detected by compiler error, only compile-tested.

Cc: "Igor M. Liplianin" <liplianin@netup.ru>
Signed-off-by: Daniel Axtens <dja@axtens.net>
Link: https://lore.kernel.org/r/20200120074344.504-2-dja@axtens.net
Signed-off-by: Kees Cook <keescook@chromium.org>
Link: https://lore.kernel.org/r/202002251042.D898E67AC@keescook
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/altera-stapl/altera.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/misc/altera-stapl/altera.c b/drivers/misc/altera-stapl/altera.c
index 25e5f24b3fecd..5bdf574723144 100644
--- a/drivers/misc/altera-stapl/altera.c
+++ b/drivers/misc/altera-stapl/altera.c
@@ -2112,8 +2112,8 @@ static int altera_execute(struct altera_state *astate,
 	return status;
 }
 
-static int altera_get_note(u8 *p, s32 program_size,
-			s32 *offset, char *key, char *value, int length)
+static int altera_get_note(u8 *p, s32 program_size, s32 *offset,
+			   char *key, char *value, int keylen, int vallen)
 /*
  * Gets key and value of NOTE fields in the JBC file.
  * Can be called in two modes:  if offset pointer is NULL,
@@ -2170,7 +2170,7 @@ static int altera_get_note(u8 *p, s32 program_size,
 						&p[note_table + (8 * i) + 4])];
 
 				if (value != NULL)
-					strlcpy(value, value_ptr, length);
+					strlcpy(value, value_ptr, vallen);
 
 			}
 		}
@@ -2189,13 +2189,13 @@ static int altera_get_note(u8 *p, s32 program_size,
 				strlcpy(key, &p[note_strings +
 						get_unaligned_be32(
 						&p[note_table + (8 * i)])],
-					length);
+					keylen);
 
 			if (value != NULL)
 				strlcpy(value, &p[note_strings +
 						get_unaligned_be32(
 						&p[note_table + (8 * i) + 4])],
-					length);
+					vallen);
 
 			*offset = i + 1;
 		}
@@ -2449,7 +2449,7 @@ int altera_init(struct altera_config *config, const struct firmware *fw)
 			__func__, (format_version == 2) ? "Jam STAPL" :
 						"pre-standardized Jam 1.1");
 		while (altera_get_note((u8 *)fw->data, fw->size,
-					&offset, key, value, 256) == 0)
+					&offset, key, value, 32, 256) == 0)
 			printk(KERN_INFO "%s: NOTE \"%s\" = \"%s\"\n",
 					__func__, key, value);
 	}
-- 
2.20.1

