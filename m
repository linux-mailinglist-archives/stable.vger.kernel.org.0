Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5139749BB32
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 19:23:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231139AbiAYSXa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jan 2022 13:23:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230431AbiAYSWf (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Jan 2022 13:22:35 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43635C061759
        for <stable@vger.kernel.org>; Tue, 25 Jan 2022 10:22:35 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id c76-20020a25c04f000000b00613e2c514e2so38964597ybf.21
        for <stable@vger.kernel.org>; Tue, 25 Jan 2022 10:22:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=Lok6oxADWNe/Lq9Bd8BF739UQWqpIq0qYKa/bk6A5N0=;
        b=Q7l+l0kOp7iAA251LRk5qfU1ONabSuPZAiJwgqqdIvUyhHRq5IpqYE0NG2FjMa8LI3
         BOf0LsBOrb5++slHn79YerH9uoCp11FPSy6Bk1I2YWasaNbov63mEXtyjagbrQdhbk4u
         d+ykI49DmoF40J+nuy6z7Uni3moA4qm18Mo2TtKprOXdqOWQIHq+zsvKbQg7QOwlD5MZ
         2x0eWn+SQcCkXLrY9t+ikn9LW98pTC2sJf36jaM0RVFCl7BKt0YN5QzVBzk660JBKU78
         OmF/S/Yf/V7V4h6eZhc5o7qKII3l+IRuydkfe4u8z2fWazTlYOqNaDTs5rcXCVUfusb1
         TAVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=Lok6oxADWNe/Lq9Bd8BF739UQWqpIq0qYKa/bk6A5N0=;
        b=B0P5wHZW1YDkBenAg226CnsWYtuZ1LMm9xzmEVYWJAlVzaoCRbTlZRqzMKePuLqrLU
         fz86OEvBUKpSTVFWVdGQEdYZEvUrk6hR4cjvNIe51DR68Ey4NEuHDdmB0c/FuoFsa+5F
         +GjjCj4PTdVaaG84iBYKsB5iq9YVjZ0Vi3PqSUVHCjeg3aCyz1ApyrXv7uOtN9A+4FRe
         2WXHDbgdDadrS+2JcYkrnUytWM7eAJu/NyL7vWAmGvnTMENwLeafpHfJpJi0hCk5xP/X
         uOzp8EUgU2CniKflQEZaU+pUuPH2r9Q6p85f75hKVFLoOB6reFNwCv7+tRI8AfVvUi4h
         AqwA==
X-Gm-Message-State: AOAM5305XVJWDRLvDVPvV98xgMN0z6TXtPMMWpmEL8BxWBKvJLVbT55Y
        HtiTNEw5AQFWBAiB20LWrUeS0Zueidjx
X-Google-Smtp-Source: ABdhPJywOjHqDnkI+4Tt9DzDqL7Nok6BVw+ygf1J/HuOdAqVIIEzVomSL/CnnzfCvbWdHBqUd9wizHquVF9G
X-Received: from eugenis.svl.corp.google.com ([2620:15c:2ce:200:d947:cd1e:4976:2712])
 (user=eugenis job=sendgmr) by 2002:a05:6902:47:: with SMTP id
 m7mr33544786ybh.69.1643134954491; Tue, 25 Jan 2022 10:22:34 -0800 (PST)
Date:   Tue, 25 Jan 2022 10:22:17 -0800
Message-Id: <20220125182217.2605202-1-eugenis@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.0.rc0.227.g00780c9af4-goog
Subject: [PATCH v2] arm64: extable: fix load_unaligned_zeropad() reg indices
From:   Evgenii Stepanov <eugenis@google.com>
To:     Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Jisheng Zhang <jszhang@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Evgenii Stepanov <eugenis@google.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

In ex_handler_load_unaligned_zeropad() we erroneously extract the data and
addr register indices from ex->type rather than ex->data. As ex->type will
contain EX_TYPE_LOAD_UNALIGNED_ZEROPAD (i.e. 4):
 * We'll always treat X0 as the address register, since EX_DATA_REG_ADDR is
   extracted from bits [9:5]. Thus, we may attempt to dereference an
   arbitrary address as X0 may hold an arbitrary value.
 * We'll always treat X4 as the data register, since EX_DATA_REG_DATA is
   extracted from bits [4:0]. Thus we will corrupt X4 and cause arbitrary
   behaviour within load_unaligned_zeropad() and its caller.

Fix this by extracting both values from ex->data as originally intended.

On an MTE-enabled QEMU image we are hitting the following crash:
 Unable to handle kernel NULL pointer dereference at virtual address 0000000000000000
 Call trace:
  fixup_exception+0xc4/0x108
  __do_kernel_fault+0x3c/0x268
  do_tag_check_fault+0x3c/0x104
  do_mem_abort+0x44/0xf4
  el1_abort+0x40/0x64
  el1h_64_sync_handler+0x60/0xa0
  el1h_64_sync+0x7c/0x80
  link_path_walk+0x150/0x344
  path_openat+0xa0/0x7dc
  do_filp_open+0xb8/0x168
  do_sys_openat2+0x88/0x17c
  __arm64_sys_openat+0x74/0xa0
  invoke_syscall+0x48/0x148
  el0_svc_common+0xb8/0xf8
  do_el0_svc+0x28/0x88
  el0_svc+0x24/0x84
  el0t_64_sync_handler+0x88/0xec
  el0t_64_sync+0x1b4/0x1b8
 Code: f8695a69 71007d1f 540000e0 927df12a (f940014a)

Fixes: 753b32368705 ("arm64: extable: add load_unaligned_zeropad() handler")
Cc: <stable@vger.kernel.org> # 5.16.x
Reviewed-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Evgenii Stepanov <eugenis@google.com>
---
 arch/arm64/mm/extable.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/mm/extable.c b/arch/arm64/mm/extable.c
index c0181e60cc98..489455309695 100644
--- a/arch/arm64/mm/extable.c
+++ b/arch/arm64/mm/extable.c
@@ -40,8 +40,8 @@ static bool
 ex_handler_load_unaligned_zeropad(const struct exception_table_entry *ex,
 				  struct pt_regs *regs)
 {
-	int reg_data = FIELD_GET(EX_DATA_REG_DATA, ex->type);
-	int reg_addr = FIELD_GET(EX_DATA_REG_ADDR, ex->type);
+	int reg_data = FIELD_GET(EX_DATA_REG_DATA, ex->data);
+	int reg_addr = FIELD_GET(EX_DATA_REG_ADDR, ex->data);
 	unsigned long data, addr, offset;
 
 	addr = pt_regs_read_reg(regs, reg_addr);
-- 
2.35.0.rc0.227.g00780c9af4-goog

