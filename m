Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BB4129BD6F
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:49:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1799913AbgJ0Qgd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 12:36:33 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:40874 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1801800AbgJ0PoU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Oct 2020 11:44:20 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09RFTTXA008828;
        Tue, 27 Oct 2020 15:44:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : in-reply-to : message-id : references : mime-version :
 content-type; s=corp-2020-01-29;
 bh=ismCXTGOvFqyBCDE0+HN6RH2KMvDozegLmpusGyRFFE=;
 b=aa+misCN3rVRXXFm/g7L2QkS4ib0A+54qSj7r7HT4IXOEwhYl0iebSa2g1nO8CQWKvfS
 zKfmbG9m31C0nC8M5j6iJD0XPKxDevcqvWeKWAo8CJM+pSHWHmyuu5ho/5rScTZX+s4M
 Q/xJyOPo3Y/0AYgXbw/Iw9dEetpJ/++QxJD3us+CIJ2+XElynSYZNp/su3bhhsLMbEzm
 QNfAWLMoSckWXCCuzjS2VX/HhzpidEMA5SAs99rKJJOz2Wzt997aZdPqrGmj6KykMjfx
 2migkZqwLH5C2tM8GmieapF50T67V5bsJSBg8306xInpVWirZY++TNYTl7sBp8rihBhv Pg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 34c9satxvs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 27 Oct 2020 15:44:17 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09RFUjC1160272;
        Tue, 27 Oct 2020 15:42:17 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 34cwumhuhj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 27 Oct 2020 15:42:17 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 09RFgGWp019393;
        Tue, 27 Oct 2020 15:42:16 GMT
Received: from dhcp-10-175-161-9.vpn.oracle.com (/10.175.161.9)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 27 Oct 2020 08:42:16 -0700
Date:   Tue, 27 Oct 2020 15:42:10 +0000 (GMT)
From:   Alan Maguire <alan.maguire@oracle.com>
X-X-Sender: alan@localhost
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Alan Maguire <alan.maguire@oracle.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.8 574/633] selftests/bpf: Fix overflow tests to reflect
 iter size increase
In-Reply-To: <20201027135549.734594680@linuxfoundation.org>
Message-ID: <alpine.LRH.2.21.2010271538290.12876@localhost>
References: <20201027135522.655719020@linuxfoundation.org> <20201027135549.734594680@linuxfoundation.org>
User-Agent: Alpine 2.21 (LRH 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9786 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 bulkscore=0
 spamscore=0 adultscore=0 malwarescore=0 mlxlogscore=999 suspectscore=3
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010270097
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9786 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 malwarescore=0 lowpriorityscore=0 bulkscore=0
 priorityscore=1501 spamscore=0 phishscore=0 clxscore=1011 suspectscore=3
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010270097
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 27 Oct 2020, Greg Kroah-Hartman wrote:

> From: Alan Maguire <alan.maguire@oracle.com>
> 
> [ Upstream commit eb58bbf2e5c7917aa30bf8818761f26bbeeb2290 ]
> 
> bpf iter size increase to PAGE_SIZE << 3 means overflow tests assuming
> page size need to be bumped also.
>

Alexei can correct me if I've got this wrong but I don't believe
it's a stable backport candidate.

This selftests change should only be relevant when the BPF iterator
size has been bumped up as it was in

af65320 bpf: Bump iter seq size to support BTF representation of large 
data structures

...so I don't _think_ this commit belongs in stable unless the
above commit is backported also (and unless I'm missing something
I don't see a burning reason to do that currently).

Backporting this alone will likely induce bpf test failures.
Apologies if the "Fix" in the title was misleading; it should
probably have been "Update" to reflect the fact it's not fixing
an existing bug but rather updating the test to operate correctly
in the context of other changes in the for-next patch series
it was part of.
 
Thanks!

Alan
