Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC41C2E840D
	for <lists+stable@lfdr.de>; Fri,  1 Jan 2021 16:10:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727047AbhAAPKk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Jan 2021 10:10:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726798AbhAAPKk (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Jan 2021 10:10:40 -0500
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDDBDC061573
        for <stable@vger.kernel.org>; Fri,  1 Jan 2021 07:09:59 -0800 (PST)
Received: by mail-pg1-x52c.google.com with SMTP id v19so14595874pgj.12
        for <stable@vger.kernel.org>; Fri, 01 Jan 2021 07:09:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:subject:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=d+FwuGsujZrFAAbK6DdnnAT6hpz/KW09xw7n1RhjmxY=;
        b=s6UsZWKkM4ILG15qHaTMplxJnTtVmiw9AWAPvNUWfl6X7/ZNrCP6oY9V5moMd5oljT
         KJ397QRdQ+6dSHkpCGlqV8BV7WVe6yKb5EWOqPHTY5Y7QrU6ZKzR4VBv6SyCaIGfT2Uf
         J99h3JjQGN+Mbv/G3is9mCluQ7bpp6rvWJxsRXPCowpGrk4HWIvnGRgpvPjbuHeOL4v7
         swMqYGtKkL8SVc8De6RWblrYSw7wH+7FRE84AIZyoxAQkJNvUgDB5X6T1BfcYznQlN10
         ltE9ZT9QO0Hl4paz5TTFuesGSP3ZZTxLFza5yiD/Ncn1hD5/OkR+jRrKl2awaF0EfrBo
         yLXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=d+FwuGsujZrFAAbK6DdnnAT6hpz/KW09xw7n1RhjmxY=;
        b=F1wg1GIZ81kvJDtofvhUcjSnAyU61GeIe7hHQoXVN/xKFqQ7S95CvcL1HQ1wlT7ymc
         SSlQCMURsjJDuoA+kIgMYyIheyFOdBPGl/dulnrsUUOHGSycitaMnu14YOFCvR7dxjOR
         03vOhxilmuyL7Mj2cBo35zVGKUIP6jqtdWdcGJG3vTZi9BGoaKjjERSleqlMpsygR5DB
         UZUcJJNgGNx0e2lCYD6W3HTi8Orjrborq7nuFXfJBOVAZmZu1roE8SnKzx2QSy+NwAkr
         txDAGoy1hUOgBdaC6DtviokJEjGpr6Ytp8uKL7U61lWh/+CymdE86YPNON9hmKTz1g9Q
         LYUA==
X-Gm-Message-State: AOAM5335aEwjmqJxoF2U5YBeHyzuvjc6ONslbGQ/EJHEYB+9hAvXjlPQ
        rPtob4qmooS8HJnZDcufIel+4iXhUYcfgw==
X-Google-Smtp-Source: ABdhPJz8ooBOM57wanJ3jaJQp36Q1fkSNgnJK/FKSBlFvXmWxMWHN4CeO4Fi6H7/UOV6KR0P40u2gQ==
X-Received: by 2002:a62:7b86:0:b029:19d:f996:44f3 with SMTP id w128-20020a627b860000b029019df99644f3mr55931852pfc.65.1609513799026;
        Fri, 01 Jan 2021 07:09:59 -0800 (PST)
Received: from [127.0.0.1] ([118.34.233.180])
        by smtp.gmail.com with ESMTPSA id x22sm49542434pfc.19.2021.01.01.07.09.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 Jan 2021 07:09:58 -0800 (PST)
From:   Jinoh Kang <jinoh.kang.kr@gmail.com>
Subject: [PATCH 4.19 bp] ext4: don't remount read-only with errors=continue on
 reboot
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Jan Kara <jack@suse.cz>, Andreas Dilger <adilger@dilger.ca>,
        Theodore Ts'o <tytso@mit.edu>, stable@vger.kernel.org
References: <16091470451704@kroah.com>
Message-ID: <2c1466be-7b5d-1e50-bcc2-3bcb9478fba2@gmail.com>
Date:   Fri, 1 Jan 2021 15:09:54 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:78.0) Gecko/20100101 Firefox/78.0
MIME-Version: 1.0
In-Reply-To: <16091470451704@kroah.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jan Kara <jack@suse.cz>

commit b08070eca9e247f60ab39d79b2c25d274750441f upstream.

ext4_handle_error() with errors=continue mount option can accidentally
remount the filesystem read-only when the system is rebooting. Fix that.

Fixes: 1dc1097ff60e ("ext4: avoid panic during forced reboot")
Signed-off-by: Jan Kara <jack@suse.cz>
Reviewed-by: Andreas Dilger <adilger@dilger.ca>
Cc: stable@kernel.org
Link: https://lore.kernel.org/r/20201127113405.26867-2-jack@suse.cz
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 fs/ext4/super.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index ee96f504ed78..e9e9f09f5370 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -454,19 +454,17 @@ static bool system_going_down(void)
 
 static void ext4_handle_error(struct super_block *sb)
 {
+	journal_t *journal = EXT4_SB(sb)->s_journal;
+
 	if (test_opt(sb, WARN_ON_ERROR))
 		WARN_ON_ONCE(1);
 
-	if (sb_rdonly(sb))
+	if (sb_rdonly(sb) || test_opt(sb, ERRORS_CONT))
 		return;
 
-	if (!test_opt(sb, ERRORS_CONT)) {
-		journal_t *journal = EXT4_SB(sb)->s_journal;
-
-		EXT4_SB(sb)->s_mount_flags |= EXT4_MF_FS_ABORTED;
-		if (journal)
-			jbd2_journal_abort(journal, -EIO);
-	}
+	EXT4_SB(sb)->s_mount_flags |= EXT4_MF_FS_ABORTED;
+	if (journal)
+		jbd2_journal_abort(journal, -EIO);
 	/*
 	 * We force ERRORS_RO behavior when system is rebooting. Otherwise we
 	 * could panic during 'reboot -f' as the underlying device got already
-- 
2.26.2

