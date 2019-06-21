Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C0754F00B
	for <lists+stable@lfdr.de>; Fri, 21 Jun 2019 22:35:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726045AbfFUUfy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Jun 2019 16:35:54 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:47054 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725985AbfFUUfy (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 Jun 2019 16:35:54 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5LKSjW7026390;
        Fri, 21 Jun 2019 20:35:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=I+O4EY7HfIDZE39+n2CmCAfAj+j4DjI6+VRejt3ADbY=;
 b=2XUw0+WuaZlgLzqQhtBCIiCzoi+wlHOjQN+qS0zOcckqz/FSlqlYKzM/xYUoTGhscT8P
 i4eChYLULBYCwbv9aQluGZSJQJvXDAo055D0l2Bkc5vC4GV1tF524Nh6ujkbyfyLS6Xo
 hGPlHfjvZToyk32fDnrfFxonc6ouDq5IO+uWOaRDTf432J3tc3ms1eEO/4nEmk/2ZNZK
 4zLuNVi0Vqwo9lbP7zLApBYiuBtHDBWbKsbCVx9snabs4GVz8eXD7ek8RXjWB6JHKkzv
 wbaOE4BbtHpNp/LGnfh65SCKroUA1ssLJrme+9GdvOlYaeP0ouCIXYXDpijrQiLv3Tjw Vg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2t7809r9qq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Jun 2019 20:35:28 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5LKXhAT064507;
        Fri, 21 Jun 2019 20:35:27 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2t77ypcvua-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Jun 2019 20:35:27 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x5LKZKKO003782;
        Fri, 21 Jun 2019 20:35:21 GMT
Received: from char.us.oracle.com (/10.152.32.25)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 21 Jun 2019 13:35:20 -0700
Received: by char.us.oracle.com (Postfix, from userid 1000)
        id 609E46A0131; Fri, 21 Jun 2019 16:36:45 -0400 (EDT)
Date:   Fri, 21 Jun 2019 16:36:45 -0400
From:   Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To:     Sasha Levin <sashal@kernel.org>
Cc:     zhe.he@windriver.com, konrad@darnok.org, hch@lst.de,
        stable@vger.kernel.org, m.szyprowski@samsung.com,
        robin.murphy@arm.com
Subject: Re: [PATCH v2] kernel/dma: Fix panic caused by passing swiotlb to
 command line
Message-ID: <20190621203645.GL22931@char.us.oracle.com>
References: <1543832571-121638-1-git-send-email-zhe.he@windriver.com>
 <20190614215638.A58C52184E@mail.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190614215638.A58C52184E@mail.kernel.org>
User-Agent: Mutt/1.9.1 (2017-09-22)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9295 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906210154
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9295 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906210154
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jun 14, 2019 at 09:56:37PM +0000, Sasha Levin wrote:
> Hi,
> 
> [This is an automated email]
> 
> This commit has been processed because it contains a -stable tag.
> The stable tag indicates that it's relevant for the following trees: all
> 
> The bot has tested the following trees: v5.1.9, v4.19.50, v4.14.125, v4.9.181, v4.4.181.
> 
> v5.1.9: Build OK!
> v4.19.50: Build OK!
> v4.14.125: Failed to apply! Possible dependencies:
>     Unable to calculate
> 
> v4.9.181: Failed to apply! Possible dependencies:
>     Unable to calculate
> 
> v4.4.181: Failed to apply! Possible dependencies:
>     ae7871be189c ("swiotlb: Convert swiotlb_force from int to enum")
>     b67a8b29df7e ("arm64: mm: only initialize swiotlb when necessary")
> 
> 
> How should we proceed with this patch?
> 

Skip.

> --
> Thanks,
> Sasha
