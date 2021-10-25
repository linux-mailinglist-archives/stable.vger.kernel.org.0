Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D8124391A7
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 10:43:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232241AbhJYIqQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 04:46:16 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:24498 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232206AbhJYIqP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Oct 2021 04:46:15 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19P8RCG6031384;
        Mon, 25 Oct 2021 04:43:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=xg0X2PvvzwrUG0Hg3HVhvAoSDiqb6LKTok5pTT6sFQw=;
 b=Rs141UzFQqvSw8Y7q4joCSksnSfTZ9r9PD9kvxaQw9xczcpU/eO3xZvpis6C66O7IjoI
 5Ceb+uR4KJBAEMMDpXXFrahE5UX5YzJMoeqMrMXWJe76CDq4d7t5kTf1JfzXXvUCN1/S
 98KUKuFkSGT8SaqxwYxPXVBl6ZxIzjsZDdoMFKgzSpr7cLu/Ma90I0oSnvMKLCbeUrtk
 GZ/0Mbyrth1FgDT+DiinpjwVvd8OSDIgewZPnGRsjC1om+Z4jte2rPekiuAG5G/ubncu
 mRsV7SoiN2Ac2JC0+JzfZzZnV0QG8kSWELRDy6qlZcLE6PE0yUcnid29S+t9pRIWySBJ 1g== 
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bvyfbmqss-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 25 Oct 2021 04:43:52 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19P8gjsH026626;
        Mon, 25 Oct 2021 08:43:50 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma03ams.nl.ibm.com with ESMTP id 3bva19kksx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 25 Oct 2021 08:43:50 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19P8hlmn49807740
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 25 Oct 2021 08:43:48 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A41C5A406D;
        Mon, 25 Oct 2021 08:43:47 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 60F93A405B;
        Mon, 25 Oct 2021 08:43:47 +0000 (GMT)
Received: from sig-9-145-154-249.de.ibm.com (unknown [9.145.154.249])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 25 Oct 2021 08:43:47 +0000 (GMT)
Message-ID: <1bb91a1b400c10c0b54f445cc6af8525576946b9.camel@linux.ibm.com>
Subject: Re: [PATCH 5.14 1/2] s390/pci: cleanup resources only if necessary
From:   Niklas Schnelle <schnelle@linux.ibm.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org
Date:   Mon, 25 Oct 2021 10:43:46 +0200
In-Reply-To: <YXZhPl880f8an3UR@kroah.com>
References: <20211021141341.344756-1-schnelle@linux.ibm.com>
         <20211021141341.344756-2-schnelle@linux.ibm.com>
         <YXVLsMbqZ389YHX8@kroah.com> <YXZhPl880f8an3UR@kroah.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-16.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: _5Bb8cUyrrLWQjx8edoPIiLWi87imagP
X-Proofpoint-GUID: _5Bb8cUyrrLWQjx8edoPIiLWi87imagP
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-25_02,2021-10-25_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 mlxlogscore=796 bulkscore=0 spamscore=0 clxscore=1015 adultscore=0
 lowpriorityscore=0 impostorscore=0 priorityscore=1501 mlxscore=0
 suspectscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2109230001 definitions=main-2110250050
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 2021-10-25 at 09:48 +0200, Greg KH wrote:
> On Sun, Oct 24, 2021 at 02:04:00PM +0200, Greg KH wrote:
> > On Thu, Oct 21, 2021 at 04:13:40PM +0200, Niklas Schnelle wrote:
> > > commit 023cc3cb1e4baa8d1900a4f2e999701c82ce2b6c upstream.
> > 
> > This is not a commit in Linus's tree :(
> > 
> 
> It is 02368b7cf6c7 ("s390/pci: cleanup resources only if necessary"),
> don't know where the sha1 you have here is from :(

Oh sorry yes, this the correct commit. Mixed up and got the hash from a
local branch, even managed to match the first 3 digits. I resent with
the correct hash.

