Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CBDB4BB40D
	for <lists+stable@lfdr.de>; Fri, 18 Feb 2022 09:22:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232332AbiBRIWX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Feb 2022 03:22:23 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:57862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230221AbiBRIWX (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Feb 2022 03:22:23 -0500
Received: from mail-vs1-xe32.google.com (mail-vs1-xe32.google.com [IPv6:2607:f8b0:4864:20::e32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 018323DA55
        for <stable@vger.kernel.org>; Fri, 18 Feb 2022 00:22:06 -0800 (PST)
Received: by mail-vs1-xe32.google.com with SMTP id w4so9127015vsq.1
        for <stable@vger.kernel.org>; Fri, 18 Feb 2022 00:22:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=eMllH6SqtmgTmAnOJGaH+RpoEMH0PN5Is8QhFl+6HxM=;
        b=HL0wvkvGe2eP4np3H58p9xh104v5TkTJEGcm2ZjEC8IxhSg9P85EuQemODe8R9Tte0
         qkvcUJdoLwgX4yY24qQB9GWFnVgumjIpIhQIhMEESf15ibGXNnSr8c3k5r3+akfxI1/q
         8YKI4SgITdEfG0fZZJgGMMvqFAIO/514sC/iXvoNojHOV8S30aCCjHMXawdsRNsnDPIR
         yBCWJAFuPbL0NS/r2wWaxWvXV8xM3fYGLgeKR54IqD6kk3hfgU84fDC+xfiaUNKO+15B
         lWjXVMyAfuQ4AQE9W29lJKd0DZL62Tc5YvksLasFXzg8R8tic3gM0t3DjM3EWeZqpkby
         O2Hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=eMllH6SqtmgTmAnOJGaH+RpoEMH0PN5Is8QhFl+6HxM=;
        b=aVKaT6Fp2p80A1kiEGX1Q7fjDwVvfJwq52QzoC4QPPwvNd4G4E2K4TlYOfXRtF1cal
         3CHzQFR5wGT/Ptem3pz5/DBeXCbmI6PmBwDyEAlxHMxOhSfOmxKjfx/3c57o1lswpa0U
         nqw39bjDR4abpmycYyQWn0gV3iKaOpOp2oBFInuHQDsjFjbBL/C5ScC0J/xzhiJVwJba
         YLvnEbTPKWyOaIO3zD///2L3mVOtue1OtpsKVpfrVyckuk8L4xXPk1EIALEMSkLHcIl2
         uMMpTzl7LEVDR1DU/ie3V+HbcT0lStQF43cgZnTyzzkRVdAOCPjLhEWkXtw/xePPcNMY
         waVA==
X-Gm-Message-State: AOAM533ttbEIS/77vgs3c1ZU1OuxyIUgt4914lxsfO5IATgKdmmEeHD+
        dpvq+E9f7apnLICviIJaWzg07db0VbIAm2wbr5w=
X-Google-Smtp-Source: ABdhPJyCzfXvNtee5NBtD8m4thIouz/upC6brVCpl5NMEty8kQbjo0ufFCmtxWrnRxqYd+vLzCwWxODQf/SH3xyxQoY=
X-Received: by 2002:a05:6102:38c9:b0:31b:e4b3:5106 with SMTP id
 k9-20020a05610238c900b0031be4b35106mr3080505vst.39.1645172525992; Fri, 18 Feb
 2022 00:22:05 -0800 (PST)
MIME-Version: 1.0
References: <20220216091307.703-1-adrianhuang0701@gmail.com> <989cf124-13d7-5601-a942-e515c81a72a9@linux.intel.com>
In-Reply-To: <989cf124-13d7-5601-a942-e515c81a72a9@linux.intel.com>
From:   Huang Adrian <adrianhuang0701@gmail.com>
Date:   Fri, 18 Feb 2022 16:21:54 +0800
Message-ID: <CAHKZfL0dx8HuuB1AqN3fkcHjPZDJMTfPqRgW4XnuFVE8Cw4iFQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/1] iommu/vt-d: Fix list_add double add when enabling
 VMD and scalable mode
To:     Lu Baolu <baolu.lu@linux.intel.com>
Cc:     David Woodhouse <dwmw2@infradead.org>,
        Joerg Roedel <joro@8bytes.org>,
        iommu@lists.linux-foundation.org,
        Kevin Tian <kevin.tian@intel.com>,
        Liu Yi L <yi.l.liu@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Nirmal Patel <nirmal.patel@linux.intel.com>,
        Jonathan Derrick <jonathan.derrick@linux.dev>,
        stable@vger.kernel.org, Adrian Huang <ahuang12@lenovo.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 18, 2022 at 10:30 AM Lu Baolu <baolu.lu@linux.intel.com> wrote:
>
> On 2/16/22 5:13 PM, Adrian Huang wrote:
> > pci_real_dma_dev() in pci_for_each_dma_alias() gets the real dma device
> > which is the VMD device 0000:59:00.5. However, pte of the VMD device
> > 0000:59:00.5 has been configured during this message "pci 0000:59:00.5:
> > Adding to iommu group 42". So, the status -EBUSY is returned when
> > configuring pasid entry for device 10000:80:01.0.
>
> So the VMD subdevice (pci 10000:80:01.0) is an alias device of the "pci
> 0000:59:00.5", and it uses the Source-ID of "pci 0000:59:00.5" for DMA
> transactions. Do I understand it right? If so, it makes sense to skip
> setting up pasid entry for VMD subdevices.

Yes, your understanding is correct.

> Another thing I am still concerned is about the context entry setup.
> What does the context entries look like for both VMD and subdevices
> after domain_context_mapping() being called?

pasid_table in struct device_domain_info is NULL because the field
pasid_table is configured in intel_pasid_alloc_table().

The following statement in domain_context_mapping_one() is true for
subdevices because the context is configured by the real VMD device
0000:59:00.5. So, domain_context_mapping() does nothing for
subdevices.
                if (context_present(context))
                              goto out_unlock;

Here is the log for your reference with pr_debug() enabled.

[   19.063445] pci 0000:59:00.5: Adding to iommu group 42
...
[   22.673502] DMAR: Set context mapping for 59:00.5
..
[   32.089696] vmd 0000:59:00.5: PCI host bridge to bus 10000:80
[   32.119452] pci 10000:80:01.0: [8086:352a] type 01 class 0x060400
[   32.126302] pci 10000:80:01.0: reg 0x10: [mem 0x00000000-0x0001ffff 64bit]
[   32.134023] pci 10000:80:01.0: enabling Extended Tags
[   32.139730] pci 10000:80:01.0: PME# supported from D0 D3hot D3cold
[   32.160526] DMAR: Set context mapping for 59:00.5
[   32.171090] pci 10000:80:01.0: Adding to iommu group 42
...

-- Adrian
