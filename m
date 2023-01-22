Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8201767725B
	for <lists+stable@lfdr.de>; Sun, 22 Jan 2023 21:30:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230127AbjAVUac (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Jan 2023 15:30:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230122AbjAVUab (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Jan 2023 15:30:31 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04F57193CE;
        Sun, 22 Jan 2023 12:30:26 -0800 (PST)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30MEZ4m8011623;
        Sun, 22 Jan 2023 20:29:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=7ovEDdouXJfZvNrAmKNf72ri1q//XHfeiPgg8MjldS4=;
 b=Fp0TLzjiEkDT3v4QJfXxGwxG1mL+yLLNa8VQw1UA7E16NryPcdcsg3F5fhBLE38QXnEX
 I9v77vTbpKoCMMkAqJuHXOSynCmoj8yf1Q/j3cmNCeK03puqMEk76fMf+6ROS94WCiJ6
 +EFVp3ng+6uT26Rvewt1tLFsUQEYjGr7625xl6RUV3vQkmYSSrFWDF3NSDuusWSIdgSB
 GACPNbK55tEMWfbI+TtqStYge9TAxmEVq3bkFq1SIKjCGZNZ7gIm5eIH2NXNRRpRaEQR
 mwjmxBIvbm9X7Z1grd7UiAeDty54bIh4qJyoexdTWsIoXAMDMoMWhtUDk9fRKkNBpe0b YA== 
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3n8swmea5n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 22 Jan 2023 20:29:58 +0000
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 30MHRtuv019851;
        Sun, 22 Jan 2023 20:29:58 GMT
Received: from smtprelay02.dal12v.mail.ibm.com ([9.208.130.97])
        by ppma04dal.us.ibm.com (PPS) with ESMTPS id 3n87p6tt2u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 22 Jan 2023 20:29:58 +0000
Received: from smtpav04.wdc07v.mail.ibm.com (smtpav04.wdc07v.mail.ibm.com [10.39.53.231])
        by smtprelay02.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 30MKTuR246400000
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 22 Jan 2023 20:29:57 GMT
Received: from smtpav04.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B608E58052;
        Sun, 22 Jan 2023 20:29:56 +0000 (GMT)
Received: from smtpav04.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AAEF058050;
        Sun, 22 Jan 2023 20:29:55 +0000 (GMT)
Received: from li-f45666cc-3089-11b2-a85c-c57d1a57929f.ibm.com (unknown [9.160.45.232])
        by smtpav04.wdc07v.mail.ibm.com (Postfix) with ESMTP;
        Sun, 22 Jan 2023 20:29:55 +0000 (GMT)
Message-ID: <23e4bce238bee0591ba6fb3566f7b42f6719331f.camel@linux.ibm.com>
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
Date:   Sun, 22 Jan 2023 15:29:54 -0500
In-Reply-To: <e1a1fe029aea21ba533cb6196e64f29c7b052c57.camel@huaweicloud.com>
References: <20221221141007.2579770-1-roberto.sassu@huaweicloud.com>
         <CAHC9VhQUAuF-Fan72j7BOqOdLE=B=mJpJ_GpR5p5cUmXruYT=Q@mail.gmail.com>
         <4b8688ee3d533d989196004d5f9f2c7eb4093f8b.camel@huaweicloud.com>
         <CAHC9VhSamRVpgrDrSuc2dsbbw3-pvjDi9BsFWoWssHkAD2W5vA@mail.gmail.com>
         <a764acb285d0616c8608eaab8671ceb9c22cb390.camel@huaweicloud.com>
         <058f1bdf4ba75c3a00918cefbf1be32477b51639.camel@linux.ibm.com>
         <e1a1fe029aea21ba533cb6196e64f29c7b052c57.camel@huaweicloud.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.28.5 (3.28.5-18.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: s6BgAZpAIkV9EueSx_57O9LauKbcJdq5
X-Proofpoint-GUID: s6BgAZpAIkV9EueSx_57O9LauKbcJdq5
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-22_16,2023-01-20_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=699
 priorityscore=1501 bulkscore=0 phishscore=0 lowpriorityscore=0
 malwarescore=0 adultscore=0 spamscore=0 mlxscore=0 suspectscore=0
 impostorscore=0 clxscore=1011 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2212070000 definitions=main-2301220196
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 2023-01-13 at 11:52 +0100, Roberto Sassu wrote:

> > > If we add a new policy keyword, existing policies would not be updated
> > > unless the system administrator notices it. If a remote attestation
> > > fails, the administrator has to look into it.
> > 
> > Verifying the measurement list against a TPM quote should work
> > regardless of additional measurements.  The attestation server,
> > however, should also check for unknown files.
> > 
> > > Maybe we can introduce a new hook called MMAP_CHECK_REQ, so that an
> > > administrator could change the policy to have the current behavior, if
> > > the administrator wishes so.

<snip>

> > However "_REQ" could mean either requested or required.
> 
> It was to recall reqprot. I could rename to MMAP_CHECK_REQPROT.

That sounds good.

-- 
thanks,

Mimib


