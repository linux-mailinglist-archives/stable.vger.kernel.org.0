Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DBC81F16B0
	for <lists+stable@lfdr.de>; Mon,  8 Jun 2020 12:28:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729396AbgFHK20 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 06:28:26 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:57882 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729393AbgFHK2Z (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Jun 2020 06:28:25 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 058ABstu178122;
        Mon, 8 Jun 2020 06:28:10 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 31g59r9m0u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 08 Jun 2020 06:28:10 -0400
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 058AMoMC010283;
        Mon, 8 Jun 2020 06:28:09 -0400
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0b-001b2d01.pphosted.com with ESMTP id 31g59r9kyv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 08 Jun 2020 06:28:09 -0400
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 058AQ566011235;
        Mon, 8 Jun 2020 10:28:07 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma05fra.de.ibm.com with ESMTP id 31g2s7sgxw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 08 Jun 2020 10:28:07 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 058AS5bq6685010
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 8 Jun 2020 10:28:05 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F0AF7AE056;
        Mon,  8 Jun 2020 10:28:04 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 242A6AE053;
        Mon,  8 Jun 2020 10:28:04 +0000 (GMT)
Received: from oc3871087118.ibm.com (unknown [9.145.56.93])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Mon,  8 Jun 2020 10:28:04 +0000 (GMT)
Date:   Mon, 8 Jun 2020 12:28:02 +0200
From:   Alexander Gordeev <agordeev@linux.ibm.com>
To:     Andy Shevchenko <andy.shevchenko@gmail.com>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-s390@vger.kernel.org, Stable <stable@vger.kernel.org>,
        Yury Norov <yury.norov@gmail.com>,
        Amritha Nambiar <amritha.nambiar@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Kees Cook <keescook@chromium.org>,
        Matthew Wilcox <willy@infradead.org>,
        Miklos Szeredi <mszeredi@redhat.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        "Tobin C . Harding" <tobin@kernel.org>,
        Vineet Gupta <vineet.gupta1@synopsys.com>,
        Will Deacon <will.deacon@arm.com>,
        Willem de Bruijn <willemb@google.com>
Subject: Re: [PATCH RESEND] lib: fix bitmap_parse() on 64-bit big endian archs
Message-ID: <20200608102801.GA22989@oc3871087118.ibm.com>
References: <1589798090-11136-1-git-send-email-agordeev@linux.ibm.com>
 <CAHp75VdM2yrpd2d3pK2RkmbhF3yiM4=fiTXL4i3yu3AxV3wY-A@mail.gmail.com>
 <20200518115059.GA19150@oc3871087118.ibm.com>
 <20200602102430.GA17703@oc3871087118.ibm.com>
 <20200605132558.GM2428291@smile.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200605132558.GM2428291@smile.fi.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-08_07:2020-06-08,2020-06-08 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0 mlxscore=0
 impostorscore=0 clxscore=1015 adultscore=0 spamscore=0 phishscore=0
 malwarescore=0 mlxlogscore=999 cotscore=-2147483648 bulkscore=0
 suspectscore=0 priorityscore=1501 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2006080073
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jun 05, 2020 at 04:25:58PM +0300, Andy Shevchenko wrote:
> Test case, please.

Hi Andy,

Below is the output of the runtime kernel test "test_bitmap".
I resent the patch with Andrew Morton on CC, but did not include
the excessive test output:

test_bitmap: parse: 4: input is 1, result is 0x100000000, expected 0x1
test_bitmap: parse: 5: input is deadbeef, result is 0xdeadbeef00000000, expected 0xdeadbeef
test_bitmap: parse: 6: input is 1,0, result is 0x1, expected 0x100000000
test_bitmap: parse: 7: input is deadbeef,,0,1, result is 0x1, expected 0xdeadbeef
test_bitmap: parse: 8: input is deadbeef,1,0, result is 0x1, expected 0x100000000
test_bitmap: parse: 9: input is baadf00d,deadbeef,1,0, result is 0x1, expected 0x100000000
test_bitmap: parse: 10: input is badf00d,deadbeef,1,0, errno is -75, expected 0
test_bitmap: parse: 11: input is badf00d,deadbeef,1,0, errno is -75, expected 0
test_bitmap: parse: 12: input is   badf00d,deadbeef,1,0  , errno is -75, expected 0
test_bitmap: parse: 13: input is  , badf00d,deadbeef,1,0 , , errno is -75, expected 0
test_bitmap: parse: 14: input is  , badf00d, ,, ,,deadbeef,1,0 , , errno is -75, expected 0
test_bitmap: parse: 16: input is 3,0, errno is 0, expected -75
test_bitmap: parse_user: 4: input is 1, result is 0x100000000, expected 0x1
test_bitmap: parse_user: 5: input is deadbeef, result is 0xdeadbeef00000000, expected 0xdeadbeef
test_bitmap: parse_user: 6: input is 1,0, result is 0x1, expected 0x100000000
test_bitmap: parse_user: 7: input is deadbeef,,0,1, result is 0x1, expected 0xdeadbeef
test_bitmap: parse_user: 8: input is deadbeef,1,0, result is 0x1, expected 0x100000000
test_bitmap: parse_user: 9: input is baadf00d,deadbeef,1,0, result is 0x1, expected 0x100000000
test_bitmap: parse_user: 10: input is badf00d,deadbeef,1,0, errno is -75, expected 0
test_bitmap: parse_user: 11: input is badf00d,deadbeef,1,0, errno is -75, expected 0
test_bitmap: parse_user: 12: input is   badf00d,deadbeef,1,0  , errno is -75, expected 0
test_bitmap: parse_user: 13: input is  , badf00d,deadbeef,1,0 , , errno is -75, expected 0
test_bitmap: parse_user: 14: input is  , badf00d, ,, ,,deadbeef,1,0 , , errno is -75, expected 0
test_bitmap: parse_user: 16: input is 3,0, errno is 0, expected -75

Thanks!


> Yes, you can simulate BE test case on LE platform and vise versa.
> 
> -- 
> With Best Regards,
> Andy Shevchenko
> 
> 
