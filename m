Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 717BD4D64A2
	for <lists+stable@lfdr.de>; Fri, 11 Mar 2022 16:31:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349313AbiCKPcR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Mar 2022 10:32:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349173AbiCKPcM (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Mar 2022 10:32:12 -0500
Received: from alexa-out.qualcomm.com (alexa-out.qualcomm.com [129.46.98.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1D2A1C025E;
        Fri, 11 Mar 2022 07:31:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=quicinc.com; i=@quicinc.com; q=dns/txt; s=qcdkim;
  t=1647012667; x=1678548667;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=sxa44dfwh+7OfJVU2hGG661tCEMXjNsht7SbfX+FjMQ=;
  b=m9oFnRR8m9MCwDodx1GEkT4N4eRqxIM4pnZW9Gb9oreYDJylmZzgmVup
   kV07laFxjOBqiuaTmWEkSmybqZtujewfXgWrpXaJctlg5HDoPhHwFXqFN
   DUAQBQxzm8WP6RKSgeaXK+TsYRb+8NKfvZMmyk74ViprSwTrG/iY3b6m2
   k=;
Received: from ironmsg09-lv.qualcomm.com ([10.47.202.153])
  by alexa-out.qualcomm.com with ESMTP; 11 Mar 2022 07:31:06 -0800
X-QCInternal: smtphost
Received: from nasanex01c.na.qualcomm.com ([10.47.97.222])
  by ironmsg09-lv.qualcomm.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Mar 2022 07:31:06 -0800
Received: from nalasex01a.na.qualcomm.com (10.47.209.196) by
 nasanex01c.na.qualcomm.com (10.47.97.222) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.15; Fri, 11 Mar 2022 07:31:05 -0800
Received: from hu-charante-hyd.qualcomm.com (10.80.80.8) by
 nalasex01a.na.qualcomm.com (10.47.209.196) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.15; Fri, 11 Mar 2022 07:31:01 -0800
From:   Charan Teja Kalla <quic_charante@quicinc.com>
To:     <akpm@linux-foundation.org>, <surenb@google.com>, <vbabka@suse.cz>,
        <rientjes@google.com>, <sfr@canb.auug.org.au>,
        <edgararriaga@google.com>, <minchan@kernel.org>,
        <nadav.amit@gmail.com>, <mhocko@suse.com>
CC:     <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        Charan Teja Kalla <quic_charante@quicinc.com>,
        "# 5 . 10+" <stable@vger.kernel.org>
Subject: [PATCH V2,1/2] mm: madvise: return correct bytes advised with process_madvise
Date:   Fri, 11 Mar 2022 20:59:05 +0530
Message-ID: <125b61a0edcee5c2db8658aed9d06a43a19ccafc.1647008754.git.quic_charante@quicinc.com>
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

The process_madvise() system call returns error even after processing
some VMA's passed in the 'struct iovec' vector list which leaves the
user confused to know where to restart the advise next. It is also
against this syscall man page[1] documentation where it mentions that
"return value may be less than the total number of requested bytes, if
an error occurred after some iovec elements were already processed.".

Consider a user passed 10 VMA's in the 'struct iovec' vector list of
which 9 are processed but one. Then it just returns the error caused on
that failed VMA despite the first 9 VMA's processed, leaving the user
confused about on which VMA it is failed. Returning the number of bytes
processed here can help the user to know which VMA it is failed on and
thus can retry/skip the advise on that VMA.

[1]https://man7.org/linux/man-pages/man2/process_madvise.2.html.

Fixes: ecb8ac8b1f14("mm/madvise: introduce process_madvise() syscall: an external memory hinting API")
Cc: <stable@vger.kernel.org> # 5.10+
Signed-off-by: Charan Teja Kalla <quic_charante@quicinc.com>
---
Changes in V2:
 -- Separated the ENOMEM handling and return bytes processed, as per Minchan comments.
 -- This contains correcting return bytes processed with process_madvise().

Changes in V1:
 -- Fixed the ENOMEM handling and return bytes processed by process_madvise.
 -- https://patchwork.kernel.org/project/linux-mm/patch/1646803679-11433-1-git-send-email-quic_charante@quicinc.com/

 mm/madvise.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/mm/madvise.c b/mm/madvise.c
index 38d0f51..e97e6a9 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -1433,8 +1433,7 @@ SYSCALL_DEFINE5(process_madvise, int, pidfd, const struct iovec __user *, vec,
 		iov_iter_advance(&iter, iovec.iov_len);
 	}
 
-	if (ret == 0)
-		ret = total_len - iov_iter_count(&iter);
+	ret = (total_len - iov_iter_count(&iter)) ? : ret;
 
 release_mm:
 	mmput(mm);
-- 
2.7.4

