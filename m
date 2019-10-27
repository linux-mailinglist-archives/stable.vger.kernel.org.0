Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E03B9E680A
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 22:26:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732934AbfJ0V01 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 17:26:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:48376 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732928AbfJ0V00 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Oct 2019 17:26:26 -0400
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4FDAD21E6F;
        Sun, 27 Oct 2019 21:26:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572211585;
        bh=2dkV0I/ttTsDq2uK0syJ7uNnKrFVDYIZq51ZA9hvSWg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w/ORJfyfLyq+8SLsKV8YB8wl6lbiE9uC5Q8awLZN/RgRqr9XP/Xao9ZrpRAlZS4k8
         AifGPNo166YOzSWAV8UxAXKXIDlelCQQS4YU+tcOh7eVRRTVb9c6ZK/AX43tfMuQpN
         6voQTXHuAFP6uvJRBYyciJsalRcW35NsDpz57oEw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nikolay Borisov <nborisov@suse.com>,
        Qu Wenruo <wqu@suse.com>, David Sterba <dsterba@suse.com>
Subject: [PATCH 5.3 187/197] btrfs: tracepoints: Fix bad entry members of qgroup events
Date:   Sun, 27 Oct 2019 22:01:45 +0100
Message-Id: <20191027203406.582477867@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191027203351.684916567@linuxfoundation.org>
References: <20191027203351.684916567@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qu Wenruo <wqu@suse.com>

commit 1b2442b4ae0f234daeadd90e153b466332c466d8 upstream.

[BUG]
For btrfs:qgroup_meta_reserve event, the trace event can output garbage:

  qgroup_meta_reserve: 9c7f6acc-b342-4037-bc47-7f6e4d2232d7: refroot=5(FS_TREE) type=DATA diff=2
  qgroup_meta_reserve: 9c7f6acc-b342-4037-bc47-7f6e4d2232d7: refroot=5(FS_TREE) type=0x258792 diff=2

The @type can be completely garbage, as DATA type is not possible for
trace_qgroup_meta_reserve() trace event.

[CAUSE]
Ther are several problems related to qgroup trace events:
- Unassigned entry member
  Member entry::type of trace_qgroup_update_reserve() and
  trace_qgourp_meta_reserve() is not assigned

- Redundant entry member
  Member entry::type is completely useless in
  trace_qgroup_meta_convert()

Fixes: 4ee0d8832c2e ("btrfs: qgroup: Update trace events for metadata reservation")
CC: stable@vger.kernel.org # 4.10+
Reviewed-by: Nikolay Borisov <nborisov@suse.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/trace/events/btrfs.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/include/trace/events/btrfs.h
+++ b/include/trace/events/btrfs.h
@@ -1687,6 +1687,7 @@ TRACE_EVENT(qgroup_update_reserve,
 		__entry->qgid		= qgroup->qgroupid;
 		__entry->cur_reserved	= qgroup->rsv.values[type];
 		__entry->diff		= diff;
+		__entry->type		= type;
 	),
 
 	TP_printk_btrfs("qgid=%llu type=%s cur_reserved=%llu diff=%lld",
@@ -1709,6 +1710,7 @@ TRACE_EVENT(qgroup_meta_reserve,
 	TP_fast_assign_btrfs(root->fs_info,
 		__entry->refroot	= root->root_key.objectid;
 		__entry->diff		= diff;
+		__entry->type		= type;
 	),
 
 	TP_printk_btrfs("refroot=%llu(%s) type=%s diff=%lld",
@@ -1725,7 +1727,6 @@ TRACE_EVENT(qgroup_meta_convert,
 	TP_STRUCT__entry_btrfs(
 		__field(	u64,	refroot			)
 		__field(	s64,	diff			)
-		__field(	int,	type			)
 	),
 
 	TP_fast_assign_btrfs(root->fs_info,


