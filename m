Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB8988C8C4
	for <lists+stable@lfdr.de>; Wed, 14 Aug 2019 04:34:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728583AbfHNCOI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Aug 2019 22:14:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:46136 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728571AbfHNCOI (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 13 Aug 2019 22:14:08 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5293E20842;
        Wed, 14 Aug 2019 02:14:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565748847;
        bh=k8yonzpNdAgceiEG578aqiAgYJnAWLHIoNXeqkcJjYA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lWwOWYKLoOIQqHrC0N7cDCGqRgfkkYQwIY5cbfktJgnlrQv4L58LabknSSPci63gX
         aS6TvioRz530yDMXJl/4t853igm31JnVdsfae7LipVTL1LuKyrZ5FGUPjSo+Gqsq6k
         lU/YkkibZFooiY1lmQvcQWv04INd/ERzwtWtJdqs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vasily Gorbik <gor@linux.ibm.com>,
        Thomas Richter <tmricht@linux.ibm.com>,
        Andreas Krebbel <krebbel@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>, linux-s390@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 099/123] s390: put _stext and _etext into .text section
Date:   Tue, 13 Aug 2019 22:10:23 -0400
Message-Id: <20190814021047.14828-99-sashal@kernel.org>
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

From: Vasily Gorbik <gor@linux.ibm.com>

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

