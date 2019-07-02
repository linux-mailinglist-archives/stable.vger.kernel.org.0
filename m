Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F11155C6F1
	for <lists+stable@lfdr.de>; Tue,  2 Jul 2019 04:09:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726434AbfGBCJh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jul 2019 22:09:37 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:47672 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726362AbfGBCJh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Jul 2019 22:09:37 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6228pek195172;
        Tue, 2 Jul 2019 02:09:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=lXB2umxm4Qxv5Jy6JF1w9qFRyfyBm2ed0ppYjC/gkXs=;
 b=czWLyvqqHGd12bl13IG+KBmPKJ1vm3zTRakmWxBDGZo3Z1HQhQY0jOpEstB0hWYp/kHi
 k9pvXt3M1bQhtqYRJO43DgFxfZfM0BnZvCXQ8Hnch78Ehc+t0G2n2+cEhEnct3PPqHVV
 JrVVK59qPNCg6S/vZY6HrsXLU0XK/nbfsuuRls9/31Bi2gdtCBxxNUjXO+rMk+fwpEot
 hBwuekxknCD/cSeIGXa8/wHUekSr28UoAi5AkqXYrSiMDqr9PyPN30cG+FYpt412fzfv
 lG73z9C8s/LG2CKYBtqTq0g8Ew8R8PalL9aXYHFUf5OCvZplWHYrk30HUuMwfxdj9EjC pQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2te61e0nbu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 02 Jul 2019 02:09:31 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6228PI0117335;
        Tue, 2 Jul 2019 02:09:30 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2tebku060s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 02 Jul 2019 02:09:30 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x6229SwQ025233;
        Tue, 2 Jul 2019 02:09:29 GMT
Received: from bostrovs-us.us.oracle.com (/10.152.32.65)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 01 Jul 2019 19:09:28 -0700
Date:   Mon, 1 Jul 2019 22:09:51 -0400
From:   Boris Ostrovsky <boris.ostrovsky@oracle.com>
To:     Juergen Gross <jgross@suse.com>
Cc:     xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        Stefano Stabellini <sstabellini@kernel.org>,
        stable@vger.kernel.org
Subject: Re: [PATCH] xen/events: fix binding user event channels to cpus
Message-ID: <20190702020951.GA8003@bostrovs-us.us.oracle.com>
References: <20190621184703.17108-1-jgross@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190621184703.17108-1-jgross@suse.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9305 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1907020019
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9305 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1907020020
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jun 21, 2019 at 08:47:03PM +0200, Juergen Gross wrote:
> When binding an interdomain event channel to a vcpu via
> IOCTL_EVTCHN_BIND_INTERDOMAIN not only the event channel needs to be
> bound, but the affinity of the associated IRQi must be changed, too.
> Otherwise the IRQ and the event channel won't be moved to another vcpu
> in case the original vcpu they were bound to is going offline.
> 
> Cc: <stable@vger.kernel.org> # 4.13
> Fixes: c48f64ab472389df ("xen-evtchn: Bind dyn evtchn:qemu-dm interrupt to next online VCPU")
> Signed-off-by: Juergen Gross <jgross@suse.com>

Reviewed-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>

