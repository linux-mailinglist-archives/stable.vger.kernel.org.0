Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C760D258393
	for <lists+stable@lfdr.de>; Mon, 31 Aug 2020 23:31:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728879AbgHaVbh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Aug 2020 17:31:37 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:54514 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726224AbgHaVbh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Aug 2020 17:31:37 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07VL2uYE110245;
        Mon, 31 Aug 2020 17:31:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=1Dbw3IMHWQxOhGrQ00lEjLfXQ44s1hsxiHPb7q4Nmjo=;
 b=EUkMf822AAlWQ//FDIhDFf6IzXlhbwcw1qzafRLv8MVYdgPY0LMMnRbM/aCNOnoPeVBm
 8hPoXrXjD6rOVvkRNOdnkE221KQv4xW3eWpMqKE3zUkyLFtS6oghgivUGPTsdiT1hyZg
 JXHksymgb0A5Ojkga6XknSP6msxgU6iUQnmM26942ZodWuJjfAEbzEJhAeqpeDHXSmVB
 rR/0PFzchy88xHP+iwBTEpZ/aoKdA9tEa5NyX3EtQATWfike6YVxYZ0aVKtb30k4/Rvv
 wNBXXt14zniNcqLNGAbm3hudpDOVaG5eLXrx5melgq3fHINq/6/r9CGdAZSX7KVwfh3M qQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33975wb1bk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 31 Aug 2020 17:31:33 -0400
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 07VLKk0O017994;
        Mon, 31 Aug 2020 17:31:33 -0400
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33975wb1a4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 31 Aug 2020 17:31:33 -0400
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 07VLGK3s013879;
        Mon, 31 Aug 2020 21:31:30 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma02fra.de.ibm.com with ESMTP id 337en7hkq6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 31 Aug 2020 21:31:30 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 07VLVSM414418202
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 31 Aug 2020 21:31:28 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 69D92A4067;
        Mon, 31 Aug 2020 21:31:28 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C1732A4062;
        Mon, 31 Aug 2020 21:31:26 +0000 (GMT)
Received: from li-f45666cc-3089-11b2-a85c-c57d1a57929f.ibm.com (unknown [9.160.2.129])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 31 Aug 2020 21:31:26 +0000 (GMT)
Message-ID: <b74a68cb22656e4646d61c651aeb5ebee234530c.camel@linux.ibm.com>
Subject: Re: [PATCH 03/11] evm: Refuse EVM_ALLOW_METADATA_WRITES only if the
 HMAC key is loaded
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     Roberto Sassu <roberto.sassu@huawei.com>,
        "mjg59@google.com" <mjg59@google.com>
Cc:     "linux-integrity@vger.kernel.org" <linux-integrity@vger.kernel.org>,
        "linux-security-module@vger.kernel.org" 
        <linux-security-module@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Silviu Vlasceanu <Silviu.Vlasceanu@huawei.com>
Date:   Mon, 31 Aug 2020 17:31:26 -0400
In-Reply-To: <0c1c8fb398c340d89531360be7e3418b@huawei.com>
References: <20200618160133.937-1-roberto.sassu@huawei.com>
         <20200618160133.937-3-roberto.sassu@huawei.com>
         <caedd49bc2080a2fb8b16b9ecacab67d11e68fd7.camel@linux.ibm.com>
         <0c1c8fb398c340d89531360be7e3418b@huawei.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.28.5 (3.28.5-12.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-31_10:2020-08-31,2020-08-31 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 suspectscore=0 phishscore=0 adultscore=0 spamscore=0 mlxscore=0
 clxscore=1015 priorityscore=1501 bulkscore=0 impostorscore=0
 malwarescore=0 mlxlogscore=999 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2006250000 definitions=main-2008310123
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 2020-08-31 at 08:24 +0000, Roberto Sassu wrote:
> > From: Mimi Zohar [mailto:zohar@linux.ibm.com]
> > Sent: Friday, August 21, 2020 10:15 PM
> > Hi Roberto,
> > 
> > On Thu, 2020-06-18 at 18:01 +0200, Roberto Sassu wrote:
> > > Granting metadata write is safe if the HMAC key is not loaded, as it won't
> > > let an attacker obtain a valid HMAC from corrupted xattrs.
> > evm_write_key()
> > > however does not allow it if any key is loaded, including a public key,
> > > which should not be a problem.
> > >
> > 
> > Why is the existing hebavior a problem?  What is the problem being
> > solved?
> 
> Hi Mimi
> 
> currently it is not possible to set EVM_ALLOW_METADATA_WRITES when
> only a public key is loaded and the HMAC key is not. The patch removes
> this limitation.

Yes, I understand.  You're describing "what" the problem is, not "why"
this is a problem.  Support for loading EVM HMAC and x509 certificates
isn't new.  Please add a line or two prior to this paragraph providing
the context for why this is now a problem.

Is the problem related to previoulsy not beginning EVM verification
until after the EVM HMAC key was loaded?  Or perhaps EVM signatures
were not that common since they weren't portable.   Now, with portable
and immutable signatures loading x509 certificates is more common.

thanks,

Mimi

