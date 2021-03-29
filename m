Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB7A034C85D
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:25:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232636AbhC2IVl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:21:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:37846 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233417AbhC2IUy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:20:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 00BEB6197F;
        Mon, 29 Mar 2021 08:20:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617006054;
        bh=eCvm4I9ZRMNN0HQ3CUV1uqnU6AChyXBaa02oYgA/Wag=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XfGbMFoZ7s74e0Z+4CNI+kaAaGf0n/tp4n9Atk5XtU0WnkH3ZnLlrggCTqdMFROHC
         Ghd3AydWCvMlV+haZt0US7LvFGe/WW1ZmoLmqH3INYs0nDTpmjPe/JFqfb2XQ5RwbR
         eYOtpMNphCJfdri4eNOhFS+Lvfb5rF+zmawiglMc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ido Schimmel <idosch@nvidia.com>,
        Adiel Bidani <adielb@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        Petr Machata <petrm@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.10 067/221] psample: Fix user API breakage
Date:   Mon, 29 Mar 2021 09:56:38 +0200
Message-Id: <20210329075631.414610879@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075629.172032742@linuxfoundation.org>
References: <20210329075629.172032742@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

commit e43accba9b071dcd106b5e7643b1b106a158cbb1 upstream.

Cited commit added a new attribute before the existing group reference
count attribute, thereby changing its value and breaking existing
applications on new kernels.

Before:

 # psample -l
 libpsample ERROR psample_group_foreach: failed to recv message: Operation not supported

After:

 # psample -l
 Group Num       Refcount        Group Seq
 1               1               0

Fix by restoring the value of the old attribute and remove the
misleading comments from the enumerator to avoid future bugs.

Cc: stable@vger.kernel.org
Fixes: d8bed686ab96 ("net: psample: Add tunnel support")
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reported-by: Adiel Bidani <adielb@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/uapi/linux/psample.h |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/include/uapi/linux/psample.h
+++ b/include/uapi/linux/psample.h
@@ -3,7 +3,6 @@
 #define __UAPI_PSAMPLE_H
 
 enum {
-	/* sampled packet metadata */
 	PSAMPLE_ATTR_IIFINDEX,
 	PSAMPLE_ATTR_OIFINDEX,
 	PSAMPLE_ATTR_ORIGSIZE,
@@ -11,10 +10,8 @@ enum {
 	PSAMPLE_ATTR_GROUP_SEQ,
 	PSAMPLE_ATTR_SAMPLE_RATE,
 	PSAMPLE_ATTR_DATA,
-	PSAMPLE_ATTR_TUNNEL,
-
-	/* commands attributes */
 	PSAMPLE_ATTR_GROUP_REFCOUNT,
+	PSAMPLE_ATTR_TUNNEL,
 
 	__PSAMPLE_ATTR_MAX
 };


