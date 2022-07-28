Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3517D58439B
	for <lists+stable@lfdr.de>; Thu, 28 Jul 2022 17:53:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232413AbiG1PxR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Jul 2022 11:53:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbiG1PxQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 Jul 2022 11:53:16 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9FDCE6BC3A
        for <stable@vger.kernel.org>; Thu, 28 Jul 2022 08:53:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659023594;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cyh9GNwkSeiWX8VVWJet6cmrStrv1Y1BhHYKMAKCy08=;
        b=CR7W8yzle9Zr6nPa3nWK0fbYLGoAXfhatxVa3PcQEOnfHlNL3N53sWk0hiH4MWKad2nh/E
        59aZW5AU9W/hgptHHpgeQw4+ldnMUlsMdGVabDM7mZ3/SxURgQ2T3beFYGdHEKh15RzRVf
        tcMTGMmYbZItnL/Ao9Gtk3TtkXVvOrw=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-228-nagcF-f6N-O7vHzdA-OdXw-1; Thu, 28 Jul 2022 11:53:13 -0400
X-MC-Unique: nagcF-f6N-O7vHzdA-OdXw-1
Received: by mail-ed1-f70.google.com with SMTP id y5-20020a056402358500b0043c0593d4f6so1378739edc.0
        for <stable@vger.kernel.org>; Thu, 28 Jul 2022 08:53:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cyh9GNwkSeiWX8VVWJet6cmrStrv1Y1BhHYKMAKCy08=;
        b=M8pflgBhFVcBBOwa/nqsnH6l1xUyQvKVctQgW/Tkd5Acife/BYQAYdxqgK8CnMr+gg
         iq4U3NM1GSajTu+0V63kzb5f7zMBGgs+FPwsPg26S/eY/BPML1HztgQ5Fu0K/kBus+ym
         GGB0i3/yA3ly512B2bYV5Yui+vzHpDhwdBOxh6X93E8FkY7GGnm9q/p6/4egHmLspqK2
         hIpKCp3lnL78JEofbyJMNqjc+BRrFcD04JdTfOGMqZeOds8v9KTgD7ByXVVyBB78iIRU
         QqWDPvwKNRXGIIWQO/D1v1E7bWFfK8NdR0MFgQbuHoFkZR0UuojrWnfcDngLzrOKlhdY
         9N4Q==
X-Gm-Message-State: AJIora8uI5O79YSo1S1tPQhmedaEFp+UD0qksSqvzAgsEu2CyA5pWNad
        99s6PQDK4YnlyR2OI2iE9e53Emu2a1/7dNJaPRaZfgH4CHm76efysxsnPWPodVv9QB7iitdkYsv
        6XkDEXsgawpTy3oU6
X-Received: by 2002:a05:6402:11c9:b0:43b:b905:cb88 with SMTP id j9-20020a05640211c900b0043bb905cb88mr28005166edw.102.1659023591973;
        Thu, 28 Jul 2022 08:53:11 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1uQ0WGkcljQ8+LQm9jJHKMMx05xV2P+kXpPzT5FmSEfnOq9qHwys5h+KfxqBoBs5xEkKeffGQ==
X-Received: by 2002:a05:6402:11c9:b0:43b:b905:cb88 with SMTP id j9-20020a05640211c900b0043bb905cb88mr28005135edw.102.1659023591576;
        Thu, 28 Jul 2022 08:53:11 -0700 (PDT)
Received: from goa-sendmail ([93.56.169.184])
        by smtp.gmail.com with ESMTPSA id a12-20020a170906368c00b0072af890f52dsm548037ejc.88.2022.07.28.08.53.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Jul 2022 08:53:10 -0700 (PDT)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     Jarkko Sakkinen <jarkko@profian.com>
Cc:     stable@vger.kernel.org, Jarkko Sakkinen <jarkko@kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "maintainer : X86 ARCHITECTURE 32-BIT AND 64-BIT" <x86@kernel.org>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Isaku Yamahata <isaku.yamahata@intel.com>,
        "open list : KERNEL VIRTUAL MACHINE FOR X86 KVM/x86" 
        <kvm@vger.kernel.org>,
        "open list : X86 ARCHITECTURE 32-BIT AND 64-BIT" 
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] KVM: x86/mmu: Fix incorrect use of CONFIG_RETPOLINE
Date:   Thu, 28 Jul 2022 17:53:07 +0200
Message-Id: <20220728155307.277425-1-pbonzini@redhat.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220728000221.19088-1-jarkko@profian.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Queued, thanks.

Paolo


