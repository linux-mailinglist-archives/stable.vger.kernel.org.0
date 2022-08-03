Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 295B958917E
	for <lists+stable@lfdr.de>; Wed,  3 Aug 2022 19:33:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238313AbiHCRdw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Aug 2022 13:33:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238302AbiHCRdu (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Aug 2022 13:33:50 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 993A75723E
        for <stable@vger.kernel.org>; Wed,  3 Aug 2022 10:33:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659548028;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+5QAlTD0yVo3KUlmnd7w4NlvzNv43A/mFCjPCFZegUM=;
        b=Nk38WKu5DsyfQcDtXoMj9DCJ8w75rjyG1Di9whCV9hr3seZXd0z+pY7JFi0ET6j7vV5rGV
        qVmzpr6HB/H+oVSUme7RNsu0KMOXp0UtpPbJL91mmr6BTVhEbYOBZgBNMLOLUiukENP2RW
        0vss2p120iR0+1nLNpZQmVKyoiuyH3Y=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-247--k7EZePlNvOAxXewX6h1OQ-1; Wed, 03 Aug 2022 13:33:47 -0400
X-MC-Unique: -k7EZePlNvOAxXewX6h1OQ-1
Received: by mail-wm1-f72.google.com with SMTP id q10-20020a1ce90a000000b003a4f6e08166so379816wmc.5
        for <stable@vger.kernel.org>; Wed, 03 Aug 2022 10:33:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=+5QAlTD0yVo3KUlmnd7w4NlvzNv43A/mFCjPCFZegUM=;
        b=jvtIxv5+oljT7j/B84r0qAq+PJYDOgmAbjJRogrlK82PiNIFdyZWj9XFByUlI/7GIy
         vLCUkZZg2B9sioaFx16er+fgSayZtgHna1NZx1nEeW0Zt62WKqFqdmC++j+tblg18NOL
         wRMUt7GR6sr0S/zcmOlr87v3a8jPcZcNNZEjnY2cU4vfqjxIIny4RUqH50Xvw/RB9cb1
         Te/2tDciURweKWSMklxlcdiQnAQankdx6/N/cPhD1OX8ebU1RdhN5CISQRhvhqMVGDV7
         5MbXgqrBhJLg0eMCCC/VaEKPJnzj9rm9MqkdGPBPrQUkj9JBOjU4L0stccRLV96YQdby
         qn2g==
X-Gm-Message-State: ACgBeo0Qf7lM3zvQ8at6I/jRsJHk4F2WYYYs0Qe71tGb27VIVXRPVEE5
        8PqSqBbf+BtfiFYgV6PLV1SCUyfRfbDinUleWeEyzfE3ps1NmMNNyDTFo5sd4QPp0SlCWpZwaIq
        nxn8RzMHyO2qiA4b2
X-Received: by 2002:a5d:5a1a:0:b0:21f:a9b:62c6 with SMTP id bq26-20020a5d5a1a000000b0021f0a9b62c6mr16526610wrb.20.1659548026122;
        Wed, 03 Aug 2022 10:33:46 -0700 (PDT)
X-Google-Smtp-Source: AA6agR7NS7DQx36jQ4hn2m0a7zi3iwiyfGu90K9fZ7IwCQxglzQUf40ZJcqhUqtqEInch/OWlH0/yQ==
X-Received: by 2002:a5d:5a1a:0:b0:21f:a9b:62c6 with SMTP id bq26-20020a5d5a1a000000b0021f0a9b62c6mr16526595wrb.20.1659548025917;
        Wed, 03 Aug 2022 10:33:45 -0700 (PDT)
Received: from ?IPV6:2001:b07:add:ec09:c399:bc87:7b6c:fb2a? ([2001:b07:add:ec09:c399:bc87:7b6c:fb2a])
        by smtp.googlemail.com with ESMTPSA id m15-20020adffa0f000000b0021e5f32ade7sm18593005wrr.68.2022.08.03.10.33.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Aug 2022 10:33:45 -0700 (PDT)
Message-ID: <899e4d3d-e086-71a5-38f9-17e85ce11ea4@redhat.com>
Date:   Wed, 3 Aug 2022 19:33:39 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH] x86/fpu: Allow PKRU to be (once again) written by ptrace.
Content-Language: en-US
To:     Ingo Molnar <mingo@kernel.org>, Kyle Huey <me@kylehuey.com>
Cc:     Dave Hansen <dave.hansen@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org,
        Robert O'Callahan <robert@ocallahan.org>,
        David Manouchehri <david.manouchehri@riseup.net>,
        kvm@vger.kernel.org, stable@vger.kernel.org
References: <20220731050342.56513-1-khuey@kylehuey.com>
 <Yuo59tV071/i6yhf@gmail.com>
 <CAP045ArF0SX84tDr=iZoK=EnXK2LsXYut3-KMkCxQO2OOhn=0A@mail.gmail.com>
 <Yuqvkufu7Hu4drL6@gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <Yuqvkufu7Hu4drL6@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 8/3/22 19:25, Ingo Molnar wrote:
> Ok - allowing ptrace to set the full 32 bits of the PKRU register seems OK
> then, and is 100% equivalent to using WRPKRU, right? So there's no implicit
> masking/clearing of bits depending on how many keys are available, or other
> details where WRPKRU might differ from a pure 32-bit per thread write,
> correct?

Yes, it's the same.

Paolo

