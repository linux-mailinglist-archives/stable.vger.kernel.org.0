Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 500AE4122F0
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:17:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351773AbhITSTC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:19:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:39244 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1351724AbhITSQ5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:16:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E14F161A60;
        Mon, 20 Sep 2021 17:22:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632158549;
        bh=rHM8pExSYGB04i59AgI0OSz9coKtLAGDTOw1Due3n4I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nHEMkoysJiDkeAgs4FY59vM8UYoalB6pdQdLsLkK1fLMwEQPAKZoIvUiN4rde3BXz
         Zzkga6ABVHO546vO7SHo8tc+IZb/OJt2AFOZDww51qxLvyxcaxFx+HhHx+5sPjCZ7k
         NpampJp8KcO5vRffsxIEkqF0Acyu1PQv/bcniO7U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexander Egorenkov <egorenar@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH 5.4 207/260] s390/sclp: fix Secure-IPL facility detection
Date:   Mon, 20 Sep 2021 18:43:45 +0200
Message-Id: <20210920163938.142246010@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163931.123590023@linuxfoundation.org>
References: <20210920163931.123590023@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Egorenkov <egorenar@linux.ibm.com>

commit d76b14f3971a0638b6cd0da289f8b48acee287d0 upstream.

Prevent out-of-range access if the returned SCLP SCCB response is smaller
in size than the address of the Secure-IPL flag.

Fixes: c9896acc7851 ("s390/ipl: Provide has_secure sysfs attribute")
Cc: stable@vger.kernel.org # 5.2+
Signed-off-by: Alexander Egorenkov <egorenar@linux.ibm.com>
Reviewed-by: Christian Borntraeger <borntraeger@de.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/s390/char/sclp_early.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/s390/char/sclp_early.c
+++ b/drivers/s390/char/sclp_early.c
@@ -40,13 +40,14 @@ static void __init sclp_early_facilities
 	sclp.has_gisaf = !!(sccb->fac118 & 0x08);
 	sclp.has_hvs = !!(sccb->fac119 & 0x80);
 	sclp.has_kss = !!(sccb->fac98 & 0x01);
-	sclp.has_sipl = !!(sccb->cbl & 0x4000);
 	if (sccb->fac85 & 0x02)
 		S390_lowcore.machine_flags |= MACHINE_FLAG_ESOP;
 	if (sccb->fac91 & 0x40)
 		S390_lowcore.machine_flags |= MACHINE_FLAG_TLB_GUEST;
 	if (sccb->cpuoff > 134)
 		sclp.has_diag318 = !!(sccb->byte_134 & 0x80);
+	if (sccb->cpuoff > 137)
+		sclp.has_sipl = !!(sccb->cbl & 0x4000);
 	sclp.rnmax = sccb->rnmax ? sccb->rnmax : sccb->rnmax2;
 	sclp.rzm = sccb->rnsize ? sccb->rnsize : sccb->rnsize2;
 	sclp.rzm <<= 20;


