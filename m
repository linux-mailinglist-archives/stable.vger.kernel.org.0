Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1DE6328F75
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:54:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239097AbhCATwA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:52:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:54248 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242043AbhCATnv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:43:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E28156502C;
        Mon,  1 Mar 2021 17:14:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614618867;
        bh=y1vVb6H2Ynlpe7HVnGQZ/pRkRfbcw3+MNvs+pxOPqIE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gADm9mHUqvr6CETCL/GyWEjhwa7uM9U/GiQghHVNusWT8lrVSstFYBipzXsKds9J2
         XWxSHvsOF5SdTTTq8Onk2AKC4M/d/2+lKYccZU3dXihwC6E7cU2nwupwlPjz5D+oQu
         8iDWo9jX/3xZOl5opMu35r94zVeJQLw3/WvpB/Dc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Lakshmi Ramasubramanian <nramas@linux.microsoft.com>,
        Tyler Hicks <tyhicks@linux.microsoft.com>,
        Mimi Zohar <zohar@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 246/663] ima: Free IMA measurement buffer on error
Date:   Mon,  1 Mar 2021 17:08:14 +0100
Message-Id: <20210301161153.990661984@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lakshmi Ramasubramanian <nramas@linux.microsoft.com>

[ Upstream commit 6d14c6517885fa68524238787420511b87d671df ]

IMA allocates kernel virtual memory to carry forward the measurement
list, from the current kernel to the next kernel on kexec system call,
in ima_add_kexec_buffer() function.  In error code paths this memory
is not freed resulting in memory leak.

Free the memory allocated for the IMA measurement list in
the error code paths in ima_add_kexec_buffer() function.

Signed-off-by: Lakshmi Ramasubramanian <nramas@linux.microsoft.com>
Suggested-by: Tyler Hicks <tyhicks@linux.microsoft.com>
Fixes: 7b8589cc29e7 ("ima: on soft reboot, save the measurement list")
Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/integrity/ima/ima_kexec.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/security/integrity/ima/ima_kexec.c b/security/integrity/ima/ima_kexec.c
index 121de3e04af23..206ddcaa5c67a 100644
--- a/security/integrity/ima/ima_kexec.c
+++ b/security/integrity/ima/ima_kexec.c
@@ -119,6 +119,7 @@ void ima_add_kexec_buffer(struct kimage *image)
 	ret = kexec_add_buffer(&kbuf);
 	if (ret) {
 		pr_err("Error passing over kexec measurement buffer.\n");
+		vfree(kexec_buffer);
 		return;
 	}
 
-- 
2.27.0



