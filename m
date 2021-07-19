Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0973B3CE14D
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:11:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346875AbhGSPZh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:25:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:58058 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346033AbhGSPQ5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:16:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A564961222;
        Mon, 19 Jul 2021 15:57:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626710233;
        bh=9sHeRwrUUh9yPtTPlC8N358xe2XQYAzu9ijcoIe1FJA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NzIRMxgjTq6UwzsN+6402V+esRq0dHts6rgIRCyVfTxM14Y0PvpjcUWcO5vSoi4Pn
         52MCeXsGmQzlNHAEmg5x5/tamX37ywgzaTC3QyfVSTHRoIovX8lhP2vXq+qER/TfSY
         b3BU8jWqjzJwOFcCiT1vyGdvjSV9/RAX5/vG7iMo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mike Marshall <hubcap@omnibond.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 131/243] orangefs: fix orangefs df output.
Date:   Mon, 19 Jul 2021 16:52:40 +0200
Message-Id: <20210719144945.145343268@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144940.904087935@linuxfoundation.org>
References: <20210719144940.904087935@linuxfoundation.org>
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
index ee5efdc35cc1..2f2e430461b2 100644
--- a/fs/orangefs/super.c
+++ b/fs/orangefs/super.c
@@ -209,7 +209,7 @@ static int orangefs_statfs(struct dentry *dentry, struct kstatfs *buf)
 	buf->f_bavail = (sector_t) new_op->downcall.resp.statfs.blocks_avail;
 	buf->f_files = (sector_t) new_op->downcall.resp.statfs.files_total;
 	buf->f_ffree = (sector_t) new_op->downcall.resp.statfs.files_avail;
-	buf->f_frsize = sb->s_blocksize;
+	buf->f_frsize = 0;
 
 out_op_release:
 	op_release(new_op);
-- 
2.30.2



