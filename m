Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C33FD24EA86
	for <lists+stable@lfdr.de>; Sun, 23 Aug 2020 02:11:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728704AbgHWALy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Aug 2020 20:11:54 -0400
Received: from gate.crashing.org ([63.228.1.57]:49551 "EHLO gate.crashing.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728434AbgHWALy (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 22 Aug 2020 20:11:54 -0400
Received: from gate.crashing.org (localhost.localdomain [127.0.0.1])
        by gate.crashing.org (8.14.1/8.14.1) with ESMTP id 07N0B38x017004;
        Sat, 22 Aug 2020 19:11:03 -0500
Received: (from segher@localhost)
        by gate.crashing.org (8.14.1/8.14.1/Submit) id 07N0B1Iw017003;
        Sat, 22 Aug 2020 19:11:01 -0500
X-Authentication-Warning: gate.crashing.org: segher set sender to segher@kernel.crashing.org using -f
Date:   Sat, 22 Aug 2020 19:11:01 -0500
From:   Segher Boessenkool <segher@kernel.crashing.org>
To:     Guohua Zhong <zhongguohua1@huawei.com>
Cc:     christophe.leroy@csgroup.eu, nixiaoming@huawei.com,
        wangle6@huawei.com, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        paulus@samba.org, linuxppc-dev@lists.ozlabs.org
Subject: Re: =?utf-8?B?UmXvvJpSZQ==?=
        =?utf-8?Q?=3A?= [PATCH] powerpc: Fix a bug in __div64_32 if divisor is zero
Message-ID: <20200823001101.GO28786@gate.crashing.org>
References: <8dedfcce-04e0-ec7d-6af5-ec1d6d8602b0@csgroup.eu> <20200822165433.58228-1-zhongguohua1@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200822165433.58228-1-zhongguohua1@huawei.com>
User-Agent: Mutt/1.4.2.3i
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Aug 23, 2020 at 12:54:33AM +0800, Guohua Zhong wrote:
> Yet, I have noticed that there is no checking of 'base' in these functions.
> But I am not sure how to check is better.As we know that the result is 
> undefined when divisor is zero. It maybe good to print error and dump stack.
>  Let the process to know that the divisor is zero by sending SIGFPE. 

That is now what the PowerPC integer divide insns do: they just leave
the result undefined (and they can set the overflow flag then, but no
one uses that).


Segher
