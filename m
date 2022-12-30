Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D6E965956A
	for <lists+stable@lfdr.de>; Fri, 30 Dec 2022 07:29:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229706AbiL3G3k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Dec 2022 01:29:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229617AbiL3G3j (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 30 Dec 2022 01:29:39 -0500
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 201D6136
        for <stable@vger.kernel.org>; Thu, 29 Dec 2022 22:29:37 -0800 (PST)
Received: by mail-ej1-x62a.google.com with SMTP id gh17so49578299ejb.6
        for <stable@vger.kernel.org>; Thu, 29 Dec 2022 22:29:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=CUtBC29RnUwaoeYV0vES6XTh4g9FzCYRz5OdufIfOhg=;
        b=yYitSniTvjeQRhVimVN+FPInjYa5pmqRCEW+3cXECKtHvauKCI39aaGTAWbXbEwaoQ
         0syqcsil4KsHV5MNoA4sTSCYSIQfjPTNAoQ0qT4mmNU+bBwq3L/cf+Rv2aKsbKQqolnJ
         snceasG2i8OGsEPSDwKLONIX/YK92p+BXGIAvdV0rJYeiKgdbOnqrkJ0NZIt6LusRIQv
         Jrp2jLLuq6JBXGSeRvfRS1WwVgnQ+nHD2DaNOSPBgJLKOONTQp63s3iWEY1NWjWvgIsT
         pDIebcp/92j6AuEwEvENpcspbx5hDgUtXUgxRJUHmTc+wvD2ye4zGzTOq8Ehfz8jCO9w
         Khcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CUtBC29RnUwaoeYV0vES6XTh4g9FzCYRz5OdufIfOhg=;
        b=oTql3P15fUuTntvAE7hYON9PLTEQ3wlTXkOUpkjcyb8ty5oy0y1gsn2raj2hNGuaI2
         WsEIrM2sViTC5TFKpW21EymWBSiFOzMn1SXJaCMAM80SoBP+MtJf4himxHA1lsmBao7y
         9t2dfQghjPCMARi16cOqxzhXl0MpmKA5LykxREulOYy6hG64vCwATrLBVdG21opsPgl0
         UBg6OtyK7jfRh392Mg2HKKQwjelY7v9PdDS3W/dY8zUZsxcGh/R9Inrdlnqn+0lhlNuF
         4IBfR1Ze82e03GouC786i5xR6TErFcsEQO6iAzGGO9GDvvS85gqkDZ+yYIt4CBQtHES0
         vJsw==
X-Gm-Message-State: AFqh2kqbSEj3hh+ZViRafGIdTxczti/9UnDt9IyCJstxOxL3ZcQAI3uA
        GuFCDopInEOai+yQR+YPwOvKqA==
X-Google-Smtp-Source: AMrXdXs1UZrpLLkZ5ZmlfkTjJq5g6i/yWopFxpcADP6xLPPSM3mD12zBDvjytJWXrXfkZOquEYFpRA==
X-Received: by 2002:a17:907:a0cc:b0:78d:f454:37a6 with SMTP id hw12-20020a170907a0cc00b0078df45437a6mr26722795ejc.73.1672381775733;
        Thu, 29 Dec 2022 22:29:35 -0800 (PST)
Received: from alba.. ([82.77.81.131])
        by smtp.gmail.com with ESMTPSA id p25-20020aa7cc99000000b004678b543163sm8941370edt.0.2022.12.29.22.29.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Dec 2022 22:29:35 -0800 (PST)
From:   Tudor Ambarus <tudor.ambarus@linaro.org>
To:     tytso@mit.edu, adilger.kernel@dilger.ca
Cc:     linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        joneslee@google.com, Tudor Ambarus <tudor.ambarus@linaro.org>,
        syzbot+0827b4b52b5ebf65f219@syzkaller.appspotmail.com,
        stable@vger.kernel.org
Subject: [PATCH v2] ext4: Fix possible use-after-free in ext4_find_extent
Date:   Fri, 30 Dec 2022 08:29:31 +0200
Message-Id: <20221230062931.2344157-1-tudor.ambarus@linaro.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1780; h=from:subject; bh=U6sdxC4dljuI9QHvwdLKmBfCri/ltD6JexhZ1sawArg=; b=owGbwMvMwMXoHervvrRX5CXjabUkhuR1rd4lPclfDqqtPpObd6vlb2WaJMduq8rbJy9pc4bsexob xvakk9GYhYGRi0FWTJFF1knr1Hm+E7lxsv/uwwxiZQKZwsDFKQATKf/M/j+oIyo8U8zc7YtfI+tLx6 Uv++7NDy1vf3IuQ0D4cln0RTHXBYcvKJxNif96wuXWn1Nv4mouxj/c4Ni+PGBOwH9WdXMmRVPDj0zt ck8XmFdr/JuReqGM8ZYk9/ptvzilc0/6zylN6fJcFiYV4czaaX6JZU56n9xCO16jiFAVMYsmYa1tPP UtNQaJUf/V1Bpknp6Zb6MyX3RtZdiCz1N45n9bdkyiikV7Tp7W50uv3FMn/lCdxLlvR3dNxhflwrik 3+8SHbn1CyfoLJHwLlFLqf6y+FP2lPMM72I7lbfrNkn9ORF8oZf355kaDXabB2vX/7b4Is7ArLmeWc rA5taTzpwLS/elTl3wLfi1RNtJAA==
X-Developer-Key: i=tudor.ambarus@linaro.org; a=openpgp; fpr=280B06FD4CAAD2980C46DDDF4DB1B079AD29CF3D
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

syzbot reported a use-after-free Read in ext4_find_extent that is hit when
using a corrupted file system. The bug was reported on Android 5.15, but
using the same reproducer triggers the bug on v6.2-rc1 as well.

Fix the use-after-free by checking the extent header magic. An alternative
would be to check the values of EXT4_{FIRST,LAST}_{EXTENT,INDEX} used in
ext4_ext_binsearch() and ext4_ext_binsearch_idx(), so that we make sure
that pointers returned by EXT4_{FIRST,LAST}_{EXTENT,INDEX} don't exceed the
bounds of the extent tree node. But this alternative will not squash
the bug for the cases where eh->eh_entries fit into eh->eh_max. We could
also try to check the sanity of the path, but costs more than checking just
the header magic, so stick to the header magic sanity check.

Link: https://syzkaller.appspot.com/bug?id=be6e90ce70987950e6deb3bac8418344ca8b96cd
Reported-by: syzbot+0827b4b52b5ebf65f219@syzkaller.appspotmail.com
Cc: stable@vger.kernel.org
Signed-off-by: Tudor Ambarus <tudor.ambarus@linaro.org>
---
v2: drop wrong/uneeded le16_to_cpu() conversion for eh->eh_magic

 fs/ext4/extents.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 9de1c9d1a13d..bedc8c098449 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -894,6 +894,12 @@ ext4_find_extent(struct inode *inode, ext4_lblk_t block,
 		gfp_flags |= __GFP_NOFAIL;
 
 	eh = ext_inode_hdr(inode);
+	if (eh->eh_magic != EXT4_EXT_MAGIC) {
+		EXT4_ERROR_INODE(inode, "Extent header has invalid magic.");
+		ret = -EFSCORRUPTED;
+		goto err;
+	}
+
 	depth = ext_depth(inode);
 	if (depth < 0 || depth > EXT4_MAX_EXTENT_DEPTH) {
 		EXT4_ERROR_INODE(inode, "inode has invalid extent depth: %d",
-- 
2.34.1

