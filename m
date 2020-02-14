Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E24CD15F783
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 21:12:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389326AbgBNUMK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 15:12:10 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:54520 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388948AbgBNUMK (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Feb 2020 15:12:10 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01EK8slH109372;
        Fri, 14 Feb 2020 20:11:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=SHVAUp+OJ3+OGTvce+XogHU7eHOaTVPHbznHopguoFU=;
 b=hpIhxdaLRRF+vo4c+1R1Bm9u9FORGZ3uHGUiF5etLzR2wdxDMsh1pgdgUFDnn5oEs3z8
 E4pIVycqyjszBMYO4UJl2ACvgpfn/w1/mhBQPrQQBc2ZqXEFAsO821au3FRdVZnXoFb3
 B76Ed/PdQX9fFfzqRT8VavTPFS+zByNagsCbplX5iWM4l8OLv3SR7/An6XQaeLBRgDqh
 eH+pP3XkXVXSrxQajiHs/8ozDvMmu4351EZ2lN8OgoWLfBXjdAGjipENS0NWutnqzmhl
 gxHA/Jv0N4JxN0gkdlGkYuX03GZI7AZb7DQG+j+XwCpTJEaw0HjlxPJdXV0AHDUi+frG xw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2y2k88uemb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 Feb 2020 20:11:55 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01EK7Zvs092152;
        Fri, 14 Feb 2020 20:09:54 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2y4k3e9320-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 Feb 2020 20:09:54 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 01EK9o6E012450;
        Fri, 14 Feb 2020 20:09:52 GMT
Received: from ca-dmjordan1.us.oracle.com (/10.211.9.48)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 14 Feb 2020 12:09:50 -0800
Date:   Fri, 14 Feb 2020 15:10:06 -0500
From:   Daniel Jordan <daniel.m.jordan@oracle.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Yang Yingliang <yangyingliang@huawei.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 091/195] padata: Remove broken queue flushing
Message-ID: <20200214201006.6qlfqillveotr47n@ca-dmjordan1.us.oracle.com>
References: <20200210122305.731206734@linuxfoundation.org>
 <20200210122314.217904406@linuxfoundation.org>
 <5E4674BB.4020900@huawei.com>
 <20200214152128.GC3959278@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200214152128.GC3959278@kroah.com>
User-Agent: NeoMutt/20180716
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9531 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 adultscore=0
 bulkscore=0 malwarescore=0 phishscore=0 suspectscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002140146
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9531 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 lowpriorityscore=0
 suspectscore=0 bulkscore=0 phishscore=0 mlxlogscore=999 mlxscore=0
 malwarescore=0 impostorscore=0 clxscore=1015 spamscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002140146
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 14, 2020 at 07:21:28AM -0800, Greg Kroah-Hartman wrote:
> So this causes a problem in the 4.19-rc tree but not in Linus's tree?
> Or am I confused?  Should it be dropped from stable or is there some
> other fix-of-a-fix that I need to apply here?

This causes a problem in 4.19.103 and 4.19-rc but not Linus's tree.

The fix-of-a-fix is posted recently here:

    https://lore.kernel.org/lkml/20200214182821.337706-1-daniel.m.jordan@oracle.com/

For 4.14, 4.9, and 4.4, I'm posting a revised version of "Remove broken queue
flushing" in each review thread.  4.14 is already up.  Is this what I should be
doing?

thanks,
Daniel
