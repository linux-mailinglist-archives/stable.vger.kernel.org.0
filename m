Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A64B321118
	for <lists+stable@lfdr.de>; Mon, 22 Feb 2021 08:02:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229925AbhBVHCI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Feb 2021 02:02:08 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:12198 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229780AbhBVHCH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Feb 2021 02:02:07 -0500
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4DkY2J0qBDzlNMY;
        Mon, 22 Feb 2021 14:59:20 +0800 (CST)
Received: from [10.67.110.218] (10.67.110.218) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.498.0; Mon, 22 Feb 2021 15:01:13 +0800
Subject: Re: [PATCH 4.4.257 0/1] Bugfix for ad4740ceccfb ("futex: Avoid
 violating the 10th rule of futex")
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     <stable@vger.kernel.org>, <judy.chenhui@huawei.com>,
        <zhangjinhao2@huawei.com>, <lee.jones@linaro.org>,
        <tglx@linutronix.de>, <cj.chengjian@huawei.com>
References: <20210222040618.2911498-1-zhengyejian1@huawei.com>
 <YDNR6dsqrAxUa6Jz@kroah.com>
From:   "Zhengyejian (Zetta)" <zhengyejian1@huawei.com>
Message-ID: <efffd6d1-4e37-7e0c-babf-3986e007d90a@huawei.com>
Date:   Mon, 22 Feb 2021 15:01:12 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <YDNR6dsqrAxUa6Jz@kroah.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.110.218]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 2021/2/22 14:40, Greg KH wrote:
> On Mon, Feb 22, 2021 at 12:06:17PM +0800, Zheng Yejian wrote:
>> *** BLURB HERE ***
> 
> No blurb?  Why is this needed?
> 
> .
> 

This patch may fix the following bug:

Link:
https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/tree/kernel/futex.c?h=linux-4.4.y&id=788437ba4c80d0d5e32ceaa28f872343e87236f5

     > static int __fixup_pi_state_owner(u32 __user *uaddr, struct 
futex_q *q,
     > 				  struct task_struct *argowner)
     > {
     > 	struct futex_pi_state *pi_state = q->pi_state;
     > 	struct task_struct *oldowner, *newowner;
     > 	u32 uval, curval, newval, newtid;
     > 	int err = 0;
     >
     > 	oldowner = pi_state->owner;
     >
     > 	/* Owner died? */
     > 	if (!pi_state->owner)
     > 		newtid |= FUTEX_OWNER_DIED;
Variable "newtid" is used without initialized.
