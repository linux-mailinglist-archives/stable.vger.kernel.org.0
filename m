Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90F242B83D2
	for <lists+stable@lfdr.de>; Wed, 18 Nov 2020 19:30:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726199AbgKRS25 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Nov 2020 13:28:57 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:51782 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726098AbgKRS24 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 Nov 2020 13:28:56 -0500
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AIIBuv6156954;
        Wed, 18 Nov 2020 13:28:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=ieECabNj9Nkw3pmQnqfIS+TIFqQu2Vl+ABLyf3b+yg0=;
 b=Y95ECNekhOzFlD4tVBHfD7RVhY8mOtNKNzBR8NB12FCka/t0iZlrp6r34VAUno1rgXA2
 u5mGRVIbG1Wez0nMsOAPUabDhdM5GsCXjv41U/xrwlN49fERl01IvHePBny0bFt3Z2xz
 ch/uVoMTcLCqp5lZ7V38AucuEeF0k/GnKINwPlEJFRTgGJFn7o/fuFTYCgTCqZe9kDJS
 +L5Z0g7S+3cMlfJR9SA+lgw6d0dMuxkvJU8hbv8iriuyG8thM9E3CPrMeBzUaOAhOKl+
 pLkDlurPK3NwRZZvKMTAljlGjNNR5VaK9L59wNlVjqz57zLid5Rfjvi2iuaCjEt4qXDg eg== 
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0b-001b2d01.pphosted.com with ESMTP id 34w8p8ggj3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 Nov 2020 13:28:45 -0500
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0AIISigt003533;
        Wed, 18 Nov 2020 18:28:44 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma06fra.de.ibm.com with ESMTP id 34t6gha9b8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 Nov 2020 18:28:44 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0AIISfaQ63832452
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Nov 2020 18:28:41 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8B71F4C04A;
        Wed, 18 Nov 2020 18:28:41 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 34BAC4C040;
        Wed, 18 Nov 2020 18:28:39 +0000 (GMT)
Received: from li-f45666cc-3089-11b2-a85c-c57d1a57929f.ibm.com (unknown [9.160.77.84])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 18 Nov 2020 18:28:38 +0000 (GMT)
Message-ID: <939ee428816825b5b28641d6e09b5e75b4172917.camel@linux.ibm.com>
Subject: Re: [RESEND][PATCH] ima: Set and clear FMODE_CAN_READ in
 ima_calc_file_hash()
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Roberto Sassu <roberto.sassu@huawei.com>,
        "linux-integrity@vger.kernel.org" <linux-integrity@vger.kernel.org>,
        "linux-security-module@vger.kernel.org" 
        <linux-security-module@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Silviu Vlasceanu <Silviu.Vlasceanu@huawei.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Date:   Wed, 18 Nov 2020 13:28:38 -0500
In-Reply-To: <CAHk-=wjinHpYRk_F1qiaXbXcMtn-ZHKkPkBvZpDJHjoN_2o4ag@mail.gmail.com>
References: <20201113080132.16591-1-roberto.sassu@huawei.com>
         <20201114111057.GA16415@infradead.org>
         <0fd0fb3360194d909ba48f13220f9302@huawei.com>
         <20201116162202.GA15010@infradead.org>
         <c556508437ffc10d3873fe25cbbba3484ca574df.camel@linux.ibm.com>
         <CAHk-=wiso=-Fhe2m042CfBNUGhoVB1Pry14DF64uUgztHVOW0g@mail.gmail.com>
         <20201116174127.GA4578@infradead.org>
         <CAHk-=wjd0RNthZQTLVsnK_d9SFYH0rug2tkezLLB0J-YZzVC+Q@mail.gmail.com>
         <3f8cc7c9462353ac2eef58e39beee079bdd9c7b4.camel@linux.ibm.com>
         <CAHk-=wih-ibNUxeiKpuKrw3Rd2=QEAZ8zgRWt_CORAjbZykRWQ@mail.gmail.com>
         <5d8fa26d376999f703aac9103166a572fc0df437.camel@linux.ibm.com>
         <CAHk-=wiPfWZYsAqhQry=mhAbKei8bHZDyVPJS0XHZz_FH9Jymw@mail.gmail.com>
         <CAHk-=wjinHpYRk_F1qiaXbXcMtn-ZHKkPkBvZpDJHjoN_2o4ag@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.28.5 (3.28.5-12.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-18_06:2020-11-17,2020-11-18 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 suspectscore=0
 phishscore=0 mlxscore=0 adultscore=0 impostorscore=0 mlxlogscore=951
 malwarescore=0 spamscore=0 lowpriorityscore=0 clxscore=1015
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011180122
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 2020-11-17 at 15:36 -0800, Linus Torvalds wrote:
> Another alternative is to change the policy and say "any write-only
> open gets turned into a read-write open".
> 
> But it needs to be done at *OPEN* time, not randomly afterwards by
> just lying to the 'struct file'.

The ima_file_check hook is at open, but it is immediately after
vfs_open().   Only after the file is opened can we determine if the
file is in policy.  If the file was originally opened without read
permission, a new file instance (dentry_open) with read permission is
opened.  Would limiting opening a new file instance with read
permission to just the ima_file_check hook be acceptable?

thanks,

Mimi

