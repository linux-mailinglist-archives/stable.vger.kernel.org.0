Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B5C8CEB70
	for <lists+stable@lfdr.de>; Mon,  7 Oct 2019 20:08:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728289AbfJGSI1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Oct 2019 14:08:27 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:56844 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728079AbfJGSI0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Oct 2019 14:08:26 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x97I2hgn144024
        for <stable@vger.kernel.org>; Mon, 7 Oct 2019 14:08:26 -0400
Received: from e06smtp01.uk.ibm.com (e06smtp01.uk.ibm.com [195.75.94.97])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2vg9gr9x3q-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <stable@vger.kernel.org>; Mon, 07 Oct 2019 14:08:25 -0400
Received: from localhost
        by e06smtp01.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <stable@vger.kernel.org> from <zohar@linux.ibm.com>;
        Mon, 7 Oct 2019 19:08:23 +0100
Received: from b06cxnps3075.portsmouth.uk.ibm.com (9.149.109.195)
        by e06smtp01.uk.ibm.com (192.168.101.131) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 7 Oct 2019 19:08:19 +0100
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x97I8Idm54394928
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 7 Oct 2019 18:08:18 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 14DF711C05C;
        Mon,  7 Oct 2019 18:08:18 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C533A11C04C;
        Mon,  7 Oct 2019 18:08:16 +0000 (GMT)
Received: from dhcp-9-31-103-196.watson.ibm.com (unknown [9.31.103.196])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  7 Oct 2019 18:08:16 +0000 (GMT)
Subject: Re: [PATCH] KEYS: asym_tpm: Switch to get_random_bytes()
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     James Bottomley <James.Bottomley@HansenPartnership.com>,
        Jerry Snitselaar <jsnitsel@redhat.com>,
        David Safford <david.safford@ge.com>,
        linux-integrity@vger.kernel.org, stable@vger.kernel.org,
        David Howells <dhowells@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        "open list:ASYMMETRIC KEYS" <keyrings@vger.kernel.org>,
        "open list:CRYPTO API" <linux-crypto@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Date:   Mon, 07 Oct 2019 14:08:15 -0400
In-Reply-To: <20191006235238.GA16641@linux.intel.com>
References: <1570140491.5046.33.camel@linux.ibm.com>
         <1570147177.10818.11.camel@HansenPartnership.com>
         <20191004182216.GB6945@linux.intel.com>
         <1570213491.3563.27.camel@HansenPartnership.com>
         <20191004183342.y63qdvspojyf3m55@cantor>
         <1570214574.3563.32.camel@HansenPartnership.com>
         <20191004200728.xoj6jlgbhv57gepc@cantor>
         <20191004201134.nuesk6hxtxajnxh2@cantor>
         <1570227068.17537.4.camel@HansenPartnership.com>
         <1570322333.5046.145.camel@linux.ibm.com>
         <20191006235238.GA16641@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.20.5 (3.20.5-1.fc24) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19100718-4275-0000-0000-0000036EEB6D
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19100718-4276-0000-0000-00003881FA7D
Message-Id: <1570471695.5046.186.camel@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-10-07_03:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=647 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1908290000 definitions=main-1910070161
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 2019-10-07 at 02:52 +0300, Jarkko Sakkinen wrote:
> 
> With TEE coming in, TPM is not the only hardware measure anymore sealing
> the keys and we don't want a mess where every hardware asset does their
> own proprietary key generation. The proprietary technology should only
> take care of the sealing part.

I'm fine with the concept of "trusted" keys being extended beyond just
TPM.  But just as the VFS layer defines a set of callbacks and generic
functions, which can be used in lieu of file system specific callback
functions, a similar approach could be used here.

Mimi

