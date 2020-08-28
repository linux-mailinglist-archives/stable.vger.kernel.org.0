Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8B432561F3
	for <lists+stable@lfdr.de>; Fri, 28 Aug 2020 22:24:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726379AbgH1UYP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Aug 2020 16:24:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726033AbgH1UYM (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 Aug 2020 16:24:12 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5628C061264
        for <stable@vger.kernel.org>; Fri, 28 Aug 2020 13:24:12 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id t9so1212432pfq.8
        for <stable@vger.kernel.org>; Fri, 28 Aug 2020 13:24:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=IDS3NnzgLo0jrRDnLv1X/fj0Kz/8LODkkhTNK4jyDRo=;
        b=VkgdNHjZq31Eigk47vi7CkDqjau+mhw53riN9wARNhROVsSn2/UUqRzJ4oh/vSrxQx
         d3S+/drA+wN7IDQsGamfGjjj6cOFOVVR19bMKsv9INeB4/nh4BEe5h19A0V8DdLeFqzQ
         aS6V94csB6BUgDyDXMVwYBEM5VRp6FHCck4EI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=IDS3NnzgLo0jrRDnLv1X/fj0Kz/8LODkkhTNK4jyDRo=;
        b=cNgJZjZ6t7NiRR4CUjBo3WE4EENNpWwQuH4SvrSe0kSjsN2lXEl0DQhlBKkxd55DTY
         vTBMwywiJt8hDbTjnXfvRZ6lRrdBQcgumSNsP20qgnZh7mIM9Y9sufrWwQiLch5Rt10G
         0zqSwbfIIpj73pQP3h4yNaoCQPqjnVukeYAeE23nzLHMMi961nuzd6bEm0xYmXd96PyV
         cgmkekB1s4/SqqSKHStrDwl9QVCSDQOx1LkV9ydSx2nL2FmkaVpU0Kdm+pi37iBdON3k
         pbOuSOSPQqHXn5lsvK2GViWBpg9t4QbavmnLk0MXMTIHI+IHnrPRIziuJJNM/vQGvHIg
         lTTQ==
X-Gm-Message-State: AOAM531SPsQtJtdz5bHzBNadQsIXk/UxZEMEkmcjE4o1eu+gdHtK9nCB
        xa+UDdQFPOD+V+pcLOHaLzArMQ==
X-Google-Smtp-Source: ABdhPJwJFQIEnDqL/cQjIPckGc84unXTiL/Nr/l2N0aCBeG+4HOQULnZIveNW/NMnCw45iHbrlHN2Q==
X-Received: by 2002:a63:6fc6:: with SMTP id k189mr362882pgc.165.1598646252072;
        Fri, 28 Aug 2020 13:24:12 -0700 (PDT)
Received: from [10.69.69.102] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id z1sm174013pjn.34.2020.08.28.13.24.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 28 Aug 2020 13:24:11 -0700 (PDT)
Subject: Re: [PATCH] nvme: Revert: Fix controller creation races with teardown
 flow
To:     Sagi Grimberg <sagi@grimberg.me>, linux-nvme@lists.infradead.org
Cc:     Israel Rukshin <israelr@mellanox.com>, stable@vger.kernel.org,
        Keith Busch <kbusch@kernel.org>,
        Max Gurtovoy <maxg@mellanox.com>,
        Christoph Hellwig <hch@lst.de>
References: <20200828190150.34455-1-james.smart@broadcom.com>
 <0867c437-1521-c0c9-d7fa-6a615d88105a@grimberg.me>
From:   James Smart <james.smart@broadcom.com>
Message-ID: <a73cd06b-b319-d55f-1465-4263e08900ae@broadcom.com>
Date:   Fri, 28 Aug 2020 13:24:10 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.1.1
MIME-Version: 1.0
In-Reply-To: <0867c437-1521-c0c9-d7fa-6a615d88105a@grimberg.me>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 8/28/2020 12:08 PM, Sagi Grimberg wrote:
>
>> The indicated patch introduced a barrier in the sysfs_delete attribute
>> for the controller that rejects the request if the controller isn't
>> created. "Created" is defined as at least 1 call to nvme_start_ctrl().
>>
>> This is problematic in error-injection testing.  If an error occurs on
>> the initial attempt to create an association and the controller enters
>> reconnect(s) attempts, the admin cannot delete the controller until
>> either there is a successful association created or ctrl_loss_tmo
>> times out.
>>
>> Where this issue is particularly hurtful is when the "admin" is the
>> nvme-cli, it is performing a connection to a discovery controller, and
>> it is initiated via auto-connect scripts.  With the FC transport, if the
>> first connection attempt fails, the controller enters a normal reconnect
>> state but returns control to the cli thread that created the controller.
>> In this scenario, the cli attempts to read the discovery log via ioctl,
>> which fails, causing the cli to see it as an empty log and then proceeds
>> to delete the discovery controller. The delete is rejected and the
>> controller is left live. If the discovery controller reconnect then
>> succeeds, there is no action to delete it, and it sits live doing 
>> nothing.
>
> This is indeed a regression.
>
> Perhaps we should also revert:
> 12a0b6622107 ("nvme: don't hold nvmf_transports_rwsem for more than 
> transport lookups")
>
> Which inherently caused this by removing the serialization of
> .create_ctrl()...

no, I believe the patch on the semaphore is correct. Otherwise - things 
can be blocked a long time.. a minute (1 cmd timeout) or even multiple 
minutes in the case where a command failure in core layers effectively 
gets ignored and thus doesn't cause the error path in the transport.  
There can be multiple /dev/nvme-fabrics commands stacked up that can 
make the delays look much longer to the last guy.

as far as creation vs teardown... yeah, not fun, but there are other 
ways to deal with it. FC: I got rid of the separate create/reconnect 
threads a while ago thus the return-control-while-reconnecting behavior, 
so I've had to deal with it.  It's one area it'd be nice to see some 
convergence in implementation again between transports.

-- james

