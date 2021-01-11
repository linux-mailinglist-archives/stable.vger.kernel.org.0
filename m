Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 345672F186B
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 15:39:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728623AbhAKOiu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 09:38:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727984AbhAKOit (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jan 2021 09:38:49 -0500
Received: from mail.kapsi.fi (mail.kapsi.fi [IPv6:2001:67c:1be8::25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60DB1C061786;
        Mon, 11 Jan 2021 06:38:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=kapsi.fi;
         s=20161220; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:
        MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=Ixsfk5NwQACytWv/iH7/K21zegLffRIyRkNvUq/GHSI=; b=FL+aKR9e5W+KUyeSOR3QP01kCJ
        3Fzf4i0EE9fMDz5UmtBuPYNSIOpTj/9MXCNPOxA9nUJkMO8ZqjEwiEDpZhuYiXMwXBSl0hGUhH1LF
        Le2jdTJ13B+m3kltnOGiY2ocrtYUocHkeW/uMFfw00F+d5i20DX4cDRu/obuUFZpS/Ix3miQFsS0Z
        qOLP1LbDwmYG5gdqBa1nJrZQXj26a/+GXHndDlX0eyTKm39iQYoyTTrHo+qEydMWSMUuoOLSUzgPe
        e4ylBVbXaals04IRIN2nAcfm5vF5VmUmbuW6oPDBZpSSDUy5BqezxyDQsUK277wU2OiKxYHAIea3P
        7WfS63yA==;
Received: from dsl-hkibng22-54f986-236.dhcp.inet.fi ([84.249.134.236] helo=[192.168.1.10])
        by mail.kapsi.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.89)
        (envelope-from <cyndis@kapsi.fi>)
        id 1kyyKd-0005Qp-Ex; Mon, 11 Jan 2021 16:38:07 +0200
Subject: Re: [PATCH] i2c: tegra: Wait for config load atomically while in ISR
To:     David Laight <David.Laight@ACULAB.COM>,
        'Mikko Perttunen' <mperttunen@nvidia.com>,
        "ldewangan@nvidia.com" <ldewangan@nvidia.com>,
        "digetx@gmail.com" <digetx@gmail.com>,
        "thierry.reding@gmail.com" <thierry.reding@gmail.com>,
        "jonathanh@nvidia.com" <jonathanh@nvidia.com>,
        "wsa@kernel.org" <wsa@kernel.org>
Cc:     "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
References: <20210111135547.3613092-1-mperttunen@nvidia.com>
 <a0b0f224c2864b80a5bac53646d67daf@AcuMS.aculab.com>
From:   Mikko Perttunen <cyndis@kapsi.fi>
Message-ID: <9ba3d704-674b-94df-d10f-e3edb3c695d6@kapsi.fi>
Date:   Mon, 11 Jan 2021 16:38:06 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <a0b0f224c2864b80a5bac53646d67daf@AcuMS.aculab.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 84.249.134.236
X-SA-Exim-Mail-From: cyndis@kapsi.fi
X-SA-Exim-Scanned: No (on mail.kapsi.fi); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Agreed that this is possibly not optimal, but this patch simply returns 
the behavior to what it was before "i2c: tegra: Support atomic 
transfers", fixing the overt issue.

Design fixes can be considered later, in a non-stable patch.

Mikko

On 1/11/21 4:31 PM, David Laight wrote:
> From: Mikko Perttunen
>> Sent: 11 January 2021 13:56
>>
>> Upon a communication error, the interrupt handler can call
>> tegra_i2c_disable_packet_mode. This causes a sleeping poll to happen
>> unless the current transaction was marked atomic. Since
>> tegra_i2c_disable_packet_mode is only called from the interrupt path,
>> make it use atomic waiting always.
> 
> Spin-waiting in an ISR for anything that it makes sense to do
> a sleep-wait for at other times is badly broken design.
> 
> 	David
> 
> -
> Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
> Registration No: 1397386 (Wales)
> 
