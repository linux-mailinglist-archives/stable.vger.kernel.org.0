Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C15AE29A16F
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 01:48:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2441450AbgJ0Al5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Oct 2020 20:41:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:47522 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2408718AbgJZXt3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Oct 2020 19:49:29 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3083421741;
        Mon, 26 Oct 2020 23:49:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603756168;
        bh=qJzPW3OxS5BO+JElgCEQtzOpg3Ebd0WJKjndwZZP0LM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dA7Nhq4XvNHMbFewlv4E+oiiip8/Gwh5zOUskDFbYd6dL4fh4sdrpzjZFGGiNJ33d
         NdorO+5YYvpp+qUAhFqbidfP8BHF1XnCCjXhHFfUOI33nRcQ8Q3QGg3utS9TN3+Svf
         QC5L6XjBh+TiU/aLb3+X+o5DbIk0+uupj+h2TVyQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     David Howells <dhowells@redhat.com>,
        Sasha Levin <sashal@kernel.org>, linux-afs@lists.infradead.org
Subject: [PATCH AUTOSEL 5.9 018/147] afs: Don't assert on unpurgeable server records
Date:   Mon, 26 Oct 2020 19:46:56 -0400
Message-Id: <20201026234905.1022767-18-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201026234905.1022767-1-sashal@kernel.org>
References: <20201026234905.1022767-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Howells <dhowells@redhat.com>

[ Upstream commit 7530d3eb3dcf1a30750e8e7f1f88b782b96b72b8 ]

Don't give an assertion failure on unpurgeable afs_server records - which
kills the thread - but rather emit a trace line when we are purging a
record (which only happens during network namespace removal or rmmod) and
print a notice of the problem.

Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/afs/server.c            | 7 ++++++-
 include/trace/events/afs.h | 2 ++
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/fs/afs/server.c b/fs/afs/server.c
index e82e452e26124..684a2b02b9ff7 100644
--- a/fs/afs/server.c
+++ b/fs/afs/server.c
@@ -550,7 +550,12 @@ void afs_manage_servers(struct work_struct *work)
 
 		_debug("manage %pU %u", &server->uuid, active);
 
-		ASSERTIFCMP(purging, active, ==, 0);
+		if (purging) {
+			trace_afs_server(server, atomic_read(&server->ref),
+					 active, afs_server_trace_purging);
+			if (active != 0)
+				pr_notice("Can't purge s=%08x\n", server->debug_id);
+		}
 
 		if (active == 0) {
 			time64_t expire_at = server->unuse_time;
diff --git a/include/trace/events/afs.h b/include/trace/events/afs.h
index 5f0c1cf1ea130..55d53234bfdf6 100644
--- a/include/trace/events/afs.h
+++ b/include/trace/events/afs.h
@@ -40,6 +40,7 @@ enum afs_server_trace {
 	afs_server_trace_get_new_cbi,
 	afs_server_trace_get_probe,
 	afs_server_trace_give_up_cb,
+	afs_server_trace_purging,
 	afs_server_trace_put_call,
 	afs_server_trace_put_cbi,
 	afs_server_trace_put_find_rsq,
@@ -270,6 +271,7 @@ enum afs_cb_break_reason {
 	EM(afs_server_trace_get_new_cbi,	"GET cbi  ") \
 	EM(afs_server_trace_get_probe,		"GET probe") \
 	EM(afs_server_trace_give_up_cb,		"giveup-cb") \
+	EM(afs_server_trace_purging,		"PURGE    ") \
 	EM(afs_server_trace_put_call,		"PUT call ") \
 	EM(afs_server_trace_put_cbi,		"PUT cbi  ") \
 	EM(afs_server_trace_put_find_rsq,	"PUT f-rsq") \
-- 
2.25.1

