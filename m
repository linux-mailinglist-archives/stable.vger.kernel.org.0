Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B06636AE98B
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:25:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231560AbjCGRZg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:25:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229907AbjCGRZH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:25:07 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E07088EA31
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:20:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 296EB614D0
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:20:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F286C4339B;
        Tue,  7 Mar 2023 17:20:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678209616;
        bh=jnSHuPMg5NCpgfM5FLzIyEv3LzUqrPtECnpS6f3ZFr8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IeSekpYunDlfVCx25ekmLcnWOKVFybZoeGGc9nlc2m8Ln7K8UqI/EUQIhXlu2jNII
         vm2RbaqkQYIEIxG3jbKL69QFSOAO+STSgbTr3SzRazWMGJg5T8HKc+oTjImOgj9iNS
         2ufS16Moah/jmUpsXGDioBFRwtbKSBBZbR+n5Yfc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Halil Pasic <pasic@linux.ibm.com>,
        Harald Freudenberger <freude@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0276/1001] s390/ap: fix status returned by ap_qact()
Date:   Tue,  7 Mar 2023 17:50:48 +0100
Message-Id: <20230307170033.641881937@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
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

[ Upstream commit a2522c80f074c35254974fec39fffe8b8d75befe ]

Since commit 159491f3b509 ("s390/ap: rework assembler functions to use
unions for in/out register variables") the  function ap_qact() tries to
grab the status from the wrong part of the register. Thus we always end
up with zeros. Which is wrong, among others, because we detect failures
via status.response_code.

Signed-off-by: Halil Pasic <pasic@linux.ibm.com>
Reported-by: Harald Freudenberger <freude@linux.ibm.com>
Fixes: 159491f3b509 ("s390/ap: rework assembler functions to use unions for in/out register variables")
Reviewed-by: Harald Freudenberger <freude@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/include/asm/ap.h | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/s390/include/asm/ap.h b/arch/s390/include/asm/ap.h
index 876afe46f316d..57a2d6518d272 100644
--- a/arch/s390/include/asm/ap.h
+++ b/arch/s390/include/asm/ap.h
@@ -293,7 +293,10 @@ static inline struct ap_queue_status ap_qact(ap_qid_t qid, int ifbit,
 	unsigned long reg0 = qid | (5UL << 24) | ((ifbit & 0x01) << 22);
 	union {
 		unsigned long value;
-		struct ap_queue_status status;
+		struct {
+			u32 _pad;
+			struct ap_queue_status status;
+		};
 	} reg1;
 	unsigned long reg2;
 
-- 
2.39.2



