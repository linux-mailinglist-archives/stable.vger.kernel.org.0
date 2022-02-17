Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65E834BACFA
	for <lists+stable@lfdr.de>; Thu, 17 Feb 2022 23:59:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229455AbiBQW7y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Feb 2022 17:59:54 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:44570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229471AbiBQW7s (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Feb 2022 17:59:48 -0500
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 476682819A8
        for <stable@vger.kernel.org>; Thu, 17 Feb 2022 14:59:32 -0800 (PST)
Received: by mail-pg1-x52b.google.com with SMTP id h125so6271495pgc.3
        for <stable@vger.kernel.org>; Thu, 17 Feb 2022 14:59:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZIVtLYCYVy+ZnEnBv89ZDqCMTq3f5KWSBO5Xa1GIRSY=;
        b=CNy+Qwx+HEGhoHLMpHxucGosX2GwVFyVLpCG/AfkDtzS1r6ZMmvbQFTh6Cg5YoQ129
         vWqGeA4cCnOEPqdzXWn1MYSxeDem3ezdlOvg5v5uFe6ynPBga7CWNlMuQBX2rrc6vOSi
         TlO4WjJBtXmFc+2XlXESlYVvHLlYNIUyfyBWKNU2/STEdmoH/E5z8DBa0O05/kz/fmSz
         ODk1gK7joQ16Qsadu8CQPvH3yJiMv1+kspkRtIr4uFoATLUq28pqPfXcboLP6QdZn+Sh
         kbUsvtOt6/hj5FiNN23I26kz2gfl8Rp7TP5AuSH+cbe5hBZzR6Nwl6BXzvmBJEiGPilL
         A8iQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZIVtLYCYVy+ZnEnBv89ZDqCMTq3f5KWSBO5Xa1GIRSY=;
        b=Ye7UBb3+rRkBAITX2eVRNTpMY/gKzhggGH/Ssv2f0r0spFJ89/IHpA8K2RjKjeiasQ
         loON3szoLEhZnjK+u3Qo75atf6QAOSKRTdB9hI2kHZ6upP4EibogxOUWUB1DeleDoxHz
         F3ReThFRnOARbwAR+G4ko0bFw3GBrYIz8zbCj5JiJQFIDmAQRRm7tfGYDopWe+SvaNh1
         /BpCFwsSp84Yv/xq/kxOgVe8sHx9nkmfrmYE3cn1jeGwAjJYRj2/sx4kIwydfgK7+FUE
         zHR5ubv7+m2KcjE/6TlumEDdvrDI7qSmgPhWSqmRrg6ebEgrgiyVTrWBDwML3xIU8Sc7
         6UZQ==
X-Gm-Message-State: AOAM531UPDzTTMzlZ6CycqltYwaU67ReeqBn44HbLmYjsI5RsjpHlkqm
        DCqeWX2XWoAn5qETsH89UrHfSbWVlBMXsA==
X-Google-Smtp-Source: ABdhPJydVuTmk2ew3KrI6duOMuB5RA64SDmRd3BGUciU5N/6MOeMrS3LHIZw0vUlQXlV4dp2bWM77A==
X-Received: by 2002:a63:2b48:0:b0:365:2766:7e5f with SMTP id r69-20020a632b48000000b0036527667e5fmr4156467pgr.613.1645138771308;
        Thu, 17 Feb 2022 14:59:31 -0800 (PST)
Received: from lrumancik-glaptop2.roam.corp.google.com ([2601:647:4701:18d0:9e69:6ca2:e1cf:4ed2])
        by smtp.gmail.com with ESMTPSA id b16sm593260pfv.192.2022.02.17.14.59.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Feb 2022 14:59:31 -0800 (PST)
From:   Leah Rumancik <leah.rumancik@gmail.com>
To:     stable@vger.kernel.org
Cc:     Zhang Yi <yi.zhang@huawei.com>, Theodore Ts'o <tytso@mit.edu>,
        Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH for 5.4 3/3] ext4: prevent partial update of the extent blocks
Date:   Thu, 17 Feb 2022 14:59:14 -0800
Message-Id: <20220217225914.40363-3-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.35.1.473.g83b2b277ed-goog
In-Reply-To: <20220217225914.40363-1-leah.rumancik@gmail.com>
References: <20220217225914.40363-1-leah.rumancik@gmail.com>
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

From: Zhang Yi <yi.zhang@huawei.com>

commit 0f2f87d51aebcf71a709b52f661d681594c7dffa upstream.

In the most error path of current extents updating operations are not
roll back partial updates properly when some bad things happens(.e.g in
ext4_ext_insert_extent()). So we may get an inconsistent extents tree
if journal has been aborted due to IO error, which may probability lead
to BUGON later when we accessing these extent entries in errors=continue
mode. This patch drop extent buffer's verify flag before updatng the
contents in ext4_ext_get_access(), and reset it after updating in
__ext4_ext_dirty(). After this patch we could force to check the extent
buffer if extents tree updating was break off, make sure the extents are
consistent.

Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: Theodore Ts'o <tytso@mit.edu>
Link: https://lore.kernel.org/r/20210908120850.4012324-4-yi.zhang@huawei.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
---
 fs/ext4/extents.c | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 1ec6d0ccf5ba..f1bbce4350c4 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -133,14 +133,25 @@ static int ext4_ext_truncate_extend_restart(handle_t *handle,
 static int ext4_ext_get_access(handle_t *handle, struct inode *inode,
 				struct ext4_ext_path *path)
 {
+	int err = 0;
+
 	if (path->p_bh) {
 		/* path points to block */
 		BUFFER_TRACE(path->p_bh, "get_write_access");
-		return ext4_journal_get_write_access(handle, path->p_bh);
+		err = ext4_journal_get_write_access(handle, path->p_bh);
+
+		/*
+		 * The extent buffer's verified bit will be set again in
+		 * __ext4_ext_dirty(). We could leave an inconsistent
+		 * buffer if the extents updating procudure break off du
+		 * to some error happens, force to check it again.
+		 */
+		if (!err)
+			clear_buffer_verified(path->p_bh);
 	}
 	/* path points to leaf/index in inode body */
 	/* we use in-core data, no need to protect them */
-	return 0;
+	return err;
 }
 
 /*
@@ -160,6 +171,9 @@ int __ext4_ext_dirty(const char *where, unsigned int line, handle_t *handle,
 		/* path points to block */
 		err = __ext4_handle_dirty_metadata(where, line, handle,
 						   inode, path->p_bh);
+		/* Extents updating done, re-set verified flag */
+		if (!err)
+			set_buffer_verified(path->p_bh);
 	} else {
 		/* path points to leaf/index in inode body */
 		err = ext4_mark_inode_dirty(handle, inode);
-- 
2.35.1.473.g83b2b277ed-goog

