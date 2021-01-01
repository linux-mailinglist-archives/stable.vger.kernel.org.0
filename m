Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 489FA2E851F
	for <lists+stable@lfdr.de>; Fri,  1 Jan 2021 18:04:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727479AbhAAREH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Jan 2021 12:04:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727473AbhAAREH (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Jan 2021 12:04:07 -0500
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD42EC061573
        for <stable@vger.kernel.org>; Fri,  1 Jan 2021 09:03:26 -0800 (PST)
Received: by mail-pg1-x534.google.com with SMTP id n25so14764103pgb.0
        for <stable@vger.kernel.org>; Fri, 01 Jan 2021 09:03:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:subject:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=IsaH0dIjrgBOprkpxcmWW8rtyN4UxoW5h79iplUaFZU=;
        b=i3WGH6QvwiE8TwWqTVpIl64PzLrKslKmufzjzg8U6KzIDvRAefCMbgG+Xt8j6Bq+RJ
         p+4wlTMSw9FDXAiwAf1ZqE3eQyTavdxY1Blq91wPeRJ00/21ygdqxdSwvWbgVWBJgKYJ
         oOrrqmwKS+++HKTbIhprQalT43uKmnzUtDgJsGH5o6AbWYvGFLgDoUsgxWLzQTEX7r/x
         yyl1eRxEsTT4uvHJpHTedxzIIPiAspA9RZZJ5n7soOS/bhW4IwmYRmAMZL3HuIQ2ZQPh
         /Ufolg2te7CNI4+Yh9tOk2Pd+iBdFSpxmfiSomn3JolVlMF97ueVEeJDMijXcLjdmmM3
         rveg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=IsaH0dIjrgBOprkpxcmWW8rtyN4UxoW5h79iplUaFZU=;
        b=iinHBylBtjbgilcmr9GYmOBDa6rEe9+MZlylnf8Pu19UT+1UsZD9X0E/PdzK1KdJBU
         OE7AQvdPBikmdDhC6m//bHUKDQgjdFrDjnKXrQhqe2oZ0/QJxniJIqMkyyJeWHc43EDC
         XUP/W1BTUbxnsnfY1Q+pCGVcWvMOY/XTCwYsnnvNH7smdVrWY35AsHc5tcLiyOecbqkm
         YoUlvUAx6YI8eiZEISnqpK1cYuQ19yRM1YHNQuXgsO45pcXeoo4qaOVvnopQKJ9RI63H
         5JM7aKqy9QuWL1Qtc6KNiOxJbSOmrsEzdXv0kD1mwv/5bOrO7QmFYdg0/WDsNU2Oc9Jg
         iAXg==
X-Gm-Message-State: AOAM530XSGza/imFG4PpsFfXuIobr7XxD7yFxHiBEmcRl+7EgeeconAP
        X7ZOMecRP+4k/rWGAA1nQtmskTJoFGuH5A==
X-Google-Smtp-Source: ABdhPJxfz62rseywImqjy5nkjEHl5bynSPWnJMbpP3G36xP9Wq2GZdTHrdhdT/yaqNQjhzzQvhZa3g==
X-Received: by 2002:a62:80ce:0:b029:19d:b280:5019 with SMTP id j197-20020a6280ce0000b029019db2805019mr35938346pfd.43.1609520606095;
        Fri, 01 Jan 2021 09:03:26 -0800 (PST)
Received: from [127.0.0.1] ([118.34.233.180])
        by smtp.gmail.com with ESMTPSA id e6sm13599888pjr.34.2021.01.01.09.03.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 Jan 2021 09:03:25 -0800 (PST)
From:   Jinoh Kang <jinoh.kang.kr@gmail.com>
Subject: [PATCH 5.4 bp v2] ext4: don't remount read-only with errors=continue
 on reboot
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Jan Kara <jack@suse.cz>, Andreas Dilger <adilger@dilger.ca>,
        Theodore Ts'o <tytso@mit.edu>, stable@vger.kernel.org
References: <16091470451704@kroah.com>
 <5611c936-5913-d570-36a4-2b2ed209cd88@gmail.com> <1609147045182133@kroah.com>
Message-ID: <9efcb977-b6a6-b5b4-04a7-59b376b890e5@gmail.com>
Date:   Fri, 1 Jan 2021 17:03:21 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:78.0) Gecko/20100101 Firefox/78.0
MIME-Version: 1.0
In-Reply-To: <1609147045182133@kroah.com>
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
[jinoh: backport accounting for missing
  commit 9b5f6c9b83d9 ("ext4: make s_mount_flags modifications atomic")]
Signed-off-by: Jinoh Kang <jinoh.kang.kr@gmail.com>
---
v1 --> v2: added missing comment and signoff
Apologies for wasted traffic...

Please disregard the previous mail, which was in a wrong thread:
- <5611c936-5913-d570-36a4-2b2ed209cd88@gmail.com> [PATCH 5.4 bp]
That said, the patches for 4.19 and 5.4 have the same patch ID.
---
 fs/ext4/super.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 920658ca8777..06568467b0c2 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -455,19 +455,17 @@ static bool system_going_down(void)
 
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

