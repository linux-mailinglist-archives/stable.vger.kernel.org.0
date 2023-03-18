Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C6B36BF94D
	for <lists+stable@lfdr.de>; Sat, 18 Mar 2023 11:15:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229850AbjCRKPm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 18 Mar 2023 06:15:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229588AbjCRKPl (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 18 Mar 2023 06:15:41 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDBAD2410D;
        Sat, 18 Mar 2023 03:15:38 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id bh21-20020a05600c3d1500b003ed1ff06fb0so4717598wmb.3;
        Sat, 18 Mar 2023 03:15:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679134537;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PP8hrBv8Zg8teY5qFhszUF4+5kq7WXrNzkvw8H5L9wU=;
        b=kPRmcTrxrivd2xuDLHt5cE6iYYvBIHf4nvCdgVa+M+57aq9hnoNz7SrURAVTqmcwPg
         iXCx7XbGglaOK3BtBjKOVMsgnSzpKRusVDL/ERfbg56PZ7tRy7qtTIKcmIw4zqVl8fmm
         84XVgCIMZk81KcVFqz9lcpiNqmzaRjAJpbdxq+ks06+yy0f0oRJLtngFozSegNtu5SHO
         f2pWlOZAVvH3Gl1NCF18uFJS50b8QLPty/J82SovpwM6Xan2kXTkJJEBEPfCUjp9zgZL
         Bd9r203XrnqdAw42//OsNcerPTq67OEjWwklA0e4O6MHXr/pmI4uM7azyfDVz1WaMFzy
         uSMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679134537;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PP8hrBv8Zg8teY5qFhszUF4+5kq7WXrNzkvw8H5L9wU=;
        b=ct83WwT1lZJ2Y4mzP66acvwZ/UohlCbfJ1I52yzHcSqcXXux9iFF5JGLkqCflzCb+g
         5nwfjSzyzglNX9+vkl8JjbdGjAVcGvYbMkwQw3L452spXizM1qZ0Ji2otmpkXMB0XDrd
         gVYT9WYUU3r/rx8TIkF3y55iVZwtGoarXla+T4rO+MGf5j9V8B3MNmDOESyHUxycFxoY
         HEPf1R4yEyOr5Ec3myGuwZlfz/vtwEVfnwsUsZoXmkeXoaj3zF6kxgnzlHFI/4FIOsds
         ahKdcsiIBBxoLMv35Uqd/1B0ZxAhnyKJUH36l5uSTY/GGdTm7ZiGIHtTpC22cXYw1taC
         hdNQ==
X-Gm-Message-State: AO0yUKXQMMoB1zUOF1CBrGdsa6kFCoorKUzKRfORBeqw3pK700rvsG0B
        tatVdU5DhIFDY82tBfcMQaA=
X-Google-Smtp-Source: AK7set/eTR5iXiGk1JpNxuDJvoCXQSBxXjSju76oRZWaqFETPcKCm/WhdvKoMixuwGaiLannhivCUg==
X-Received: by 2002:a05:600c:3c9e:b0:3e1:f8af:8772 with SMTP id bg30-20020a05600c3c9e00b003e1f8af8772mr26614966wmb.9.1679134537368;
        Sat, 18 Mar 2023 03:15:37 -0700 (PDT)
Received: from amir-ThinkPad-T480.lan ([5.29.249.86])
        by smtp.gmail.com with ESMTPSA id v26-20020a05600c215a00b003eafc47eb09sm4333965wml.43.2023.03.18.03.15.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Mar 2023 03:15:36 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Sasha Levin <sashal@kernel.org>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Leah Rumancik <leah.rumancik@gmail.com>,
        Chandan Babu R <chandan.babu@oracle.com>,
        Christian Brauner <brauner@kernel.org>,
        linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org, Dave Chinner <dchinner@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        Dave Chinner <david@fromorbit.com>
Subject: [PATCH 5.10 01/15] xfs: don't assert fail on perag references on teardown
Date:   Sat, 18 Mar 2023 12:15:15 +0200
Message-Id: <20230318101529.1361673-2-amir73il@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230318101529.1361673-1-amir73il@gmail.com>
References: <20230318101529.1361673-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

commit 5b55cbc2d72632e874e50d2e36bce608e55aaaea upstream.

[backport for 5.10.y, prior to perag refactoring in v5.14]

Not fatal, the assert is there to catch developer attention. I'm
seeing this occasionally during recoveryloop testing after a
shutdown, and I don't want this to stop an overnight recoveryloop
run as it is currently doing.

Convert the ASSERT to a XFS_IS_CORRUPT() check so it will dump a
corruption report into the log and cause a test failure that way,
but it won't stop the machine dead.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/xfs/xfs_mount.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index a2a5a0fd9233..402cf828cc91 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -126,7 +126,6 @@ __xfs_free_perag(
 {
 	struct xfs_perag *pag = container_of(head, struct xfs_perag, rcu_head);
 
-	ASSERT(atomic_read(&pag->pag_ref) == 0);
 	kmem_free(pag);
 }
 
@@ -145,7 +144,7 @@ xfs_free_perag(
 		pag = radix_tree_delete(&mp->m_perag_tree, agno);
 		spin_unlock(&mp->m_perag_lock);
 		ASSERT(pag);
-		ASSERT(atomic_read(&pag->pag_ref) == 0);
+		XFS_IS_CORRUPT(pag->pag_mount, atomic_read(&pag->pag_ref) != 0);
 		xfs_iunlink_destroy(pag);
 		xfs_buf_hash_destroy(pag);
 		call_rcu(&pag->rcu_head, __xfs_free_perag);
-- 
2.34.1

