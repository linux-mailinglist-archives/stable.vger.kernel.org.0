Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB1B2587FB
	for <lists+stable@lfdr.de>; Thu, 27 Jun 2019 19:08:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726511AbfF0RIR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Jun 2019 13:08:17 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:53756 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726425AbfF0RIR (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Jun 2019 13:08:17 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5RH4WJ1158114;
        Thu, 27 Jun 2019 17:08:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=qd4A0mvM0Ngq6zbyx+rmW6vBBHikEcXp7ZIPNNKkKVA=;
 b=Labos5CwgwhGuTBqiO5Jh2OR9iDmPNQZRWGerA+bzBV95vaUFDrqhHH7fRyK9W8AAFxg
 nv97i9pt5MeEamWj8XSxgCmNwG2YqoPzb9JxDAHuRR0VJ7ymkDKZaquODPN6T9vcVYvu
 B1oL69XqIglUYqoETwpL1WzWBDGSeyneq7K5gV/7IygTqsXYkSsZI3roQIN+fCtIMc4d
 vpDBpSSewAORC05lbd3lqkwtyw7V/3tj0kd5hLkUf5EZVEx0aCCazndGDc/D63MSMCP+
 FS7HGGjhGjDm+wEXU6w09IYBplnwoBQw31tjTGSe0SuFZcPgC7DxqrNK2ITd+otoxs// PA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2t9brthk7r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 Jun 2019 17:08:13 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5RH8Bq3044035;
        Thu, 27 Jun 2019 17:08:12 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 2t9acdca0g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 Jun 2019 17:08:12 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x5RH8A27011733;
        Thu, 27 Jun 2019 17:08:10 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 27 Jun 2019 10:08:10 -0700
Date:   Thu, 27 Jun 2019 10:08:09 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Sasha Levin <sashal@kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Subject: Re: [STABLE 4.19] fixes for xfs memory and fs corruption
Message-ID: <20190627170809.GD5179@magnolia>
References: <155009104740.32028.193157199378698979.stgit@magnolia>
 <20190213205804.GE32253@magnolia>
 <CAOQ4uximAfJjNdunY2xK_1DwC2G7v31XWbv64AdO9nYdExUsVw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uximAfJjNdunY2xK_1DwC2G7v31XWbv64AdO9nYdExUsVw@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9301 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906270197
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9301 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906270196
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jun 27, 2019 at 07:12:48PM +0300, Amir Goldstein wrote:
> Darrick,
> 
> Can I have your blessing on the choice of these upstream commits
> as stable candidates?
> I did not observe any xfstests regressions when testing v4.19.55
> with these patches applied.

All four commits look reasonable to me. :)

--D

> Sasha,
> 
> Can you run these patches though your xfstests setup?
> They fix nasty bugs.
> 
> Make sure to update xfsprogs to very latest, because
> generic/530 used to blow up (OOM) my test machine...
> 
> >
> > The first patch fixes a memory corruption that syzkaller found in the
> > attr listent code;
> 
> 3b50086f0c0d xfs: don't overflow xattr listent buffer
> 
> > see "generic: posix acl extended attribute memory
> > corruption test" for the relevant regression test.
> 
> Fixed generic/529
> 
> >
> > Patches 2 fixes problems found in XFS's unlinked inode recovery code
> > that were unearthed by some new testcases.  We're logging nlink==1 temp
> > files on the iunlinked list (and then the vfs sets nlink to 0 without
> > telling us) which means that we leak them in recovery if we crash
> > immediately after the committing the creation of the temp file.
> >
> > Patch 3 fixes the problem that ifree during recovery can expand the
> > finobt but we need to force the ifree code to reserve blocks for the
> > transaction because perag reservations aren't set up yet.
> 
> e1f6ca113815 xfs: rename m_inotbt_nores to m_finobt_nores
> 15a268d9f263 xfs: reserve blocks for ifree transaction during log recovery
> c4a6bf7f6cc7 xfs: don't ever put nlink > 0 inodes on the unlinked list
> 
> >
> > See "[PATCH v2 2/2] generic: check the behavior of programs opening a
> > lot of O_TMPFILE files" for the regression test.
> >
> 
> Fixes generic/530
> 
> Thanks,
> Amir.
