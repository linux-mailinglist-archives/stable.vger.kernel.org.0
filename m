Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F53D2506C7
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 19:45:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726026AbgHXRpM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 13:45:12 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:31306 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725601AbgHXRpM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Aug 2020 13:45:12 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07OHVwsT169379;
        Mon, 24 Aug 2020 13:45:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=LLSRJbnN1rzlyk5a9nLMVRUtWdyFeR8aOd9giiaAzjg=;
 b=sOX5dqt/fm60iVUH5jNLH6ljv0F/G3N41XlagB2QNV8IYDVPUq4yHHP+Ls+Iq93Ukmsk
 8GEnX+oSAkGhiTe4hgEhll4a2qMlEK6gMQu7GWSPcIERC5chPuRkc4P0V3O8k9B+xF9D
 nvfV34tXGLOtj3txCcecfrutXTQJO7K9qyF9PG6UIDAQhF9CimrzIcV1/i8AEyVOkazu
 1cNRnP+eoyQOok68F+phTeDBOjqJTYNsIsraVLoGOCCqX3FjpImS0B3BJ4i8oQGa6zSC
 /UARsq9dzsz7A3HZRiuVxoRMaHlDmaSMOy2TAniP9+vdu0Erj0HXBh/ivNNjpP47SL8+ gw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 334gxn2h6c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 24 Aug 2020 13:45:07 -0400
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 07OHWoCN174371;
        Mon, 24 Aug 2020 13:45:07 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 334gxn2h54-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 24 Aug 2020 13:45:06 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 07OHh2B6017626;
        Mon, 24 Aug 2020 17:45:04 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma06ams.nl.ibm.com with ESMTP id 332uk6akxg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 24 Aug 2020 17:45:04 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 07OHj2JA60817720
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Aug 2020 17:45:02 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5D93E4C04A;
        Mon, 24 Aug 2020 17:45:02 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 520F94C046;
        Mon, 24 Aug 2020 17:45:01 +0000 (GMT)
Received: from sig-9-65-254-31.ibm.com (unknown [9.65.254.31])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 24 Aug 2020 17:45:01 +0000 (GMT)
Message-ID: <d4c9d5333256b17acdbe41729dd680f534266130.camel@linux.ibm.com>
Subject: Re: [PATCH 01/11] evm: Execute evm_inode_init_security() only when
 the HMAC key is loaded
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     Roberto Sassu <roberto.sassu@huawei.com>, mjg59@google.com
Cc:     linux-integrity@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Date:   Mon, 24 Aug 2020 13:45:00 -0400
In-Reply-To: <2b204e31d21e93c0167d154c2397cd5d11be6e7f.camel@linux.ibm.com>
References: <20200618160133.937-1-roberto.sassu@huawei.com>
         <2b204e31d21e93c0167d154c2397cd5d11be6e7f.camel@linux.ibm.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.28.5 (3.28.5-12.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-24_12:2020-08-24,2020-08-24 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 clxscore=1015
 bulkscore=0 impostorscore=0 priorityscore=1501 malwarescore=0 spamscore=0
 lowpriorityscore=0 adultscore=0 phishscore=0 mlxscore=0 suspectscore=3
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008240138
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Roberto,

On Fri, 2020-08-21 at 14:30 -0400, Mimi Zohar wrote:
> Sorry for the delay in reviewing these patches.   Missing from this
> patch set is a cover letter with an explanation for grouping these
> patches into a patch set, other than for convenience.  In this case, it
> would be along the lines that the original use case for EVM portable
> and immutable keys support was for a few critical files, not combined
> with an EVM encrypted key type.   This patch set more fully integrates
> the initial EVM portable and immutable signature support.

Thank you for more fully integrating the EVM portable signatures into
IMA.

" [PATCH 08/11] ima: Allow imasig requirement to be satisfied by EVM
portable signatures" equates an IMA signature to having a portable and
immutable EVM signature.  That is true in terms of signature
verification, but from an attestation perspective the "ima-sig"
template will not contain a signature.  If not the EVM signature, then
at least some other indication should be included in the measurement
list.

Are you planning on posting the associated IMA/EVM regression tests?

Mimi

