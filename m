Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1AD1B6AF385
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 20:06:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231645AbjCGTGA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 14:06:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232141AbjCGTFp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 14:05:45 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 632CEA8EA5
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:51:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9EB76B819CA
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:51:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10E78C433A1;
        Tue,  7 Mar 2023 18:51:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678215063;
        bh=AM1/GlzEmac11IRA1ziyHXEiFDmUmATfMpQy7ZOE2/g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OrP8uMG/2CDml+x40aagFHaArO6NULcRhXFtQ40srf51rg52V9r476T0XiAVNcczN
         cEah0thrNZs5ew1pPgoCJMh4YgLY7GXEcVWOFNgPa+MhrEhF+6UPV2sh5l8PRSm0c8
         5C7Do8v6mY51W1wUNY3IKdWHI2lA+6gTt07V2xKg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Halil Pasic <pasic@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Harald Freudenberger <freude@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 139/567] s390/ap: fix status returned by ap_aqic()
Date:   Tue,  7 Mar 2023 17:57:55 +0100
Message-Id: <20230307165911.924850883@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307165905.838066027@linuxfoundation.org>
References: <20230307165905.838066027@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Halil Pasic <pasic@linux.ibm.com>

[ Upstream commit 394740d7645ea767795074287769dd26dbd4d782 ]

There function ap_aqic() tries to grab the status from the
wrong part of the register. Thus we always end up with
zeros. Which is wrong, among others, because we detect
failures via status.response_code.

Signed-off-by: Halil Pasic <pasic@linux.ibm.com>
Reported-by: Janosch Frank <frankja@linux.ibm.com>
Fixes: 159491f3b509 ("s390/ap: rework assembler functions to use unions for in/out register variables")
Reviewed-by: Harald Freudenberger <freude@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/include/asm/ap.h | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/s390/include/asm/ap.h b/arch/s390/include/asm/ap.h
index 3afbee21dc1f1..8a8c0b157b551 100644
--- a/arch/s390/include/asm/ap.h
+++ b/arch/s390/include/asm/ap.h
@@ -236,7 +236,10 @@ static inline struct ap_queue_status ap_aqic(ap_qid_t qid,
 	union {
 		unsigned long value;
 		struct ap_qirq_ctrl qirqctrl;
-		struct ap_queue_status status;
+		struct {
+			u32 _pad;
+			struct ap_queue_status status;
+		};
 	} reg1;
 	void *reg2 = ind;
 
@@ -250,7 +253,7 @@ static inline struct ap_queue_status ap_aqic(ap_qid_t qid,
 		"	lgr	%[reg1],1\n"   /* gr1 (status) into reg1 */
 		: [reg1] "+&d" (reg1)
 		: [reg0] "d" (reg0), [reg2] "d" (reg2)
-		: "cc", "0", "1", "2");
+		: "cc", "memory", "0", "1", "2");
 
 	return reg1.status;
 }
-- 
2.39.2



