Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1541D3438C5
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 06:46:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229647AbhCVFqP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 01:46:15 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:37258 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229621AbhCVFqE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Mar 2021 01:46:04 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12M5isjs043843;
        Mon, 22 Mar 2021 05:45:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=6lqeceNwNjvLIvI4KG2Mzz1t5DsQN3/hObHOkdaqajk=;
 b=BPFsK4L7FOeZ5xC1VGWYZ6uRVeYG1eLYglHjoFQYCFnFsYv1vyyMPEV4/cOxM6FC9rmd
 W3Djc+YxxpJeQT5/I5VGkDkXNc2zRmX+vX8+UnHyqh4BjK7pUQ92mDatjQSihLkRmY3a
 dNvB6WFD2L5cZsSko6+d+lw1zoTdIiIjAoJnZChu5YTfq7q6Bk1qvvseVwRyr5f+K/q/
 /NwnUzUNntw8YqeQg+wM19+Kky4YPYHsFBlVS5RCHJImVMMFMtOOyW7OLNNcWeDFNh3g
 oO2pO/LrdaM27ZQgD5FZQ3JJWIPih04Rv2aKAPtue/Lq2nmrfi2mESnX26zXiAh2UJZ0 1A== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 37d8fr2cbd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 22 Mar 2021 05:45:33 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12M5eHj5129213;
        Mon, 22 Mar 2021 05:45:31 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 37dtxwj09v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 22 Mar 2021 05:45:31 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 12M5jUZE018654;
        Mon, 22 Mar 2021 05:45:30 GMT
Received: from kadam (/102.36.221.92)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 21 Mar 2021 22:45:29 -0700
Date:   Mon, 22 Mar 2021 08:45:22 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-crypto@vger.kernel.org, Neil Horman <nhorman@tuxdriver.com>,
        Corentin Labbe <clabbe@baylibre.com>, stable@vger.kernel.org
Subject: Re: [PATCH] crypto: rng - fix crypto_rng_reset() refcounting when
 !CRYPTO_STATS
Message-ID: <20210322054522.GC1667@kadam>
References: <20210322050748.265604-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210322050748.265604-1-ebiggers@kernel.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-IMR: 1
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9930 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 malwarescore=0 phishscore=0 bulkscore=0 mlxscore=0 suspectscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103220044
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9930 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 priorityscore=1501
 impostorscore=0 spamscore=0 mlxscore=0 suspectscore=0 mlxlogscore=999
 phishscore=0 bulkscore=0 adultscore=0 malwarescore=0 clxscore=1011
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103220045
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Mar 21, 2021 at 10:07:48PM -0700, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> crypto_stats_get() is a no-op when the kernel is compiled without
> CONFIG_CRYPTO_STATS, so pairing it with crypto_alg_put() unconditionally
> (as crypto_rng_reset() does) is wrong.
> 

Presumably the intention was that _get() and _put() should always pair.
It's really ugly and horrible that they don't. We could have
predicted bug like this would happen and will continue to happen until
the crypto_stats_get() is renamed.

regards,
dan carpenter

