Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CDC8401B88
	for <lists+stable@lfdr.de>; Mon,  6 Sep 2021 14:56:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242417AbhIFM5o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Sep 2021 08:57:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:33882 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242378AbhIFM5i (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 Sep 2021 08:57:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9229F610C8;
        Mon,  6 Sep 2021 12:56:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630932994;
        bh=J1D+vVYM1Bp+6Auu1hyBHhe7tty7N/sPZrHc+DcdPgU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Rxb1gV1kgW8DBp4GcbQeQFLc4RNvj3opcNpB+DCPPflwXPHkrNhFGB+kxBCeVNF1h
         Iw/YQ6JsEUing+t4nRzES0mm7iBDkq2jEMfm5RCVcusmiVJ1rNmczv0eTEt1yew/eK
         iyY6PdDYufYE5qFJGczKidMUaDru5sus2VbizNL0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, TOTE Robot <oslab@tsinghua.edu.cn>,
        Tuo Li <islituo@gmail.com>, Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 18/29] ceph: fix possible null-pointer dereference in ceph_mdsmap_decode()
Date:   Mon,  6 Sep 2021 14:55:33 +0200
Message-Id: <20210906125450.397801261@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210906125449.756437409@linuxfoundation.org>
References: <20210906125449.756437409@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tuo Li <islituo@gmail.com>

[ Upstream commit a9e6ffbc5b7324b6639ee89028908b1e91ceed51 ]

kcalloc() is called to allocate memory for m->m_info, and if it fails,
ceph_mdsmap_destroy() behind the label out_err will be called:
  ceph_mdsmap_destroy(m);

In ceph_mdsmap_destroy(), m->m_info is dereferenced through:
  kfree(m->m_info[i].export_targets);

To fix this possible null-pointer dereference, check m->m_info before the
for loop to free m->m_info[i].export_targets.

[ jlayton: fix up whitespace damage
	   only kfree(m->m_info) if it's non-NULL ]

Reported-by: TOTE Robot <oslab@tsinghua.edu.cn>
Signed-off-by: Tuo Li <islituo@gmail.com>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ceph/mdsmap.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/ceph/mdsmap.c b/fs/ceph/mdsmap.c
index 1096d1d3a84c..47f2903bacb9 100644
--- a/fs/ceph/mdsmap.c
+++ b/fs/ceph/mdsmap.c
@@ -393,9 +393,11 @@ void ceph_mdsmap_destroy(struct ceph_mdsmap *m)
 {
 	int i;
 
-	for (i = 0; i < m->possible_max_rank; i++)
-		kfree(m->m_info[i].export_targets);
-	kfree(m->m_info);
+	if (m->m_info) {
+		for (i = 0; i < m->possible_max_rank; i++)
+			kfree(m->m_info[i].export_targets);
+		kfree(m->m_info);
+	}
 	kfree(m->m_data_pg_pools);
 	kfree(m);
 }
-- 
2.30.2



