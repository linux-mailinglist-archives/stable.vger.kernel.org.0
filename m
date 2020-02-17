Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE75C160E99
	for <lists+stable@lfdr.de>; Mon, 17 Feb 2020 10:32:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728916AbgBQJcE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Feb 2020 04:32:04 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:26660 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728773AbgBQJcE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Feb 2020 04:32:04 -0500
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01H9V5Ah132822
        for <stable@vger.kernel.org>; Mon, 17 Feb 2020 04:32:03 -0500
Received: from e06smtp03.uk.ibm.com (e06smtp03.uk.ibm.com [195.75.94.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2y6dnscrja-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <stable@vger.kernel.org>; Mon, 17 Feb 2020 04:32:02 -0500
Received: from localhost
        by e06smtp03.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <stable@vger.kernel.org> from <schnelle@linux.ibm.com>;
        Mon, 17 Feb 2020 09:32:01 -0000
Received: from b06avi18626390.portsmouth.uk.ibm.com (9.149.26.192)
        by e06smtp03.uk.ibm.com (192.168.101.133) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 17 Feb 2020 09:31:58 -0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 01H9V2Rl45351242
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 17 Feb 2020 09:31:02 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 506C311C058;
        Mon, 17 Feb 2020 09:31:57 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1707411C052;
        Mon, 17 Feb 2020 09:31:57 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Mon, 17 Feb 2020 09:31:57 +0000 (GMT)
Date:   Mon, 17 Feb 2020 10:31:56 +0100
From:   Niklas Schnelle <schnelle@linux.ibm.com>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>, linux-s390@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.5 094/542] s390/pci: Fix possible deadlock in
 recover_store()
References: <20200214154854.6746-1-sashal@kernel.org>
 <20200214154854.6746-94-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200214154854.6746-94-sashal@kernel.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-TM-AS-GCONF: 00
x-cbid: 20021709-0012-0000-0000-000003878BE7
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20021709-0013-0000-0000-000021C41864
Message-Id: <20200217093156.GB42010@tuxmaker.boeblingen.de.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-17_05:2020-02-14,2020-02-17 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 clxscore=1031
 malwarescore=0 impostorscore=0 lowpriorityscore=0 bulkscore=0 spamscore=0
 adultscore=0 suspectscore=0 mlxscore=0 phishscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002170083
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 14, 2020 at 10:41:26AM -0500, Sasha Levin wrote:
> From: Niklas Schnelle <schnelle@linux.ibm.com>
> 
> [ Upstream commit 576c75e36c689bec6a940e807bae27291ab0c0de ]
> 
> With zpci_disable() working, lockdep detected a potential deadlock
> (lockdep output at the end).
> 
> The deadlock is between recovering a PCI function via the
> 
> /sys/bus/pci/devices/<dev>/recover
> 
> attribute vs powering it off via
> 
> /sys/bus/pci/slots/<slot>/power.
> 
> The fix is analogous to the changes in commit 0ee223b2e1f6 ("scsi: core:
> Avoid that SCSI device removal through sysfs triggers a deadlock")
> that fixed a potential deadlock on removing a SCSI device via sysfs.
[ ... snip ... ]

While technically useful on its own this commit really should go together with
the following upstream commit:

17cdec960cf776b20b1fb08c622221babe591d51
("s390/pci: Recover handle in clp_set_pci_fn()")

While the problem fixed here is independent,  writing to the power/recover
attributes will often fail due to an inconsistent function handle without the
second commit.
In particular without it a PCI function in the error state can not be
recovered or powered off.

I would recommend adding the second commit to the backports as well.

Thanks,
Niklas Schnelle
-- 
Niklas Schnelle
Linux on Z Development

