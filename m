Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDF2C60652E
	for <lists+stable@lfdr.de>; Thu, 20 Oct 2022 18:00:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230424AbiJTQAq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Oct 2022 12:00:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230425AbiJTQAp (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Oct 2022 12:00:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3AAC1A7A1C;
        Thu, 20 Oct 2022 09:00:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 228EB61C43;
        Thu, 20 Oct 2022 16:00:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5109AC433D6;
        Thu, 20 Oct 2022 16:00:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666281643;
        bh=bLuCedl4s9jdTFLoZhM2DGA0BttT058xaU3Ol8SB5r0=;
        h=From:To:Cc:Subject:Date:From;
        b=krGDiwbcMT5ujYebgyqN7jxYS+vp9IhtmLLt9ofmcojNx2t8b95kPontEO9bt5yfO
         d6Fp+pI7vRi0f54D+p4bjIJPMYDlUwrJF+yo5a6v41mRJX0oNwZDZdFe7HejyA21fH
         BjGernPI0c0HB9IgD+XGuFEG1O1PIvwE6hzJxLcChRtYLmsPoNl9Pdhr7qaIOx7+7h
         5xBDbUpLXpBeY9eADoD6qbWVhnw46ZIM/UNqdj9IIed9hrUNvc8j+Y7DXkf6RMpQ0K
         9E6joa/nr7MrtgrBpxZu91XTFZMC0/qkvg4G1CPwNsAOCI4AQj785JS2mvIgtjXF5j
         Ok+daXoDrJ47Q==
From:   Arnd Bergmann <arnd@kernel.org>
To:     Alexander Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     linux-fsdevel@vger.kernel.org, Thomas Schmitt <scdbackup@gmx.net>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Jan Kara <jack@suse.cz>, Jeff Layton <jlayton@kernel.org>,
        Deepa Dinamani <deepa.kernel@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] isofs: prevent file time rollover after year 2038
Date:   Thu, 20 Oct 2022 18:00:29 +0200
Message-Id: <20221020160037.4002270-1-arnd@kernel.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Schmitt <scdbackup@gmx.net>

Change the return type of function iso_date() from int to time64_t,
to avoid truncating to the 1902..2038 date range.

After this patch, the reported timestamps should fall into the
range reported in the s_time_min/s_time_max fields.

Signed-off-by: Thomas Schmitt <scdbackup@gmx.net>
Cc: stable@vger.kernel.org
Link: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=800627
Fixes: 34be4dbf87fc ("isofs: fix timestamps beyond 2027")
Fixes: 5ad32b3acded ("isofs: Initialize filesystem timestamp ranges")
[arnd: expand changelog text slightly]
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 fs/isofs/isofs.h | 2 +-
 fs/isofs/util.c  | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/isofs/isofs.h b/fs/isofs/isofs.h
index dcdc191ed183..c3473ca3f686 100644
--- a/fs/isofs/isofs.h
+++ b/fs/isofs/isofs.h
@@ -106,7 +106,7 @@ static inline unsigned int isonum_733(u8 *p)
 	/* Ignore bigendian datum due to broken mastering programs */
 	return get_unaligned_le32(p);
 }
-extern int iso_date(u8 *, int);
+extern time64_t iso_date(u8 *, int);
 
 struct inode;		/* To make gcc happy */
 
diff --git a/fs/isofs/util.c b/fs/isofs/util.c
index e88dba721661..348af786a8a4 100644
--- a/fs/isofs/util.c
+++ b/fs/isofs/util.c
@@ -16,10 +16,10 @@
  * to GMT.  Thus  we should always be correct.
  */
 
-int iso_date(u8 *p, int flag)
+time64_t iso_date(u8 *p, int flag)
 {
 	int year, month, day, hour, minute, second, tz;
-	int crtime;
+	time64_t crtime;
 
 	year = p[0];
 	month = p[1];
-- 
2.29.2

