Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74F9B2C8A8F
	for <lists+stable@lfdr.de>; Mon, 30 Nov 2020 18:14:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729289AbgK3RNp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Nov 2020 12:13:45 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:44914 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725955AbgK3RNo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Nov 2020 12:13:44 -0500
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AUH2RHc053140;
        Mon, 30 Nov 2020 12:11:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=168R89ch6P3dB9j/wazTes6DaxYIGhAQ6T7t5kbp4MQ=;
 b=qhPwJIYcZXU47BNp07tNDQm9pXD36oQ7FQuBK/VsCUe9YitOoQNmYB9V6MrG2LCgXy6Z
 6oZ1l3blyrK5R4Oz54ctrU727UdWY2Udikbi//rtQbJCGaxvn5lOaWKQcqtYrYauO1N7
 /pmbruqaLjecxziXYE5soua9qf+xw8cuO2r/ku270iDwxd9SHW+zclNXq6KA/DxkMwuQ
 aLilHCAV0RBbK582tYx0ijCQpaugQfPQLgS8f6KSOlSX7iMcLB5DPvZPTvgFUg/hfM4A
 fg3xn6fzZqmCuMv5A9LIE0Uwm4tuFiemdNl87rQqjSB6qXVBh7fWp2u8CUhLrsqRawQ2 OQ== 
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 35549m9c73-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 30 Nov 2020 12:11:06 -0500
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0AUH7q8t030175;
        Mon, 30 Nov 2020 17:11:04 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma04ams.nl.ibm.com with ESMTP id 353e6828ej-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 30 Nov 2020 17:11:04 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0AUHB23Z40698358
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 30 Nov 2020 17:11:02 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0EED7AE05A;
        Mon, 30 Nov 2020 17:11:02 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 37B60AE04D;
        Mon, 30 Nov 2020 17:11:00 +0000 (GMT)
Received: from li-f45666cc-3089-11b2-a85c-c57d1a57929f.ibm.com (unknown [9.160.59.46])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 30 Nov 2020 17:10:59 +0000 (GMT)
Message-ID: <855fe20ed05ea1aba21da3c9c05fcb025fc51763.camel@linux.ibm.com>
Subject: Re: [PATCH] ima: Don't modify file descriptor mode on the fly
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     Roberto Sassu <roberto.sassu@huawei.com>,
        torvalds@linux-foundation.org, hch@infradead.org
Cc:     linux-integrity@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org, silviu.vlasceanu@huawei.com,
        stable@vger.kernel.org
Date:   Mon, 30 Nov 2020 12:10:59 -0500
In-Reply-To: <20201126103456.15167-1-roberto.sassu@huawei.com>
References: <20201126103456.15167-1-roberto.sassu@huawei.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.28.5 (3.28.5-12.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-30_06:2020-11-30,2020-11-30 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 bulkscore=0
 phishscore=0 clxscore=1015 mlxscore=0 mlxlogscore=789 lowpriorityscore=0
 adultscore=0 spamscore=0 impostorscore=0 suspectscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011300106
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 2020-11-26 at 11:34 +0100, Roberto Sassu wrote:
> Commit a408e4a86b36b ("ima: open a new file instance if no read
> permissions") already introduced a second open to measure a file when the
> original file descriptor does not allow it. However, it didn't remove the
> existing method of changing the mode of the original file descriptor, which
> is still necessary if the current process does not have enough privileges
> to open a new one.
> 
> Changing the mode isn't really an option, as the filesystem might need to
> do preliminary steps to make the read possible. Thus, this patch removes
> the code and keeps the second open as the only option to measure a file
> when it is unreadable with the original file descriptor.
> 
> Cc: <stable@vger.kernel.org> # 4.20.x: 0014cc04e8ec0 ima: Set file->f_mode
> Fixes: 2fe5d6def1672 ("ima: integrity appraisal extension")
> Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>

Thanks, Roberto, Christoph.  The patch is now queued in next-integrity.

Mimi

