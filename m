Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0611D29B808
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:08:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2898752AbgJ0PaM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:30:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:46778 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1797960AbgJ0PaI (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:30:08 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 65A9D20728;
        Tue, 27 Oct 2020 15:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603812608;
        bh=6FBiIxQzkB3jbzMl05xxWV4AakLDBq6/8nQcuyuypD8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QBvtMZqfk/iCktIb1lgRPkymMDZA5la2jQgJDqpvD08DEi1D7hB7eWdAIqVZCGgek
         yykW5jSjDj0rcSa1kSK+xUoOnH+RiCr19d+8NaRZ1owpuq/qU6sjgqclhIG1Lfzw4s
         a9cwr6EF9GaMFsGJsyufaYkPL+CLl8R+n6guUBk0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, KP Singh <kpsingh@google.com>,
        Florent Revest <revest@chromium.org>,
        Mimi Zohar <zohar@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 268/757] ima: Fix NULL pointer dereference in ima_file_hash
Date:   Tue, 27 Oct 2020 14:48:38 +0100
Message-Id: <20201027135503.147495198@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: KP Singh <kpsingh@google.com>

[ Upstream commit aa662fc04f5b290b3979332588bf8d812b189962 ]

ima_file_hash can be called when there is no iint->ima_hash available
even though the inode exists in the integrity cache. It is fairly
common for a file to not have a hash. (e.g. an mknodat, prior to the
file being closed).

Another example where this can happen (suggested by Jann Horn):

Process A does:

	while(1) {
		unlink("/tmp/imafoo");
		fd = open("/tmp/imafoo", O_RDWR|O_CREAT|O_TRUNC, 0700);
		if (fd == -1) {
			perror("open");
			continue;
		}
		write(fd, "A", 1);
		close(fd);
	}

and Process B does:

	while (1) {
		int fd = open("/tmp/imafoo", O_RDONLY);
		if (fd == -1)
			continue;
    		char *mapping = mmap(NULL, 0x1000, PROT_READ|PROT_EXEC,
			 	     MAP_PRIVATE, fd, 0);
		if (mapping != MAP_FAILED)
			munmap(mapping, 0x1000);
		close(fd);
  	}

Due to the race to get the iint->mutex between ima_file_hash and
process_measurement iint->ima_hash could still be NULL.

Fixes: 6beea7afcc72 ("ima: add the ability to query the cached hash of a given file")
Signed-off-by: KP Singh <kpsingh@google.com>
Reviewed-by: Florent Revest <revest@chromium.org>
Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/integrity/ima/ima_main.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/security/integrity/ima/ima_main.c b/security/integrity/ima/ima_main.c
index 8a91711ca79b2..4c86cd4eece0c 100644
--- a/security/integrity/ima/ima_main.c
+++ b/security/integrity/ima/ima_main.c
@@ -531,6 +531,16 @@ int ima_file_hash(struct file *file, char *buf, size_t buf_size)
 		return -EOPNOTSUPP;
 
 	mutex_lock(&iint->mutex);
+
+	/*
+	 * ima_file_hash can be called when ima_collect_measurement has still
+	 * not been called, we might not always have a hash.
+	 */
+	if (!iint->ima_hash) {
+		mutex_unlock(&iint->mutex);
+		return -EOPNOTSUPP;
+	}
+
 	if (buf) {
 		size_t copied_size;
 
-- 
2.25.1



