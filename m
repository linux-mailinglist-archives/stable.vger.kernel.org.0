Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FC49309C77
	for <lists+stable@lfdr.de>; Sun, 31 Jan 2021 15:03:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231202AbhAaNx3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 31 Jan 2021 08:53:29 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:5152 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231442AbhAaMq1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 31 Jan 2021 07:46:27 -0500
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10VCW19H054320;
        Sun, 31 Jan 2021 07:44:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=1dYKWKDrlQBSm/GbEdIYkPx8PgHv9TDrV5d6Dp4ph5g=;
 b=HgP3ztsvikEEVVHlzpt4wvZLUGzwp+pJJhRw+5cApKa2/aP/dVrMZDHG/CVMyrJMos4Q
 PmXvBOexDECNjCGYFKENkCK8sFCXG8DiZOjfdPtvjGOxMF/Pgao5i9pqIiDoItFno9vD
 wPNnrCPNxLqzPSSslcdoVkFxY+mHu+lQxqp9BqFhyV88wB36jlNJPqeLZU9jjTptJv1+
 xaSWiXhz7rX5fIvnd+XLl2a8jiG1jZ+kvXS8Ji5aj9Zgb9Yrm8u0Tu5WEbltgp36YrlY
 j+cYAcUq53Q6EiCEnbUSm/qfTzrn+oqSUCvGn5LoRktMQWdSc3l821WF11i8wADtO2NZ /A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36dtpt9txv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 31 Jan 2021 07:44:46 -0500
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 10VCXDjn057366;
        Sun, 31 Jan 2021 07:44:46 -0500
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36dtpt9txa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 31 Jan 2021 07:44:45 -0500
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10VCcAUl014522;
        Sun, 31 Jan 2021 12:44:43 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma03fra.de.ibm.com with ESMTP id 36cy388ghg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 31 Jan 2021 12:44:43 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10VCifSj9699768
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 31 Jan 2021 12:44:41 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 515CEAE04D;
        Sun, 31 Jan 2021 12:44:41 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 44291AE045;
        Sun, 31 Jan 2021 12:44:39 +0000 (GMT)
Received: from li-f45666cc-3089-11b2-a85c-c57d1a57929f.ibm.com (unknown [9.160.28.14])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Sun, 31 Jan 2021 12:44:39 +0000 (GMT)
Message-ID: <7c873938bf8a901a39c5e69f5f700b79597a2b5e.camel@linux.ibm.com>
Subject: Re: [PATCH v5 2/3] KEYS: trusted: Fix migratable=1 failing
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     jarkko@kernel.org, linux-integrity@vger.kernel.org
Cc:     stable@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        David Howells <dhowells@redhat.com>,
        James Morris <jmorris@namei.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        David Safford <safford@watson.ibm.com>
Date:   Sun, 31 Jan 2021 07:44:38 -0500
In-Reply-To: <20210128235621.127925-3-jarkko@kernel.org>
References: <20210128235621.127925-1-jarkko@kernel.org>
         <20210128235621.127925-3-jarkko@kernel.org>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.28.5 (3.28.5-14.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-01-31_04:2021-01-29,2021-01-31 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 bulkscore=0
 lowpriorityscore=0 adultscore=0 mlxlogscore=999 mlxscore=0 malwarescore=0
 priorityscore=1501 phishscore=0 impostorscore=0 spamscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101310065
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 2021-01-29 at 01:56 +0200, jarkko@kernel.org wrote:
> From: Jarkko Sakkinen <jarkko@kernel.org>
> 
> Consider the following transcript:
> 
> $ keyctl add trusted kmk "new 32 blobauth=helloworld keyhandle=80000000 migratable=1" @u
> add_key: Invalid argument
> 
> The documentation has the following description:
> 
>   migratable=   0|1 indicating permission to reseal to new PCR values,
>                 default 1 (resealing allowed)
> 
> The consequence is that "migratable=1" should succeed. Fix this by
> allowing this condition to pass instead of return -EINVAL.
> 
> [*] Documentation/security/keys/trusted-encrypted.rst
> 
> Cc: stable@vger.kernel.org
> Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
> Cc: Mimi Zohar <zohar@linux.ibm.com>
> Cc: David Howells <dhowells@redhat.com>
> Fixes: d00a1c72f7f4 ("keys: add new trusted key-type")
> Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>

thanks,

Reviewed-by: Mimi Zohar <zohar@linux.ibm.com>

