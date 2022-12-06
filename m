Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0AB9B644997
	for <lists+stable@lfdr.de>; Tue,  6 Dec 2022 17:44:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234971AbiLFQoU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Dec 2022 11:44:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234997AbiLFQoO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Dec 2022 11:44:14 -0500
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EDA5E1D
        for <stable@vger.kernel.org>; Tue,  6 Dec 2022 08:44:13 -0800 (PST)
Received: by mail-ej1-x62d.google.com with SMTP id ud5so7633406ejc.4
        for <stable@vger.kernel.org>; Tue, 06 Dec 2022 08:44:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=2POlYQTJaSS6Ay3XCJDsRhKW5sTyCduNygYnKqIiHnw=;
        b=Pp2dswtDvNyPzgc/FyCEaes8oHg7EKiMMO1S2IH1vtD/c+XuQsw12FOANfDZjnANHM
         IwUvEWU2zoxFyyAG/pGL5TdeHue3McxsEVGFsBzNDX0zvL669Tt/dnmE6eQHtx/sbKEI
         ukEyp/gzuzVlfic7ewwqM8dCKBEIrJdUfKWJsZWFyZ1gVZ8SMqCvIXYqYXZ6TrM7vvWj
         MvsOUCBpYh5vTjMgeyKDRYlqZ0Alv+3lzYqChv63CnHZHqEE4wLNGzRGPOJKZ5EBMvpB
         Ws9ZS4xxZzZT2rWYpOsNb7zibG/LRE7hrQtaZahv/R4a6saqJEXDkY9qjJJd2JYn/HBR
         ZbAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2POlYQTJaSS6Ay3XCJDsRhKW5sTyCduNygYnKqIiHnw=;
        b=Kv6HzyApJvGuV74lyJjUoECSeGXVW6B4pij7+/U54U6NaThIyL+NJTHsA94KCOpsRe
         Sk+Y5DlOlVrOpaQuoV0lZnoDudLEBPe3MMJ2I3k8XKm6kdITwzcL9bcHWz7hwXGPBxt8
         M8sGZRcCfcBWqeyckcCjB5aA9Egv36vslm1o2sXw5QTa+hFLgwDWmYqrrO0Sj6Mnvys9
         30pSdz6SkObJc5F2CQz2tQXF2jsuUTXtdNOcn7t2AvB3aJdNs9F74jBzSeq1Otu/POm7
         jAp2Cspvq5Hp+rsjL44tdHa/duGuKGlC3rQryQikU3SYbkV6t9eONxnAOAkDvPeWuG2V
         YQpg==
X-Gm-Message-State: ANoB5ploDTYwtNytZQsREzL6Zm+qAMuKL5gFmbiTofBSbNdmZHAhlSEG
        cvExFjV5Cbp25lMflGmX1T0=
X-Google-Smtp-Source: AA0mqf7TC3D1B2C7MEZ9OW1Mapqsj2W0YI5XddO2UbiFsvvOirRfj1No6+VQSyOjUGjfDddYPhbRUA==
X-Received: by 2002:a17:906:b14f:b0:7ae:6d3e:a02e with SMTP id bt15-20020a170906b14f00b007ae6d3ea02emr73037259ejb.626.1670345051624;
        Tue, 06 Dec 2022 08:44:11 -0800 (PST)
Received: from skbuf ([188.26.184.215])
        by smtp.gmail.com with ESMTPSA id fe17-20020a1709072a5100b007be301a1d51sm7508996ejc.211.2022.12.06.08.44.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Dec 2022 08:44:11 -0800 (PST)
Date:   Tue, 6 Dec 2022 18:44:09 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     "Radu Nicolae Pirea (OSS)" <radu-nicolae.pirea@oss.nxp.com>,
        stable@vger.kernel.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com
Subject: Re: [PATCH] net: dsa: sja1105: fix new_retagging table size
Message-ID: <20221206164409.upvgo4fjefsefhs6@skbuf>
References: <20221206135104.734446-1-radu-nicolae.pirea@oss.nxp.com>
 <Y49o8Zei2aYsy/hr@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y49o8Zei2aYsy/hr@kroah.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Dec 06, 2022 at 05:08:17PM +0100, Greg KH wrote:
> > Should be applied on top of 5.10.157.
> > It is not relevant for newer LTS kernels.
> 
> Why not?
> 
> Please describe in HUGE detail why that is the case, what commit changed
> the tree to prevent this, and why only this one tree needs this specific
> change.  We almost never want to take patches that are not in Linus's
> tree so the justification to do so is a much much higher level.
> 
> And properly get the needed network maintainers ack as well.

Here I suppose that you would like the commit description to state that
VLAN retagging was a mechanism used by the sja1105 driver between kernels
5.9 and 5.15 solely to multiplex VLAN information with source port information
to the CPU. It was limited in that it could only multiplex up to 32 VLANs,
and it was replaced with the bridge TX forwarding offload feature once
that became available. As a result, kernels 5.15 and newer have all
support for VLAN retagging removed.

However, there is a bug in the delta commit procedure sja1105_build_vlan_table()
used by the VLAN retagging code, where the driver allocates less memory
than it needs. It intends to allocate a maximum sized (SJA1105_MAX_RETAGGING_COUNT = 32)
array of retagging table elements, but instead it allocates that number
of elements of a different size (the table->ops->unpacked_entry_size of
BLK_IDX_RETAGGING is sizeof(struct sja1105_retagging_entry) aka 56,
whereas the table->ops->unpacked_entry_size of BLK_IDX_VLAN_LOOKUP is
sizeof(struct sja1105_vlan_lookup_entry), aka 48).

32 elements of 48 bytes will only fit 27 elements of 56 bytes. So when
the VLAN Retagging table contains 28 elements or more, the last few will
be stored in memory that is out of the array that was pre-allocated.

This change fixes the typo that led to that.

Something like that?
