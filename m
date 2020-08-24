Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4654724FE71
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 15:02:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726889AbgHXNCm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 09:02:42 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:57318 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726189AbgHXNCm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Aug 2020 09:02:42 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07OCYq1w141833;
        Mon, 24 Aug 2020 09:02:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=fIp8RUpwJMp0o6RgRzKqxD/GxlQSQy5lvqbrxwtLA8w=;
 b=WY+72C9l25B0HRlffPVL3R0LB8VlovEYorcNtb9R/Pnhb5+95jLsn2TGv29Uq5F8Pp+u
 TfLfYT88+GS9wWL/ElHZ4+E5n/3cJnWsF+319YBe4GX4iBqWKldPpryASzqtNsEMFYtB
 71IUZQXXiGQHeAL5S/Bw57m7q/DQqqyNHAUgxiI++EbKioARAIjHa6z8ep8nsJCRYmyd
 +Ea7wHIP83DjZhdJ2lf9ak7KdnmAYlrd4qwlJtOTY9ZLePveKAsxGaS7cA7RbcOHEPUs
 xLLVyyZ8vjhzQyT33Q7PwBdQYub3sAeSAB+HG4Ag7tKVWNc6o7yhvyig7iRIFZY94fNr 2g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3349q90h4f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 24 Aug 2020 09:02:35 -0400
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 07OCap6U152042;
        Mon, 24 Aug 2020 09:02:30 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3349q90h2j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 24 Aug 2020 09:02:30 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 07OCwKCs008721;
        Mon, 24 Aug 2020 13:02:27 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma06ams.nl.ibm.com with ESMTP id 332uk6acgs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 24 Aug 2020 13:02:27 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 07OD2P3b32702740
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Aug 2020 13:02:25 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2503D4C058;
        Mon, 24 Aug 2020 13:02:25 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 924614C050;
        Mon, 24 Aug 2020 13:02:23 +0000 (GMT)
Received: from sig-9-65-254-31.ibm.com (unknown [9.65.254.31])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 24 Aug 2020 13:02:23 +0000 (GMT)
Message-ID: <ccf18096bf715d0eb8f68899c324452a4b044124.camel@linux.ibm.com>
Subject: Re: [PATCH 10/11] ima: Don't ignore errors from
 crypto_shash_update()
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     Roberto Sassu <roberto.sassu@huawei.com>, mjg59@google.com
Cc:     linux-integrity@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org, silviu.vlasceanu@huawei.com,
        stable@vger.kernel.org
Date:   Mon, 24 Aug 2020 09:02:22 -0400
In-Reply-To: <20200618160458.1579-10-roberto.sassu@huawei.com>
References: <20200618160329.1263-2-roberto.sassu@huawei.com>
         <20200618160458.1579-10-roberto.sassu@huawei.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.28.5 (3.28.5-12.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-24_11:2020-08-24,2020-08-24 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0
 priorityscore=1501 clxscore=1015 lowpriorityscore=0 malwarescore=0
 adultscore=0 bulkscore=0 mlxscore=0 impostorscore=0 suspectscore=3
 phishscore=0 mlxlogscore=909 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2006250000 definitions=main-2008240099
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 2020-06-18 at 18:04 +0200, Roberto Sassu wrote:
> Errors returned by crypto_shash_update() are not checked in
> ima_calc_boot_aggregate_tfm() and thus can be overwritten at the next
> iteration of the loop. This patch adds a check after calling
> crypto_shash_update() and returns immediately if the result is not zero.
> 
> Cc: stable@vger.kernel.org
> Fixes: 3323eec921efd ("integrity: IMA as an integrity service provider")
> Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>

Verification of the boot_aggregate will fail, but yes this should be
fixed.  This patch  and the next should be moved up front to the
beginning of the patch set.

Reviewed-by: Mimi Zohar <zohar@linux.ibm.com>

thanks,

Mimi

