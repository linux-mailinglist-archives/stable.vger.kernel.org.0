Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 796856CC41B
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 17:00:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233615AbjC1PAM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 11:00:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233745AbjC1PAC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 11:00:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0E85EB65
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 07:59:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5130D6184A
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 14:59:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6180AC433D2;
        Tue, 28 Mar 2023 14:59:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680015595;
        bh=0sKTGWZTyuzmakDvFE0JuJ4JDyXn5MownDMjEWMidSA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S2oiX2ZKu9WhL3Rl8C5JdQwzJZ3S7COe4E3NUSBJzxChlMY2qFRe7vqpRjcVmRR8D
         0aj/vHBdxu/tY+AlNJzF9AlM81g5Avi0TkBHXvcJO5kFXFkK3zFSXuuOLcv8nmCdFF
         1axRnAVSJve8V8xc6XJNFxdClvMl/5RAt0iLcFjU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yin Fengwei <fengwei.yin@intel.com>,
        kernel test robot <yujie.liu@intel.com>,
        "Paulo Alcantara (SUSE)" <pc@manguebit.com>,
        Shyam Prasad N <sprasad@microsoft.com>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.1 105/224] smb3: lower default deferred close timeout to address perf regression
Date:   Tue, 28 Mar 2023 16:41:41 +0200
Message-Id: <20230328142621.719779579@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142617.205414124@linuxfoundation.org>
References: <20230328142617.205414124@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steve French <stfrench@microsoft.com>

commit 7e0e76d99079be13c9961dde7c93b2d1ee665af4 upstream.

Performance tests with large number of threads noted that the change
of the default closetimeo (deferred close timeout between when
close is done by application and when client has to send the close
to the server), to 5 seconds from 1 second, significantly degraded
perf in some cases like this (in the filebench example reported,
the stats show close requests on the wire taking twice as long,
and 50% regression in filebench perf). This is stil configurable
via mount parm closetimeo, but to be safe, decrease default back
to its previous value of 1 second.

Reported-by: Yin Fengwei <fengwei.yin@intel.com>
Reported-by: kernel test robot <yujie.liu@intel.com>
Link: https://lore.kernel.org/lkml/997614df-10d4-af53-9571-edec36b0e2f3@intel.com/
Fixes: 5efdd9122eff ("smb3: allow deferred close timeout to be configurable")
Cc: stable@vger.kernel.org # 6.0+
Tested-by: Yin Fengwei <fengwei.yin@intel.com>
Reviewed-by: Paulo Alcantara (SUSE) <pc@manguebit.com>
Reviewed-by: Shyam Prasad N <sprasad@microsoft.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/cifs/fs_context.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/cifs/fs_context.h b/fs/cifs/fs_context.h
index 1b8d4e27f831..3de00e7127ec 100644
--- a/fs/cifs/fs_context.h
+++ b/fs/cifs/fs_context.h
@@ -286,5 +286,5 @@ extern void smb3_update_mnt_flags(struct cifs_sb_info *cifs_sb);
  * max deferred close timeout (jiffies) - 2^30
  */
 #define SMB3_MAX_DCLOSETIMEO (1 << 30)
-#define SMB3_DEF_DCLOSETIMEO (5 * HZ) /* Can increase later, other clients use larger */
+#define SMB3_DEF_DCLOSETIMEO (1 * HZ) /* even 1 sec enough to help eg open/write/close/open/read */
 #endif
-- 
2.40.0



