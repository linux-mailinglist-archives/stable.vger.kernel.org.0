Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1C7134CD59
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 11:52:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232155AbhC2JwI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 05:52:08 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:27704 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S232034AbhC2Jvy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Mar 2021 05:51:54 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12T9XAQX194653;
        Mon, 29 Mar 2021 05:51:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=nXxBRDUKwv4tg/UBkzFy6h2ENZzL491+fnndTiowvk4=;
 b=drq38PB5FRwtpw+LxpbQ7I4BjfqCIYqe708C+H4xYrof0a05p80fpy9vZxeFrnQBd7Hp
 Z9Hmpbdu/bje+Q60h0wn4FTXD+URyYPBp1YwgE5Xq3fCdkjxeVnOgY82qLR2S4CAqNFP
 yVAk1s3VKJcFeKbgU9+SlZsx74eZ0UAXRSgt2fjoGz0LdvCVF00QEi87+0H3zn1oxim5
 iUWFpSHPBwRWxZpi12tqfA+0bmU8Yx0X+DUpHY5VY0JVBbhIwsgYECMXAVYFi+Kdp13r
 TIvqjOvs47lH6KBS+N7ODDeYdN2N2nYt9NWkIBa3lo90WH9TX9REbOjT3W4X4jiwXyGf RA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 37juxb9d0d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 29 Mar 2021 05:51:14 -0400
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 12T9bflm017044;
        Mon, 29 Mar 2021 05:51:13 -0400
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0b-001b2d01.pphosted.com with ESMTP id 37juxb9cyq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 29 Mar 2021 05:51:13 -0400
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 12T9gTCf008972;
        Mon, 29 Mar 2021 09:51:11 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma05fra.de.ibm.com with ESMTP id 37hvb8gvef-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 29 Mar 2021 09:51:11 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 12T9p93F25231686
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 29 Mar 2021 09:51:09 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3C0A111C04A;
        Mon, 29 Mar 2021 09:51:09 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E16D711C058;
        Mon, 29 Mar 2021 09:51:03 +0000 (GMT)
Received: from pomme.local (unknown [9.211.151.38])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 29 Mar 2021 09:51:03 +0000 (GMT)
Subject: Re: [PATCH] powerpc/vdso: Separate vvar vma from vdso
To:     Dmitry Safonov <dima@arista.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        linux-kernel@vger.kernel.org
Cc:     Dmitry Safonov <0x7f454c46@gmail.com>,
        Andrei Vagin <avagin@gmail.com>,
        Andy Lutomirski <luto@kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Paul Mackerras <paulus@samba.org>,
        linuxppc-dev@lists.ozlabs.org, stable@vger.kernel.org
References: <20210326191720.138155-1-dima@arista.com>
 <52562f46-6767-ba04-7301-04c6209fe4f1@csgroup.eu>
 <1b1494a8-da80-e170-78fa-48dfb3226e75@arista.com>
From:   Laurent Dufour <ldufour@linux.ibm.com>
Message-ID: <ff24e583-aab7-6d73-8b19-4a0e47457482@linux.ibm.com>
Date:   Mon, 29 Mar 2021 11:51:02 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.0
In-Reply-To: <1b1494a8-da80-e170-78fa-48dfb3226e75@arista.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: FAlyGckbWKhcUViz8Ul3CgHiuiimSH8s
X-Proofpoint-ORIG-GUID: nVhytTAiyqNveN1mzjsuDnanoTdeSsmI
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-29_05:2021-03-26,2021-03-29 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 adultscore=0
 clxscore=1011 priorityscore=1501 bulkscore=0 mlxscore=0 mlxlogscore=999
 spamscore=0 malwarescore=0 lowpriorityscore=0 impostorscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2103250000 definitions=main-2103290071
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Christophe and Dimitry,

Le 27/03/2021 à 18:43, Dmitry Safonov a écrit :
> Hi Christophe,
> 
> On 3/27/21 5:19 PM, Christophe Leroy wrote:
> [..]
>>> I opportunistically Cc stable on it: I understand that usually such
>>> stuff isn't a stable material, but that will allow us in CRIU have
>>> one workaround less that is needed just for one release (v5.11) on
>>> one platform (ppc64), which we otherwise have to maintain.
>>
>> Why is that a workaround, and why for one release only ? I think the
>> solution proposed by Laurentto use the aux vector AT_SYSINFO_EHDR should
>> work with any past and future release.
> 
> Yeah, I guess.
> Previously, (before v5.11/power) all kernels had ELF start at "[vdso]"
> VMA start, now we'll have to carry the offset in the VMA. Probably, not
> the worst thing, but as it will be only for v5.11 release it can break,
> so needs separate testing.
> Kinda life was a bit easier without this additional code.
The assumption that ELF header is at the start of "[vdso]" is perhaps not a good 
one, but using a "[vvar]" section looks more conventional and allows to clearly 
identify the data part. I'd argue for this option.

> 
>>> I wouldn't go as far as to say that the commit 511157ab641e is ABI
>>> regression as no other userspace got broken, but I'd really appreciate
>>> if it gets backported to v5.11 after v5.12 is released, so as not
>>> to complicate already non-simple CRIU-vdso code. Thanks!
>>>
>>> Cc: Andrei Vagin <avagin@gmail.com>
>>> Cc: Andy Lutomirski <luto@kernel.org>
>>> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
>>> Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
>>> Cc: Laurent Dufour <ldufour@linux.ibm.com>
>>> Cc: Michael Ellerman <mpe@ellerman.id.au>
>>> Cc: Paul Mackerras <paulus@samba.org>
>>> Cc: linuxppc-dev@lists.ozlabs.org
>>> Cc: stable@vger.kernel.org # v5.11
>>> [1]: https://github.com/checkpoint-restore/criu/issues/1417
>>> Signed-off-by: Dmitry Safonov <dima@arista.com>
>>> Tested-by: Christophe Leroy <christophe.leroy@csgroup.eu>
>>
>> I tested it with sifreturn_vdso selftest and it worked, because that
>> selftest doesn't involve VDSO data.
> 
> Thanks again on helping with testing it, I appreciate it!
> 
>> But if I do a mremap() on the VDSO text vma without remapping VVAR to
>> keep the same distance between the two vmas, gettimeofday() crashes. The
>> reason is that the code obtains the address of the data by calculating a
>> fix difference from its own address with the below macro, the delta
>> being resolved at link time:
>>
>> .macro get_datapage ptr
>>      bcl    20, 31, .+4
>> 999:
>>      mflr    \ptr
>> #if CONFIG_PPC_PAGE_SHIFT > 14
>>      addis    \ptr, \ptr, (_vdso_datapage - 999b)@ha
>> #endif
>>      addi    \ptr, \ptr, (_vdso_datapage - 999b)@l
>> .endm
>>
>> So the datapage needs to remain at the same distance from the code at
>> all time.
>>
>> Wondering how the other architectures do to have two independent VMAs
>> and be able to move one independently of the other.
> 
> It's alright as far as I know. If userspace remaps vdso/vvar it should
> be aware of this (CRIU keeps this in mind, also old vdso image is dumped
> to compare on restore with the one that the host has).

I do agree, playing with the VDSO mapping needs the application to be aware of 
the mapping details, and prior to 83d3f0e90c6c "powerpc/mm: tracking vDSO 
remap", remapping the VDSO was not working on PowerPC and nobody complained...

Laurent.

