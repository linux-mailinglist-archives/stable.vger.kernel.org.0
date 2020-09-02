Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EBA025A223
	for <lists+stable@lfdr.de>; Wed,  2 Sep 2020 02:01:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726193AbgIBABz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 20:01:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726173AbgIBABy (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Sep 2020 20:01:54 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67582C061244
        for <stable@vger.kernel.org>; Tue,  1 Sep 2020 17:01:54 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id o20so1788485pfp.11
        for <stable@vger.kernel.org>; Tue, 01 Sep 2020 17:01:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=SUd5OBWmb4twpsDXcovuk1+7mDMags4RX62eeDKc/j4=;
        b=SIPn8cavJLZmGaqVbpSzNC79gtGkxz7L8SNrd1P28xvoptEqQGw4rDZs4+azyE0Vn3
         lH+/QkjXfGcA8S0+Iz0Z9ETZXh+hl+IVW1jgJP4pjOV9z4dgb+dFHGbDDcqURQ5niZtn
         ag1p/zowYHvS4DO2NVk0LHefLkYprvIdjbYTQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=SUd5OBWmb4twpsDXcovuk1+7mDMags4RX62eeDKc/j4=;
        b=ArMrc/jj0rPx7oj2dTb8XBiGJjNQP+uJ9JWcdD8xihFXFd814bjX9fkAEqYSMWgCzJ
         N791Z6fW8J8HZ5ChtJyYPYiD7mgzgTLQOCQ8ozg9IKajAN5rQuXIyrt7MIuCE9yEnpw+
         SYyeFGiUzXlutiPuWMm0QQYcZ9b6A2lalL2pLMBDVNglGnJiLK/ErK8ea4CylcXdft0J
         ec5eiw66IWBIe+ve/mx9hOUsi+FS1ag1XcU0vwspGyE48D/+0krHjzUw3TPmS+hM4lDy
         XyUk129KBscUA1aVgkIIH+e2OgxjlSipm2DXM0sFv+2q1KGOPiCI1ew5bFmP+sQe6Fe+
         taUg==
X-Gm-Message-State: AOAM533lLEjrrQdXtrLlZat3YsjeQ4wSuWOmu9xTpiG0jbXGRvCco9ME
        Ib7m36y30AL0QuMRS95j/ffi5esIOT1+eA==
X-Google-Smtp-Source: ABdhPJzPaKvhg/U0wjf0jcoHxmLVETNP2MUiSLNBY70mczbJJMMlqJTGY+Qvfmv/G9cyo+zxoeOxCw==
X-Received: by 2002:a63:541e:: with SMTP id i30mr3684911pgb.47.1599004913647;
        Tue, 01 Sep 2020 17:01:53 -0700 (PDT)
Received: from [10.230.128.89] ([192.19.228.250])
        by smtp.gmail.com with ESMTPSA id g32sm3152900pgl.89.2020.09.01.17.01.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Sep 2020 17:01:52 -0700 (PDT)
Subject: Re: [PATCH] nvme: Revert: Fix controller creation races with teardown
 flow
To:     Sagi Grimberg <sagi@grimberg.me>, linux-nvme@lists.infradead.org
Cc:     Israel Rukshin <israelr@mellanox.com>, stable@vger.kernel.org,
        Keith Busch <kbusch@kernel.org>,
        Max Gurtovoy <maxg@mellanox.com>,
        Christoph Hellwig <hch@lst.de>
References: <20200828190150.34455-1-james.smart@broadcom.com>
 <0867c437-1521-c0c9-d7fa-6a615d88105a@grimberg.me>
 <a73cd06b-b319-d55f-1465-4263e08900ae@broadcom.com>
 <741ec2a7-7a38-9432-33fb-58227bf1f1f1@grimberg.me>
 <7f43e9db-974a-5e98-76a6-ed2f3bd0dc92@broadcom.com>
 <4aaad97e-03b5-5c22-af8e-ae7624e78991@grimberg.me>
 <f7d0c08f-2a34-fffa-7962-d0641bc579fd@broadcom.com>
 <7e78b2e6-d103-23a1-a9ab-d12336a9c089@grimberg.me>
From:   James Smart <james.smart@broadcom.com>
Message-ID: <e1df5a4a-702e-eea0-d52d-ec5f0de1422d@broadcom.com>
Date:   Tue, 1 Sep 2020 17:01:50 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.2.0
MIME-Version: 1.0
In-Reply-To: <7e78b2e6-d103-23a1-a9ab-d12336a9c089@grimberg.me>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 9/1/2020 3:01 PM, Sagi Grimberg wrote:
>
> But you also return back &ctrl->ctrl, that is another dereference, and
> what will make ctrl to be an ERR_PTR?
>
> Anyway, we should probably come up with something more robust...

ok

>
>> not sure what you are asking.   if it's how long to fail the creation 
>> of a new association - it's at least 60s (an admin command timeout).
>
> That's the worst case (admin command timeout), but is it the most common
> case?
>

Yes - as it currently corresponds to packet drops.  command failures are 
rare. FC has a feature to speed this up but it's not widely implemented yet.

> Would making the timeouts shorter in the initial connect make sense?
> Just throwing out ideas...

I'd enjoy a reduced time regardless. But the main concern is how long we 
have the systemd processes blocked.

-- james

