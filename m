Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 145A05A8D9C
	for <lists+stable@lfdr.de>; Thu,  1 Sep 2022 07:49:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233176AbiIAFtr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Sep 2022 01:49:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233234AbiIAFtd (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Sep 2022 01:49:33 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F4FA1178F8;
        Wed, 31 Aug 2022 22:49:18 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id n23-20020a7bc5d7000000b003a62f19b453so709387wmk.3;
        Wed, 31 Aug 2022 22:49:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=rXO269FD1Qqh/3kSRd+jcHDLkTXo4nk6CloH8biq0G4=;
        b=lcBt1D2ozbfxCreI8a5QDg6/ghKxaGngsLVwnAdnPAygerzAQSYoe3s8OksG+rl4d0
         /myztBG8tQiuKXMBdzcwdpcxDoZ6TeYx59gZ/4/wZnUgcAgvYBNvVCdNFM/G5lzkNb2z
         7krFgN0kkMlXyaFuu1MbqsfrtQFFUwPo3nPISnXAfPbBWPRChQ93WqVcOl0FMJ1/mZ8/
         1USYKzYxOqCVScMZ3WYm6EQQ+a0O5GAJvNIKng9zIcFYxNKKJ8Bb4CxF1wSsBw44La/h
         HqqvJ6EYVgxFaFCRgGU4hYUgfClKP1U5FCd9sNd8q83eVKAT6mo2tXMfn5mAwCp5EAYx
         rsWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=rXO269FD1Qqh/3kSRd+jcHDLkTXo4nk6CloH8biq0G4=;
        b=Yio69aXhtA4Nb51rZyRchpHNePRWpQ6VP5Yy+2Q/tKtakaiGzBvXaepqdWBWjkCeW1
         pJCJvpagj5VNhKvjAFA6VOsOyFu3CvuADEAKATFbFDm3co+DnsZnNDHP59Dk2X+o/rAU
         eqTquJeDTjPk9tcTJzh8OC1ldf6bkiAcwvHKX+Rf97jEXuD0Y9tNcEK/EsWlHQ4i54EV
         Cs6klg+tBplIdXjdFhfafNZCpbNWrwZ2/Oiy/tcgEfbugkqyBjW85NPeguy348oHKJnj
         idJcF12oVEzNO5sJpl8eoRPPuUnqIHeAPvxGuYjJiW7etdqcEWpoPlTQGgKgZKIL24LU
         s32A==
X-Gm-Message-State: ACgBeo0HpzVOfJo73zfOs8hswX7fHw2NNT/2VP2UHiSkhw4AZp0nTraf
        1B4P2g2BkwMpJPlR4FlmciM=
X-Google-Smtp-Source: AA6agR6wP+xXOYpv+/W1Z5iqSGaKFtnj7VDL4EtJOlAuDX0SRIiKSnJggYSRVh+OkSgusl+5zmSVng==
X-Received: by 2002:a05:600c:3b92:b0:3a6:5645:5fc7 with SMTP id n18-20020a05600c3b9200b003a656455fc7mr3891845wms.148.1662011346725;
        Wed, 31 Aug 2022 22:49:06 -0700 (PDT)
Received: from localhost.localdomain ([77.137.66.49])
        by smtp.gmail.com with ESMTPSA id bg15-20020a05600c3c8f00b003a4f08495b7sm4447262wmb.34.2022.08.31.22.49.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Aug 2022 22:49:06 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Sasha Levin <sashal@kernel.org>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Leah Rumancik <leah.rumancik@gmail.com>,
        Chandan Babu R <chandan.babu@oracle.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Adam Manzanares <a.manzanares@samsung.com>,
        linux-xfs@vger.kernel.org, stable@vger.kernel.org,
        Dave Chinner <dchinner@redhat.com>
Subject: [PATCH 5.10 v2 3/7] xfs: fix overfilling of reserve pool
Date:   Thu,  1 Sep 2022 08:48:50 +0300
Message-Id: <20220901054854.2449416-4-amir73il@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220901054854.2449416-1-amir73il@gmail.com>
References: <20220901054854.2449416-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Darrick J. Wong" <djwong@kernel.org>

commit 82be38bcf8a2e056b4c99ce79a3827fa743df6ec upstream.

Due to cycling of m_sb_lock, it's possible for multiple callers of
xfs_reserve_blocks to race at changing the pool size, subtracting blocks
from fdblocks, and actually putting it in the pool.  The result of all
this is that we can overfill the reserve pool to hilarious levels.

xfs_mod_fdblocks, when called with a positive value, already knows how
to take freed blocks and either fill the reserve until it's full, or put
them in fdblocks.  Use that instead of setting m_resblks_avail directly.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_fsops.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index dacead0d0934..775f833146e3 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -394,18 +394,17 @@ xfs_reserve_blocks(
 		 * count or we'll get an ENOSPC.  Don't set the reserved flag
 		 * here - we don't want to reserve the extra reserve blocks
 		 * from the reserve.
+		 *
+		 * The desired reserve size can change after we drop the lock.
+		 * Use mod_fdblocks to put the space into the reserve or into
+		 * fdblocks as appropriate.
 		 */
 		fdblks_delta = min(free, delta);
 		spin_unlock(&mp->m_sb_lock);
 		error = xfs_mod_fdblocks(mp, -fdblks_delta, 0);
-		spin_lock(&mp->m_sb_lock);
-
-		/*
-		 * Update the reserve counters if blocks have been successfully
-		 * allocated.
-		 */
 		if (!error)
-			mp->m_resblks_avail += fdblks_delta;
+			xfs_mod_fdblocks(mp, fdblks_delta, 0);
+		spin_lock(&mp->m_sb_lock);
 	}
 out:
 	if (outval) {
-- 
2.25.1

