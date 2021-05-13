Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F6DA37FE7E
	for <lists+stable@lfdr.de>; Thu, 13 May 2021 21:59:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232376AbhEMUA2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 May 2021 16:00:28 -0400
Received: from mail-pf1-f174.google.com ([209.85.210.174]:37700 "EHLO
        mail-pf1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232373AbhEMUA1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 May 2021 16:00:27 -0400
Received: by mail-pf1-f174.google.com with SMTP id c13so9333632pfv.4
        for <stable@vger.kernel.org>; Thu, 13 May 2021 12:59:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6JuaE072ma7gtlH/E3dycnKuy6xr1SU9PAm53OPO8Sg=;
        b=hjPgQorHb6jUvKNhYGHS2lVvIl026sJa9USNA3Pu36Cz35wD01M+TqzC91SYu3xRqB
         hj7BGhboeB1ApoK/aRkaFFw85NwvHG3oCmRINvS1rZZu+lNsbbhAe+TBoZY9zPRFVJFu
         mOZ+X7GVn6wFxF02nELIGRRQJZbWDlaDtTVuQf7bR/1MOFURmVC4b1Jf3xGYe3Qjk8e+
         uJ0pzB7xOt1FvGs8Luhr7UWfpdvfvWQz7DZINV76AW/Lr4TOeGunNMRbCFWuRkkJHIuQ
         wu/paTpwiPL7O9K+o9DVLFn8RmLnEX94stLE6v4XBNlreODFYk1lQZI403HgakfbyiNz
         4RfQ==
X-Gm-Message-State: AOAM533+89Wk8XEFT46uVJQ/gp/EPgh2qk8GlU3F3eTSil5HBmKUgkTr
        1pFRnUbutNXoeqIDWG806gLn9gcndPI=
X-Google-Smtp-Source: ABdhPJxlJGtD+a1LrTrDH7uF+fkDI/O/UtMLWcIdaICpPGRUJalnwUDxzW5LMSAd2Xj+gcfn7xG2gw==
X-Received: by 2002:a63:ff25:: with SMTP id k37mr43193144pgi.360.1620935956750;
        Thu, 13 May 2021 12:59:16 -0700 (PDT)
Received: from ?IPv6:2601:647:4802:9070:fbea:aad3:995d:b40e? ([2601:647:4802:9070:fbea:aad3:995d:b40e])
        by smtp.gmail.com with ESMTPSA id h19sm2824776pgm.40.2021.05.13.12.59.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 May 2021 12:59:16 -0700 (PDT)
Subject: Re: [PATCH] nvme-fc: clear q_live at beginning of association
 teardown
To:     James Smart <jsmart2021@gmail.com>, linux-nvme@lists.infradead.org
Cc:     stable@vger.kernel.org
References: <20210511045635.12494-1-jsmart2021@gmail.com>
 <601fa5a1-e52b-edf1-f32e-b1c454e23758@grimberg.me>
 <f26aad29-aef7-6fd9-979b-a0bfc4f46a06@gmail.com>
From:   Sagi Grimberg <sagi@grimberg.me>
Message-ID: <361251b9-60da-d7b8-9352-a09e80a845a4@grimberg.me>
Date:   Thu, 13 May 2021 12:59:14 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <f26aad29-aef7-6fd9-979b-a0bfc4f46a06@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


>>> The __nvmf_check_ready() routine used to bounce all filesystem io if
>>> the controller state isn't LIVE. However, a later patch changed the
>>> logic so that it rejection ends up being based on the Q live check.
>>> The fc transport has a slightly different sequence from rdma and tcp
>>> for shutting down queues/marking them non-live. FC marks its queue
>>> non-live after aborting all ios and waiting for their termination,
>>> leaving a rather large window for filesystem io to continue to hit the
>>> transport. Unfortunately this resulted in filesystem io or applications
>>> seeing I/O errors.
>>>
>>> Change the fc transport to mark the queues non-live at the first
>>> sign of teardown for the association (when i/o is initially terminated).
>>
>> Sounds like the correct behavior to me, what is the motivation for doing
>> that only after all I/O was aborted?
>>
>> And,
>> Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
> 
> source evolution over time (rdma/tcp changed how they worked) and the 
> need didn't show up earlier based on the earlier checks.

Makes sense...
