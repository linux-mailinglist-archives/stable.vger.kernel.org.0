Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80E3D2B4F1E
	for <lists+stable@lfdr.de>; Mon, 16 Nov 2020 19:22:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732176AbgKPSVa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Nov 2020 13:21:30 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:52476 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729555AbgKPSVa (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Nov 2020 13:21:30 -0500
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AGI1UuT186530;
        Mon, 16 Nov 2020 13:21:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=wsTuE6Zzrnrn5c2WufKfrNoKmg3P4Ge4J3WtTTDx828=;
 b=lA788sEMYgducpArP8W68NqRrDv+feJLItaf3ZAXUBbMDo43GrPlu5F9q0s8RgPykDtZ
 2ZqkKntnmTiJ3z1GB+JgpnlCjgbt8rSStCH/a/WFop6RRc2X80qkN47Urcs4ZFyJ7T27
 xWZ84GM+nq8LSOYnQu7pwiAbbxxrYQHI7k10kzKtN/ESF41DcK7mMT54XkzWyUyvScud
 qMoO+7k2WfOrs6wEbrkqhsyI4bnbLmJHe99NMSiyZV6NKLPTeRJpScvCy44Y570Anxvv
 v2GlOXoPW7CGNrh6XP6tTqA0F0+3K3DH0NL+bAEZ2QbZb6L0wFMaN7hrztzgOqT3rAgp 6Q== 
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com with ESMTP id 34uvav46t2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 Nov 2020 13:21:17 -0500
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0AGIIn9B001136;
        Mon, 16 Nov 2020 18:21:16 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma06ams.nl.ibm.com with ESMTP id 34t6gh2cn3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 Nov 2020 18:21:15 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0AGILDZY2228744
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 Nov 2020 18:21:13 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B1C7842049;
        Mon, 16 Nov 2020 18:21:13 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0E4C842041;
        Mon, 16 Nov 2020 18:21:11 +0000 (GMT)
Received: from sig-9-65-243-37.ibm.com (unknown [9.65.243.37])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 16 Nov 2020 18:21:10 +0000 (GMT)
Message-ID: <51b4f4f119a80827fcc539de68ec9fa3df16d94d.camel@linux.ibm.com>
Subject: Re: [RESEND][PATCH] ima: Set and clear FMODE_CAN_READ in
 ima_calc_file_hash()
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     Christoph Hellwig <hch@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Roberto Sassu <roberto.sassu@huawei.com>,
        "linux-integrity@vger.kernel.org" <linux-integrity@vger.kernel.org>,
        "linux-security-module@vger.kernel.org" 
        <linux-security-module@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Silviu Vlasceanu <Silviu.Vlasceanu@huawei.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Date:   Mon, 16 Nov 2020 13:21:10 -0500
In-Reply-To: <20201116174127.GA4578@infradead.org>
References: <20201113080132.16591-1-roberto.sassu@huawei.com>
         <20201114111057.GA16415@infradead.org>
         <0fd0fb3360194d909ba48f13220f9302@huawei.com>
         <20201116162202.GA15010@infradead.org>
         <c556508437ffc10d3873fe25cbbba3484ca574df.camel@linux.ibm.com>
         <CAHk-=wiso=-Fhe2m042CfBNUGhoVB1Pry14DF64uUgztHVOW0g@mail.gmail.com>
         <20201116174127.GA4578@infradead.org>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.28.5 (3.28.5-12.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-16_09:2020-11-13,2020-11-16 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=3
 priorityscore=1501 mlxscore=0 phishscore=0 mlxlogscore=999 bulkscore=0
 malwarescore=0 impostorscore=0 adultscore=0 clxscore=1015 spamscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011160102
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 2020-11-16 at 17:41 +0000, Christoph Hellwig wrote:
> On Mon, Nov 16, 2020 at 09:37:32AM -0800, Linus Torvalds wrote:
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
> The "issue" with IMA is that it uses security hooks to hook into the
> VFS and then wants to read every file that gets opened on a real file
> system to "measure" the contents vs a hash stashed away somewhere.
> Which has always been rather sketchy.

There are security hooks, where IMA is co-located, but there are also
IMA hooks where there isn't an IMA hook (e.g. ima_file_check).  In all
cases, the file needs to be read in order to calculate the file hash,
which is then used for verifying file signatures (equivalent of secure
boot) and extending the TPM (equivalent of trusted boot).  Only after
measuring and verifying the file integrity, should access be granted to
the file.

Whether filesystems can and should be trusted to provide the real file
hashes is a separate issue.

The decision as to which files should be measured or the signature
verified is based on policy.

thanks,

Mimi

