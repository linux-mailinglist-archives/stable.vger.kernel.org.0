Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 700064F79A3
	for <lists+stable@lfdr.de>; Thu,  7 Apr 2022 10:27:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242986AbiDGI3u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Apr 2022 04:29:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242981AbiDGI3t (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 Apr 2022 04:29:49 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7F3280228;
        Thu,  7 Apr 2022 01:27:46 -0700 (PDT)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2376ULsh025570;
        Thu, 7 Apr 2022 08:27:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=RmMYuPqxwwPzePUHlIPhEwrZGdiFnH4asGaZARwkco0=;
 b=ZIw5RvS4zVAK19kf1brqLXOLSyalrNG0TfcTXDPi0bg4bG1SJels8oQzFQ/ENb3AiPs6
 NFPL5kKCPoWC8WN7xd5nbw+8Z5aE5Dp7G14OsWmI8/ub1+wpjyqKgEUJlyD0mu+M3IHa
 OK1XIy5nvZvs+xelrtstQcO3jLrgz46OLh3WCfPuZZPCJ9Yi9lMgxY9KxvF+9HA9LY2z
 yYA53BGidQFS9rgiZAd/3fMQeaP5WmAbPFRIjNFfLukahTu9wKnZN3rrcq07BZ+Aln2T
 /RGlPLcVvtpOFhPbV92rT8hPAlWj5YTDpTLx5zlAxB54HoyAra7xRAFZI2xbfQcprj4P rg== 
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3f9tr62815-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 07 Apr 2022 08:27:43 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2378FMSx015394;
        Thu, 7 Apr 2022 08:27:41 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma06ams.nl.ibm.com with ESMTP id 3f6drhsccx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 07 Apr 2022 08:27:41 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2378Rcpe45547962
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 7 Apr 2022 08:27:38 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 134EAAE053;
        Thu,  7 Apr 2022 08:27:38 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 94988AE045;
        Thu,  7 Apr 2022 08:27:37 +0000 (GMT)
Received: from sig-9-145-36-59.uk.ibm.com (unknown [9.145.36.59])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  7 Apr 2022 08:27:37 +0000 (GMT)
Message-ID: <9a0af2fec80f1b46c3ad9d80c6424e168ca2e54e.camel@linux.ibm.com>
Subject: Re: [PATCH AUTOSEL 5.17 18/31] s390/pci: improve zpci_dev reference
 counting
From:   Niklas Schnelle <schnelle@linux.ibm.com>
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     Matthew Rosato <mjrosato@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        gerald.schaefer@linux.ibm.com, hca@linux.ibm.com,
        agordeev@linux.ibm.com, linux-s390@vger.kernel.org
Date:   Thu, 07 Apr 2022 10:27:37 +0200
In-Reply-To: <20220407011029.113321-18-sashal@kernel.org>
References: <20220407011029.113321-1-sashal@kernel.org>
         <20220407011029.113321-18-sashal@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-18.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 7Sm7alq2IFxI8JJUNz4WOVNztY7Qfpdx
X-Proofpoint-GUID: 7Sm7alq2IFxI8JJUNz4WOVNztY7Qfpdx
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-04-06_13,2022-04-06_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 phishscore=0
 priorityscore=1501 lowpriorityscore=0 bulkscore=0 mlxlogscore=999
 impostorscore=0 mlxscore=0 clxscore=1031 spamscore=0 malwarescore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204070041
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 2022-04-06 at 21:10 -0400, Sasha Levin wrote:
> From: Niklas Schnelle <schnelle@linux.ibm.com>
> 
> [ Upstream commit c122383d221dfa2f41cfe5e672540595de986fde ]
> 
> Currently zpci_dev uses kref based reference counting but only accounts
> for one original reference plus one reference from an added pci_dev to
> its underlying zpci_dev. Counting just the original reference worked
> until the pci_dev reference was added in commit 2a671f77ee49 ("s390/pci:
> fix use after free of zpci_dev") because once a zpci_dev goes away, i.e.
> enters the reserved state, it would immediately get released. However
> with the pci_dev reference this is no longer the case and the zpci_dev
> may still appear in multiple availability events indicating that it was
> reserved. This was solved by detecting when the zpci_dev is already on
> its way out but still hanging around. This has however shown some light
> on how unusual our zpci_dev reference counting is.
> 
> Improve upon this by modelling zpci_dev reference counting on pci_dev.
> Analogous to pci_get_slot() increment the reference count in
> get_zdev_by_fid(). Thus all users of get_zdev_by_fid() must drop the
> reference once they are done with the zpci_dev.
> 
> Similar to pci_scan_single_device(), zpci_create_device() returns the
> device with an initial count of 1 and the device added to the zpci_list
> (analogous to the PCI bus' device_list). In turn users of
> zpci_create_device() must only drop the reference once the device is
> gone from the point of view of the zPCI subsystem, it might still be
> referenced by the common PCI subsystem though.
> 
> Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>
> Signed-off-by: Niklas Schnelle <schnelle@linux.ibm.com>
> Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---

This isn't really a bug fix, as far as I'm aware the existing code
works correctly. It is just about making things more like PCI bus
reference counting and less weird. I also see some potential of the
state of things with just this commit added being confusing. That's why
there is a follow up commit 7dcfe50f58d2 ("s390/pci: rename
get_zdev_by_bus() to zdev_from_bus()") to make it more obvious when
zpci_zdev_put() is needed.

In short I'd propose to drop this patch from the stable queues.

