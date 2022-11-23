Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C815B63606E
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 14:51:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237845AbiKWNvA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 08:51:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237898AbiKWNuk (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 08:50:40 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E44FF725E3;
        Wed, 23 Nov 2022 05:41:07 -0800 (PST)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2ANDec0E014405;
        Wed, 23 Nov 2022 13:40:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=jrBfC7dJpNTP1PLQfstnPLWNDBdb22fQzfNFamy2PC8=;
 b=AaieTKG04yy8nLruIMJR+YOGtbxysrdu39W3ljR0dxw0JwhwYsS+9IAFKYoDgQL8LzNc
 +lgn8yqPrKZ9/kQfFYNwu9YbDtXQJZmuyNqSYnzHIk6jxLrNYkOnhPaqGdC4IuzfrTzC
 iBMMd8VCI7Jifbh5KyKm8QSwxxjsbkIbyT4+m8Mycxb9QqRAJ/dAcd0yXioKjm06ymRv
 V/raGoAZ9AZAkhJlDdjEnvRXgXYLmF3XNdWhmNU5ucee1iuhhlFNGB3sB8aqPUJnMXV1
 Dm0i5OiuWFgkeJvdfFL0OZWxaQPAVlkGQmhyDoZLf1pCtce/DkKtU/2O7hroXpbrMQbh aw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3m0x1db1d6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Nov 2022 13:40:44 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2ANDeiQ0014781;
        Wed, 23 Nov 2022 13:40:44 GMT
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3m0x1db1cw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Nov 2022 13:40:44 +0000
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2ANDb9tk020967;
        Wed, 23 Nov 2022 13:40:43 GMT
Received: from smtprelay02.dal12v.mail.ibm.com ([9.208.130.97])
        by ppma01wdc.us.ibm.com with ESMTP id 3kxps9jyty-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Nov 2022 13:40:43 +0000
Received: from smtpav02.wdc07v.mail.ibm.com (smtpav02.wdc07v.mail.ibm.com [10.39.53.229])
        by smtprelay02.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2ANDeg3910027292
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 23 Nov 2022 13:40:42 GMT
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6F7A85805D;
        Wed, 23 Nov 2022 13:40:42 +0000 (GMT)
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1D5875805B;
        Wed, 23 Nov 2022 13:40:41 +0000 (GMT)
Received: from sig-9-77-136-225.ibm.com (unknown [9.77.136.225])
        by smtpav02.wdc07v.mail.ibm.com (Postfix) with ESMTP;
        Wed, 23 Nov 2022 13:40:40 +0000 (GMT)
Message-ID: <c6c448c2acc07caf840046067322f3e1110cedff.camel@linux.ibm.com>
Subject: Re: [PATCH] ima: Make a copy of sig and digest in
 asymmetric_verify()
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     Roberto Sassu <roberto.sassu@huaweicloud.com>,
        dmitry.kasatkin@gmail.com, paul@paul-moore.com, jmorris@namei.org,
        serge@hallyn.com
Cc:     linux-integrity@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Roberto Sassu <roberto.sassu@huawei.com>,
        stable@vger.kernel.org
Date:   Wed, 23 Nov 2022 08:40:40 -0500
In-Reply-To: <a676b387d23f9ca630418ece20a6761a9437ce76.camel@huaweicloud.com>
References: <20221104122023.1750333-1-roberto.sassu@huaweicloud.com>
         <9ef25f1b8621dab8b3cd4373bf6ce1633daae70e.camel@linux.ibm.com>
         <a676b387d23f9ca630418ece20a6761a9437ce76.camel@huaweicloud.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.28.5 (3.28.5-18.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: A4w4EOTzV7eVgvLNW0Kki-TTp_RoLq50
X-Proofpoint-ORIG-GUID: scHn40DzzQvLVXcH_h5cwupBFjhVnBtP
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-23_07,2022-11-23_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 phishscore=0
 adultscore=0 spamscore=0 impostorscore=0 clxscore=1015 bulkscore=0
 malwarescore=0 suspectscore=0 lowpriorityscore=0 mlxlogscore=999
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211230097
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 2022-11-23 at 13:56 +0100, Roberto Sassu wrote:
> On Tue, 2022-11-22 at 14:39 -0500, Mimi Zohar wrote:
> > Hi Roberto,
> > 
> > On Fri, 2022-11-04 at 13:20 +0100, Roberto Sassu wrote:
> > > From: Roberto Sassu <roberto.sassu@huawei.com>
> > > 
> > > Commit ac4e97abce9b8 ("scatterlist: sg_set_buf() argument must be in linear
> > > mapping") requires that both the signature and the digest resides in the
> > > linear mapping area.
> > > 
> > > However, more recently commit ba14a194a434c ("fork: Add generic vmalloced
> > > stack support"), made it possible to move the stack in the vmalloc area,
> > > which could make the requirement of the first commit not satisfied anymore.
> > > 
> > > If CONFIG_SG=y and CONFIG_VMAP_STACK=y, the following BUG() is triggered:
> > 
> > ^CONFIG_DEBUG_SG
> > 
> > > [  467.077359] kernel BUG at include/linux/scatterlist.h:163!
> > > [  467.077939] invalid opcode: 0000 [#1] PREEMPT SMP NOPTI
> > > 
> > > [...]
> > > 
> > > [  467.095225] Call Trace:
> > > [  467.096088]  <TASK>
> > > [  467.096928]  ? rcu_read_lock_held_common+0xe/0x50
> > > [  467.097569]  ? rcu_read_lock_sched_held+0x13/0x70
> > > [  467.098123]  ? trace_hardirqs_on+0x2c/0xd0
> > > [  467.098647]  ? public_key_verify_signature+0x470/0x470
> > > [  467.099237]  asymmetric_verify+0x14c/0x300
> > > [  467.099869]  evm_verify_hmac+0x245/0x360
> > > [  467.100391]  evm_inode_setattr+0x43/0x190
> > > 
> > > The failure happens only for the digest, as the pointer comes from the
> > > stack, and not for the signature, which instead was allocated by
> > > vfs_getxattr_alloc().
> > 
> > Only after enabling CONFIG_DEBUG_SG does EVM fail.
> > 
> > > Fix this by making a copy of both in asymmetric_verify(), so that the
> > > linear mapping requirement is always satisfied, regardless of the caller.
> > 
> > As only EVM is affected, it would make more sense to limit the change
> > to EVM.
> 
> I found another occurrence:
> 
> static int xattr_verify(enum ima_hooks func, struct integrity_iint_cache *iint,
> 			struct evm_ima_xattr_data *xattr_value, int xattr_len,
> 			enum integrity_status *status, const char **cause)
> {
> 
> [...]
> 
> 		rc = integrity_digsig_verify(INTEGRITY_KEYRING_IMA,
> 					     (const char *)xattr_value,
> 					     xattr_len, hash.digest,
> 					     hash.hdr.length);
> 
> Should I do two patches?

I'm just not getting it.  Why did you enable CONFIG_DEBUG_SIG?  Were
you testing random kernel configs?  Are you actually seeing signature
verifications errors without it enabled?  Or is it causing other
problems?  Is the "BUG_ON" still needed?

If you're going to fix the EVM and IMA callers, then make them separate
patches.
-- 
thanks,

Mimi

