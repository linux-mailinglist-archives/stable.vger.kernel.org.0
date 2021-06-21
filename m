Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63DEA3AF0B4
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 18:49:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232137AbhFUQvr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 12:51:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:41352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233463AbhFUQtp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Jun 2021 12:49:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 930366145B;
        Mon, 21 Jun 2021 16:34:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624293284;
        bh=BI7DdNCcTO7m5jjZQLi7eYOCQXk23B73zOQUucRPvpU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e5Cmt3pKcWjU/nTOKu5eVHqUMNgV5AjiDoGQFS5WISuHu2/U60kiO2ccaAAJ4umcg
         zFeCcmqU8NGcWiJkNiHFfj9TUJL3ja6ws4llIIGdvQ4C+jmLrVw6O6FdtinFBM+JgE
         MoBg8oAtZQIrpAQplPdwg07FSWTIeeTGBtT+JHJE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH 5.12 133/178] s390/mcck: fix invalid KVM guest condition check
Date:   Mon, 21 Jun 2021 18:15:47 +0200
Message-Id: <20210621154927.309454936@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210621154921.212599475@linuxfoundation.org>
References: <20210621154921.212599475@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Gordeev <agordeev@linux.ibm.com>

commit 1874cb13d5d7cafa61ce93a760093ebc5485b6ab upstream.

Wrong condition check is used to decide if a machine check hit
while in KVM guest. As result of this check the instruction
following the SIE critical section might be considered as still
in KVM guest and _CIF_MCCK_GUEST CPU flag mistakenly set as
result.

Fixes: c929500d7a5a ("s390/nmi: s390: New low level handling for machine check happening in guest")
Cc: <stable@vger.kernel.org>
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Reviewed-by: Christian Borntraeger <borntraeger@de.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/kernel/entry.S |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/s390/kernel/entry.S
+++ b/arch/s390/kernel/entry.S
@@ -653,7 +653,7 @@ ENDPROC(stack_overflow)
 	slgr	%r9,%r13
 	larl	%r13,.Lsie_skip
 	clgr	%r9,%r13
-	jh	.Lcleanup_sie_int
+	jhe	.Lcleanup_sie_int
 	oi	__LC_CPU_FLAGS+7, _CIF_MCCK_GUEST
 .Lcleanup_sie_int:
 	BPENTER	__SF_SIE_FLAGS(%r15),(_TIF_ISOLATE_BP|_TIF_ISOLATE_BP_GUEST)


