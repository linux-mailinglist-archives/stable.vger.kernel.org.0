Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D234A5650A8
	for <lists+stable@lfdr.de>; Mon,  4 Jul 2022 11:24:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232580AbiGDJYA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jul 2022 05:24:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233379AbiGDJX4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Jul 2022 05:23:56 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 66C1CBCB3
        for <stable@vger.kernel.org>; Mon,  4 Jul 2022 02:23:55 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 816CD23A;
        Mon,  4 Jul 2022 02:23:55 -0700 (PDT)
Received: from bogus (unknown [10.57.39.193])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D6BB03F792;
        Mon,  4 Jul 2022 02:23:53 -0700 (PDT)
Date:   Mon, 4 Jul 2022 10:22:43 +0100
From:   Sudeep Holla <sudeep.holla@arm.com>
To:     Jackie Liu <liuyun01@kylinos.cn>
Cc:     linux-arm-kernel@lists.infradead.org, luriwen@kylinos.cn,
        15815827059@163.com, cristian.marussi@arm.com,
        huhai <huhai@kylinos.cn>, stable@vger.kernel.org
Subject: Re: [PATCH] firmware: arm_scpi: Ensure scpi_info is not assigned if
 the probe fails
Message-ID: <20220704092243.rzk6l3rhjul4wavq@bogus>
References: <20220701160310.148344-1-sudeep.holla@arm.com>
 <bf21d317-8d4b-e237-86b7-be577b5bc652@kylinos.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <bf21d317-8d4b-e237-86b7-be577b5bc652@kylinos.cn>
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 04, 2022 at 09:19:56AM +0800, Jackie Liu wrote:
> Hi Sudeep.
> 
> Thanks for your patch, It's look good to me.
> 
> Reviewed-by: Jackie Liu <liuyun01@kylinos.cn>
> 
> 在 2022/7/2 00:03, Sudeep Holla 写道:
> > When scpi probe fails, at any point, we need to ensure that the scpi_info
> > is not set and will remain NULL until the probe succeeds. If it is not
> > taken care, then it could result in kernel panic with a NULL pointer
> > dereference.
> 
> I think the null pointer reference is not correct. It should be UAF. The
> logic is as follows:
>

Right, I will update the commit message, sorry for that got carried away by
the message in the kernel panic.

> scpi_info = devm_zalloc
> 
> After that if fails, the address will be released, but scpi_info is not
> NULL. Normal, there will be no problem, because scpi_info is alloc by
> kzalloc, so even if scpi_info is not NULL, but scpi_info->scpi_ops is
> NULL, It still work normally.
>
> But if another process or thread alloc a new data, if they are same address,
> and then it is assigned a value, so wild pointer scpi_info->scpi_ops is not
> NULL now, Then, Panic.
> 

I do understand that, I will update the commit log to cover these and
thanks for the review.

-- 
Regards,
Sudeep
