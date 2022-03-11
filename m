Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D48424D64A3
	for <lists+stable@lfdr.de>; Fri, 11 Mar 2022 16:31:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349284AbiCKPcS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Mar 2022 10:32:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245374AbiCKPcP (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Mar 2022 10:32:15 -0500
Received: from alexa-out-sd-02.qualcomm.com (alexa-out-sd-02.qualcomm.com [199.106.114.39])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0CD71B8CB5;
        Fri, 11 Mar 2022 07:31:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=quicinc.com; i=@quicinc.com; q=dns/txt; s=qcdkim;
  t=1647012671; x=1678548671;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=RMMRc4l/DMGvaxhGwtRQMf5EeR3IlqrnnLrpu8bbrak=;
  b=WzqIFtBhcXIggjeehhHaEQVuhhi8jKTqMAIrAJoziPqTuWQR5r75229M
   ATZntzVNx1bp8+Nx58vCjnEFYJwGo9rOuLmkjxVGLEOcErdC/tqfQRbGu
   bgff4I17h1SqFWPb+QikvSbO/XPDQM2DwJaxmbtpXN6EgoJlg/SWJ0vHK
   o=;
Received: from unknown (HELO ironmsg01-sd.qualcomm.com) ([10.53.140.141])
  by alexa-out-sd-02.qualcomm.com with ESMTP; 11 Mar 2022 07:31:11 -0800
X-QCInternal: smtphost
Received: from nasanex01c.na.qualcomm.com ([10.47.97.222])
  by ironmsg01-sd.qualcomm.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Mar 2022 07:31:10 -0800
Received: from nalasex01a.na.qualcomm.com (10.47.209.196) by
 nasanex01c.na.qualcomm.com (10.47.97.222) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.15; Fri, 11 Mar 2022 07:31:10 -0800
Received: from hu-charante-hyd.qualcomm.com (10.80.80.8) by
 nalasex01a.na.qualcomm.com (10.47.209.196) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.15; Fri, 11 Mar 2022 07:31:05 -0800
From:   Charan Teja Kalla <quic_charante@quicinc.com>
To:     <akpm@linux-foundation.org>, <surenb@google.com>, <vbabka@suse.cz>,
        <rientjes@google.com>, <sfr@canb.auug.org.au>,
        <edgararriaga@google.com>, <minchan@kernel.org>,
        <nadav.amit@gmail.com>, <mhocko@suse.com>
CC:     <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        Charan Teja Kalla <quic_charante@quicinc.com>,
        "# 5 . 10+" <stable@vger.kernel.org>
Subject: [PATCH V2,2/2] mm: madvise: skip unmapped vma holes passed to process_madvise
Date:   Fri, 11 Mar 2022 20:59:06 +0530
Message-ID: <4f091776142f2ebf7b94018146de72318474e686.1647008754.git.quic_charante@quicinc.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1647008754.git.quic_charante@quicinc.com>
References: <cover.1647008754.git.quic_charante@quicinc.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01b.na.qualcomm.com (10.46.141.250) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The process_madvise() system call is expected to skip holes in vma
passed through 'struct iovec' vector list. But do_madvise, which
process_madvise() calls for each vma, returns ENOMEM in case of unmapped
holes, despite the VMA is processed.
Thus process_madvise() should treat ENOMEM as expected and consider the
VMA passed to as processed and continue processing other vma's in the
vector list. Returning -ENOMEM to user, despite the VMA is processed,
will be unable to figure out where to start the next madvise.

Fixes: ecb8ac8b1f14("mm/madvise: introduce process_madvise() syscall: an external memory hinting API")
Cc: <stable@vger.kernel.org> # 5.10+
Signed-off-by: Charan Teja Kalla <quic_charante@quicinc.com>
---
Changes in V2:
  -- Fixed handling of ENOMEM by process_madvise().
  -- Patch doesn't exist in V1.

 mm/madvise.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/mm/madvise.c b/mm/madvise.c
index e97e6a9..14fb76d 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -1426,9 +1426,16 @@ SYSCALL_DEFINE5(process_madvise, int, pidfd, const struct iovec __user *, vec,
 
 	while (iov_iter_count(&iter)) {
 		iovec = iov_iter_iovec(&iter);
+		/*
+		 * do_madvise returns ENOMEM if unmapped holes are present
+		 * in the passed VMA. process_madvise() is expected to skip
+		 * unmapped holes passed to it in the 'struct iovec' list
+		 * and not fail because of them. Thus treat -ENOMEM return
+		 * from do_madvise as valid and continue processing.
+		 */
 		ret = do_madvise(mm, (unsigned long)iovec.iov_base,
 					iovec.iov_len, behavior);
-		if (ret < 0)
+		if (ret < 0 && ret != -ENOMEM)
 			break;
 		iov_iter_advance(&iter, iovec.iov_len);
 	}
-- 
2.7.4

