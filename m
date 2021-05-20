Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 934C238A967
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 13:01:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239029AbhETLBp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 07:01:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:57122 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239566AbhETK7p (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 06:59:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D338561D06;
        Thu, 20 May 2021 10:03:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621504985;
        bh=rkX6z2dPoS2cqSstGb9735JhgAFXr7gdHa10h8sCZ04=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ak9PEN0/QrDcA6x+AhUGq62XMJZj+aiI/NdfQlHXeq8zuAlN/7Dq0FQLAljos3YAl
         jAiDOdWgT30usG5sZ09hO2LxzpEiGMY8WCqTGsVloKFbkeXXmQli+wSFxBWNNrE6Xq
         hgSUq66SQvg9gdzrVWEsNcMWb7C5cInlHviA43pI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexander Aring <aahringo@redhat.com>,
        David Teigland <teigland@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 170/240] fs: dlm: fix debugfs dump
Date:   Thu, 20 May 2021 11:22:42 +0200
Message-Id: <20210520092114.359205151@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092108.587553970@linuxfoundation.org>
References: <20210520092108.587553970@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Aring <aahringo@redhat.com>

[ Upstream commit 92c48950b43f4a767388cf87709d8687151a641f ]

This patch fixes the following message which randomly pops up during
glocktop call:

seq_file: buggy .next function table_seq_next did not update position index

The issue is that seq_read_iter() in fs/seq_file.c also needs an
increment of the index in an non next record case as well which this
patch fixes otherwise seq_read_iter() will print out the above message.

Signed-off-by: Alexander Aring <aahringo@redhat.com>
Signed-off-by: David Teigland <teigland@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/dlm/debug_fs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/dlm/debug_fs.c b/fs/dlm/debug_fs.c
index 466f7d60edc2..fabce23fdbac 100644
--- a/fs/dlm/debug_fs.c
+++ b/fs/dlm/debug_fs.c
@@ -545,6 +545,7 @@ static void *table_seq_next(struct seq_file *seq, void *iter_ptr, loff_t *pos)
 
 		if (bucket >= ls->ls_rsbtbl_size) {
 			kfree(ri);
+			++*pos;
 			return NULL;
 		}
 		tree = toss ? &ls->ls_rsbtbl[bucket].toss : &ls->ls_rsbtbl[bucket].keep;
-- 
2.30.2



