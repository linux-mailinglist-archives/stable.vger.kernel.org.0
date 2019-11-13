Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93211FA122
	for <lists+stable@lfdr.de>; Wed, 13 Nov 2019 02:55:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728989AbfKMBzC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Nov 2019 20:55:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:46192 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727656AbfKMBzA (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Nov 2019 20:55:00 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7DD682245C;
        Wed, 13 Nov 2019 01:54:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573610099;
        bh=CISu5P/jMUfzxYshfYe9HfhmQSco0Rm52SQyQxCrb00=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oj21XZuTwKEzq0STQXRfd2MISOUDsqDv3Ok0WgbpipNqoO/lsMbisqRcTw/W7hczw
         QmXUCFxvevxfCSv7RaYlrAa+Wam+qO7Kl8P74+MRHk60KcleQw/05098NSiqtubF45
         KPGZ1LYpP1TSw2lf26wFzU1l4XtFWHozosdyQw5U=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Borislav Petkov <bp@suse.de>, Lianbo Jiang <lijiang@redhat.com>,
        x86@kernel.org, Sasha Levin <sashal@kernel.org>,
        linux-fsdevel@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 159/209] proc/vmcore: Fix i386 build error of missing copy_oldmem_page_encrypted()
Date:   Tue, 12 Nov 2019 20:49:35 -0500
Message-Id: <20191113015025.9685-159-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191113015025.9685-1-sashal@kernel.org>
References: <20191113015025.9685-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index cbde728f8ac60..5c5f161763c8c 100644
--- a/fs/proc/vmcore.c
+++ b/fs/proc/vmcore.c
@@ -176,6 +176,16 @@ int __weak remap_oldmem_pfn_range(struct vm_area_struct *vma,
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

