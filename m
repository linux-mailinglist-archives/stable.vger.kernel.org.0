Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2FEF3E97B9
	for <lists+stable@lfdr.de>; Wed, 11 Aug 2021 20:37:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230309AbhHKShp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Aug 2021 14:37:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229802AbhHKSho (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Aug 2021 14:37:44 -0400
Received: from mail-qt1-x836.google.com (mail-qt1-x836.google.com [IPv6:2607:f8b0:4864:20::836])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D56F6C061765
        for <stable@vger.kernel.org>; Wed, 11 Aug 2021 11:37:20 -0700 (PDT)
Received: by mail-qt1-x836.google.com with SMTP id w10so2883290qtj.3
        for <stable@vger.kernel.org>; Wed, 11 Aug 2021 11:37:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xD+VK3L998w69TK+GIGcMqW+brd/MxrzVzDmY1Ufij0=;
        b=hoQHHm0+saPiVOe+74eP6G+yhPNIcnWxhODC3QgUKCJ5SPFjl4sBoRpNs/wH0miDvj
         SiYir2Kpuc6mMJK8eFVrxiBvQDezY5w4evjgbUDrosuQ0EdsXYeqrFNUmts+CHHld8ch
         1iUQNUFCi0gADY0NIbbiXcUDC56SC3+v6JkSYARKhGu0sTmOlAC75kWf8fMG9GTut+jP
         aRlmm7uivk4/iQ8l2AG1YsZwU+hDCr0YT6JeMptbw80MPtPNr5V8GnuIrVPa5HsgDYDu
         BBS+Z65w0iINr39jy+GOn/1uRQzM/ciXonfzBHSHRXnpyVCL7gqoK/H6wzWBHyOPLYUf
         DnfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xD+VK3L998w69TK+GIGcMqW+brd/MxrzVzDmY1Ufij0=;
        b=L1EjLbbpfwmwh5WNetn1prkrYoPEN3d/hKgNfbhhFohxXGL8r+MdOvrXCH7bYa34Tm
         5E5j8CsSe6N1nkv3iyj2RaCmljhWtljJ075X6MK3sJmrMwlkN4QQ20jhNjsCSeO9MmMu
         KlZy1MMUe6Z4pl5Sogq+1dMmQwDr/2CmEP72XWBOePLNhoUNZFoKIelBbf8IJwjOXS9H
         iU3zPuNQMZSUjzhXIBhz8vhD/92nxeIa/VBJgadQcOjNmAZf8BghhmeePxe2tMszURVx
         DatRLM9xdc23PvuksjKtrlhDCX/Vj46tyUfaHIxD2sj0I0L1VmzQGOgau28IGSOTNuTm
         mmZg==
X-Gm-Message-State: AOAM530bsFmkM9+x0rSMWDU3DVFscZhlQ5s1Fr8Xjdpfqb+G+EwVFutp
        J7E30DtDRrnyVqaL9hAdc/DiYg==
X-Google-Smtp-Source: ABdhPJztTCx/5084L51L6LtWQ7hfa69eNMV+2VsaeGS/+VQO5DUTF8mj+YSfH5TEhwCZ3Rd2Yxwr0g==
X-Received: by 2002:ac8:4e88:: with SMTP id 8mr87703qtp.269.1628707039857;
        Wed, 11 Aug 2021 11:37:19 -0700 (PDT)
Received: from localhost (cpe-174-109-172-136.nc.res.rr.com. [174.109.172.136])
        by smtp.gmail.com with ESMTPSA id h6sm31299qtb.44.2021.08.11.11.37.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Aug 2021 11:37:19 -0700 (PDT)
From:   Josef Bacik <josef@toxicpanda.com>
To:     linux-btrfs@vger.kernel.org, kernel-team@fb.com
Cc:     stable@vger.kernel.org
Subject: [PATCH 1/2] btrfs: reduce the preemptive flushing threshold to 90%
Date:   Wed, 11 Aug 2021 14:37:15 -0400
Message-Id: <465ed2e70752cf6922f9ecdc2eaf4f2663654b68.1628706812.git.josef@toxicpanda.com>
X-Mailer: git-send-email 2.26.3
In-Reply-To: <cover.1628706812.git.josef@toxicpanda.com>
References: <cover.1628706812.git.josef@toxicpanda.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The preemptive flushing code was added in order to avoid needing to
synchronously wait for ENOSPC flushing to recover space.  Once we're
almost full however we can essentially flush constantly.  We were using
98% as a threshold to determine if we were simply full, however in
practice this is a really high bar to hit.  For example reports of
systems running into this problem had around 94% usage and thus
continued to flush.  Fix this by lowering the threshold to 90%, which is
a more sane value, especially for smaller file systems.

cc: stable@vger.kernel.org
Link: https://bugzilla.kernel.org/show_bug.cgi?id=212185
Fixes: 576fa34830af ("btrfs: improve preemptive background space flushing")
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/btrfs/space-info.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/space-info.c b/fs/btrfs/space-info.c
index d9c8d738678f..ddb4878e94df 100644
--- a/fs/btrfs/space-info.c
+++ b/fs/btrfs/space-info.c
@@ -733,7 +733,7 @@ static bool need_preemptive_reclaim(struct btrfs_fs_info *fs_info,
 {
 	u64 global_rsv_size = fs_info->global_block_rsv.reserved;
 	u64 ordered, delalloc;
-	u64 thresh = div_factor_fine(space_info->total_bytes, 98);
+	u64 thresh = div_factor(space_info->total_bytes, 9);
 	u64 used;
 
 	/* If we're just plain full then async reclaim just slows us down. */
-- 
2.26.3

