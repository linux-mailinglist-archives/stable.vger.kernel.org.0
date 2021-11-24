Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9F6545C38C
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:37:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349099AbhKXNkJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:40:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:33126 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352826AbhKXNiH (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:38:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D09286322F;
        Wed, 24 Nov 2021 12:56:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637758581;
        bh=HLusY3OAlwfPZfrj2gsEVHEuC4rUfqSD/1AL2edvMLs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Qft//d90G7ku7nwo5kdAUQNonUIuk6TxgemYkWb7KzEU5XoF6sGyPT9Qbv4zAANl/
         aOlGUCmWxxmFA5HjqJZF8TmxIVNQv/ebNkeF1JDerIfKHOWIsAsmKq+sezQqba00BK
         vojCz0IAbrTTxPj/Me2U9gYK9AgyjgHg6mxVtjUU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Heiko Carstens <hca@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 117/154] s390/kexec: fix return code handling
Date:   Wed, 24 Nov 2021 12:58:33 +0100
Message-Id: <20211124115706.067443478@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115702.361983534@linuxfoundation.org>
References: <20211124115702.361983534@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Heiko Carstens <hca@linux.ibm.com>

[ Upstream commit 20c76e242e7025bd355619ba67beb243ba1a1e95 ]

kexec_file_add_ipl_report ignores that ipl_report_finish may fail and
can return an error pointer instead of a valid pointer.
Fix this and simplify by returning NULL in case of an error and let
the only caller handle this case.

Fixes: 99feaa717e55 ("s390/kexec_file: Create ipl report and pass to next kernel")
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kernel/ipl.c                |    3 ++-
 arch/s390/kernel/machine_kexec_file.c |    8 +++++++-
 2 files changed, 9 insertions(+), 2 deletions(-)

--- a/arch/s390/kernel/ipl.c
+++ b/arch/s390/kernel/ipl.c
@@ -2156,7 +2156,7 @@ void *ipl_report_finish(struct ipl_repor
 
 	buf = vzalloc(report->size);
 	if (!buf)
-		return ERR_PTR(-ENOMEM);
+		goto out;
 	ptr = buf;
 
 	memcpy(ptr, report->ipib, report->ipib->hdr.len);
@@ -2195,6 +2195,7 @@ void *ipl_report_finish(struct ipl_repor
 	}
 
 	BUG_ON(ptr > buf + report->size);
+out:
 	return buf;
 }
 
--- a/arch/s390/kernel/machine_kexec_file.c
+++ b/arch/s390/kernel/machine_kexec_file.c
@@ -170,6 +170,7 @@ static int kexec_file_add_ipl_report(str
 	struct kexec_buf buf;
 	unsigned long addr;
 	void *ptr, *end;
+	int ret;
 
 	buf.image = image;
 
@@ -199,7 +200,10 @@ static int kexec_file_add_ipl_report(str
 		ptr += len;
 	}
 
+	ret = -ENOMEM;
 	buf.buffer = ipl_report_finish(data->report);
+	if (!buf.buffer)
+		goto out;
 	buf.bufsz = data->report->size;
 	buf.memsz = buf.bufsz;
 
@@ -209,7 +213,9 @@ static int kexec_file_add_ipl_report(str
 		data->kernel_buf + offsetof(struct lowcore, ipl_parmblock_ptr);
 	*lc_ipl_parmblock_ptr = (__u32)buf.mem;
 
-	return kexec_add_buffer(&buf);
+	ret = kexec_add_buffer(&buf);
+out:
+	return ret;
 }
 
 void *kexec_file_add_components(struct kimage *image,


