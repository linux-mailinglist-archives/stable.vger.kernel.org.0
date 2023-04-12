Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF2966DEE39
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 10:41:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229450AbjDLIlK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 04:41:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231247AbjDLIkJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 04:40:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E5BB7D97
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 01:39:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2D65562FF2
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 08:38:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DDE8C4339B;
        Wed, 12 Apr 2023 08:38:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681288700;
        bh=0v2h6MAqLDWJy8r9FK4Wjz16DUWz19dMM7R4k6Tcw/I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qd7qJiQ5AnIpoeFE1J7Y9SZ7J2Tcd/hT4+CJWWAxOB0AOvYVPIinUITpKUTyIiJCK
         wm/B2gN9sTAYQDkhMR8wMFnQpEgU7Ju/Boa4K9F25B0vwpjh+fj3qAA2phuud+hYlb
         s+xrALsGOdpKGu74vrzszJAtEht/ekwed8jg3/k0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yin Fengwei <fengwei.yin@intel.com>,
        kernel test robot <yujie.liu@intel.com>,
        "Paulo Alcantara (SUSE)" <pc@manguebit.com>,
        Shyam Prasad N <sprasad@microsoft.com>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 77/93] smb3: lower default deferred close timeout to address perf regression
Date:   Wed, 12 Apr 2023 10:34:18 +0200
Message-Id: <20230412082826.379618513@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082823.045155996@linuxfoundation.org>
References: <20230412082823.045155996@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steve French <stfrench@microsoft.com>

[ Upstream commit 7e0e76d99079be13c9961dde7c93b2d1ee665af4 ]

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
Stable-dep-of: d19342c6609b ("cifs: sanitize paths in cifs_update_super_prepath.")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/fs_context.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/cifs/fs_context.h b/fs/cifs/fs_context.h
index b5ae210bafe04..ad45256cf68e2 100644
--- a/fs/cifs/fs_context.h
+++ b/fs/cifs/fs_context.h
@@ -282,5 +282,5 @@ extern void smb3_update_mnt_flags(struct cifs_sb_info *cifs_sb);
  * max deferred close timeout (jiffies) - 2^30
  */
 #define SMB3_MAX_DCLOSETIMEO (1 << 30)
-#define SMB3_DEF_DCLOSETIMEO (5 * HZ) /* Can increase later, other clients use larger */
+#define SMB3_DEF_DCLOSETIMEO (1 * HZ) /* even 1 sec enough to help eg open/write/close/open/read */
 #endif
-- 
2.39.2



