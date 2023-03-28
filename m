Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7B986CC2F9
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 16:50:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233455AbjC1OuR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 10:50:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233268AbjC1Ots (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 10:49:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88DADBDD1
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 07:49:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9DCDD61826
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 14:49:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1685C433D2;
        Tue, 28 Mar 2023 14:49:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680014958;
        bh=KcTD0+fNcItRaW+9wCkIlXTCzzZqsJ7mrhkHxHqrJus=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Bl7/FyA5yhR3m6P6cgZkpKuBCg4dIaEd12n+zq7d7oX8JYhhYPK42RAv2BHV9F5VV
         miXcTRSOkFKSxOkqIqaUKuHfS0XBzzJKEO0naG4U8xVeCPO1+qw5SF383moWrqdgUV
         /Rs3nUMYYu6+hjp70attcuNcOgRYOy0V0IPZQFPU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yin Fengwei <fengwei.yin@intel.com>,
        kernel test robot <yujie.liu@intel.com>,
        "Paulo Alcantara (SUSE)" <pc@manguebit.com>,
        Shyam Prasad N <sprasad@microsoft.com>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.2 115/240] smb3: lower default deferred close timeout to address perf regression
Date:   Tue, 28 Mar 2023 16:41:18 +0200
Message-Id: <20230328142624.583674291@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142619.643313678@linuxfoundation.org>
References: <20230328142619.643313678@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
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
 fs/cifs/fs_context.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/cifs/fs_context.h
+++ b/fs/cifs/fs_context.h
@@ -286,5 +286,5 @@ extern void smb3_update_mnt_flags(struct
  * max deferred close timeout (jiffies) - 2^30
  */
 #define SMB3_MAX_DCLOSETIMEO (1 << 30)
-#define SMB3_DEF_DCLOSETIMEO (5 * HZ) /* Can increase later, other clients use larger */
+#define SMB3_DEF_DCLOSETIMEO (1 * HZ) /* even 1 sec enough to help eg open/write/close/open/read */
 #endif


