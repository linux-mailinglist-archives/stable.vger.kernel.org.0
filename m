Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 216153FEEFC
	for <lists+stable@lfdr.de>; Thu,  2 Sep 2021 15:52:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234331AbhIBNw5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Sep 2021 09:52:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:35134 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230473AbhIBNw4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Sep 2021 09:52:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8E270610A1;
        Thu,  2 Sep 2021 13:51:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630590717;
        bh=dgIzmPo1P6m2cyM7pyKV1/gksgOBtehkPWZag/5Vm6o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WlRyCrDfyqg/IC3joO7zvX3DBgpe35Fqn5W+UZB/Ra0RC1kJpbjjPriXozRfNOja8
         Zjicp2Dd4n5vCgIyrykcuK246FDkVuQApg06lPZJaY4HQokZMOo3oz81Omq83XJUYo
         zSp15enInSRmjp7wBTKxbcRpApjMHMyPMWtnrAN/zyh6VgHy2TYj/grT/ZD7jrZTb1
         bGbmjgBoQuDHsdcAlnzzUn52Ct82P36yQO/OWA/kZJSl0tf8AI6ba6c3q+GvS2ZB2Q
         XfP6CgvSGLkDinK6Z68A5zkPUlv3GD1zjJlmxe49vBgI3qEIbxe/VPblcKJ1z/iP5H
         V08PuN7GOfCnQ==
Date:   Thu, 2 Sep 2021 09:51:56 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Pavel Machek <pavel@denx.de>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 5.10 047/103] net: stmmac: add mutex lock to protect est
 parameters
Message-ID: <YTDW/KTUpKz6C771@sashalap>
References: <20210901122300.503008474@linuxfoundation.org>
 <20210901122302.156121465@linuxfoundation.org>
 <20210901200953.GB8962@duo.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210901200953.GB8962@duo.ucw.cz>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 01, 2021 at 10:09:53PM +0200, Pavel Machek wrote:
>Hi!
>
>> [ Upstream commit b2aae654a4794ef898ad33a179f341eb610f6b85 ]
>>
>> Add a mutex lock to protect est structure parameters so that the
>> EST parameters can be updated by other threads.
>
>Mainline version of the patch is okay, but I believe we need one more
>mutex_unlock in 5.10.

I think you're right. Looks like it's because we don't have 5a5586112b92
("net: stmmac: support FPE link partner hand-shaking procedure") in 5.10
(and I don't think it makes sense to backport it either).

I've squashed your patch into the backport, thanks!

-- 
Thanks,
Sasha
