Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 504DD45C282
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:27:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348033AbhKXN3r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:29:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:57672 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350638AbhKXN1j (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:27:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 704AC61546;
        Wed, 24 Nov 2021 12:50:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637758242;
        bh=qKRyRYTaBTjobOCrCZV/n3jIuTcmvEL97q9qKq+p5y0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=01VH6sMrY/La3J7y6p2Nae0SniHK9ccLKzSRTIA0SHjBO062fN5BPUUigfC2zYkiS
         NgAD0BhJlGQRkdFFDv4zXDfBGVSRPTQPGjP/SyPHA5aAxy2NnvrahTNHZQae37DQlL
         coPGHmnI4O5GQ4ZjKCiclFmLA6uyW0xRZdw48buU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Heiko Carstens <hca@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 075/100] s390/kexec: fix return code handling
Date:   Wed, 24 Nov 2021 12:58:31 +0100
Message-Id: <20211124115657.280367506@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115654.849735859@linuxfoundation.org>
References: <20211124115654.849735859@linuxfoundation.org>
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
@@ -1783,7 +1783,7 @@ void *ipl_report_finish(struct ipl_repor
 
 	buf = vzalloc(report->size);
 	if (!buf)
-		return ERR_PTR(-ENOMEM);
+		goto out;
 	ptr = buf;
 
 	memcpy(ptr, report->ipib, report->ipib->hdr.len);
@@ -1822,6 +1822,7 @@ void *ipl_report_finish(struct ipl_repor
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


