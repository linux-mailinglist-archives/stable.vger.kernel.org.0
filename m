Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DDEC536317
	for <lists+stable@lfdr.de>; Fri, 27 May 2022 15:02:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345414AbiE0NCn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 May 2022 09:02:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238766AbiE0NCm (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 May 2022 09:02:42 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 234EA36171;
        Fri, 27 May 2022 06:02:41 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id l188-20020a1c25c5000000b003978df8a1e2so625342wml.1;
        Fri, 27 May 2022 06:02:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2qWgwOMIZoZnoqcx4izZwNBl2nOWFWpcJl0NLoI3n8I=;
        b=D1asEyurKfOj4O5wyIM2tCD77qiG2CDbf5Rm4L+CPlOeY05rXGZ42wq0lRN87FsOBx
         vtA6XNJYHu82PXphIrsIqiv7wEEDZyxiROgBhER/IegsC4js781gTLAPu4SWQ9dTlnzz
         XRVOkhdhPUk8gWCshQ5Oh70vUnaBXqXuziDEh2Eq+q1FhONkFoLzLnnlFSuZYFbh00e8
         RHGvigeRP3HT4/asV/J5pgLylsKOPBcskqb4teBN7ArlOmhpnmvtpkTkWKX2cccLr/CZ
         C+/F1ridNKYVlD76tJZnryRvjrfmy/S5zI4EimJ1NbBTNxHdPA2Pc6/3huTuYQnDd5Zf
         YioQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2qWgwOMIZoZnoqcx4izZwNBl2nOWFWpcJl0NLoI3n8I=;
        b=AOImio6jZVa6PN8igIaGTB0PtiJnsIz9nbAIofuAXxDL6KU4dhmiAqIbXJteo1+lnj
         Hg8+TS9D2NbYc7Emj+1bFVokT8P4ogxammQ/kxOX3eeKU5aZmdvbFahfANyCRyay/FLC
         JhjHDjRm1mpq8LCy90ZKFCtmlogZXY/9aSLB1FvWWRk94LVcbn4ENLOvtojv8kOgrx0a
         VBrsW3IwZyBoj/RHDDzTE2KQzwJPdk2gtxn2I1wAiMJnNE/VEGye4aOdCHXXAAK9X43r
         DaoKFwfnIoM2u2SwPPI1WyHDrYy/a53jAYg9RtbESxfpC7oPKz7ypZVaWSKN+OMwtV14
         ruHw==
X-Gm-Message-State: AOAM531j8JqeCOfticLh4MciCJvlRsLrwrvCdJzwTjhBsWC/iyG8u/+z
        K8qN3z/w7owvV3nwgUVD71o=
X-Google-Smtp-Source: ABdhPJyZMS3hMDKVoKJL4EN8AfFxBYaewcCJ18FDO7g7uVvOcs6VQGCWuBZUahHthiSIqZqYE/IRcg==
X-Received: by 2002:a7b:cd0b:0:b0:397:49cf:2ef0 with SMTP id f11-20020a7bcd0b000000b0039749cf2ef0mr7005306wmj.156.1653656559614;
        Fri, 27 May 2022 06:02:39 -0700 (PDT)
Received: from amir-ThinkPad-T480.lan ([77.137.79.96])
        by smtp.gmail.com with ESMTPSA id l36-20020a05600c08a400b003942a244f48sm1932569wmp.33.2022.05.27.06.02.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 May 2022 06:02:39 -0700 (PDT)
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
        linux-xfs@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH 5.10 v2 1/5] xfs: detect overflows in bmbt records
Date:   Fri, 27 May 2022 16:02:15 +0300
Message-Id: <20220527130219.3110260-2-amir73il@gmail.com>
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

From: "Darrick J. Wong" <darrick.wong@oracle.com>

commit acf104c2331c1ba2a667e65dd36139d1555b1432 upstream.

Detect file block mappings with a blockcount that's either so large that
integer overflows occur or are zero, because neither are valid in the
filesystem.  Worse yet, attempting directory modifications causes the
iext code to trip over the bmbt key handling and takes the filesystem
down.  We can fix most of this by preventing the bad metadata from
entering the incore structures in the first place.

Found by setting blockcount=0 in a directory data fork mapping and
watching the fireworks.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/xfs/libxfs/xfs_bmap.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index d9a692484eae..de9c27ef68d8 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -6229,6 +6229,11 @@ xfs_bmap_validate_extent(
 	xfs_fsblock_t		endfsb;
 	bool			isrt;
 
+	if (irec->br_startblock + irec->br_blockcount <= irec->br_startblock)
+		return __this_address;
+	if (irec->br_startoff + irec->br_blockcount <= irec->br_startoff)
+		return __this_address;
+
 	isrt = XFS_IS_REALTIME_INODE(ip);
 	endfsb = irec->br_startblock + irec->br_blockcount - 1;
 	if (isrt && whichfork == XFS_DATA_FORK) {
-- 
2.25.1

