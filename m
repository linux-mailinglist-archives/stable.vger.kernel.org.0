Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB90765C6C1
	for <lists+stable@lfdr.de>; Tue,  3 Jan 2023 19:51:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238522AbjACSvK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Jan 2023 13:51:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238750AbjACSvB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Jan 2023 13:51:01 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32BAA1147;
        Tue,  3 Jan 2023 10:50:59 -0800 (PST)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 303HKaCT008304;
        Tue, 3 Jan 2023 18:50:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=dxz8E5dWDzfZ3hObw18n1zT2NyCgsodgeS4Pk5qI9hI=;
 b=RrU7ujVUAIOf9MTW+lw98VVCw5g1CSP+VGKNElNeIMeCZslzoFLLGQ1ja7Af1z8wIE/q
 RQPcYiqc+l9T97z2kT7TPK1Oy8Lat8H6q1tSWZIQ8Liy2Pj8532k6+GRGcTa/7Gkb1tC
 Ul3XYtk/mvEK0vzZLzdr1Z2OZ1BR9Jz4gZYCfJnwXvnLJH1+usKyTlLMBoAOCmmc015V
 g4JdYpkYT2aZgORkb86M7aZw6gfMuiKVqnk8Y8R5+IWdYrm19N+vb2QJGStRjFb2WHbW
 EZ2oGXHIYjM+1tOrDHPb92L7tl3mHl+9zQhIR9WfgJoGdxmzMsBhF5n3mBwK9pM3GYdi NQ== 
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3mvmb7s127-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 03 Jan 2023 18:50:52 +0000
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 303Hjtlh007492;
        Tue, 3 Jan 2023 18:50:51 GMT
Received: from smtprelay02.dal12v.mail.ibm.com ([9.208.130.97])
        by ppma01dal.us.ibm.com (PPS) with ESMTPS id 3mtcq8858e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 03 Jan 2023 18:50:51 +0000
Received: from smtpav02.wdc07v.mail.ibm.com (smtpav02.wdc07v.mail.ibm.com [10.39.53.229])
        by smtprelay02.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 303Iooq518940354
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 3 Jan 2023 18:50:50 GMT
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EE0C25805D;
        Tue,  3 Jan 2023 18:50:49 +0000 (GMT)
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4344E58058;
        Tue,  3 Jan 2023 18:50:49 +0000 (GMT)
Received: from li-f45666cc-3089-11b2-a85c-c57d1a57929f.ibm.com (unknown [9.160.32.150])
        by smtpav02.wdc07v.mail.ibm.com (Postfix) with ESMTP;
        Tue,  3 Jan 2023 18:50:49 +0000 (GMT)
Message-ID: <a93e895499a32160298b19636ab3157c541aee88.camel@linux.ibm.com>
Subject: Re: [PATCH v2 1/2] ima: use the lsm policy update notifier
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     GUO Zihua <guozihua@huawei.com>, stable@vger.kernel.org,
        gregkh@linuxfoundation.org
Cc:     paul@paul-moore.com, linux-integrity@vger.kernel.org,
        luhuaxin1@huawei.com
Date:   Tue, 03 Jan 2023 13:50:48 -0500
In-Reply-To: <20230103022011.15741-2-guozihua@huawei.com>
References: <20230103022011.15741-1-guozihua@huawei.com>
         <20230103022011.15741-2-guozihua@huawei.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.28.5 (3.28.5-18.el8) 
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 3Z5oC4-iKIj95jnj3mncKoZYSQslXPWu
X-Proofpoint-GUID: 3Z5oC4-iKIj95jnj3mncKoZYSQslXPWu
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2023-01-03_07,2023-01-03_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 phishscore=0
 mlxlogscore=876 malwarescore=0 bulkscore=0 lowpriorityscore=0
 priorityscore=1501 clxscore=1015 mlxscore=0 spamscore=0 adultscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301030159
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 2023-01-03 at 10:20 +0800, GUO Zihua wrote:
> From: Janne Karhunen <janne.karhunen@gmail.com>
> 
> [ Upstream commit b169424551930a9325f700f502802f4d515194e5 ]
> 
> This patch is backported to resolve the issue of IMA ignoreing LSM part of
> an LSM based rule. As the LSM notifier chain was an atomic notifier
> chain, we'll not be able to call synchronize_rcu() within our notifier
> handling function. Instead, we call the call_rcu() function to resolve
> the freeing issue. To do that, we would needs to include a rcu_head
> member in our rule, as well as wrap the call to ima_lsm_free_rule() into
> a rcu_callback_t type callback function.
> 
> Original patch message is as follows:
> 
> commit b169424551930a9325f700f502802f4d515194e5
> Author: Janne Karhunen <janne.karhunen@gmail.com>
> Date:   Fri Jun 14 15:20:15 2019 +0300
> 
>   Don't do lazy policy updates while running the rule matching,
>   run the updates as they happen.
> 
>   Depends on commit f242064c5df3 ("LSM: switch to blocking policy update
>                                   notifiers")
> 
>   Signed-off-by: Janne Karhunen <janne.karhunen@gmail.com>
>   Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
> 
> Cc: stable@vger.kernel.org #4.19.y
> Signed-off-by: GUO Zihua <guozihua@huawei.com>

There was quite a bit of discussion regarding converting the atomic
notifier to blocking, but this backport doesn't make that change.

Refer to 
https://lore.kernel.org/linux-integrity/CAHC9VhS=GsEVUmxtiV64o8G6i2nJpkzxzpyTADgN-vhV8pzZbg@mail.gmail.com/

Mimi

