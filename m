Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EAC153631A
	for <lists+stable@lfdr.de>; Fri, 27 May 2022 15:02:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351633AbiE0NCq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 May 2022 09:02:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238766AbiE0NCq (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 May 2022 09:02:46 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D918A38DA5;
        Fri, 27 May 2022 06:02:43 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id f23-20020a7bcc17000000b003972dda143eso4534008wmh.3;
        Fri, 27 May 2022 06:02:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LuV2WNWBzFzDFM9UzO8H2iJ9QFWj2tDa1lgS6fde0JU=;
        b=UvvABez8z9lZbkFJbj4IVJXKTyWP60hfRwmj8uhW2+hn4U1iQQbSVlNjLJj6JzsDvv
         dkfqaUixXEd8l0L7AijSNvw/t8RUb4NiIvD7pIFPvIBFLwp6kgL4lesmCjG3qACe/e3F
         MJhJoMoEZd0vBm/TY2/A09Ga98djpZBtJ8TdG/h1hsZnR1dUotLFRFZdZH04jGolLm3Y
         ++tksUi/5t8gVMQZqkdOoicsQbDeV/8qp63Tc5uRy2lmcUqY96a/DUh6VZcUje2TUxWZ
         Z79q+Ef1cPoYuN6klaYXfXlk3RMJxAyn9HhQjWewtr7AzNUn8RGum5OWbZyaUH8Ml6q5
         Nb6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LuV2WNWBzFzDFM9UzO8H2iJ9QFWj2tDa1lgS6fde0JU=;
        b=cofpERDbE4rfFECfpE2aqVZH4zlgaGsoxZFQWbs6A9tqwY/axaoXNO4Ttw5LSt5PBB
         wWR1rjduqJIYCXLyfy3HMzCVDF4OPNR319F1QOKe6Icnvu1u6BBM9sPe+rlPL/gk8o2/
         xYswje9GIDP5yAB2M8xK8a6FaGdwk69apZU2g7jdNjfaHU9gjBD46OaV+zOPHg7pu8mb
         o/V6P5RIueIe96Hau5ixrmdRg2Bm7mM3kw1VF9vZAAqy7a1mZL+IOmdN+1jhMlNygXaT
         rQeEowImZdH1V/KgnDmpKhYBk0tk1yKXNFXXRRV6sG0cDujEP8WzmKSH2wKRQkJiotkX
         D9CQ==
X-Gm-Message-State: AOAM532LlxDIklD24ayg1x1YYu0Tmt3xIsXN8gKxIfFKeajus8oKGjki
        mrRb83PfcOzUWHQPubxwhGA=
X-Google-Smtp-Source: ABdhPJwsxtxffw7pnTMq8yhgFiR9e6Tit/BAK9nBylpRWsfXZIdOd72ycjqt3uI8ZhN4FIicAqtwaQ==
X-Received: by 2002:a05:600c:2053:b0:397:36f3:c95e with SMTP id p19-20020a05600c205300b0039736f3c95emr6940543wmg.185.1653656561818;
        Fri, 27 May 2022 06:02:41 -0700 (PDT)
Received: from amir-ThinkPad-T480.lan ([77.137.79.96])
        by smtp.gmail.com with ESMTPSA id l36-20020a05600c08a400b003942a244f48sm1932569wmp.33.2022.05.27.06.02.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 May 2022 06:02:41 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Sasha Levin <sashal@kernel.org>,
        Dave Chinner <david@fromorbit.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Theodore Ts'o <tytso@mit.edu>,
        Leah Rumancik <leah.rumancik@gmail.com>,
        Chandan Babu R <chandan.babu@oracle.com>,
        Adam Manzanares <a.manzanares@samsung.com>,
        Tyler Hicks <code@tyhicks.com>, Jan Kara <jack@suse.cz>,
        linux-xfs@vger.kernel.org, stable@vger.kernel.org,
        Kaixu Xia <kaixuxia@tencent.com>
Subject: [PATCH 5.10 v2 2/5] xfs: show the proper user quota options
Date:   Fri, 27 May 2022 16:02:16 +0300
Message-Id: <20220527130219.3110260-3-amir73il@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220527130219.3110260-1-amir73il@gmail.com>
References: <20220527130219.3110260-1-amir73il@gmail.com>
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

From: Kaixu Xia <kaixuxia@tencent.com>

commit 237d7887ae723af7d978e8b9a385fdff416f357b upstream.

The quota option 'usrquota' should be shown if both the XFS_UQUOTA_ACCT
and XFS_UQUOTA_ENFD flags are set. The option 'uqnoenforce' should be
shown when only the XFS_UQUOTA_ACCT flag is set. The current code logic
seems wrong, Fix it and show proper options.

Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/xfs/xfs_super.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index e3e229e52512..5ebd6cdc44a7 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -199,10 +199,12 @@ xfs_fs_show_options(
 		seq_printf(m, ",swidth=%d",
 				(int)XFS_FSB_TO_BB(mp, mp->m_swidth));
 
-	if (mp->m_qflags & (XFS_UQUOTA_ACCT|XFS_UQUOTA_ENFD))
-		seq_puts(m, ",usrquota");
-	else if (mp->m_qflags & XFS_UQUOTA_ACCT)
-		seq_puts(m, ",uqnoenforce");
+	if (mp->m_qflags & XFS_UQUOTA_ACCT) {
+		if (mp->m_qflags & XFS_UQUOTA_ENFD)
+			seq_puts(m, ",usrquota");
+		else
+			seq_puts(m, ",uqnoenforce");
+	}
 
 	if (mp->m_qflags & XFS_PQUOTA_ACCT) {
 		if (mp->m_qflags & XFS_PQUOTA_ENFD)
-- 
2.25.1

