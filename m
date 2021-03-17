Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63C1B33F260
	for <lists+stable@lfdr.de>; Wed, 17 Mar 2021 15:16:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231266AbhCQOPq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Mar 2021 10:15:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231705AbhCQOPi (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Mar 2021 10:15:38 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2231C06174A;
        Wed, 17 Mar 2021 07:15:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Message-ID:From:CC:To:Subject:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:
        Date:Sender:Reply-To:Content-ID:Content-Description;
        bh=CMMz5R1TICGoardcIZbuQbx/IbDn7R6aDFEFgKeLLJw=; b=SgzSOzls4iI1qxq/PGJWPYRBFb
        rFE1EcVrfc1TpoiIoUGVJ204bhFGtx3WBPohUhVUEX/eHBcWyi1U9NZ5PyuZPqJyKJdeemTaCbIgX
        sLrB7QPQgpGFD8jrUDTf6MZLOmuL3W6CcGgOS2l3P5DZ28JBNSl126SXOVxMNQg2KqWl7crfFKOq7
        GNCBy1CGrI8zlYJ7YiIEKduV42jmovU4yYCRaV+YIDfVN1sD3kSROw5Mtt3x68MKLmep4V7k6uqpV
        8GE5wDZdNvKLCYvLbHgbT+o7KsYnkK4hxlvVx7Kq6Z8ZTOyeAra+yeim4JhwslpeXEdIir8gkNZPy
        EdNrJt6A==;
Received: from [2001:8b0:10b:1:6dbf:8591:24f9:c1c2]
        by desiato.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lMWxR-003EYd-9t; Wed, 17 Mar 2021 14:15:33 +0000
Date:   Wed, 17 Mar 2021 13:37:16 +0000
User-Agent: K-9 Mail for Android
In-Reply-To: <YFIE8xnr/HWqxm4p@8bytes.org>
References: <20210317091037.31374-1-joro@8bytes.org> <20210317091037.31374-3-joro@8bytes.org> <449d4a2d192d23eb504e43b13c35c326f2d0309a.camel@infradead.org> <YFIE8xnr/HWqxm4p@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH 2/3] iommu/amd: Don't call early_amd_iommu_init() when AMD IOMMU is disabled
To:     Joerg Roedel <joro@8bytes.org>
CC:     iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        Huang Rui <ray.huang@amd.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Xiaojian Du <xiaojian.du@amd.com>,
        Joerg Roedel <jroedel@suse.de>, stable@vger.kernel.org
From:   David Woodhouse <dwmw2@infradead.org>
Message-ID: <3014DA56-84D8-474B-94FE-6FDBB6241F9F@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by desiato.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 17 March 2021 13:32:35 GMT, Joerg Roedel <joro@8bytes=2Eorg> wrote:
>On Wed, Mar 17, 2021 at 11:47:11AM +0000, David Woodhouse wrote:
>> If you've already moved the Stoney Ridge check out of the way,
>there's
>> no real reason why you can't just set
>init_state=3DIOMMU_CMDLINE_DISABLED
>> directly from parse_amd_iommu_options(), is there? Then you don't
>need
>> the condition here at all?
>
>True, there is even more room for optimization=2E The amd_iommu_disabled
>variable can go away entirely, including its checks in
>early_amd_iommu_init()=2E I will do a patch-set on-top of this for v5=2E1=
3
>which does more cleanups=2E

If we can get to the point where we don't even need to check amd_iommu_irq=
_remap in the =2E=2E=2Eselect() function because the IRQ domain is never ev=
en registered in the case where the flag ends up false, all the better :)

--=20
Sent from my Android device with K-9 Mail=2E Please excuse my brevity=2E
