Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC0371BFC3E
	for <lists+stable@lfdr.de>; Thu, 30 Apr 2020 16:05:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728663AbgD3NxR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Apr 2020 09:53:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:34990 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727768AbgD3NxQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Apr 2020 09:53:16 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9EB1E21775;
        Thu, 30 Apr 2020 13:53:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588254796;
        bh=iwModBdYnSBiQuxKQuEKfO9ES8TM7ARRk9PlkKU5/ZA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zGaw4tyzBsraI7PY2+Ngh+G1M+GS/LGvS/AA2XRkDWeFVIm1qYYrj7FAzunbKHi2+
         KMRFrv9WUPeyxCS3zIHtlJT4GVCQRKDMtoozEy7v2NFOm2+ZrZIsw5kjEWMQGiJBUn
         lwYGWWIkXJSG6izF7cCvFwYtu8woH0hiPejBvPUQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     David Howells <dhowells@redhat.com>,
        Sasha Levin <sashal@kernel.org>, linux-afs@lists.infradead.org
Subject: [PATCH AUTOSEL 5.4 51/57] afs: Fix to actually set AFS_SERVER_FL_HAVE_EPOCH
Date:   Thu, 30 Apr 2020 09:52:12 -0400
Message-Id: <20200430135218.20372-51-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200430135218.20372-1-sashal@kernel.org>
References: <20200430135218.20372-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Howells <dhowells@redhat.com>

[ Upstream commit 69cf3978f3ada4e54beae4ad44868b5627864884 ]

AFS keeps track of the epoch value from the rxrpc protocol to note (a) when
a fileserver appears to have restarted and (b) when different endpoints of
a fileserver do not appear to be associated with the same fileserver
(ie. all probes back from a fileserver from all of its interfaces should
carry the same epoch).

However, the AFS_SERVER_FL_HAVE_EPOCH flag that indicates that we've
received the server's epoch is never set, though it is used.

Fix this to set the flag when we first receive an epoch value from a probe
sent to the filesystem client from the fileserver.

Fixes: 3bf0fb6f33dd ("afs: Probe multiple fileservers simultaneously")
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/afs/cmservice.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/afs/cmservice.c b/fs/afs/cmservice.c
index b378cd780ed54..fc5eb0f893049 100644
--- a/fs/afs/cmservice.c
+++ b/fs/afs/cmservice.c
@@ -169,7 +169,7 @@ static int afs_record_cm_probe(struct afs_call *call, struct afs_server *server)
 
 	spin_lock(&server->probe_lock);
 
-	if (!test_bit(AFS_SERVER_FL_HAVE_EPOCH, &server->flags)) {
+	if (!test_and_set_bit(AFS_SERVER_FL_HAVE_EPOCH, &server->flags)) {
 		server->cm_epoch = call->epoch;
 		server->probe.cm_epoch = call->epoch;
 		goto out;
-- 
2.20.1

