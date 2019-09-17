Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 98473B5853
	for <lists+stable@lfdr.de>; Wed, 18 Sep 2019 01:00:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728254AbfIQXAq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Sep 2019 19:00:46 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:39460 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726201AbfIQXAq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Sep 2019 19:00:46 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x8HMn8Me147007
        for <stable@vger.kernel.org>; Tue, 17 Sep 2019 19:00:45 -0400
Received: from e06smtp05.uk.ibm.com (e06smtp05.uk.ibm.com [195.75.94.101])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2v37u59sck-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <stable@vger.kernel.org>; Tue, 17 Sep 2019 19:00:44 -0400
Received: from localhost
        by e06smtp05.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <stable@vger.kernel.org> from <zohar@linux.ibm.com>;
        Wed, 18 Sep 2019 00:00:43 +0100
Received: from b06cxnps4076.portsmouth.uk.ibm.com (9.149.109.198)
        by e06smtp05.uk.ibm.com (192.168.101.135) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 18 Sep 2019 00:00:39 +0100
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x8HN0cEf44368082
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Sep 2019 23:00:38 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C8F1452052;
        Tue, 17 Sep 2019 23:00:38 +0000 (GMT)
Received: from localhost.ibm.com (unknown [9.85.163.39])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 27ECC5204E;
        Tue, 17 Sep 2019 23:00:38 +0000 (GMT)
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     Patrick Callaghan <patrickc@us.ibm.com>
Cc:     maroon <maroon@lists.linux.ibm.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        stable@vger.kernel.org
Subject: [PATCH] tpm: Wrap the buffer from the caller to tpm_buf in tpm_send()
Date:   Tue, 17 Sep 2019 19:00:35 -0400
X-Mailer: git-send-email 2.7.5
X-TM-AS-GCONF: 00
x-cbid: 19091723-0020-0000-0000-0000036E4D62
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19091723-0021-0000-0000-000021C3F389
Message-Id: <1568761235-17516-1-git-send-email-zohar@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-09-17_12:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1908290000 definitions=main-1909170212
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>

tpm_send() does not give anymore the result back to the caller. This
would require another memcpy(), which kind of tells that the whole
approach is somewhat broken. Instead, as Mimi suggested, this commit
just wraps the data to the tpm_buf, and thus the result will not go to
the garbage.

Obviously this assumes from the caller that it passes large enough
buffer, which makes the whole API somewhat broken because it could be
different size than @buflen but since trusted keys is the only module
using this API right now I think that this fix is sufficient for the
moment.

In the near future the plan is to replace the parameters with a tpm_buf
created by the caller.

Reported-by: Mimi Zohar <zohar@linux.ibm.com>
Suggested-by: Mimi Zohar <zohar@linux.ibm.com>
Cc: stable@vger.kernel.org
Fixes: 412eb585587a ("use tpm_buf in tpm_transmit_cmd() as the IO parameter")
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Reviewed-by: Jerry Snitselaar <jsnitsel@redhat.com>
---
 drivers/char/tpm/tpm-interface.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/char/tpm/tpm-interface.c b/drivers/char/tpm/tpm-interface.c
index 208e5ba40e6e..e268f7422427 100644
--- a/drivers/char/tpm/tpm-interface.c
+++ b/drivers/char/tpm/tpm-interface.c
@@ -354,14 +354,9 @@ int tpm_send(struct tpm_chip *chip, void *cmd, size_t buflen)
 	if (!chip)
 		return -ENODEV;
 
-	rc = tpm_buf_init(&buf, 0, 0);
-	if (rc)
-		goto out;
-
-	memcpy(buf.data, cmd, buflen);
+	buf.data = cmd;
 	rc = tpm_transmit_cmd(chip, &buf, 0, "attempting to a send a command");
-	tpm_buf_destroy(&buf);
-out:
+
 	tpm_put_ops(chip);
 	return rc;
 }
-- 
2.7.5

