Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F28ED4D8A5E
	for <lists+stable@lfdr.de>; Mon, 14 Mar 2022 18:05:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241976AbiCNRGM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Mar 2022 13:06:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236660AbiCNRGL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Mar 2022 13:06:11 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 116F71CFFA
        for <stable@vger.kernel.org>; Mon, 14 Mar 2022 10:05:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647277499;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bkqWgLnqhGzD7mGaBYDRm/Y79LLy6/I7th1CZtjVxLo=;
        b=P7L/heCoNFngDfG6MtNaAdxZx4RKBcZHjtyfgqHRY0m71eVQuZ0RZDmZx4ZBagn1BDPkPZ
        u2nyXlzEJqpcqODd8TlpTAI+wL/2W4BZYKgXmGyxVgP11xiN5++50V6NIRISkYugImXw87
        xncfhEhBCQWvpAIpnEfSd8/jM7FMOCw=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-203--JdYnK6aODu8Ch_x_qZERQ-1; Mon, 14 Mar 2022 13:04:57 -0400
X-MC-Unique: -JdYnK6aODu8Ch_x_qZERQ-1
Received: by mail-qv1-f70.google.com with SMTP id bh20-20020ad44914000000b00440be590fa7so511407qvb.8
        for <stable@vger.kernel.org>; Mon, 14 Mar 2022 10:04:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=bkqWgLnqhGzD7mGaBYDRm/Y79LLy6/I7th1CZtjVxLo=;
        b=nwQJ8mqJByPnkxuuMaabBPjVzzi8o7zUt7pDFjVmh7s6aGCPBXPfd7TEfoV4IGN/rU
         ZOMeawjmdNzPYZPPfNyTUfluiS+6afJZcUoXBmEmEsKLeaE46PBbSc1Olv7XllzvdHcs
         bmXgUUw/5HZ0YsL/evlvPU6k5u92DIaU8RsoD8gy9E+oL9UNtLVMFs3CAH+1/3Kdf8pC
         kkdb1NpprgNEaFRK2WqB/ABhzyP6r8yRzD4zUXPwSBFdcClFmm/ZOg2eCtMFHHW0msOm
         +qWA3lvoEG5Iu3A+Wch7JEObJOTQMvIxhqg+TPvObGqI6z+Gfl4qZ58X10YN6SJQkmFP
         XekQ==
X-Gm-Message-State: AOAM533fpdMlAHYMiSnJhRjG+ClnGeWnRf8gkJuUiRcJnIYvSI3JJ6DZ
        vwJh2oTg0PUJ13+AZjKqgqZav6vYfxZ92gEPpMpK66dqZfW4HBuKloGQmQALxm+Sf94Z2Un+xps
        73Aq/XwBJGYw+i4H2
X-Received: by 2002:ac8:5789:0:b0:2e1:c40e:9be3 with SMTP id v9-20020ac85789000000b002e1c40e9be3mr12179979qta.308.1647277497166;
        Mon, 14 Mar 2022 10:04:57 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzNarz25Puf3q/N7nVPXUASu4gHSYjV0U/7zQ/n1w7IuT2Hc5uzYov009LRaU0VUlajZSe49w==
X-Received: by 2002:ac8:5789:0:b0:2e1:c40e:9be3 with SMTP id v9-20020ac85789000000b002e1c40e9be3mr12179959qta.308.1647277496912;
        Mon, 14 Mar 2022 10:04:56 -0700 (PDT)
Received: from [192.168.100.101] ([75.38.49.119])
        by smtp.gmail.com with ESMTPSA id z203-20020a3765d4000000b0067b48d49c65sm8201553qkb.95.2022.03.14.10.04.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Mar 2022 10:04:56 -0700 (PDT)
Message-ID: <c4a65b9a-d1e2-bf0d-2519-aac7185931d5@redhat.com>
Date:   Mon, 14 Mar 2022 13:04:55 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [tip: irq/urgent] PCI/MSI: Mask MSI-X vectors only on success
Content-Language: en-US
To:     Stefan Roese <sr@denx.de>,
        Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>,
        linux-kernel@vger.kernel.org
Cc:     Thomas Gleixner <tglx@linutronix.de>, linux-pci@vger.kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Marek Vasut <marex@denx.de>, stable@vger.kernel.org,
        x86@kernel.org, maz@kernel.org
References: <20211210161025.3287927-1-sr@denx.de>
 <163948488617.23020.3934435568065766936.tip-bot2@tip-bot2>
 <Yi9vH2F2OBDprwd8@jpiotrowski-Surface-Book-3>
 <43418c23-5efd-4d14-706f-f536c504b75a@denx.de>
From:   Dusty Mabe <dustymabe@redhat.com>
In-Reply-To: <43418c23-5efd-4d14-706f-f536c504b75a@denx.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 3/14/22 12:49, Stefan Roese wrote:

> I've added Dusty to Cc, as he (and others) already have been dealing
> with this issue AFAICT.
> 
> Dusty, could you perhaps chime in with the latest status? AFAIU, it's
> related to potential issues with the Xen version used on these systems?

Thanks Stefan,

Yes. My understanding is that the issue is because AWS is using older versions
of Xen. They are in the process of updating their fleet to a newer version of
Xen so the change introduced with Stefan's commit isn't an issue any longer.

I think the changes are scheduled to be completed in the next 10-12 weeks. For
now we are carrying a revert in the Fedora Kernel.

You can follow this Fedora CoreOS issue if you'd like to know more about when
the change lands in their backend. We work closely with one of their partner
engineers and he keeps us updated. https://github.com/coreos/fedora-coreos-tracker/issues/1066

Dusty

