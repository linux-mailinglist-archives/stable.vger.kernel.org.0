Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 468703EDC34
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 19:17:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230351AbhHPRS2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 13:18:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:35608 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229761AbhHPRS2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Aug 2021 13:18:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6BD2D6054E;
        Mon, 16 Aug 2021 17:17:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629134276;
        bh=IBjQ2hhW6a6ZbDmFSNRMf689ze6D1w9iG/hdqVz0zw0=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=uahEmHkI86CByX/PbR+s4wRzyLPZOA+WtfdbH/wL9aSwRB/KwyPTRWnbB/Ee7j1Ap
         rxpEwLiF7rkeB1TqErTXEyKaOOpPVeiJy+C38BIOmPqKQfw9Sb9c2zP+eHXYYApRIZ
         EkUXeG+Lq44gPRkM5K0HVGKHuSNjHXA85e73oxzfopVFEZM1mnWj1JGCHOwAGIiU6M
         08JvjPMg+eJ2BgrOUeyDDHBnaIIBQ0ax2AZH33m8U3E6s0qSGCNb5qjr1BkFGcL9cL
         /khAISWphgOj7qGoZ2Mq0xQ7BlJghyBkrnhmpBCZ6IBPlV5Xb07jKu+FQtZFhTePvs
         XtmjzNqbOGEPg==
Subject: Re: [PATCH 5.13 046/151] interconnect: qcom: icc-rpmh: Add BCMs to
 commit list in pre_aggregate
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, Mike Tipton <mdtipton@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
References: <20210816125444.082226187@linuxfoundation.org>
 <20210816125445.588155407@linuxfoundation.org>
From:   Georgi Djakov <djakov@kernel.org>
Message-ID: <56b19dc0-b5b0-accb-956d-1a817444ca04@kernel.org>
Date:   Mon, 16 Aug 2021 20:17:52 +0300
MIME-Version: 1.0
In-Reply-To: <20210816125445.588155407@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 16.08.21 16:01, Greg Kroah-Hartman wrote:
> From: Mike Tipton <mdtipton@codeaurora.org>
> 
> [ Upstream commit f84f5b6f72e68bbaeb850b58ac167e4a3a47532a ]
> 
> We're only adding BCMs to the commit list in aggregate(), but there are
> cases where pre_aggregate() is called without subsequently calling
> aggregate(). In particular, in icc_sync_state() when a node with initial
> BW has zero requests. Since BCMs aren't added to the commit list in
> these cases, we don't actually send the zero BW request to HW. So the
> resources remain on unnecessarily.
> 
> Add BCMs to the commit list in pre_aggregate() instead, which is always
> called even when there are no requests.
> 
> Fixes: 976daac4a1c5 ("interconnect: qcom: Consolidate interconnect RPMh support")
> Signed-off-by: Mike Tipton <mdtipton@codeaurora.org>
> Link: https://lore.kernel.org/r/20210721175432.2119-5-mdtipton@codeaurora.org
> Signed-off-by: Georgi Djakov <djakov@kernel.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>

Hello Greg and Sasha,

Please drop this patch from both 5.10 and 5.13 stable queues. It's
causing issues on some platforms and we are reverting in. Revert is
in linux-next already.

Thanks,
Georgi
