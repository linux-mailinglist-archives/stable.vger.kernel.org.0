Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB1FC405763
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 15:41:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357807AbhIINeD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 09:34:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:33698 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353147AbhIIM47 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 08:56:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 531876325C;
        Thu,  9 Sep 2021 11:58:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188713;
        bh=A5j40hBeOa+S/CWU9wfHang6QqKX1n9X4A6eC31b2Do=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kLeq6utz9wdQ2viaCXq9IDNdjjlfLlEw2w+b91mTXQIBlTTLfAitqQ35gb75GPYa+
         Lw3rE/pI7Z1BGfsORnrZ0/mVaWqPX8BgyuAXiTUJ51gSguOq6KQeWg5sRQJFxClR3i
         CXHwCfB8X27fM8E4QvKTqpPMYwDV5vuZDq4yQm9aeFyZbDWRzqt9HD/aNRXJCYjwji
         /ItqJWWJMn402PCtHkaN/F3PjHjen7EvCppuVq/RQ3tMeaRlbY/HBUef8w4ZITJjht
         RbT7unhYmRextXdWqTbmFuGVHOKUuKN8HkKPq/Gpkxzg/6Z+vIiXtTK1eGsIQ1cRjr
         57q6a5D0qGu+Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kees Cook <keescook@chromium.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-staging@lists.linux.dev, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 53/74] staging: rts5208: Fix get_ms_information() heap buffer size
Date:   Thu,  9 Sep 2021 07:57:05 -0400
Message-Id: <20210909115726.149004-53-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909115726.149004-1-sashal@kernel.org>
References: <20210909115726.149004-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kees Cook <keescook@chromium.org>

[ Upstream commit cbe34165cc1b7d1110b268ba8b9f30843c941639 ]

Fix buf allocation size (it needs to be 2 bytes larger). Found when
__alloc_size() annotations were added to kmalloc() interfaces.

In file included from ./include/linux/string.h:253,
                 from ./include/linux/bitmap.h:10,
                 from ./include/linux/cpumask.h:12,
                 from ./arch/x86/include/asm/paravirt.h:17,
                 from ./arch/x86/include/asm/irqflags.h:63,
                 from ./include/linux/irqflags.h:16,
                 from ./include/linux/rcupdate.h:26,
                 from ./include/linux/rculist.h:11,
                 from ./include/linux/pid.h:5,
                 from ./include/linux/sched.h:14,
                 from ./include/linux/blkdev.h:5,
                 from drivers/staging/rts5208/rtsx_scsi.c:12:
In function 'get_ms_information',
    inlined from 'ms_sp_cmnd' at drivers/staging/rts5208/rtsx_scsi.c:2877:12,
    inlined from 'rtsx_scsi_handler' at drivers/staging/rts5208/rtsx_scsi.c:3247:12:
./include/linux/fortify-string.h:54:29: warning: '__builtin_memcpy' forming offset [106, 107] is out
 of the bounds [0, 106] [-Warray-bounds]
   54 | #define __underlying_memcpy __builtin_memcpy
      |                             ^
./include/linux/fortify-string.h:417:2: note: in expansion of macro '__underlying_memcpy'
  417 |  __underlying_##op(p, q, __fortify_size);   \
      |  ^~~~~~~~~~~~~
./include/linux/fortify-string.h:463:26: note: in expansion of macro '__fortify_memcpy_chk'
  463 | #define memcpy(p, q, s)  __fortify_memcpy_chk(p, q, s,   \
      |                          ^~~~~~~~~~~~~~~~~~~~
drivers/staging/rts5208/rtsx_scsi.c:2851:3: note: in expansion of macro 'memcpy'
 2851 |   memcpy(buf + i, ms_card->raw_sys_info, 96);
      |   ^~~~~~

Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-staging@lists.linux.dev
Signed-off-by: Kees Cook <keescook@chromium.org>
Link: https://lore.kernel.org/r/20210818044252.1533634-1-keescook@chromium.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/rts5208/rtsx_scsi.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/rts5208/rtsx_scsi.c b/drivers/staging/rts5208/rtsx_scsi.c
index c9a6d97938f6..68889d082c3c 100644
--- a/drivers/staging/rts5208/rtsx_scsi.c
+++ b/drivers/staging/rts5208/rtsx_scsi.c
@@ -2841,10 +2841,10 @@ static int get_ms_information(struct scsi_cmnd *srb, struct rtsx_chip *chip)
 	}
 
 	if (dev_info_id == 0x15) {
-		buf_len = 0x3A;
+		buf_len = 0x3C;
 		data_len = 0x3A;
 	} else {
-		buf_len = 0x6A;
+		buf_len = 0x6C;
 		data_len = 0x6A;
 	}
 
@@ -2895,11 +2895,7 @@ static int get_ms_information(struct scsi_cmnd *srb, struct rtsx_chip *chip)
 	}
 
 	rtsx_stor_set_xfer_buf(buf, buf_len, srb);
-
-	if (dev_info_id == 0x15)
-		scsi_set_resid(srb, scsi_bufflen(srb) - 0x3C);
-	else
-		scsi_set_resid(srb, scsi_bufflen(srb) - 0x6C);
+	scsi_set_resid(srb, scsi_bufflen(srb) - buf_len);
 
 	kfree(buf);
 	return STATUS_SUCCESS;
-- 
2.30.2

