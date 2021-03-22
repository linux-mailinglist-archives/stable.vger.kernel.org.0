Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DE24343AA4
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 08:34:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229760AbhCVHeQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 03:34:16 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:33054 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229665AbhCVHdw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Mar 2021 03:33:52 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12M7U80T008974;
        Mon, 22 Mar 2021 07:33:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=ZAfDjcEFlK46WfpvHzKLQiUHKKe+9veHjui7gcLUIOI=;
 b=qmIQBxwUQFYU4r09Q9qBLZyDgN/qVOfmBCTRS9YjVPFlauLCz3v73oscCIsj25/TfD+U
 A1+DXM+dPYZKTMrHejvnOp2dHk9wHgnXka7ZhQew9L4ByV7Ot/X0GXs6ETHUd15CcaZ2
 uCECCvQvJwSW3zFvvdg5TWSRaGQyqP7FE15iRvIh4QPyLMKpFjfQIN7or7JPW1baL1y1
 0rbnZN71eVQ6erXRRUemo0QI1COCBPCA9bqc3eHzRqOMD+rlJApjWOj19KoXzF+NseSv
 wKtB7rTuzUm/62pzoiDzedSYu8n9lwHJhetHxnaNdTj7M7JX6DW+9qxlNHilhRd3G1L6 iQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 37d6jbaptn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 22 Mar 2021 07:33:13 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12M7UXci069828;
        Mon, 22 Mar 2021 07:33:11 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 37dtyvrhje-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 22 Mar 2021 07:33:11 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 12M7X94j022561;
        Mon, 22 Mar 2021 07:33:09 GMT
Received: from kadam (/102.36.221.92)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 22 Mar 2021 00:33:08 -0700
Date:   Mon, 22 Mar 2021 10:33:01 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-crypto@vger.kernel.org, Neil Horman <nhorman@tuxdriver.com>,
        Corentin Labbe <clabbe@baylibre.com>, stable@vger.kernel.org
Subject: Re: [PATCH] crypto: rng - fix crypto_rng_reset() refcounting when
 !CRYPTO_STATS
Message-ID: <20210322073300.GF1667@kadam>
References: <20210322050748.265604-1-ebiggers@kernel.org>
 <20210322054522.GC1667@kadam>
 <YFgyaeeY6k6Pltw7@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YFgyaeeY6k6Pltw7@sol.localdomain>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-IMR: 1
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9930 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 phishscore=0
 mlxlogscore=999 suspectscore=0 spamscore=0 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103220056
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9930 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0
 lowpriorityscore=0 suspectscore=0 clxscore=1015 priorityscore=1501
 spamscore=0 adultscore=0 impostorscore=0 mlxlogscore=999 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103220056
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Mar 21, 2021 at 11:00:09PM -0700, Eric Biggers wrote:
> On Mon, Mar 22, 2021 at 08:45:22AM +0300, Dan Carpenter wrote:
> > On Sun, Mar 21, 2021 at 10:07:48PM -0700, Eric Biggers wrote:
> > > From: Eric Biggers <ebiggers@google.com>
> > > 
> > > crypto_stats_get() is a no-op when the kernel is compiled without
> > > CONFIG_CRYPTO_STATS, so pairing it with crypto_alg_put() unconditionally
> > > (as crypto_rng_reset() does) is wrong.
> > > 
> > 
> > Presumably the intention was that _get() and _put() should always pair.
> > It's really ugly and horrible that they don't. We could have
> > predicted bug like this would happen and will continue to happen until
> > the crypto_stats_get() is renamed.
> > 
> 
> Well, the crypto stats stuff has always been pretty broken, so I don't think
> people have looked at it too closely.  Currently crypto_stats_get() pairs with
> one of the functions that tallies the statistics, such as
> crypto_stats_rng_seed() or crypto_stats_aead_encrypt().  What change are you
> suggesting, exactly?  Maybe moving the conditional crypto_alg_put() into a new
> function crypto_stats_put() and moving it into the callers?  Or do you think the
> functions should just be renamed to something like crypto_stats_begin() and
> crypto_stats_end_{rng_seed,aead_encrypt}()?

To be honest, I misread the crypto_alg_put() thinking that it was
crypto_*stats*_put().  My favourite fix would be to introduce a
crypto_stats_put() which is a mirror of crypto_stats_get() and ifdeffed
out if we don't have CONFIG_CRYPTO_STATS.

regards,
dan carpenter

