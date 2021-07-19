Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D79BF3CDC5E
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:33:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238973AbhGSOwM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 10:52:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:40962 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343994AbhGSOsh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:48:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 70EED613D0;
        Mon, 19 Jul 2021 15:25:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626708349;
        bh=wgxYcTgE1IyXhY2dHPu39iYdHLNL7gNaAHZJBz0shPo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FOMMKdJ7t1YCHikTUb8jqUu6cNj2jzKJIIf0gnObbcA4wAu9Bbg/KZOyXsEKmCRuI
         vGNr1Aiic83Y54VSyLcdMBslo/cRM/hZ/t9ViWYblSU8MOMrQvfEDH/V7ph6HHqA5O
         xqQdrJ16Hk7G4PbrcvXcnTDuwjDjYJi/kPMj63OY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mike Marshall <hubcap@omnibond.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 276/315] orangefs: fix orangefs df output.
Date:   Mon, 19 Jul 2021 16:52:45 +0200
Message-Id: <20210719144952.496851812@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144942.861561397@linuxfoundation.org>
References: <20210719144942.861561397@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Marshall <hubcap@omnibond.com>

[ Upstream commit 0fdec1b3c9fbb5e856a40db5993c9eaf91c74a83 ]

Orangefs df output is whacky. Walt Ligon suggested this might fix it.
It seems way more in line with reality now...

Signed-off-by: Mike Marshall <hubcap@omnibond.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/orangefs/super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/orangefs/super.c b/fs/orangefs/super.c
index 1997ce49ab46..e5f7df28793d 100644
--- a/fs/orangefs/super.c
+++ b/fs/orangefs/super.c
@@ -197,7 +197,7 @@ static int orangefs_statfs(struct dentry *dentry, struct kstatfs *buf)
 	buf->f_bavail = (sector_t) new_op->downcall.resp.statfs.blocks_avail;
 	buf->f_files = (sector_t) new_op->downcall.resp.statfs.files_total;
 	buf->f_ffree = (sector_t) new_op->downcall.resp.statfs.files_avail;
-	buf->f_frsize = sb->s_blocksize;
+	buf->f_frsize = 0;
 
 out_op_release:
 	op_release(new_op);
-- 
2.30.2



