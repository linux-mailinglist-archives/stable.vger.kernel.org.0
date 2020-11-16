Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 604612B501E
	for <lists+stable@lfdr.de>; Mon, 16 Nov 2020 19:49:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728290AbgKPStM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Nov 2020 13:49:12 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:23494 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726204AbgKPStM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Nov 2020 13:49:12 -0500
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AGIXWA2001681;
        Mon, 16 Nov 2020 13:49:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=08+LUJn+1NqpvGMznVW9wbSkVMuYy1K575hvfKSkChg=;
 b=VpsyuqgWW8gD/mVv9JaSiWSU7W4w+gN8tbS9YzMM2e7GzC/JWmdQah6uVvGcjCeezlF0
 /FIZEaTxTgc9HlbtlDtETzx1JpXxAJr2KYZWm06EEg6KwnTyCwJGTZ926zjrajAp7r1n
 In2IvOtscJ1WcWSM6RthmSwEKEjMRL81B5/EBkp9S9jk2LIqlmdiPl1w8MwCD2mXuyp0
 IMbCBP3K8YzGxOojUAiPWWehT4mjWci5Gg3EvKqhSgECnUWWCgoRPEmVUWab6q1FYgNN
 otgZZXyopj496oSpXZ5GUC766w5YcgtW+BsRQ9jsWMJckfMIwzhSq9L6ftGxkkITjsFy IQ== 
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34ux64hag2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 Nov 2020 13:49:10 -0500
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0AGIgoLD019199;
        Mon, 16 Nov 2020 18:49:09 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma03ams.nl.ibm.com with ESMTP id 34t6v8acc2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 Nov 2020 18:49:09 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0AGIn7rE2556434
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 Nov 2020 18:49:07 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E7D035204F;
        Mon, 16 Nov 2020 18:49:06 +0000 (GMT)
Received: from sig-9-65-243-37.ibm.com (unknown [9.65.243.37])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 85CBD5204E;
        Mon, 16 Nov 2020 18:49:04 +0000 (GMT)
Message-ID: <7fa1b79e42832bd033fdf18cde8293078637262f.camel@linux.ibm.com>
Subject: Re: [RESEND][PATCH] ima: Set and clear FMODE_CAN_READ in
 ima_calc_file_hash()
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     Al Viro <viro@zeniv.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Roberto Sassu <roberto.sassu@huawei.com>,
        "linux-integrity@vger.kernel.org" <linux-integrity@vger.kernel.org>,
        "linux-security-module@vger.kernel.org" 
        <linux-security-module@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Silviu Vlasceanu <Silviu.Vlasceanu@huawei.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Date:   Mon, 16 Nov 2020 13:49:03 -0500
In-Reply-To: <20201116180855.GX3576660@ZenIV.linux.org.uk>
References: <20201113080132.16591-1-roberto.sassu@huawei.com>
         <20201114111057.GA16415@infradead.org>
         <0fd0fb3360194d909ba48f13220f9302@huawei.com>
         <20201116162202.GA15010@infradead.org>
         <c556508437ffc10d3873fe25cbbba3484ca574df.camel@linux.ibm.com>
         <CAHk-=wiso=-Fhe2m042CfBNUGhoVB1Pry14DF64uUgztHVOW0g@mail.gmail.com>
         <20201116180855.GX3576660@ZenIV.linux.org.uk>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.28.5 (3.28.5-12.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-16_09:2020-11-13,2020-11-16 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 suspectscore=3 mlxscore=0 priorityscore=1501 phishscore=0 spamscore=0
 malwarescore=0 mlxlogscore=999 impostorscore=0 clxscore=1015 bulkscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011160109
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 2020-11-16 at 18:08 +0000, Al Viro wrote:
> On Mon, Nov 16, 2020 at 09:37:32AM -0800, Linus Torvalds wrote:
> > On Mon, Nov 16, 2020 at 8:47 AM Mimi Zohar <zohar@linux.ibm.com> wrote:
> > >
> > > This discussion seems to be going down the path of requiring an IMA
> > > filesystem hook for reading the file, again.  That solution was
> > > rejected, not by me.  What is new this time?
> > 
> > You can't read a non-read-opened file. Not even IMA can.
> > 
> > So don't do that then.
> > 
> > IMA is doing something wrong. Why would you ever read a file that can't be read?
> >
> > Fix whatever "open" function instead of trying to work around the fact
> > that you opened it wrong.
> 
> IMA pulls that crap on _every_ open(2), including O_WRONLY.  As far as I'm
> concerned, the only sane answer is not enabling that thing on your builds;
> they are deeply special and I hadn't been able to reason with them no
> matter how much I tried ;-/

The builtin IMA policies are only meant to be used until a custom can
be loaded.  The decision as to what should be measured or verified is
left up to the system owner.

In terms of the architecture specific policy rules, there are rules to:
- measure the kexec kernel image and kernel modules
- verify the kexec kernel image and kernel modules appended signatures

These rules should be pretty straight forward to verify.

Mimi

