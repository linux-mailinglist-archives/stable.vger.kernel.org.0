Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F0D226CC82
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 22:45:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727782AbgIPUpV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Sep 2020 16:45:21 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:56038 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726730AbgIPRDZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Sep 2020 13:03:25 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08GG2RVq051537;
        Wed, 16 Sep 2020 12:15:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=cPFcV4rzKB/0Ttq4UdnaRFgFQtnB3Rt6bFZmoLbN3TA=;
 b=fbB6UXDp4J6Nh7LIFvNSPUqmT1WQkclkByz0A/4/8RPFctgDRTVIHJP/lptuWf6Q1YS6
 eRcWZtzthv/BudMssP5pO2gK8YJxsrur/IcF7FtFz8HjxLojViWlOdVvrYsSKyjodaG/
 prahTgontzzogWT3mKPaMwlGXMOZZHCrNFdU/ivLBrdMu9wC4fN3be3333rFhYieUU6l
 QdtFViyeYY4yGF5ss5lGdyDI3Rt5rOMPelfzwuKSW/iEMPYNNMsuvqZfEF3KdinkBkL6
 0YkLbk/xQGVbPuM6I6WiwW5bmRnXhWlgnJQpVcV/Oc/E34kSYReeLsqTYWyGXqpLfcCx uw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33knk1h39v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 16 Sep 2020 12:15:27 -0400
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 08GG3Fpd057597;
        Wed, 16 Sep 2020 12:15:26 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33knk1h38g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 16 Sep 2020 12:15:26 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 08GGEbEP025728;
        Wed, 16 Sep 2020 16:15:23 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma03ams.nl.ibm.com with ESMTP id 33k6esgth3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 16 Sep 2020 16:15:23 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 08GGFLW922479182
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 16 Sep 2020 16:15:21 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 061B04C05A;
        Wed, 16 Sep 2020 16:15:21 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4457B4C04E;
        Wed, 16 Sep 2020 16:15:19 +0000 (GMT)
Received: from li-f45666cc-3089-11b2-a85c-c57d1a57929f.ibm.com (unknown [9.160.98.9])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 16 Sep 2020 16:15:19 +0000 (GMT)
Message-ID: <3183edb20e3a84c29be6f3e3b459bf51c3355b6b.camel@linux.ibm.com>
Subject: Re: [PATCH v2 04/12] evm: Execute evm_inode_init_security() only
 when the HMAC key is loaded
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     Roberto Sassu <roberto.sassu@huawei.com>, mjg59@google.com
Cc:     linux-integrity@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org, silviu.vlasceanu@huawei.com,
        stable@vger.kernel.org
Date:   Wed, 16 Sep 2020 12:15:18 -0400
In-Reply-To: <20200904092339.19598-5-roberto.sassu@huawei.com>
References: <20200904092339.19598-1-roberto.sassu@huawei.com>
         <20200904092339.19598-5-roberto.sassu@huawei.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.28.5 (3.28.5-12.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-16_10:2020-09-16,2020-09-16 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 adultscore=0
 clxscore=1015 priorityscore=1501 lowpriorityscore=0 bulkscore=0
 spamscore=0 suspectscore=0 mlxscore=0 impostorscore=0 phishscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009160114
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Roberto,

On Fri, 2020-09-04 at 11:23 +0200, Roberto Sassu wrote:
> evm_inode_init_security() requires the HMAC key to calculate the HMAC on
> initial xattrs provided by LSMs. Unfortunately, with the evm_key_loaded()
> check, the function continues even if the HMAC key is not loaded
> (evm_key_loaded() returns true also if EVM has been initialized only with a
> public key). If the HMAC key is not loaded, evm_inode_init_security()
> returns an error later when it calls evm_init_hmac().

This is all true, but the context for why it wasn't an issue previously
is missing.

The original usecase for allowing signature verificaton prior to
loading the HMAC key was a fully signed, possibly immutable, initrd. 
No new files were created or, at least, were in policy until the HMAC
key was loaded.   More recently support for requiring an EVM HMAC key
was removed.  Files having a portable and immutable signature were
given additional privileges.

Please update the patch description with the context of what has
changed.

Mimi

