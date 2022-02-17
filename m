Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA2EB4B9A21
	for <lists+stable@lfdr.de>; Thu, 17 Feb 2022 08:52:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236709AbiBQHvc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Feb 2022 02:51:32 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:52990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236700AbiBQHvb (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Feb 2022 02:51:31 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 653222A39EE
        for <stable@vger.kernel.org>; Wed, 16 Feb 2022 23:51:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645084277;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6avVhvuh+LQ6yXDGvdg58X8YQ+KJW2Yn+eyoEh3r/+I=;
        b=FKpvfVuWJjd9wRPLoyvrolje4Fl3ymiDCyVz0lGJaUmJ5VFjlS7npj4S1/SbWX6ktwmLuT
        loCdLqIGkT1L7Qyqya8CdSjUtRFIBdM319GlvZokMQr8vQ9Dm0ylin3hKKf8eS2iq6p5Nk
        4usRSQJUC01kG6/VdW3SH3YHNZYNcvc=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-280-YL-1k7gkPDu56SML35lbVg-1; Thu, 17 Feb 2022 02:51:14 -0500
X-MC-Unique: YL-1k7gkPDu56SML35lbVg-1
Received: by mail-wr1-f69.google.com with SMTP id s5-20020adfbc05000000b001e7af4f2231so1953251wrg.3
        for <stable@vger.kernel.org>; Wed, 16 Feb 2022 23:51:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=6avVhvuh+LQ6yXDGvdg58X8YQ+KJW2Yn+eyoEh3r/+I=;
        b=OYYDHv06q2crXLpgRp7RTqDZrT9Wls/ecVPTwoGBu/6LiRao7hW1X5MvSXTDRfxKti
         /wce33cLfO5DenCLTJVHvNYrhx+zkhy9SZYcbjW0kBfin+3aXyaY6PcwXpOjL1shLZnn
         s1uStTxeDbugNStv+hlnwtBzLCNHMDLYz+QCjV5+OV0Hz5EjxqW1djJ9tOM3jBrDx5XF
         fly8a8ylyON7yJ2zXIFrf3LdRrB5PYK5JDNs0oAeUk8pd1kyUMeSwEJT+peHuLT/hfez
         Cw+62PEx34RpfpLgin1JMWmZLpcvcqN8MguomP+ToMo2byXVXQJp4tIphygL+2gOh+z6
         bucw==
X-Gm-Message-State: AOAM530rnWybrAfAFrTdLprGIjlIYTFLpZA9Sjyp6HpTl7pSrxhe34MI
        w1EqLCAlZyLL/JCV+cOYuxQba1JniAIUu3JvFpShKSPR6zexdcaWfI8GObgItzg+SYanjwAfD6x
        u+YorgKzxMQbIn81i
X-Received: by 2002:a05:600c:4f90:b0:350:d962:8944 with SMTP id n16-20020a05600c4f9000b00350d9628944mr1471216wmq.48.1645084272932;
        Wed, 16 Feb 2022 23:51:12 -0800 (PST)
X-Google-Smtp-Source: ABdhPJy93ucXgz+LliTZpttm5E4CBWy4N18iehcOCxu0y01PmNrQ++eENYAkFnLkfJQ2n6ufX2ApsA==
X-Received: by 2002:a05:600c:4f90:b0:350:d962:8944 with SMTP id n16-20020a05600c4f9000b00350d9628944mr1471192wmq.48.1645084272677;
        Wed, 16 Feb 2022 23:51:12 -0800 (PST)
Received: from ?IPV6:2003:cb:c711:b800:254c:2d22:aab2:20a? (p200300cbc711b800254c2d22aab2020a.dip0.t-ipconnect.de. [2003:cb:c711:b800:254c:2d22:aab2:20a])
        by smtp.gmail.com with ESMTPSA id h11sm20171914wrr.64.2022.02.16.23.51.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Feb 2022 23:51:12 -0800 (PST)
Message-ID: <d29fd91b-2043-0880-17ab-0ef7ec14bf62@redhat.com>
Date:   Thu, 17 Feb 2022 08:51:11 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH] mm: fix dereference a null pointer in
 migrate[_huge]_page_move_mapping()
Content-Language: en-US
To:     Greg KH <gregkh@linuxfoundation.org>,
        liqiong <liqiong@nfschina.com>
Cc:     linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
References: <20220217063808.42018-1-liqiong@nfschina.com>
 <Yg35UXjB7RpqVCOI@kroah.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <Yg35UXjB7RpqVCOI@kroah.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 17.02.22 08:29, Greg KH wrote:
> On Thu, Feb 17, 2022 at 02:38:08PM +0800, liqiong wrote:
>> Upstream has no this bug.
> 
> What do you mean by this?
> 
> confused,

Dito. If this is fixed upstream and broken in stable kernels, we'd want
either a backport of the relevant upstream fix, or if too complicated, a
stable-only fix.


-- 
Thanks,

David / dhildenb

