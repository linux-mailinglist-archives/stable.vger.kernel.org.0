Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41CB3667DB6
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 19:16:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240542AbjALSQv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 13:16:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240313AbjALSQR (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 13:16:17 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DD446E40B;
        Thu, 12 Jan 2023 09:45:49 -0800 (PST)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30CHMOAg017792;
        Thu, 12 Jan 2023 17:45:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=+zxkgBUw2NX9Q0/6lfwmJnCbVmuP0kVpUi3IG5Ni2BQ=;
 b=G+42OxFBJrTXDu6fPC+UAF4bh4GDwO/02aE620Ibux0DgR+MDUFVCXtbi30/b/HW6Qka
 Lio7bNFjYls7NMcf4o6I1eZBle1RXrFRSkSPs4noFiTK/R/Z0e6cc03GrvVXIi+ovg9u
 We1ui/Fy0Kf9FcRKGpzMgOvH00SCEjk0hSE26wspJ2CCH88AT1Qm97fNkJdA0stKOkIm
 w6RdMV6ucV6qlIS2pETtQ4xiMLYmcden3NUacXrJ3sIuzgFkeDn1tV5BPCZPy/8oEf4J
 Hnn5Ap28zYWgmN6LsxR4cJHMjFoKBFxd6XcLXvlAsldvuq++8BxqnpeqJw6A1jS8pwFQ Rg== 
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3n2pj28f4w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 12 Jan 2023 17:45:16 +0000
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 30CFSsmv029176;
        Thu, 12 Jan 2023 17:45:15 GMT
Received: from smtprelay06.dal12v.mail.ibm.com ([9.208.130.100])
        by ppma04dal.us.ibm.com (PPS) with ESMTPS id 3n1m03d31b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 12 Jan 2023 17:45:15 +0000
Received: from smtpav03.wdc07v.mail.ibm.com (smtpav03.wdc07v.mail.ibm.com [10.39.53.230])
        by smtprelay06.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 30CHjEnT4653626
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Jan 2023 17:45:14 GMT
Received: from smtpav03.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E3AF658066;
        Thu, 12 Jan 2023 17:45:13 +0000 (GMT)
Received: from smtpav03.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AD44758054;
        Thu, 12 Jan 2023 17:45:12 +0000 (GMT)
Received: from li-f45666cc-3089-11b2-a85c-c57d1a57929f.ibm.com (unknown [9.160.95.124])
        by smtpav03.wdc07v.mail.ibm.com (Postfix) with ESMTP;
        Thu, 12 Jan 2023 17:45:12 +0000 (GMT)
Message-ID: <058f1bdf4ba75c3a00918cefbf1be32477b51639.camel@linux.ibm.com>
Subject: Re: [PATCH v2] security: Restore passing final prot to
 ima_file_mmap()
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     Roberto Sassu <roberto.sassu@huaweicloud.com>,
        Paul Moore <paul@paul-moore.com>
Cc:     jmorris@namei.org, serge@hallyn.com,
        linux-integrity@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk,
        Roberto Sassu <roberto.sassu@huawei.com>,
        stable@vger.kernel.org
Date:   Thu, 12 Jan 2023 12:45:10 -0500
In-Reply-To: <a764acb285d0616c8608eaab8671ceb9c22cb390.camel@huaweicloud.com>
References: <20221221141007.2579770-1-roberto.sassu@huaweicloud.com>
         <CAHC9VhQUAuF-Fan72j7BOqOdLE=B=mJpJ_GpR5p5cUmXruYT=Q@mail.gmail.com>
         <4b8688ee3d533d989196004d5f9f2c7eb4093f8b.camel@huaweicloud.com>
         <CAHC9VhSamRVpgrDrSuc2dsbbw3-pvjDi9BsFWoWssHkAD2W5vA@mail.gmail.com>
         <a764acb285d0616c8608eaab8671ceb9c22cb390.camel@huaweicloud.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.28.5 (3.28.5-18.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: -qBLr6gjQ9EoF2ZENKM6NCD8duq2FyTm
X-Proofpoint-ORIG-GUID: -qBLr6gjQ9EoF2ZENKM6NCD8duq2FyTm
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2023-01-12_10,2023-01-12_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 bulkscore=0
 spamscore=0 suspectscore=0 lowpriorityscore=0 clxscore=1011
 impostorscore=0 mlxscore=0 adultscore=0 phishscore=0 priorityscore=1501
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301120127
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 2023-01-12 at 13:36 +0100, Roberto Sassu wrote:
> On Wed, 2023-01-11 at 09:25 -0500, Paul Moore wrote:
> > On Wed, Jan 11, 2023 at 4:31 AM Roberto Sassu
> > <roberto.sassu@huaweicloud.com> wrote:
> > > On Fri, 2023-01-06 at 16:14 -0500, Paul Moore wrote:
> > > > On Wed, Dec 21, 2022 at 9:10 AM Roberto Sassu
> > > > <roberto.sassu@huaweicloud.com> wrote:
> > > > > From: Roberto Sassu <roberto.sassu@huawei.com>
> > > > > 
> > > > > Commit 98de59bfe4b2f ("take calculation of final prot in
> > > > > security_mmap_file() into a helper") moved the code to update prot with the
> > > > > actual protection flags to be granted to the requestor by the kernel to a
> > > > > helper called mmap_prot(). However, the patch didn't update the argument
> > > > > passed to ima_file_mmap(), making it receive the requested prot instead of
> > > > > the final computed prot.
> > > > > 
> > > > > A possible consequence is that files mmapped as executable might not be
> > > > > measured/appraised if PROT_EXEC is not requested but subsequently added in
> > > > > the final prot.
> > > > > 
> > > > > Replace prot with mmap_prot(file, prot) as the second argument of
> > > > > ima_file_mmap() to restore the original behavior.
> > > > > 
> > > > > Cc: stable@vger.kernel.org
> > > > > Fixes: 98de59bfe4b2 ("take calculation of final prot in security_mmap_file() into a helper")
> > > > > Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
> > > > > ---
> > > > >  security/security.c | 2 +-
> > > > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > > > 
> > > > > diff --git a/security/security.c b/security/security.c
> > > > > index d1571900a8c7..0d2359d588a1 100644
> > > > > --- a/security/security.c
> > > > > +++ b/security/security.c
> > > > > @@ -1666,7 +1666,7 @@ int security_mmap_file(struct file *file, unsigned long prot,
> > > > >                                         mmap_prot(file, prot), flags);
> > > > >         if (ret)
> > > > >                 return ret;
> > > > > -       return ima_file_mmap(file, prot);
> > > > > +       return ima_file_mmap(file, mmap_prot(file, prot));
> > > > >  }
> > > > 
> > > > This seems like a reasonable fix, although as the original commit is
> > > > ~10 years old at this point I am a little concerned about the impact
> > > > this might have on IMA.  Mimi, what do you think?
> 
> As a user, I probably would like to know that my system is not
> measuring what it is supposed to measure. The rule:

Agreed, that it is measuring what it is supposed to measure.

> 
> measure func=MMAP_CHECK mask=MAY_EXEC
> 
> is looking for executable code mapped in memory. If it is requested by
> the application or the kernel, probably it does not make too much
> difference from the perspective of measurement goals.

Currently, it's limited to measuring file's being mmapped.  From what I
can tell from looking at the code, additional measurements would be
included when "current->personality & READ_IMPLIES_EXEC".

> 
> If we add a new policy keyword, existing policies would not be updated
> unless the system administrator notices it. If a remote attestation
> fails, the administrator has to look into it.

Verifying the measurement list against a TPM quote should work
regardless of additional measurements.  The attestation server,
however, should also check for unknown files.

> 
> Maybe we can introduce a new hook called MMAP_CHECK_REQ, so that an
> administrator could change the policy to have the current behavior, if
> the administrator wishes so.

Agreed, for backwards compatibility this would be good.  Would you
support it afterward transitioning IMA to an LSM?

However "_REQ" could mean either requested or required.

> > > > Beyond that, my only other comment would be to only call mmap_prot()
> > > > once and cache the results in a local variable.  You could also fix up
> > > > some of the ugly indentation crimes in security_mmap_file() while you
> > > > are at it, e.g. something like this:
> > > 
> > > Hi Paul
> > > 
> > > thanks for the comments. With the patch set to move IMA and EVM to the
> > > LSM infrastructure we will be back to calling mmap_prot() only once,
> > > but I guess we could do anyway, as the patch (if accepted) would be
> > > likely backported to stable kernels.
> > 
> > I think there is value in fixing this now and keeping it separate from
> > the IMA-to-LSM work as they really are disjoint.
> > 
> 


