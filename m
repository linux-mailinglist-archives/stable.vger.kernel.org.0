Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE78D23AA58
	for <lists+stable@lfdr.de>; Mon,  3 Aug 2020 18:17:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726889AbgHCQRs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Aug 2020 12:17:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726802AbgHCQRr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Aug 2020 12:17:47 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1CD6C06174A;
        Mon,  3 Aug 2020 09:17:47 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id 2so98662pjx.5;
        Mon, 03 Aug 2020 09:17:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=GPsrQW4vpQ6dRXyrzWsHOIAruTyA0LII1zG3YHLs52M=;
        b=fMlUIz0rLEz3np/lgOR1J/xdo3PvyCdrkMOYNmTrImerYZd+Z0ERvgCmlU2O7XaXiN
         /rPjHx8143fNjlGV2LmOwBz6+b4AMyK3K2t+G/vrlqRbWt/s8ECFfIYlmrYWMQtw0raE
         S1DzcRzxmD4IHLSkpGCXUHciCUU31SBZsiZWitkeHTVLkjXV78v5JzNat5JLyDYj10eD
         QShTyvnNM7yjM7k6zlXp4lTkX1CBtYRuEGSHwNXjeY6OTPjNDYBqQtVXc0Rb/YIjwVrI
         uLs7ivpbkukdz6x3NNl8bVqqlMCGKzIDxU3L//Qp3uEpwMzkgJcm7wvwcT5PjHfn4vYa
         dOhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=GPsrQW4vpQ6dRXyrzWsHOIAruTyA0LII1zG3YHLs52M=;
        b=Uzek/6Yacyy7zrdp+wlhntVybN2k0hYeCkBffYoMiAXG0QymmTP2DIf8hS6xMUpVBM
         WUoJLcBXyQQeE98UqJgVTcBG+dAKrEJU3qqz5PaEF6j1/j7nLcjsPMQCTKv1W/1ruu9n
         fTyym5IFCwEYbX0P+X5kwoR8imeyqC1h39P908QMXED+zwNc3215s+OxC3i3huOEngOX
         FRs3uESIIULfIMEzNC/8JC7yHsyagLnalrD5Qz0H542DpbobeJ+lEWJkSwbqEToFSbGS
         jQsiyNzu/MP50NbQNGBFqrbGV0sQSs+Po3ar2+VF7U5RpboukPKpmjEDw4lbC9BpqHLw
         WWLg==
X-Gm-Message-State: AOAM5337r45QwI02anObOZg0WHmeyz3w6jRRF5G3hIZX1RsPYqG/3Y8i
        vSuh191Ux1rniYcp9hxereGzYLETiwvg3Q==
X-Google-Smtp-Source: ABdhPJw7avMZq/kZ3NOZty8xBaeBN9sb48D/0vRuTEUPmcWVWsBvmPfrnSh14aB4vO5FXDt8YNYHFw==
X-Received: by 2002:a17:902:eb14:: with SMTP id l20mr9684125plb.104.1596471466713;
        Mon, 03 Aug 2020 09:17:46 -0700 (PDT)
Received: from lazar-beloica-cent7-umvm1.dev.nutanix.com ([192.146.154.242])
        by smtp.gmail.com with ESMTPSA id d65sm19316102pfc.97.2020.08.03.09.17.45
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 03 Aug 2020 09:17:45 -0700 (PDT)
From:   Lazar Beloica <lazarbeloica@gmail.com>
X-Google-Original-From: Lazar Beloica <lazar.beloica@nutanix.com>
To:     linux-ext4@vger.kernel.org
Cc:     stable@vger.kernel.org, lazarbeloica@gmail.com,
        lazar.beloica@nutanix.com, boyu.mt@taobao.com,
        adilger.kernel@dilger.ca, linux-kernel@vger.kernel.org
Subject: [PATCH] ext4: fix marking group trimmed if all blocks not trimmed
Date:   Mon,  3 Aug 2020 16:17:44 +0000
Message-Id: <1596471464-198715-1-git-send-email-lazar.beloica@nutanix.com>
X-Mailer: git-send-email 1.8.3.1
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When FTRIM is issued on a group, ext4 marks it as trimmed so another FTRIM
on the same group has no effect. Ext4 marks group as trimmed if at least
one block is trimmed, therefore it is possible that a group is marked as
trimmed even if there are blocks in that group left untrimmed.

This patch marks group as trimmed only if there are no more blocks
in that group to be trimmed.

Fixes: 3d56b8d2c74cc3f375ce332b3ac3519e009d79ee
Tested-by: Lazar Beloica <lazar.beloica@nutanix.com>
Signed-off-by: Lazar Beloica <lazar.beloica@nutanix.com>
---
 fs/ext4/mballoc.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index c0a331e..130936b 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -5346,6 +5346,7 @@ static int ext4_trim_extent(struct super_block *sb, int start, int count,
 {
 	void *bitmap;
 	ext4_grpblk_t next, count = 0, free_count = 0;
+	ext4_fsblk_t max_blks = ext4_blocks_count(EXT4_SB(sb)->s_es);
 	struct ext4_buddy e4b;
 	int ret = 0;
 
@@ -5401,7 +5402,9 @@ static int ext4_trim_extent(struct super_block *sb, int start, int count,
 
 	if (!ret) {
 		ret = count;
-		EXT4_MB_GRP_SET_TRIMMED(e4b.bd_info);
+		next = mb_find_next_bit(bitmap, max_blks, max + 1);
+		if (next == max_blks)
+			EXT4_MB_GRP_SET_TRIMMED(e4b.bd_info);
 	}
 out:
 	ext4_unlock_group(sb, group);
-- 
1.8.3.1

