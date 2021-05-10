Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63F21378922
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:50:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238152AbhEJLZq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:25:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:56112 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238069AbhEJLQ5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 07:16:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B5CA861624;
        Mon, 10 May 2021 11:12:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620645139;
        bh=63YIj9kq5s/dj/k7o4ecJ4EuaKz2/ix4zucPs3pYnNk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s8GtqNwnoivijHY4z4EG6p8eogrTQYEp9WTiRmuK6PklXghM/YtFP6luNeHRyRPeX
         Nt6ExgfxrATRWE4az5Dem9mx30wcXPKDuaa4SnKec8zfeyDwCsIIC9rsNHLkcu8Ba0
         g9pd7sKgIE/Oh2qUODM+iqN0v+OPAEAsMue8xW2Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable@kernel.org,
        Fengnan Chang <changfengnan@vivo.com>,
        Andreas Dilger <adilger@dilger.ca>,
        Theodore Tso <tytso@mit.edu>
Subject: [PATCH 5.12 341/384] ext4: fix error code in ext4_commit_super
Date:   Mon, 10 May 2021 12:22:10 +0200
Message-Id: <20210510102026.020772792@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102014.849075526@linuxfoundation.org>
References: <20210510102014.849075526@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fengnan Chang <changfengnan@vivo.com>

commit f88f1466e2a2e5ca17dfada436d3efa1b03a3972 upstream.

We should set the error code when ext4_commit_super check argument failed.
Found in code review.
Fixes: c4be0c1dc4cdc ("filesystem freeze: add error handling of write_super_lockfs/unlockfs").

Cc: stable@kernel.org
Signed-off-by: Fengnan Chang <changfengnan@vivo.com>
Reviewed-by: Andreas Dilger <adilger@dilger.ca>
Link: https://lore.kernel.org/r/20210402101631.561-1-changfengnan@vivo.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/super.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -5559,8 +5559,10 @@ static int ext4_commit_super(struct supe
 	struct buffer_head *sbh = EXT4_SB(sb)->s_sbh;
 	int error = 0;
 
-	if (!sbh || block_device_ejected(sb))
-		return error;
+	if (!sbh)
+		return -EINVAL;
+	if (block_device_ejected(sb))
+		return -ENODEV;
 
 	ext4_update_super(sb);
 


