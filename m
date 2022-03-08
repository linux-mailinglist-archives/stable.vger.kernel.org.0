Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EAA714D19BB
	for <lists+stable@lfdr.de>; Tue,  8 Mar 2022 14:55:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347261AbiCHN4m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Mar 2022 08:56:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244340AbiCHN4l (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Mar 2022 08:56:41 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AB3DD49F8B
        for <stable@vger.kernel.org>; Tue,  8 Mar 2022 05:55:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646747743;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1IBDuOS2fA0Ut8e4IiZznBpFVrC7yMpgLFek2NZWFfs=;
        b=T9jdB2dl3v0/ZLlYNeb/oV5yazRPOl3B0PMh7i0TVzuoN7zaGGMzmOc9so1ojgD0wqGcD+
        73HiKHAH3CxBWesrCftjhqI6Wv5YuDHTTBFMd8aUBltsxyeQZ9DTiwLUM+rgvpkVKqrOlv
        DQc7v2LxRtC0qDkT72WjrIYEU9Dt6VY=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-474-Crl5b4KJPN-8V7HYOP7g3w-1; Tue, 08 Mar 2022 08:55:42 -0500
X-MC-Unique: Crl5b4KJPN-8V7HYOP7g3w-1
Received: by mail-ej1-f70.google.com with SMTP id le4-20020a170907170400b006dab546bc40so5462136ejc.15
        for <stable@vger.kernel.org>; Tue, 08 Mar 2022 05:55:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=1IBDuOS2fA0Ut8e4IiZznBpFVrC7yMpgLFek2NZWFfs=;
        b=Ga/I42pRk4z5W+sl6b5y6fMWH/TF6+0IYDWWIqnZI5yeMkxO6zgsF1PnpXbOQJExcK
         lxRc9WBxNgobFsB4yVQHzziCmLTvm3n6TXU8XWElfFrybuT9ghUZSgrnU0/vvjZI4xgn
         V9BtCuVnOWKskUgwjLW0XeGk4hPWK56MS0SLWJro1eMuZpF8ZhYe+BzZ89p7mBPz7o70
         g3Hk1nHUXnAbRzar7kt4FmC8WZBM20KNkvMmG29PO0cDjiigxixU5PDUSpvIwBX+CXiw
         zIxhtZ+DIjtGrQdisPSLR8lI3tnSitdNLcd4mg5GjFP9KJD5pHzkwNahLveiTRuTT9bq
         0Xow==
X-Gm-Message-State: AOAM531L85OODAddgC/YQ6KBucNPg9W0xujMUgcZIcM6UKNcDm9rl2Ov
        gJSEdzaEtmSS7KzLaU8CP3tAqeokMgoGovk2eN4R5YpeSamLRaYMs6zeVu22+7Xu7wfrmYHB2O8
        O46BrGp3mQWUxIIhd
X-Received: by 2002:a17:907:72c5:b0:6da:e99e:226c with SMTP id du5-20020a17090772c500b006dae99e226cmr13706571ejc.515.1646747741396;
        Tue, 08 Mar 2022 05:55:41 -0800 (PST)
X-Google-Smtp-Source: ABdhPJz6WmZv3/KHM1kx7+bdzcMlRqoo8+XkXcFt2ZUztmnvExDivbuO3SMLPcZhEKvKFLdILNTj/A==
X-Received: by 2002:a17:907:72c5:b0:6da:e99e:226c with SMTP id du5-20020a17090772c500b006dae99e226cmr13706551ejc.515.1646747741189;
        Tue, 08 Mar 2022 05:55:41 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id n9-20020a05640205c900b00415fbbdabbbsm6684307edx.9.2022.03.08.05.55.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Mar 2022 05:55:40 -0800 (PST)
Message-ID: <77a34051-2672-88cf-99dd-60f5acfb905e@redhat.com>
Date:   Tue, 8 Mar 2022 14:55:39 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 1/3] mm: vmalloc: introduce array allocation functions
Content-Language: en-US
To:     Michal Hocko <mhocko@suse.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Michael Ellerman <mpe@ellerman.id.au>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>,
        Christoph Lameter <cl@linux.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Vladimir Davydov <vdavydov.dev@gmail.com>, linux-mm@kvack.org,
        cgroups@vger.kernel.org, stable@vger.kernel.org
References: <20220308105918.615575-1-pbonzini@redhat.com>
 <20220308105918.615575-2-pbonzini@redhat.com>
 <Yidefp4G/Hk2Twfy@dhcp22.suse.cz>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <Yidefp4G/Hk2Twfy@dhcp22.suse.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/8/22 14:47, Michal Hocko wrote:
> Seems useful
> Acked-by: Michal Hocko<mhocko@suse.com>
> 
> Is there any reason you haven't used __alloc_size(1, 2) annotation?

It's enough to have them in the header:

>> +extern void *__vmalloc_array(size_t n, size_t size, gfp_t flags) __alloc_size(1, 2);
>> +extern void *vmalloc_array(size_t n, size_t size) __alloc_size(1, 2);
>> +extern void *__vcalloc(size_t n, size_t size, gfp_t flags) __alloc_size(1, 2);
>> +extern void *vcalloc(size_t n, size_t size) __alloc_size(1, 2);

Thanks for the quick review!

Paolo

