Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62B3433B4EE
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 14:52:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229713AbhCONv6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 09:51:58 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:2334 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229526AbhCONvp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Mar 2021 09:51:45 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12FDY8eY110249;
        Mon, 15 Mar 2021 09:51:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=eOGjjfwBRqIXEaoAxvH/exvBFolj5BMfaXKZ0b6//co=;
 b=JRVlcYaZTgOnUePfZF2Li6wE+/qlkCB+Vt9W4UipJVvSBIzcxEn0ks4lb4w/JiHZ0cM4
 xFwlBDuGIo3Rw8CIMKOgCXAoH0OLdnor1rea5A9K/MlBS7uuCzNERJC22usIWfmQ9ghk
 JXYLICuoDzDo1Qio0U1OOpWtezMWI5PDEcmWBxec3uL1Sbn7kgA3ieDDrd/UntYNyVJq
 RX36AJC4+AzHjrwBpVO6aYuq++5avPPd1PN6jr5xLbDUisNJHGs2cBHy3JoeaL4ZJX63
 Fwtt7qBgLGww261dClQ5y82A8aj7jHsy6dDB5yhiLPmfYGQbevv70ezCpiC+4CHZolaG 9A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 379yhqqe7u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 15 Mar 2021 09:51:42 -0400
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 12FDcMlE132376;
        Mon, 15 Mar 2021 09:51:42 -0400
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 379yhqqe6s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 15 Mar 2021 09:51:42 -0400
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 12FDn5KE027569;
        Mon, 15 Mar 2021 13:51:39 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma03fra.de.ibm.com with ESMTP id 378n1890k9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 15 Mar 2021 13:51:39 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 12FDpLN837683526
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 15 Mar 2021 13:51:21 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 58C4442049;
        Mon, 15 Mar 2021 13:51:37 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 06DF742041;
        Mon, 15 Mar 2021 13:51:37 +0000 (GMT)
Received: from [9.145.154.43] (unknown [9.145.154.43])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 15 Mar 2021 13:51:36 +0000 (GMT)
Subject: Re: [PATCH v2 1/2] gcov: fix clang-11+ support
To:     Nick Desaulniers <ndesaulniers@google.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     Nathan Chancellor <nathan@kernel.org>,
        linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com,
        Fangrui Song <maskray@google.com>,
        Prasad Sodagudi <psodagud@quicinc.com>, stable@vger.kernel.org
References: <20210312220518.rz6cjh33bkwaumzz@archlinux-ax161>
 <20210312224132.3413602-1-ndesaulniers@google.com>
 <20210312224132.3413602-2-ndesaulniers@google.com>
From:   Peter Oberparleiter <oberpar@linux.ibm.com>
Message-ID: <67b313b0-3254-b394-7aa3-69113fe32838@linux.ibm.com>
Date:   Mon, 15 Mar 2021 14:51:36 +0100
MIME-Version: 1.0
In-Reply-To: <20210312224132.3413602-2-ndesaulniers@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-15_05:2021-03-15,2021-03-15 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0
 priorityscore=1501 malwarescore=0 mlxlogscore=999 spamscore=0
 lowpriorityscore=0 mlxscore=0 suspectscore=0 clxscore=1011 phishscore=0
 bulkscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2103150096
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12.03.2021 23:41, Nick Desaulniers wrote:
> LLVM changed the expected function signatures for llvm_gcda_start_file()
> and llvm_gcda_emit_function() in the clang-11 release. Users of clang-11
> or newer may have noticed their kernels failing to boot due to a panic
> when enabling CONFIG_GCOV_KERNEL=y +CONFIG_GCOV_PROFILE_ALL=y.  Fix up
> the function signatures so calling these functions doesn't panic the
> kernel.
> 
> Link: https://reviews.llvm.org/rGcdd683b516d147925212724b09ec6fb792a40041
> Link: https://reviews.llvm.org/rG13a633b438b6500ecad9e4f936ebadf3411d0f44
> Cc: stable@vger.kernel.org # 5.4
> Reported-by: Prasad Sodagudi <psodagud@quicinc.com>
> Suggested-by: Nathan Chancellor <nathan@kernel.org>
> Reviewed-by: Fangrui Song <maskray@google.com>
> Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
> Tested-by: Nathan Chancellor <nathan@kernel.org>

Looks good to me (minus the code duplication - but that's IMO acceptable
since it's cleaned up again with patch 2).

Acked-by: Peter Oberparleiter <oberpar@linux.ibm.com>

That said, I'm currently thinking of adding a compile time check that
performs a dry-run gcov_info => gcda conversion in user space to detect
these kind of issues before kernels fail unpredictably [1]. I'm
confident that this could work for the GCC gcov kernel code, not sure
about the Clang version though. But if it's possible I guess it would
make sense to extend this to include the Clang code as well.

Note that this check wouldn't work for cross-compiles since the build
machine must be able to run code for the target machine.

[1]
https://lore.kernel.org/lkml/1c7a49e7-0e27-561b-a2f9-d42a83dc4c29@linux.ibm.com/


Regards,
  Peter

-- 
Peter Oberparleiter
Linux on Z Development - IBM Germany
