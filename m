Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7026D4ABFE1
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 14:49:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344395AbiBGNoK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 08:44:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1449365AbiBGNWK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 08:22:10 -0500
X-Greylist: delayed 1805 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 07 Feb 2022 05:22:09 PST
Received: from mgw-01.mpynet.fi (mgw-01.mpynet.fi [82.197.21.90])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E36E7C043181;
        Mon,  7 Feb 2022 05:22:08 -0800 (PST)
Received: from pps.filterd (mgw-01.mpynet.fi [127.0.0.1])
        by mgw-01.mpynet.fi (8.16.0.43/8.16.0.43) with SMTP id 217BqTPt079090;
        Mon, 7 Feb 2022 14:07:41 +0200
Received: from ex13.tuxera.com (ex13.tuxera.com [178.16.184.72])
        by mgw-01.mpynet.fi with ESMTP id 3e2vptra6j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 07 Feb 2022 14:07:41 +0200
Received: from virt.srv.tuxera.com (194.100.106.190) by
 tuxera-exch.ad.tuxera.com (10.20.48.11) with Microsoft SMTP Server (TLS) id
 15.0.1497.26; Mon, 7 Feb 2022 14:07:40 +0200
From:   Ari Sundholm <ari@tuxera.com>
To:     Andrew Morton <akpm@linux-foundation.org>
CC:     Ari Sundholm <ari@tuxera.com>, <linux-kernel@vger.kernel.org>,
        <linux-fsdevel@vger.kernel.org>, <stable@vger.kernel.org>,
        Anton Altaparmakov <anton@tuxera.com>
Subject: [PATCH] fs/read_write.c: Fix a broken signed integer overflow check.
Date:   Mon, 7 Feb 2022 14:07:11 +0200
Message-ID: <20220207120711.4070403-1-ari@tuxera.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [194.100.106.190]
X-ClientProxiedBy: tuxera-exch.ad.tuxera.com (10.20.48.11) To
 tuxera-exch.ad.tuxera.com (10.20.48.11)
X-Proofpoint-ORIG-GUID: mJm75l6b2RkAqRr-SI5hsFtL6HwnwGuJ
X-Proofpoint-GUID: mJm75l6b2RkAqRr-SI5hsFtL6HwnwGuJ
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.425,18.0.816
 definitions=2022-02-07_04:2022-02-07,2022-02-07 signatures=0
X-Proofpoint-Spam-Details: rule=mpy_notspam policy=mpy score=0 bulkscore=0 malwarescore=0 spamscore=0
 suspectscore=0 phishscore=0 mlxscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202070077
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The function generic_copy_file_checks() checks that the ends of the
input and output file ranges do not overflow. Unfortunately, there is
an issue with the check itself.

Due to the integer promotion rules in C, the expressions
(pos_in + count) and (pos_out + count) have an unsigned type because
the count variable has the type uint64_t. Thus, in many cases where we
should detect signed integer overflow to have occurred (and thus one or
more of the ranges being invalid), the expressions will instead be
interpreted as large unsigned integers. This means the check is broken.

Fix this by explicitly casting the expressions to loff_t.

Cc: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org
Cc: stable@vger.kernel.org
Reviewed-by: Anton Altaparmakov <anton@tuxera.com>
Signed-off-by: Ari Sundholm <ari@tuxera.com>
---
 fs/read_write.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/read_write.c b/fs/read_write.c
index 0074afa7ecb3..64166e74adc5 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -1431,7 +1431,8 @@ static int generic_copy_file_checks(struct file *file_in, loff_t pos_in,
 		return -ETXTBSY;
 
 	/* Ensure offsets don't wrap. */
-	if (pos_in + count < pos_in || pos_out + count < pos_out)
+	if ((loff_t)(pos_in + count) < pos_in ||
+			(loff_t)(pos_out + count) < pos_out)
 		return -EOVERFLOW;
 
 	/* Shorten the copy to EOF */
-- 
2.20.1

