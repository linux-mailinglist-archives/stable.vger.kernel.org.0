Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EADD52A594A
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 23:06:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729997AbgKCWGd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 17:06:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:53296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729779AbgKCUl1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:41:27 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 94B3B2224E;
        Tue,  3 Nov 2020 20:41:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604436087;
        bh=y6dWLgr/k78WEXsGzpf5VMOpXSUhgcaF1CjkWV47f08=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=doRpevBjmi+Htn/NwNf0U2deAzmcDPy2kOAHLrTxi2SAoSs1sExrtlZmt1Tu7HAZN
         TH2QEXekb791v4FUEIyE27bhCxkRrAW1g+H4YhSe3ICSmCaqnMPHPtofCAJOrccWzh
         Bwh6Acmh4hmzLa+7bvyI+9JfOEdVGTZ6oUMhW33A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Howells <dhowells@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 060/391] afs: Dont assert on unpurgeable server records
Date:   Tue,  3 Nov 2020 21:31:51 +0100
Message-Id: <20201103203351.427774628@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203348.153465465@linuxfoundation.org>
References: <20201103203348.153465465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 13c05e28c0b6c..342b35fc33c59 100644
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
2.27.0



