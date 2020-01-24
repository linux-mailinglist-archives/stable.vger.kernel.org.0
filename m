Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D7C3D148054
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:10:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731617AbgAXLJ7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:09:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:45678 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731494AbgAXLJ6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:09:58 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9FE7420663;
        Fri, 24 Jan 2020 11:09:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579864198;
        bh=0ibeI52294cLlWPCRs1Da4tsF47zLzTGxRL7Dwolsh4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UP5bNI1ewlMNV+XTSDpyXr5dZyH5N1CBrPLqJT13n2kP14pXt7xGO3rxIjncev5b+
         oUBIAyo7CEBPqBqERtV5KHlpuZkMW5hMTSVnrAiHobvu0y5wdM9dpgLE4KhAqshSHL
         dgRwHR65d9wCH8yDng5qVeT+V6QTCwTuKBKDEHxg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Howells <dhowells@redhat.com>,
        James Morris <james.morris@microsoft.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 199/639] keys: Timestamp new keys
Date:   Fri, 24 Jan 2020 10:26:09 +0100
Message-Id: <20200124093111.970346674@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Howells <dhowells@redhat.com>

[ Upstream commit 7c1857bdbdf1e4c541e45eab477ee23ed4333ea4 ]

Set the timestamp on new keys rather than leaving it unset.

Fixes: 31d5a79d7f3d ("KEYS: Do LRU discard in full keyrings")
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: James Morris <james.morris@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/keys/key.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/security/keys/key.c b/security/keys/key.c
index 249a6da4d2770..749a5cf27a192 100644
--- a/security/keys/key.c
+++ b/security/keys/key.c
@@ -297,6 +297,7 @@ struct key *key_alloc(struct key_type *type, const char *desc,
 	key->gid = gid;
 	key->perm = perm;
 	key->restrict_link = restrict_link;
+	key->last_used_at = ktime_get_real_seconds();
 
 	if (!(flags & KEY_ALLOC_NOT_IN_QUOTA))
 		key->flags |= 1 << KEY_FLAG_IN_QUOTA;
-- 
2.20.1



