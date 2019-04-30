Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 97889F7C7
	for <lists+stable@lfdr.de>; Tue, 30 Apr 2019 14:02:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727274AbfD3MBc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Apr 2019 08:01:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:56854 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730301AbfD3Lo6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 30 Apr 2019 07:44:58 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5B4F420449;
        Tue, 30 Apr 2019 11:44:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556624697;
        bh=m72RwRxcoFtulB6zopXl3rOKL6k7xVpEkWygvSNLSi4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=upjV2qYjO5A5HtBRtjZMr0JbGgMmEWzPMTjLvJ53hVDE6Pma2en04KkJcnWKhasDC
         S6xGC4Lk2Ka1Gla+tpRKJk9HQXfdk4mUYArXZhx0bYv9JTw6vmIW4DBToUqb5RulxN
         x2nQk5m10UuAS3/dG2KQXMVSGe+iPODtIC1dJdA0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Yan, Zheng" <zyan@redhat.com>,
        Ilya Dryomov <idryomov@gmail.com>,
        Luis Henriques <lhenriques@suse.com>
Subject: [PATCH 4.19 037/100] ceph: fix ci->i_head_snapc leak
Date:   Tue, 30 Apr 2019 13:38:06 +0200
Message-Id: <20190430113610.489469697@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190430113608.616903219@linuxfoundation.org>
References: <20190430113608.616903219@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yan, Zheng <zyan@redhat.com>

commit 37659182bff1eeaaeadcfc8f853c6d2b6dbc3f47 upstream.

We missed two places that i_wrbuffer_ref_head, i_wr_ref, i_dirty_caps
and i_flushing_caps may change. When they are all zeros, we should free
i_head_snapc.

Cc: stable@vger.kernel.org
Link: https://tracker.ceph.com/issues/38224
Reported-and-tested-by: Luis Henriques <lhenriques@suse.com>
Signed-off-by: "Yan, Zheng" <zyan@redhat.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ceph/mds_client.c |    9 +++++++++
 fs/ceph/snap.c       |    7 ++++++-
 2 files changed, 15 insertions(+), 1 deletion(-)

--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -1290,6 +1290,15 @@ static int remove_session_caps_cb(struct
 			list_add(&ci->i_prealloc_cap_flush->i_list, &to_remove);
 			ci->i_prealloc_cap_flush = NULL;
 		}
+
+               if (drop &&
+                  ci->i_wrbuffer_ref_head == 0 &&
+                  ci->i_wr_ref == 0 &&
+                  ci->i_dirty_caps == 0 &&
+                  ci->i_flushing_caps == 0) {
+                      ceph_put_snap_context(ci->i_head_snapc);
+                      ci->i_head_snapc = NULL;
+               }
 	}
 	spin_unlock(&ci->i_ceph_lock);
 	while (!list_empty(&to_remove)) {
--- a/fs/ceph/snap.c
+++ b/fs/ceph/snap.c
@@ -568,7 +568,12 @@ void ceph_queue_cap_snap(struct ceph_ino
 	old_snapc = NULL;
 
 update_snapc:
-	if (ci->i_head_snapc) {
+       if (ci->i_wrbuffer_ref_head == 0 &&
+           ci->i_wr_ref == 0 &&
+           ci->i_dirty_caps == 0 &&
+           ci->i_flushing_caps == 0) {
+               ci->i_head_snapc = NULL;
+       } else {
 		ci->i_head_snapc = ceph_get_snap_context(new_snapc);
 		dout(" new snapc is %p\n", new_snapc);
 	}


