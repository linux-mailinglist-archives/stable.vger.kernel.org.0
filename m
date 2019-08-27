Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D2209E122
	for <lists+stable@lfdr.de>; Tue, 27 Aug 2019 10:10:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731774AbfH0IDZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Aug 2019 04:03:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:60828 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731726AbfH0IDZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Aug 2019 04:03:25 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 14BD22184D;
        Tue, 27 Aug 2019 08:03:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566893004;
        bh=CnW/99LHE16tUeRklnY6vzCDDEueF8ANJQvc04yPUk4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Bcl41QsNSUklFqKdtIRFHG92JD1qxZqPG/m8dCG4IhYvkU5MSSjNgHnf/Rtg6lGY/
         i46MwgzECcY8djArhM1yaPaFjHZCZwsne9dq/m9O9oxZPVL5F6cT0gZuaud3+lBZEO
         soz3gfCA+Ny5zYl9jA+0z8e+mCecNRFI1VRNFSSE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Richter <tmricht@linux.ibm.com>,
        Andreas Krebbel <krebbel@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 087/162] s390: put _stext and _etext into .text section
Date:   Tue, 27 Aug 2019 09:50:15 +0200
Message-Id: <20190827072741.174759983@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190827072738.093683223@linuxfoundation.org>
References: <20190827072738.093683223@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 24350fdadbdec780406a1ef988e6cd3875e374a8 ]

Perf relies on _etext and _stext symbols being one of 't', 'T', 'v' or
'V'. Put them into .text section to guarantee that.

Also moves padding to page boundary inside .text which has an effect that
.text section is now padded with nops rather than 0's, which apparently
has been the initial intention for specifying 0x0700 fill expression.

Reported-by: Thomas Richter <tmricht@linux.ibm.com>
Tested-by: Thomas Richter <tmricht@linux.ibm.com>
Suggested-by: Andreas Krebbel <krebbel@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kernel/vmlinux.lds.S | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/arch/s390/kernel/vmlinux.lds.S b/arch/s390/kernel/vmlinux.lds.S
index 49d55327de0bc..7e0eb40209177 100644
--- a/arch/s390/kernel/vmlinux.lds.S
+++ b/arch/s390/kernel/vmlinux.lds.S
@@ -32,10 +32,9 @@ PHDRS {
 SECTIONS
 {
 	. = 0x100000;
-	_stext = .;		/* Start of text section */
 	.text : {
-		/* Text and read-only data */
-		_text = .;
+		_stext = .;		/* Start of text section */
+		_text = .;		/* Text and read-only data */
 		HEAD_TEXT
 		TEXT_TEXT
 		SCHED_TEXT
@@ -47,11 +46,10 @@ SECTIONS
 		*(.text.*_indirect_*)
 		*(.fixup)
 		*(.gnu.warning)
+		. = ALIGN(PAGE_SIZE);
+		_etext = .;		/* End of text section */
 	} :text = 0x0700
 
-	. = ALIGN(PAGE_SIZE);
-	_etext = .;		/* End of text section */
-
 	NOTES :text :note
 
 	.dummy : { *(.dummy) } :data
-- 
2.20.1



