Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BC122A585A
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 22:52:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731406AbgKCUsY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 15:48:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:39842 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730199AbgKCUsX (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:48:23 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C3C122242E;
        Tue,  3 Nov 2020 20:48:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604436503;
        bh=imz8njZ/jznJ57aojACtJGu6wjeFxaHMPzyl3LOuhNM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JZHEc2h3q2cq8LZRFXyUZhTTSRbgAK/AbecxMQvBSp3NK+Kvawrup2wuxPCtTob70
         tgDuJmAGHKYBZpJef7C+DQIWhPdURBvvR8kwV6dPplfa7e5qKxwurxhyw1B/ozgtbQ
         lV2kc4FIo8PZRJShytcEPzZ4rd37nbZmH3ta3Wi8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
        Nathan Lynch <nathanl@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.9 279/391] powerpc/drmem: Make lmb_size 64 bit
Date:   Tue,  3 Nov 2020 21:35:30 +0100
Message-Id: <20201103203405.860662341@linuxfoundation.org>
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

From: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>

commit ec72024e35dddb88a81e40071c87ceb18b5ee835 upstream.

Similar to commit 89c140bbaeee ("pseries: Fix 64 bit logical memory block panic")
make sure different variables tracking lmb_size are updated to be 64 bit.

This was found by code audit.

Cc: stable@vger.kernel.org
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Acked-by: Nathan Lynch <nathanl@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20201007114836.282468-2-aneesh.kumar@linux.ibm.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/include/asm/drmem.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/powerpc/include/asm/drmem.h
+++ b/arch/powerpc/include/asm/drmem.h
@@ -20,7 +20,7 @@ struct drmem_lmb {
 struct drmem_lmb_info {
 	struct drmem_lmb        *lmbs;
 	int                     n_lmbs;
-	u32                     lmb_size;
+	u64                     lmb_size;
 };
 
 extern struct drmem_lmb_info *drmem_info;
@@ -80,7 +80,7 @@ struct of_drconf_cell_v2 {
 #define DRCONF_MEM_RESERVED	0x00000080
 #define DRCONF_MEM_HOTREMOVABLE	0x00000100
 
-static inline u32 drmem_lmb_size(void)
+static inline u64 drmem_lmb_size(void)
 {
 	return drmem_info->lmb_size;
 }


