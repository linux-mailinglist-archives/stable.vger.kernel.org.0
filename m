Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A8BC21709A
	for <lists+stable@lfdr.de>; Tue,  7 Jul 2020 17:24:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728578AbgGGPTG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jul 2020 11:19:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:58650 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728489AbgGGPTC (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jul 2020 11:19:02 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 15A842065D;
        Tue,  7 Jul 2020 15:19:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594135142;
        bh=LH6KfOFAuiAo8bo2kq2zE0/ec7aS2WUgR/NPwDfufoY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AycJ86F8nDGlrbjYwwfqqkyF0ftdFndQMUjC7p6Y/bBP7HQrFXozqoWMxVGSS0njj
         wpiB0Fx8ORgcG/feEyYMxJoUWSyjZD3Kdf6zG00AoV1K7JeXVkx/0UUqQ/IFfiilGm
         K22BbnJH1ibfDWXE0rDW9/SrOK6VhAo38+rzoaxI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 08/36] s390/debug: avoid kernel warning on too large number of pages
Date:   Tue,  7 Jul 2020 17:17:00 +0200
Message-Id: <20200707145749.535952718@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200707145749.130272978@linuxfoundation.org>
References: <20200707145749.130272978@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christian Borntraeger <borntraeger@de.ibm.com>

[ Upstream commit 827c4913923e0b441ba07ba4cc41e01181102303 ]

When specifying insanely large debug buffers a kernel warning is
printed. The debug code does handle the error gracefully, though.
Instead of duplicating the check let us silence the warning to
avoid crashes when panic_on_warn is used.

Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
Reviewed-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kernel/debug.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/s390/kernel/debug.c b/arch/s390/kernel/debug.c
index d374f9b218b4c..04bbf7e97fea7 100644
--- a/arch/s390/kernel/debug.c
+++ b/arch/s390/kernel/debug.c
@@ -198,9 +198,10 @@ static debug_entry_t ***debug_areas_alloc(int pages_per_area, int nr_areas)
 	if (!areas)
 		goto fail_malloc_areas;
 	for (i = 0; i < nr_areas; i++) {
+		/* GFP_NOWARN to avoid user triggerable WARN, we handle fails */
 		areas[i] = kmalloc_array(pages_per_area,
 					 sizeof(debug_entry_t *),
-					 GFP_KERNEL);
+					 GFP_KERNEL | __GFP_NOWARN);
 		if (!areas[i])
 			goto fail_malloc_areas2;
 		for (j = 0; j < pages_per_area; j++) {
-- 
2.25.1



