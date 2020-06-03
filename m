Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AF451ED814
	for <lists+stable@lfdr.de>; Wed,  3 Jun 2020 23:30:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726229AbgFCVaf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Jun 2020 17:30:35 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:8704 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725961AbgFCVaf (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Jun 2020 17:30:35 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 053L3nje105267;
        Wed, 3 Jun 2020 17:30:28 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 31dr8j58y3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 03 Jun 2020 17:30:28 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 053LADH9022306;
        Wed, 3 Jun 2020 21:30:26 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma03ams.nl.ibm.com with ESMTP id 31bf480rq6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 03 Jun 2020 21:30:26 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 053LUNY58519964
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 3 Jun 2020 21:30:24 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D604252059;
        Wed,  3 Jun 2020 21:30:23 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.85.144.192])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 1978D52063;
        Wed,  3 Jun 2020 21:30:23 +0000 (GMT)
Message-ID: <1591219822.5146.2.camel@linux.ibm.com>
Subject: Re: [PATCH 1/2] ima: Directly assign the ima_default_policy pointer
 to ima_rules
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     Roberto Sassu <roberto.sassu@huawei.com>, tiwai@suse.de
Cc:     linux-integrity@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org, silviu.vlasceanu@huawei.com,
        stable@vger.kernel.org
Date:   Wed, 03 Jun 2020 17:30:22 -0400
In-Reply-To: <20200603150821.8607-1-roberto.sassu@huawei.com>
References: <20200603150821.8607-1-roberto.sassu@huawei.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.20.5 (3.20.5-1.fc24) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-03_13:2020-06-02,2020-06-03 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 suspectscore=0
 adultscore=0 mlxscore=0 spamscore=0 mlxlogscore=780 impostorscore=0
 phishscore=0 lowpriorityscore=0 priorityscore=1501 bulkscore=0
 malwarescore=0 cotscore=-2147483648 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2006030161
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 2020-06-03 at 17:08 +0200, Roberto Sassu wrote:
> This patch prevents the following oops:
> 
> [   10.771813] BUG: kernel NULL pointer dereference, address: 0000000000000
> [...]
> [   10.779790] RIP: 0010:ima_match_policy+0xf7/0xb80
> [...]
> [   10.798576] Call Trace:
> [   10.798993]  ? ima_lsm_policy_change+0x2b0/0x2b0
> [   10.799753]  ? inode_init_owner+0x1a0/0x1a0
> [   10.800484]  ? _raw_spin_lock+0x7a/0xd0
> [   10.801592]  ima_must_appraise.part.0+0xb6/0xf0
> [   10.802313]  ? ima_fix_xattr.isra.0+0xd0/0xd0
> [   10.803167]  ima_must_appraise+0x4f/0x70
> [   10.804004]  ima_post_path_mknod+0x2e/0x80
> [   10.804800]  do_mknodat+0x396/0x3c0
> 
> It occurs when there is a failure during IMA initialization, and
> ima_init_policy() is not called. IMA hooks still call ima_match_policy()
> but ima_rules is NULL. This patch prevents the crash by directly assigning
> the ima_default_policy pointer to ima_rules when ima_rules is defined. This
> wouldn't alter the existing behavior, as ima_rules is always set at the end
> of ima_init_policy().
> 
> Cc: stable@vger.kernel.org # 3.7.x
> Fixes: 07f6a79415d7d ("ima: add appraise action keywords and default rules")
> Reported-by: Takashi Iwai <tiwai@suse.de>
> Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>

Thanks, Roberto!
