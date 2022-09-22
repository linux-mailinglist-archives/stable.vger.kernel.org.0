Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2E435E6694
	for <lists+stable@lfdr.de>; Thu, 22 Sep 2022 17:15:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229980AbiIVPPN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Sep 2022 11:15:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231558AbiIVPPJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Sep 2022 11:15:09 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4BFE86711;
        Thu, 22 Sep 2022 08:15:08 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id v1so9060705plo.9;
        Thu, 22 Sep 2022 08:15:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=5gfUg+tWOywOepFzlYhd70/MV37VyEPdNntNEwmdBA4=;
        b=LLgfP9UhmlYmkKJh/2DopgnArHwiTuRVKt2STqJWW9oC7UtHiLgMcHdJbgLic2phd0
         9OnYcrGNsu7IzyB07543zODcWKFvdoWqxed8YMfAWCl5ElikxY80E1B2VVv+EvSKBMaf
         wknPfWSDUY+TOlv3mYz1qWHNge3bOV01Ji4s6k8kuVCKRgFIBjsmh0Ioe4dJvDx8Ol/y
         JlgRrLa1m29LD6u2WSYm6VadZhi0zmcZyPOWRAzqefR9D+2qafq5pwcxG+naFwDi92ME
         Ld6seMf7k7y5GGFMIQ+w2kZa5G0iqAlb9j9D3EVHhCv3bEmjGBaLPPbjQlarEQW0tEce
         YNug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=5gfUg+tWOywOepFzlYhd70/MV37VyEPdNntNEwmdBA4=;
        b=tHa8QtSNB6ocv+dAkhYhErdGVZg/11l9CejDFewtsZEUfWNmw5WS/8w2fsC6ooUZII
         9nV80cpDJUiT/OOfsxDys0StEGRcz775axQBJYnNSpTP9pfAp13bReSkYTJ/9RBI2je3
         v/TFOF2ruiKvz/uQwi2YSG2x4GzGjKxUqpHtVj0c580oqoheqz+oMG+wTT6p1dbSo0/J
         n/9Ze/rAmB0I4N325/vdLxsJf1GE7XUou9R11pm/DGz8+OysGkAYgs4ZK4NU11MnvpAl
         J4IfHF0sm76/6HOOMA6SHbdQHqf2ElGvltl4twS4Ej8/AX//ZoulMoNN7AXycF/PLTOn
         iY3w==
X-Gm-Message-State: ACrzQf2N27lkLZEowrAf3t6BwUnEuymhgw5NZ37LjL6idUpZYIm3BlyW
        CYv9W1bAzTRyrADSIXQIg5/qwGCaJTJhFA==
X-Google-Smtp-Source: AMsMyM44Dtfgy9rcOvvFs1nkX5FDm6B11nEkvcEGFhFZQQJ62sjD0kyNcpyFAc+0as/1w1bGp4s92Q==
X-Received: by 2002:a17:902:7589:b0:178:4ded:a90a with SMTP id j9-20020a170902758900b001784deda90amr3843908pll.74.1663859707795;
        Thu, 22 Sep 2022 08:15:07 -0700 (PDT)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2d4:203:500f:884a:5cc3:35d4])
        by smtp.gmail.com with ESMTPSA id m10-20020a170902db0a00b001745662d568sm4226042plx.278.2022.09.22.08.15.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Sep 2022 08:15:07 -0700 (PDT)
From:   Leah Rumancik <leah.rumancik@gmail.com>
To:     stable@vger.kernel.org
Cc:     linux-xfs@vger.kernel.org, amir73il@gmail.com,
        chandan.babu@oracle.com, Brian Foster <bfoster@redhat.com>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Dave Chinner <dchinner@redhat.com>,
        Dave Chinner <david@fromorbit.com>,
        Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 5.15 v2 2/3] xfs: fix xfs_ifree() error handling to not leak perag ref
Date:   Thu, 22 Sep 2022 08:15:00 -0700
Message-Id: <20220922151501.2297190-3-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.37.3.968.ga6b4b080e4-goog
In-Reply-To: <20220922151501.2297190-1-leah.rumancik@gmail.com>
References: <20220922151501.2297190-1-leah.rumancik@gmail.com>
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

From: Brian Foster <bfoster@redhat.com>

[ Upstream commit 6f5097e3367a7c0751e165e4c15bc30511a4ba38 ]

For some reason commit 9a5280b312e2e ("xfs: reorder iunlink remove
operation in xfs_ifree") replaced a jump to the exit path in the
event of an xfs_difree() error with a direct return, which skips
releasing the perag reference acquired at the top of the function.
Restore the original code to drop the reference on error.

Fixes: 9a5280b312e2e ("xfs: reorder iunlink remove operation in xfs_ifree")
Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 36bcdcf3bb78..b2ea85318214 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2634,7 +2634,7 @@ xfs_ifree(
 	 */
 	error = xfs_difree(tp, pag, ip->i_ino, &xic);
 	if (error)
-		return error;
+		goto out;
 
 	error = xfs_iunlink_remove(tp, pag, ip);
 	if (error)
-- 
2.37.3.968.ga6b4b080e4-goog

