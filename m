Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B929C1D7CFD
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 17:35:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728223AbgERPfu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 11:35:50 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:15124 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728110AbgERPft (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 May 2020 11:35:49 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04IFWxsf095910;
        Mon, 18 May 2020 11:35:48 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 312agcqr93-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 18 May 2020 11:35:48 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 04IFKUEW018437;
        Mon, 18 May 2020 15:35:46 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma03ams.nl.ibm.com with ESMTP id 3127t5mcxn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 18 May 2020 15:35:45 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 04IFZhqA58785966
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 18 May 2020 15:35:43 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BBBD34C04E;
        Mon, 18 May 2020 15:35:43 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 833834C04A;
        Mon, 18 May 2020 15:35:43 +0000 (GMT)
Received: from bahia.lan (unknown [9.145.63.64])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 18 May 2020 15:35:43 +0000 (GMT)
Subject: [PATCH] scripts/sorttable: Correctly handle mmap() returning
 MAP_FAILED
From:   Greg Kurz <groug@kaod.org>
To:     linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, linux-kbuild@vger.kernel.org,
        mingo@kernel.org
Date:   Mon, 18 May 2020 17:35:42 +0200
Message-ID: <158981614256.106494.12226121528668381542.stgit@bahia.lan>
User-Agent: StGit/unknown-version
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-18_06:2020-05-15,2020-05-18 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 phishscore=0
 malwarescore=0 impostorscore=0 mlxlogscore=999 clxscore=1034 bulkscore=0
 priorityscore=1501 lowpriorityscore=0 suspectscore=1 cotscore=-2147483648
 spamscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005180131
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The caller of mmap_file() assumes it returns a valid address or NULL
on error. If mmap() fails for some reason, MAP_FAILED is returned
instead and sorttable crashes later when trying to dereference the
pointer:

Program received signal SIGSEGV, Segmentation fault.
0x0000000000402b25 in do_file (fname=0x7fffffffe5e2 "vmlinux",
    addr=0xffffffffffffffff) at scripts/sorttable.c:264
264             switch (ehdr->e_ident[EI_DATA]) {
(gdb) p ehdr
$1 = (Elf32_Ehdr *) 0xffffffffffffffff

mmap() can only return NULL if the user explicitely asks for it with
MAP_FIXED, which isn't the case here. So, rather than changing the
semantics of mmap_file() and having the caller to cope with an
extra sentinel, return NULL when mmap() fails.

This bug exists since the addition of the sortextable binary (previous
name of sorttable). That code was borrowed from scripts/recordmount.c
which had the same issue. It got fixed in a similar manner by commit
3f1df12019f3 ("recordmcount: Rewrite error/success handling").

Cc: stable@vger.kernel.org # v3.5
Fixes: a79f248b9b30 ("scripts: Add sortextable to sort the kernel's exception table.")
Signed-off-by: Greg Kurz <groug@kaod.org>
---
 scripts/sorttable.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/scripts/sorttable.c b/scripts/sorttable.c
index ec6b5e81eba1..5ad7a9bbff42 100644
--- a/scripts/sorttable.c
+++ b/scripts/sorttable.c
@@ -91,6 +91,7 @@ static void *mmap_file(char const *fname, size_t *size)
 	addr = mmap(0, sb.st_size, PROT_READ|PROT_WRITE, MAP_SHARED, fd, 0);
 	if (addr == MAP_FAILED) {
 		fprintf(stderr, "Could not mmap file: %s\n", fname);
+		addr = NULL;
 		goto out;
 	}
 

