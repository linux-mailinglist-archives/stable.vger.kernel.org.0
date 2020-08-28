Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64584256102
	for <lists+stable@lfdr.de>; Fri, 28 Aug 2020 21:08:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726460AbgH1TIv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Aug 2020 15:08:51 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:33927 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726141AbgH1TIu (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 Aug 2020 15:08:50 -0400
Received: by mail-pf1-f193.google.com with SMTP id g207so1123035pfb.1
        for <stable@vger.kernel.org>; Fri, 28 Aug 2020 12:08:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=XM8dt+Eo2K0S9fXx+j818YEhd/W3DzDGMLAUALGK5fw=;
        b=pmFfNF7G8VnuVVJaQqgQWrUEjoescFuCFMdCdoxmUiFqm8aF9ZkLLh8TKHdu9BAGA0
         gZD+44Jpf7Tu9Wo5U+tPLYPgW/zWFXrViueBZnVr4YC4rBdoNTpmUE5e064udgwPq4O3
         q9n8WmnKwAFGVxisH3QKEpVls4H0p9AzZ7h3rWjIUA+foHThbPdFEZj3jq47rKqlXMMC
         /rdBYx46/XpcCYukm9AhX8Bkn+7oHK4Bl6fnn7B6Q0oDinumzKEhqDqcv1XxNonQCfZz
         dfxKu1LGExURlz40duWOHx33iIfWxPak0HgJIRsRR+okvhYTLqsnzXI3FbvEraMUTeWe
         qa7A==
X-Gm-Message-State: AOAM533Qyfne5wRy1nls52WyrD2cDN26a0StWFIjXIMpaiVxzMEFipar
        xCDRWJiREuzL0yALTQHjgWk=
X-Google-Smtp-Source: ABdhPJw3fNGYkWJlxTYNNAfR9zKd2lAO+Ga5l/So2hSewQFnDJPIFzyi9BIUwWiqaXd6RC4CajDxMQ==
X-Received: by 2002:a65:60ce:: with SMTP id r14mr180818pgv.85.1598641729827;
        Fri, 28 Aug 2020 12:08:49 -0700 (PDT)
Received: from ?IPv6:2601:647:4802:9070:c4b8:3871:4bc4:154f? ([2601:647:4802:9070:c4b8:3871:4bc4:154f])
        by smtp.gmail.com with ESMTPSA id c5sm248462pgj.0.2020.08.28.12.08.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 28 Aug 2020 12:08:49 -0700 (PDT)
Subject: Re: [PATCH] nvme: Revert: Fix controller creation races with teardown
 flow
To:     James Smart <james.smart@broadcom.com>,
        linux-nvme@lists.infradead.org
Cc:     Israel Rukshin <israelr@mellanox.com>, stable@vger.kernel.org,
        Keith Busch <kbusch@kernel.org>,
        Max Gurtovoy <maxg@mellanox.com>,
        Christoph Hellwig <hch@lst.de>
References: <20200828190150.34455-1-james.smart@broadcom.com>
From:   Sagi Grimberg <sagi@grimberg.me>
Message-ID: <0867c437-1521-c0c9-d7fa-6a615d88105a@grimberg.me>
Date:   Fri, 28 Aug 2020 12:08:47 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200828190150.34455-1-james.smart@broadcom.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


> The indicated patch introduced a barrier in the sysfs_delete attribute
> for the controller that rejects the request if the controller isn't
> created. "Created" is defined as at least 1 call to nvme_start_ctrl().
> 
> This is problematic in error-injection testing.  If an error occurs on
> the initial attempt to create an association and the controller enters
> reconnect(s) attempts, the admin cannot delete the controller until
> either there is a successful association created or ctrl_loss_tmo
> times out.
> 
> Where this issue is particularly hurtful is when the "admin" is the
> nvme-cli, it is performing a connection to a discovery controller, and
> it is initiated via auto-connect scripts.  With the FC transport, if the
> first connection attempt fails, the controller enters a normal reconnect
> state but returns control to the cli thread that created the controller.
> In this scenario, the cli attempts to read the discovery log via ioctl,
> which fails, causing the cli to see it as an empty log and then proceeds
> to delete the discovery controller. The delete is rejected and the
> controller is left live. If the discovery controller reconnect then
> succeeds, there is no action to delete it, and it sits live doing nothing.

This is indeed a regression.

Perhaps we should also revert:
12a0b6622107 ("nvme: don't hold nvmf_transports_rwsem for more than 
transport lookups")

Which inherently caused this by removing the serialization of
.create_ctrl()...
