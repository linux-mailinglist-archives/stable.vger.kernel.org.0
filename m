Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 22AA311DC5
	for <lists+stable@lfdr.de>; Thu,  2 May 2019 17:36:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728018AbfEBPdA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 May 2019 11:33:00 -0400
Received: from mx0a-001ae601.pphosted.com ([67.231.149.25]:41036 "EHLO
        mx0b-001ae601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729291AbfEBPc7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 May 2019 11:32:59 -0400
Received: from pps.filterd (m0077473.ppops.net [127.0.0.1])
        by mx0a-001ae601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x42FOkwL028384;
        Thu, 2 May 2019 10:32:52 -0500
Authentication-Results: ppops.net;
        spf=none smtp.mailfrom=ckeepax@opensource.cirrus.com
Received: from mail4.cirrus.com ([87.246.98.35])
        by mx0a-001ae601.pphosted.com with ESMTP id 2s6xhv34q3-1;
        Thu, 02 May 2019 10:32:52 -0500
Received: from EDIEX01.ad.cirrus.com (ediex01.ad.cirrus.com [198.61.84.80])
        by mail4.cirrus.com (Postfix) with ESMTP id 2ADCD611C8AF;
        Thu,  2 May 2019 10:34:36 -0500 (CDT)
Received: from EDIEX01.ad.cirrus.com (198.61.84.80) by EDIEX01.ad.cirrus.com
 (198.61.84.80) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1591.10; Thu, 2 May
 2019 16:32:51 +0100
Received: from ediswmail.ad.cirrus.com (198.61.86.93) by EDIEX01.ad.cirrus.com
 (198.61.84.80) with Microsoft SMTP Server id 15.1.1591.10 via Frontend
 Transport; Thu, 2 May 2019 16:32:51 +0100
Received: from ediswmail.ad.cirrus.com (ediswmail.ad.cirrus.com [198.61.86.93])
        by ediswmail.ad.cirrus.com (Postfix) with ESMTP id 5734E44;
        Thu,  2 May 2019 16:32:51 +0100 (BST)
Date:   Thu, 2 May 2019 16:32:51 +0100
From:   Charles Keepax <ckeepax@opensource.cirrus.com>
To:     Jarkko Nikula <jarkko.nikula@linux.intel.com>
CC:     Sasha Levin <sashal@kernel.org>, <linux-i2c@vger.kernel.org>,
        Wolfram Sang <wsa@the-dreams.de>, <stable@vger.kernel.org>
Subject: Re: [PATCH] i2c: Prevent runtime suspend of adapter when Host Notify
 is required
Message-ID: <20190502153251.GG81578@ediswmail.ad.cirrus.com>
References: <20190430142322.15013-1-jarkko.nikula@linux.intel.com>
 <20190430155637.1B45E21743@mail.kernel.org>
 <7f989564-e994-5be6-02da-2838639efe59@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <7f989564-e994-5be6-02da-2838639efe59@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1905020103
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 02, 2019 at 03:32:24PM +0300, Jarkko Nikula wrote:
> On 4/30/19 6:56 PM, Sasha Levin wrote:
> >This commit has been processed because it contains a "Fixes:" tag,
> >fixing commit: c5eb1190074c PCI / PM: Allow runtime PM without callback functions.
> >
> >The bot has tested the following trees: v5.0.10, v4.19.37.
> >
> >v5.0.10: Build OK!
> >v4.19.37: Failed to apply! Possible dependencies:
> >     6f108dd70d30 ("i2c: Clear client->irq in i2c_device_remove")
> >     93b6604c5a66 ("i2c: Allow recovery of the initial IRQ by an I2C client device.")
> >
> >
> >How should we proceed with this patch?
> >
> There's also dependency to commit
> b9bb3fdf4e87 ("i2c: Remove unnecessary call to irq_find_mapping")
> 
> Without it 93b6604c5a66 doesn't apply.
> 
> Otherwise my patch don't have dependency into these so I can have
> another version for 4.19 if needed.
> 
> I got impression from the mail thread for 6f108dd70d30 that it could
> be also stable material but cannot really judge.
> 
> Charles: does your commits b9bb3fdf4e87 and 6f108dd70d30 with the
> fix 93b6604c5a66 qualify for 4.19? (background: my fix doesn't apply
> without them but doesn't depend on them).
> 

b9bb3fdf4e87 ("i2c: Remove unnecessary call to irq_find_mapping")

I don't think this one would make sense to backport it's not
fixing any issues it just removes a redundant call. The call just
repeats work it does no harm.

6f108dd70d30 ("i2c: Clear client->irq in i2c_device_remove")
93b6604c5a66 ("i2c: Allow recovery of the initial IRQ by an I2C client device.")

These two are much more of a grey area, they do fix an actual
issue, although that issue only happens when you unbind and
rebind both an I2C device and the device providing its IRQs. A
couple of us have been trying to look for a better fix as well
which further complicates matters.

I would suggest you just backport your patch and leave these
ones. As evidenced by the fixup patch there is a slight chance
of regressions from backporting this fix and the issue it
fixes is clearly not something people are normally hitting.

Thanks,
Charles
