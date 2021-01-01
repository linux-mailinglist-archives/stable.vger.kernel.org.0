Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5372B2E8405
	for <lists+stable@lfdr.de>; Fri,  1 Jan 2021 15:59:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727047AbhAAO7G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Jan 2021 09:59:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726747AbhAAO7D (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Jan 2021 09:59:03 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB379C061573
        for <stable@vger.kernel.org>; Fri,  1 Jan 2021 06:58:22 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id f14so6187818pju.4
        for <stable@vger.kernel.org>; Fri, 01 Jan 2021 06:58:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:subject:to:cc:references:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=1jJ4DIg1DG4CUX5hD4mUZaQR31ZbEgSz1zvnTJMfNbY=;
        b=Je3+/nByf2iaJKOUmfes55E9uqc6yGGoNUXWECzveEss79abu6tsQuRprFdQtQYfoz
         RNmr+79tfn3aXf2LraFMLdhzBQf4KvcHqTmNOAOTQ7QrwaNWb0Dise29QqvFCUd7aC5Q
         ojK1nlKNqMDFlZELzpWEp6rBWfrI8bERBaAoX7coeOWxhDu0BHALhvNfTk9lWEWFb8Ts
         54eOBQonnybsxX1EJRNXQ86tzP2CYzzU2OUUfusquB+fdIxBhzitiX/mZfC+RckTEFcc
         vxIU5tNVO1IZiq25RGZkT/U3DQI5olm3fFvC58f4ochmC7zeaMNEXl1alH/mim3ustD8
         7EcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:references:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=1jJ4DIg1DG4CUX5hD4mUZaQR31ZbEgSz1zvnTJMfNbY=;
        b=Eg0W4MrOGsOjEcVRd/L7CeaPspFuxPdbvgMA6poP+SYU3YwLSYgZ56gJTkp82mtqYK
         IGt0Wt9WKrmN4KgX14MZnwcX1H6Uu/XYiaFJYKwfDMP5/cCKUMWWkc4/QFnMv61YeKbY
         KeQ3zQQdrIlSmJKuEgSrv0Pf4wYyqlup/NtgU4+2Hp7vWEhz/szLIVQODV8AYWpLcILZ
         GVRsLPpLBkPqpK6AaXR2Y6yZlZTEsAZrWpnOf75o+JELitpINU9VG5iUiRfpgKDi9U1R
         rOX/NpL2W7xVo8NdfeZBXCZXL1nReXllnD7MleMpXTYU4qibrmwJ6yJkC9RIhzzWqaH9
         WgdA==
X-Gm-Message-State: AOAM531y8CZyb8pd7lF9UyW8i4oFPGHz+9fVvUrXIxyOBoTdK1slqIkw
        w79UxuxloEXSqNGxxT3WruklZYLyDBug+g==
X-Google-Smtp-Source: ABdhPJxYm6O5p327OWe/MI9gujkGNw4rfMBnct8RTBoWrglgqLidzUZs/tgnCJCDz7B8BzUD8CBwxA==
X-Received: by 2002:a17:902:ab8b:b029:da:f377:e7d7 with SMTP id f11-20020a170902ab8bb02900daf377e7d7mr41398616plr.4.1609513102166;
        Fri, 01 Jan 2021 06:58:22 -0800 (PST)
Received: from [127.0.0.1] ([118.34.233.180])
        by smtp.gmail.com with ESMTPSA id y69sm48567019pfb.64.2021.01.01.06.58.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 Jan 2021 06:58:21 -0800 (PST)
From:   Jinoh Kang <jinoh.kang.kr@gmail.com>
Subject: [PATCH 5.4 bp] ext4: don't remount read-only with errors=continue on
 reboot
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Jan Kara <jack@suse.cz>, Andreas Dilger <adilger@dilger.ca>,
        Theodore Ts'o <tytso@mit.edu>, stable@vger.kernel.org
References: <16091470451704@kroah.com>
Autocrypt: addr=jinoh.kang.kr@gmail.com; keydata=
 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
 Nv8WeK9sQ0q6RmWqnT1HwyCBsVRR18k6XBM=
Message-ID: <5611c936-5913-d570-36a4-2b2ed209cd88@gmail.com>
Date:   Fri, 1 Jan 2021 14:58:16 +0000
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

