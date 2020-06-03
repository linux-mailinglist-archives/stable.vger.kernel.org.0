Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A65311ED854
	for <lists+stable@lfdr.de>; Thu,  4 Jun 2020 00:03:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726598AbgFCWDs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Jun 2020 18:03:48 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:43218 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726512AbgFCWDs (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Jun 2020 18:03:48 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 053M26gB189223;
        Wed, 3 Jun 2020 18:03:42 -0400
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 31egbgxqas-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 03 Jun 2020 18:03:41 -0400
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 053M0gaZ016795;
        Wed, 3 Jun 2020 22:03:39 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma01fra.de.ibm.com with ESMTP id 31bf47ukfg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 03 Jun 2020 22:03:39 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 053M3bkW65536104
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 3 Jun 2020 22:03:37 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 05ED4AE055;
        Wed,  3 Jun 2020 22:03:37 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 23128AE051;
        Wed,  3 Jun 2020 22:03:36 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.85.144.192])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  3 Jun 2020 22:03:36 +0000 (GMT)
Message-ID: <1591221815.5146.31.camel@linux.ibm.com>
Subject: Re: [PATCH 2/2] ima: Call ima_calc_boot_aggregate() in
 ima_eventdigest_init()
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     Roberto Sassu <roberto.sassu@huawei.com>, tiwai@suse.de
Cc:     linux-integrity@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org, silviu.vlasceanu@huawei.com,
        stable@vger.kernel.org
Date:   Wed, 03 Jun 2020 18:03:35 -0400
In-Reply-To: <20200603150821.8607-2-roberto.sassu@huawei.com>
References: <20200603150821.8607-1-roberto.sassu@huawei.com>
         <20200603150821.8607-2-roberto.sassu@huawei.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.20.5 (3.20.5-1.fc24) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-03_13:2020-06-02,2020-06-03 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 adultscore=0
 malwarescore=0 bulkscore=0 phishscore=0 clxscore=1015 cotscore=-2147483648
 spamscore=0 suspectscore=0 priorityscore=1501 impostorscore=0
 mlxlogscore=999 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2006030163
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Roberto,

On Wed, 2020-06-03 at 17:08 +0200, Roberto Sassu wrote:
> If the template field 'd' is chosen and the digest to be added to the
> measurement entry was not calculated with SHA1 or MD5, it is
> recalculated with SHA1, by using the passed file descriptor. However, this
> cannot be done for boot_aggregate, because there is no file descriptor.
> 
> This patch adds a call to ima_calc_boot_aggregate() in
> ima_eventdigest_init(), so that the digest can be recalculated also for the
> boot_aggregate entry.
> 
> Cc: stable@vger.kernel.org # 3.13.x
> Fixes: 3ce1217d6cd5d ("ima: define template fields library and new helpers")
> Reported-by: Takashi Iwai <tiwai@suse.de>
> Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>

Thanks, Roberto.

I've pushed both patches out to the next-integrity branch and would
appreciate some additional testing.

thanks,

Mimi
