Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 903002B4B9E
	for <lists+stable@lfdr.de>; Mon, 16 Nov 2020 17:47:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730328AbgKPQrU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Nov 2020 11:47:20 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:60188 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731072AbgKPQrU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Nov 2020 11:47:20 -0500
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AGGYHtu064243;
        Mon, 16 Nov 2020 11:47:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=jqO+d259ulDvFX9AEnkvWujX/8WL9q6Z0z8HEpJp2a0=;
 b=gqVsnk72MirMEiBd4+tq6Ai0AXWrprdi8wN0UpZVrwChGv6t2yWv5A7Na8koUi6IpgbT
 8cv0KVCI3TvkVStfCyorqi3SBm/fC0FaHRvvAbZEuBklSC+Y7+eFkWzFrLL/b9RlI+Mi
 sePtdrNq6mYD6ff64TUCxZR3LAhRvXIfHRqgY58IwFgsdYHIJ4rbNUlGYwrbHUbk2fBk
 LMD2y+OMMVtgpu4hIYDMY6UENn2jld8IAj47UNs/560H+uFa+L6E5zNS65xxermQHijA
 WFMMkQI5u5DrGJoSDYgKaaCvRjpwvTUmWMfwJej1FkaD2HVKwcUqtkriy205RT/h6rcW Lg== 
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34uvuwgppb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 Nov 2020 11:46:59 -0500
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0AGGQpGJ003279;
        Mon, 16 Nov 2020 16:46:58 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma03ams.nl.ibm.com with ESMTP id 34t6v8a9xm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 Nov 2020 16:46:58 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0AGGktip57540890
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 Nov 2020 16:46:56 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DA0A4A4057;
        Mon, 16 Nov 2020 16:46:55 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C613CA4053;
        Mon, 16 Nov 2020 16:46:53 +0000 (GMT)
Received: from sig-9-65-237-154.ibm.com (unknown [9.65.237.154])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 16 Nov 2020 16:46:53 +0000 (GMT)
Message-ID: <c556508437ffc10d3873fe25cbbba3484ca574df.camel@linux.ibm.com>
Subject: Re: [RESEND][PATCH] ima: Set and clear FMODE_CAN_READ in
 ima_calc_file_hash()
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     Christoph Hellwig <hch@infradead.org>,
        Roberto Sassu <roberto.sassu@huawei.com>
Cc:     "linux-integrity@vger.kernel.org" <linux-integrity@vger.kernel.org>,
        "linux-security-module@vger.kernel.org" 
        <linux-security-module@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Silviu Vlasceanu <Silviu.Vlasceanu@huawei.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Date:   Mon, 16 Nov 2020 11:46:52 -0500
In-Reply-To: <20201116162202.GA15010@infradead.org>
References: <20201113080132.16591-1-roberto.sassu@huawei.com>
         <20201114111057.GA16415@infradead.org>
         <0fd0fb3360194d909ba48f13220f9302@huawei.com>
         <20201116162202.GA15010@infradead.org>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.28.5 (3.28.5-12.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-16_08:2020-11-13,2020-11-16 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 suspectscore=3 malwarescore=0 mlxlogscore=885
 priorityscore=1501 adultscore=0 mlxscore=0 phishscore=0 bulkscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011160099
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 2020-11-16 at 16:22 +0000, Christoph Hellwig wrote:
> On Mon, Nov 16, 2020 at 08:52:19AM +0000, Roberto Sassu wrote:
> > FMODE_CAN_READ was not set because f_mode does not have
> > FMODE_READ. In the patch, I check if the former can be set
> > similarly to the way it is done in file_table.c and open.c.
> > 
> > Is there a better way to read a file when the file was not opened
> > for reading and a new file descriptor cannot be created?
> 
> You can't open a file not open for reading.  The file system or device
> driver might have to prepare read-specific resources in ->open to
> support reads.  So what you'll have to do is to open a new instance
> of the file that is open for reading.

This discussion seems to be going down the path of requiring an IMA
filesystem hook for reading the file, again.  That solution was
rejected, not by me.  What is new this time?

Mimi

