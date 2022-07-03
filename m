Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9E56564530
	for <lists+stable@lfdr.de>; Sun,  3 Jul 2022 07:29:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230181AbiGCFFL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 3 Jul 2022 01:05:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230079AbiGCFFK (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 3 Jul 2022 01:05:10 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE378AE60;
        Sat,  2 Jul 2022 22:05:09 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id v9so8746083wrp.7;
        Sat, 02 Jul 2022 22:05:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jWTWqlf63bfl2dBzELQaX/wALjoGLXLp+lgv6pf5bNM=;
        b=g+ugRRivwVTE22qyYY3KSVNSqOfntC5+/eUpxnsU802rEeKjAqBSDSRm28NZGkF08s
         I/mdquqpsPBRappCpkk8L8wO54PdkR+k1OdzWGuMwqSXMNv4LXfoUIoTKtiLFsyuKgxj
         uGqukdB7rTDgMY2LhfGNnLxn7SJYhLPHxlgVw1HrBZ/rjAjwIzEiszx9N1ziZmkdiJKN
         092tSojik88A+hjbYt8ieHvNbe/Yzgu7LSMsp+D6Iohiy3npJM3l8T/m+JpQPTulLTmh
         yrr+9TPFiZOZq9LnNY7gM/VSIAs8OK3ZIew6woHsdwcOCX6VFJXTRZpRYFK/rg0JFeqo
         S/3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jWTWqlf63bfl2dBzELQaX/wALjoGLXLp+lgv6pf5bNM=;
        b=R8MHPar4BJoPW7RnLH7dBhTvX+A4nLCifAZSSKQqRopb5AX3xVLmnrQzq4t5WomT8b
         qaeg9QjM9zy+wkuPMC7fVwQCVNGy0sJE2ehDKrjnLEn4/8vMRvZwqiHSffJORUgKE6kC
         e7VOsDSOsGI0DHg0QbL0jBdgcDJ9quDNg1vuBZyJLE/2rJ+N7jOE1R9iNnUzAfZFl4hc
         uXFWcNAujHY+ODDrM7OCAONLerRujFYVgObrU10vIOnFCTU55zwJsgPmJLCHSqSJMOon
         w3GRXWrkHBeO97tz6ifqkbuLwCTSc4lZWx5jVFPC0UhZIoXT2vh60CDu6NT74BoUVkmc
         rbMg==
X-Gm-Message-State: AJIora8wC5bhQH5JYb8XZ42D2byd5CitKvCUl9Kolf15wgsfNMdTAPXs
        eSAu4lvpoihveq1dRhqnTuI=
X-Google-Smtp-Source: AGRyM1sd9vlgmSK/jbNHmb4NXxZoKRjizstwWWWngz+nwADJluTxemwdDXoyeDv2yLVEIQyzWVGPhg==
X-Received: by 2002:a05:6000:1a8b:b0:21d:3f55:f156 with SMTP id f11-20020a0560001a8b00b0021d3f55f156mr14008242wry.445.1656824708336;
        Sat, 02 Jul 2022 22:05:08 -0700 (PDT)
Received: from amir-ThinkPad-T480.lan ([5.29.8.191])
        by smtp.gmail.com with ESMTPSA id e2-20020adfdbc2000000b0021b9f126fd3sm27028952wrj.14.2022.07.02.22.05.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 02 Jul 2022 22:05:07 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Sasha Levin <sashal@kernel.org>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Leah Rumancik <leah.rumancik@gmail.com>,
        Chandan Babu R <chandan.babu@oracle.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Adam Manzanares <a.manzanares@samsung.com>,
        linux-xfs@vger.kernel.org, stable@vger.kernel.org,
        Gao Xiang <hsiangkao@redhat.com>,
        Christoph Hellwig <hch@lst.de>
Subject: [PATCH 5.10 v3 4/7] xfs: ensure xfs_errortag_random_default matches XFS_ERRTAG_MAX
Date:   Sun,  3 Jul 2022 08:04:53 +0300
Message-Id: <20220703050456.3222610-5-amir73il@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220703050456.3222610-1-amir73il@gmail.com>
References: <20220703050456.3222610-1-amir73il@gmail.com>
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

From: Gao Xiang <hsiangkao@redhat.com>

commit b2c2974b8cdf1eb3ef90ff845eb27b19e2187b7e upstream.

Add the BUILD_BUG_ON to xfs_errortag_add() in order to make sure that
the length of xfs_errortag_random_default matches XFS_ERRTAG_MAX when
building.

Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_error.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
index 7f6e20899473..f9e2f606b5b8 100644
--- a/fs/xfs/xfs_error.c
+++ b/fs/xfs/xfs_error.c
@@ -293,6 +293,8 @@ xfs_errortag_add(
 	struct xfs_mount	*mp,
 	unsigned int		error_tag)
 {
+	BUILD_BUG_ON(ARRAY_SIZE(xfs_errortag_random_default) != XFS_ERRTAG_MAX);
+
 	if (error_tag >= XFS_ERRTAG_MAX)
 		return -EINVAL;
 
-- 
2.25.1

