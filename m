Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3FD024FD87
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 14:15:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725963AbgHXMPB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 08:15:01 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:13384 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725906AbgHXMPA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Aug 2020 08:15:00 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07OC235Z146980;
        Mon, 24 Aug 2020 08:14:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=ilaU6IUDf52Jth9wTolQYR+bi5i9FlQ3hnQWsivcPRE=;
 b=l6QVX2hLXEf/1hDtQuWvBcZ4rvLQ6h0urOXN8QpiEf9FxQwO51ZyP3xKQO3pFd6smLaE
 hebJABxG8PpAUYEaIWBXn+SCnWwDgeyNmf9AukG+FlYDgb22u5ZhERjoio+Zm+mddIKC
 KxDwG9oTPWYp6r8toFCAbSPatHMivlk9SUJvNhKuTqkLWTiturRlD7uIZbZ1Ggl3g0Jw
 WhvIaRIbh6I+/9UnXXwZ3DJBOVw84BygJ7ZqTZoQGmnBTmyjBx/2pv+RAFGPifdkI9MN
 sQ1GfcQEYi0hnXpMJZtCwSxIaYqDqarOQRMAsvQ2Ye1IvoZRFcdyVVja2K83ESPB32vT 3Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 334b09msjj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 24 Aug 2020 08:14:53 -0400
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 07OC26uI147048;
        Mon, 24 Aug 2020 08:14:53 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com with ESMTP id 334b09mshv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 24 Aug 2020 08:14:52 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 07OCEIY2004082;
        Mon, 24 Aug 2020 12:14:51 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma06ams.nl.ibm.com with ESMTP id 332uk6ab3n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 24 Aug 2020 12:14:51 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 07OCDJ7C61342054
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Aug 2020 12:13:19 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F0F0EA404D;
        Mon, 24 Aug 2020 12:14:48 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 52496A4040;
        Mon, 24 Aug 2020 12:14:47 +0000 (GMT)
Received: from sig-9-65-254-31.ibm.com (unknown [9.65.254.31])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 24 Aug 2020 12:14:47 +0000 (GMT)
Message-ID: <1a30cf978efa004efb5583c2c1aef0121eaa6caa.camel@linux.ibm.com>
Subject: Re: [PATCH 04/11] evm: Check size of security.evm before using it
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     Roberto Sassu <roberto.sassu@huawei.com>, mjg59@google.com
Cc:     linux-integrity@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Date:   Mon, 24 Aug 2020 08:14:46 -0400
In-Reply-To: <20200618160133.937-4-roberto.sassu@huawei.com>
References: <20200618160133.937-1-roberto.sassu@huawei.com>
         <20200618160133.937-4-roberto.sassu@huawei.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.28.5 (3.28.5-12.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-24_08:2020-08-24,2020-08-24 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 malwarescore=0
 impostorscore=0 phishscore=0 clxscore=1015 mlxscore=0 bulkscore=0
 spamscore=0 lowpriorityscore=0 priorityscore=1501 mlxlogscore=788
 suspectscore=3 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008240092
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 2020-06-18 at 18:01 +0200, Roberto Sassu wrote:
> This patch checks the size for the EVM_IMA_XATTR_DIGSIG and
> EVM_XATTR_PORTABLE_DIGSIG types to ensure that the algorithm is read from
> the buffer returned by vfs_getxattr_alloc().
> 
> Cc: stable@vger.kernel.org # 4.19.x
> Fixes: 5feeb61183dde ("evm: Allow non-SHA1 digital signatures")
> Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>

Reviewed-by: Mimi Zohar <zohar@linux.ibm.com>

