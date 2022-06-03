Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D92153D37F
	for <lists+stable@lfdr.de>; Sat,  4 Jun 2022 00:13:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349512AbiFCWNB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jun 2022 18:13:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232802AbiFCWNA (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jun 2022 18:13:00 -0400
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF78A18B3B
        for <stable@vger.kernel.org>; Fri,  3 Jun 2022 15:12:58 -0700 (PDT)
Received: by mail-io1-xd30.google.com with SMTP id r200so1062841iod.5
        for <stable@vger.kernel.org>; Fri, 03 Jun 2022 15:12:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YQaA0ysz+S1FZGYLa7EUyi8nddJMkVXVtwd4BwqcCVE=;
        b=HV4UoRzWQTlgPnhbgwevANk/jO/pR2mdRCjEqrQhcd5tWSRAUreuEBlIgi0N7EUe5A
         l4HXBsnEQLSSf3cI4CB6HWibojnau5wf0TBFvkKNvZAPcAbyAXQ2P8f/k9jT7lqGe+wt
         tVoesIjkL5kxbVbPY9AiNmv4RUob7joWxnksc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YQaA0ysz+S1FZGYLa7EUyi8nddJMkVXVtwd4BwqcCVE=;
        b=11La4PRxhKWnN3CeS0iJT+mxRAAihYGvKYZxM8icKOgRtf+OjSOdJ09+QCvx24odv/
         OHPUSbdDu+lef9CirDvh+HBGY1QnEKaIuh2M11ZQQJoVN3wY0uv7IQh2yF0R8uHFUHIq
         H7C4i67EHS+CV9OG9lqveBvYNuFn4YDkMSVt3GX78skJ958n86MCZXlR/Njtzl5DApSL
         dwurmejSOqwTL8ssMeZKL+XL7he3MedbOTqSdpMlbAh8aFQS79IgnC49JZn+IFt3QhdH
         mv4OaXjp8w25kq+JNsbF56ze/kRsHPIVzoH6pajlPAZkcxeRtbN3ldAuZDXCZ+BOPDqC
         Q21g==
X-Gm-Message-State: AOAM530O2JKpSEbm6Ji8sd2bSA/6BPenNb4TX0mjxpWELDMYQj+mBp9u
        0fkAZCfCLcdfWUyRPWlmKvx5gQ==
X-Google-Smtp-Source: ABdhPJwRZzdUFPObenCqqK8QSOyTpq8ELKioDcBezTTqdyBLuX1Qc4YsdPX8WvzjpdZYUeiXr7NzNw==
X-Received: by 2002:a05:6602:1653:b0:665:6f74:db21 with SMTP id y19-20020a056602165300b006656f74db21mr5723622iow.33.1654294378143;
        Fri, 03 Jun 2022 15:12:58 -0700 (PDT)
Received: from irdv-mkhalfella.dev.purestorage.com ([208.88.158.129])
        by smtp.googlemail.com with ESMTPSA id e10-20020a92a00a000000b002d3ded31668sm2901016ili.41.2022.06.03.15.12.56
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 03 Jun 2022 15:12:57 -0700 (PDT)
From:   Mohamed Khalfella <mkhalfella@purestorage.com>
To:     mkhalfella@purestorage.com
Cc:     bhelgaas@google.com, ebadger@purestorage.com, helgaas@kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, msaggi@purestorage.com,
        oohall@gmail.com, rajatja@google.com, ruscur@russell.cc,
        stable@vger.kernel.org
Subject: Re: [PATCH] PCI/AER: Iterate over error counters instead of error
Date:   Fri,  3 Jun 2022 22:12:47 +0000
Message-Id: <20220603221247.5118-1-mkhalfella@purestorage.com>
X-Mailer: git-send-email 2.29.0
In-Reply-To: <20220510211756.5237-1-mkhalfella@purestorage.com>
References: <20220510211756.5237-1-mkhalfella@purestorage.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Is there any chance for this to land in 5.19?

On 5/10/22 14:17, Mohamed Khalfella wrote:
> > Thanks for catching this; it definitely looks like a real issue!  I
> > guess you're probably seeing junk in the sysfs files?
> 
> That is correct. The initial report was seeing junk when reading sysfs
> files. As descibed, this is happening because we reading data past the
> end of the stats counters array.
> 
> 
> > I think maybe we should populate the currently NULL entries in the
> > string[] arrays and simplify the code here, e.g.,
> > 
> > static const char *aer_correctable_error_string[] = {
> >        "RxErr",                        /* Bit Position 0       */
> >        "dev_cor_errs_bit[1]",
> >	...
> >
> >  if (stats[i])
> >    len += sysfs_emit_at(buf, len, "%s %llu\n", strings_array[i], stats[i]);
> 
> Doing it this way will change the output format. In this case we will show
> stats only if their value is greater than zero. The current code shows all the
> stats those have names (regardless of their value) plus those have non-zero
> values.
> 
> >> @@ -1342,6 +1342,11 @@ static int aer_probe(struct pcie_device *dev)
> >>  	struct device *device = &dev->device;
> >>  	struct pci_dev *port = dev->port;
> >>
> >> +	BUILD_BUG_ON(ARRAY_SIZE(aer_correctable_error_string) <
> >> +		     AER_MAX_TYPEOF_COR_ERRS);
> >> +	BUILD_BUG_ON(ARRAY_SIZE(aer_uncorrectable_error_string) <
> >> +		     AER_MAX_TYPEOF_UNCOR_ERRS);
> >
> > And make these check for "!=" instead of "<".

I am happy to remove these BUILD_BUG_ON() if you think it is a good
idea to do so.

> 
> This will require unnecessarily extending stats arrays to have 32 entries
> in order to match names arrays. If you don't feel strogly about changing
> "<" to "!=", I prefer to keep the code as it is. 
