Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B7ED40E04F
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 18:20:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236517AbhIPQUs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 12:20:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:55068 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241212AbhIPQTU (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 12:19:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 19C20611F2;
        Thu, 16 Sep 2021 16:13:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631808801;
        bh=wT3iu+1KsIblfmC2Xxu1rpoOWJc5iroPFIXC6zv3PRM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K8fnm6pKvIruR84gnN9US7XRd1Wh6QWqBnHP6f+zvgvBGrTkxG0yMhNu/PWHXaEff
         Pm4ul9XrpavXPg1D1hZLv4KW8ICvXH+gVVN0au60C7oSiV2RCp0Yj/t57Bv5jhQWqU
         l66LffRNjuVtCf96KwqrjnvAQpSa30dQgZk6blRs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, linux-staging@lists.linux.dev,
        Kees Cook <keescook@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 228/306] staging: rts5208: Fix get_ms_information() heap buffer size
Date:   Thu, 16 Sep 2021 17:59:33 +0200
Message-Id: <20210916155801.831825518@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155753.903069397@linuxfoundation.org>
References: <20210916155753.903069397@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 1deb74112ad4..11d9d9155eef 100644
--- a/drivers/staging/rts5208/rtsx_scsi.c
+++ b/drivers/staging/rts5208/rtsx_scsi.c
@@ -2802,10 +2802,10 @@ static int get_ms_information(struct scsi_cmnd *srb, struct rtsx_chip *chip)
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
 
@@ -2855,11 +2855,7 @@ static int get_ms_information(struct scsi_cmnd *srb, struct rtsx_chip *chip)
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



