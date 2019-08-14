Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B52E28C8DD
	for <lists+stable@lfdr.de>; Wed, 14 Aug 2019 04:35:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728884AbfHNCe0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Aug 2019 22:34:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:45938 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728460AbfHNCNw (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 13 Aug 2019 22:13:52 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AAE7920874;
        Wed, 14 Aug 2019 02:13:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565748831;
        bh=oUTvVHpGCXniprAY65ZrDbxr23TG1b7WMgMOcwgLu4Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pscl496XrhIt36Hq0oFPQPAsvI4j+tv4/VKyuwY6U8ELJv+jfzBqgezSG8OkCjB0Z
         s4/UKfXmNsC712iEMXikO83Yno3/ABr6tE0cA69GKm7shL5bRtaJFqz1+1hFG6Jmbs
         tJKCIfB9yre/AZgzayEseYCli//EDypHrybkuNI0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sebastien Tisserant <stisserant@wallix.com>,
        Pavel Shilovsky <pshilov@microsoft.com>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>, linux-cifs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 091/123] SMB3: Kernel oops mounting a encryptData share with CONFIG_DEBUG_VIRTUAL
Date:   Tue, 13 Aug 2019 22:10:15 -0400
Message-Id: <20190814021047.14828-91-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190814021047.14828-1-sashal@kernel.org>
References: <20190814021047.14828-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sebastien Tisserant <stisserant@wallix.com>

[ Upstream commit ee9d66182392695535cc9fccfcb40c16f72de2a9 ]

Fix kernel oops when mounting a encryptData CIFS share with
CONFIG_DEBUG_VIRTUAL

Signed-off-by: Sebastien Tisserant <stisserant@wallix.com>
Reviewed-by: Pavel Shilovsky <pshilov@microsoft.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/smb2ops.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index ae10d6e297c3a..42de31d206169 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -3439,7 +3439,15 @@ fill_transform_hdr(struct smb2_transform_hdr *tr_hdr, unsigned int orig_len,
 static inline void smb2_sg_set_buf(struct scatterlist *sg, const void *buf,
 				   unsigned int buflen)
 {
-	sg_set_page(sg, virt_to_page(buf), buflen, offset_in_page(buf));
+	void *addr;
+	/*
+	 * VMAP_STACK (at least) puts stack into the vmalloc address space
+	 */
+	if (is_vmalloc_addr(buf))
+		addr = vmalloc_to_page(buf);
+	else
+		addr = virt_to_page(buf);
+	sg_set_page(sg, addr, buflen, offset_in_page(buf));
 }
 
 /* Assumes the first rqst has a transform header as the first iov.
-- 
2.20.1

