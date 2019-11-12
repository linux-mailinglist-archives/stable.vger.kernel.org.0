Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 436C0F893E
	for <lists+stable@lfdr.de>; Tue, 12 Nov 2019 08:00:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725821AbfKLHAG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Nov 2019 02:00:06 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:28588 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725283AbfKLHAG (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Nov 2019 02:00:06 -0500
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id xAC6wRKq025056
        for <stable@vger.kernel.org>; Tue, 12 Nov 2019 02:00:05 -0500
Received: from e06smtp03.uk.ibm.com (e06smtp03.uk.ibm.com [195.75.94.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2w7qe8rrqk-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <stable@vger.kernel.org>; Tue, 12 Nov 2019 02:00:04 -0500
Received: from localhost
        by e06smtp03.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <stable@vger.kernel.org> from <ajd@linux.ibm.com>;
        Tue, 12 Nov 2019 07:00:03 -0000
Received: from b06cxnps3075.portsmouth.uk.ibm.com (9.149.109.195)
        by e06smtp03.uk.ibm.com (192.168.101.133) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 12 Nov 2019 07:00:00 -0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xAC6xxfb48627768
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Nov 2019 06:59:59 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 29AC8AE053;
        Tue, 12 Nov 2019 06:59:59 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CD3F6AE056;
        Tue, 12 Nov 2019 06:59:58 +0000 (GMT)
Received: from ozlabs.au.ibm.com (unknown [9.192.253.14])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 12 Nov 2019 06:59:58 +0000 (GMT)
Received: from intelligence.ozlabs.ibm.com (haven.au.ibm.com [9.192.254.114])
        (using TLSv1.2 with cipher DHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by ozlabs.au.ibm.com (Postfix) with ESMTPSA id C606CA004F;
        Tue, 12 Nov 2019 17:59:53 +1100 (AEDT)
From:   Andrew Donnellan <ajd@linux.ibm.com>
To:     stable@vger.kernel.org
Cc:     linuxppc-dev@lists.ozlabs.org, npiggin@gmail.com,
        mpe@ellerman.id.au, Anton Blanchard <anton@samba.org>
Subject: [PATCH stable 4.4] powerpc/boot: Request no dynamic linker for boot wrapper
Date:   Tue, 12 Nov 2019 17:59:41 +1100
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19111207-0012-0000-0000-00000362DBBB
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19111207-0013-0000-0000-0000219E4962
Message-Id: <20191112065941.9548-1-ajd@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-11-12_01:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=15 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=933 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1910280000 definitions=main-1911120063
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicholas Piggin <npiggin@gmail.com>

Commit ff45000fcb56b5b0f1a14a865d3541746d838a0a upstream.

The boot wrapper performs its own relocations and does not require
PT_INTERP segment. However currently we don't tell the linker that.

Prior to binutils 2.28 that works OK. But since binutils commit
1a9ccd70f9a7 ("Fix the linker so that it will not silently generate ELF
binaries with invalid program headers. Fix readelf to report such
invalid binaries.") binutils tries to create a program header segment
due to PT_INTERP, and the link fails because there is no space for it:

  ld: arch/powerpc/boot/zImage.pseries: Not enough room for program headers, try linking with -N
  ld: final link failed: Bad value

So tell the linker not to do that, by passing --no-dynamic-linker.

Cc: stable@vger.kernel.org
Reported-by: Anton Blanchard <anton@samba.org>
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
[mpe: Drop dependency on ld-version.sh and massage change log]
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
[ajd: backport to v4.4 (resolve conflict with a comment line)]
Signed-off-by: Andrew Donnellan <ajd@linux.ibm.com>
---
 arch/powerpc/boot/wrapper | 24 +++++++++++++++++++++++-
 1 file changed, 23 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/boot/wrapper b/arch/powerpc/boot/wrapper
index ceaa75d5a684..be4831acda22 100755
--- a/arch/powerpc/boot/wrapper
+++ b/arch/powerpc/boot/wrapper
@@ -161,6 +161,28 @@ case "$elfformat" in
     elf32-powerpc)	format=elf32ppc	;;
 esac
 
+ld_version()
+{
+    # Poached from scripts/ld-version.sh, but we don't want to call that because
+    # this script (wrapper) is distributed separately from the kernel source.
+    # Extract linker version number from stdin and turn into single number.
+    awk '{
+	gsub(".*\\)", "");
+	gsub(".*version ", "");
+	gsub("-.*", "");
+	split($1,a, ".");
+	print a[1]*100000000 + a[2]*1000000 + a[3]*10000;
+	exit
+    }'
+}
+
+# Do not include PT_INTERP segment when linking pie. Non-pie linking
+# just ignores this option.
+LD_VERSION=$(${CROSS}ld --version | ld_version)
+LD_NO_DL_MIN_VERSION=$(echo 2.26 | ld_version)
+if [ "$LD_VERSION" -ge "$LD_NO_DL_MIN_VERSION" ] ; then
+	nodl="--no-dynamic-linker"
+fi
 
 platformo=$object/"$platform".o
 lds=$object/zImage.lds
@@ -412,7 +434,7 @@ if [ "$platform" != "miboot" ]; then
     if [ -n "$link_address" ] ; then
         text_start="-Ttext $link_address"
     fi
-    ${CROSS}ld -m $format -T $lds $text_start $pie -o "$ofile" \
+    ${CROSS}ld -m $format -T $lds $text_start $pie $nodl -o "$ofile" \
 	$platformo $tmp $object/wrapper.a
     rm $tmp
 fi
-- 
2.17.1

