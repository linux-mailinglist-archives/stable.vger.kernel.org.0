Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B0EAB106CB0
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 11:55:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728931AbfKVKyD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 05:54:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:39158 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730278AbfKVKyA (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 05:54:00 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CD62920637;
        Fri, 22 Nov 2019 10:53:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574420039;
        bh=BS6rKx4QK1VTGB6Ow00xYvFJ4tektkmDu92Gqm0uiNk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UKXl7DUrhVVqUmJWTY/QKcmNKQJjkuaVRM89A3VuxR+J3+i/NteG7G8TzEUAsVlvo
         BjzEM2y03jQDq/9VDQzs6QKCoCknrcqtS7zY26wfPozCG7lxYd+ZutA8DfGgKXC+Xi
         KdqPPKIjiME1/MPbL1OZgH8sjRAnb1iQ9WixgvqE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lianbo Jiang <lijiang@redhat.com>,
        Borislav Petkov <bp@suse.de>, x86@kernel.org,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 095/122] proc/vmcore: Fix i386 build error of missing copy_oldmem_page_encrypted()
Date:   Fri, 22 Nov 2019 11:29:08 +0100
Message-Id: <20191122100830.005748725@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122100722.177052205@linuxfoundation.org>
References: <20191122100722.177052205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

[ Upstream commit cf089611f4c446285046fcd426d90c18f37d2905 ]

Lianbo reported a build error with a particular 32-bit config, see Link
below for details.

Provide a weak copy_oldmem_page_encrypted() function which architectures
can override, in the same manner other functionality in that file is
supplied.

Reported-by: Lianbo Jiang <lijiang@redhat.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
CC: x86@kernel.org
Link: http://lkml.kernel.org/r/710b9d95-2f70-eadf-c4a1-c3dc80ee4ebb@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/proc/vmcore.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/fs/proc/vmcore.c b/fs/proc/vmcore.c
index 885d445afa0d9..ce400f97370d3 100644
--- a/fs/proc/vmcore.c
+++ b/fs/proc/vmcore.c
@@ -164,6 +164,16 @@ int __weak remap_oldmem_pfn_range(struct vm_area_struct *vma,
 	return remap_pfn_range(vma, from, pfn, size, prot);
 }
 
+/*
+ * Architectures which support memory encryption override this.
+ */
+ssize_t __weak
+copy_oldmem_page_encrypted(unsigned long pfn, char *buf, size_t csize,
+			   unsigned long offset, int userbuf)
+{
+	return copy_oldmem_page(pfn, buf, csize, offset, userbuf);
+}
+
 /*
  * Copy to either kernel or user space
  */
-- 
2.20.1



