Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E0B0644544
	for <lists+stable@lfdr.de>; Tue,  6 Dec 2022 15:04:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231530AbiLFOEC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Dec 2022 09:04:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234693AbiLFOD7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Dec 2022 09:03:59 -0500
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59C7E2C668
        for <stable@vger.kernel.org>; Tue,  6 Dec 2022 06:03:57 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id c66so14105930edf.5
        for <stable@vger.kernel.org>; Tue, 06 Dec 2022 06:03:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=iStsLCef1/B4HI2I/ZH6jTZHmPdIazqEaKt3DPqN76o=;
        b=UwWtrdmN9kpN0IzwPYEoulV5JpvXCC2UMuHQhqGDx1lO9nmt4K2miNIjqWg0xbrKFe
         tZyNzsBL2bUsZUcsj2DqU/hN7i8sgCAn7WfRVGI0snwMFlH7rbs/9OuzOTwaCkbTXz6F
         kBOAuiL9AA9yv0y6fIGoaxKys3Uf2xUbzioNr3OXyn3EB0EcVDfefuk3o02BqZVz+G0u
         Z4Md4PAPy8h2lNax3JCgYeKuQ2YPSI7Yu0CaOi03holymbdBq3QBA9eaB6cxlFyBqXVh
         A8UnrEiuf3eZEKFHGV0H79e209OE67eA9QXo50fXTcHwVubLv06r1HnZkyL1v7bNEvrX
         2zMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iStsLCef1/B4HI2I/ZH6jTZHmPdIazqEaKt3DPqN76o=;
        b=W1RR8RdkxJ33F98gjkpI9ly7m6HQL2X2tTu5dQ0LXgIe5huJHYFuFOJmQIP3hgp9DK
         77y+Ibvvu47r/g8/9a8S23woCKupVAEcM2yXFjj27JBrh6TIM+7syfS2lVmEav1saKGK
         k9kTEYNKroNC8LFDLdRfjbFcl31JnX+/OPNcphDOSvjYRks7RgxbBg3bV3csywup3wJj
         mL5r6EdLZjG9bPPSBIooYlTmNQEIT+LLYgxDx5RlRoj2bZEAHpl0RZ31QQGN514fn5dX
         jS+OfKaYEiF0NWwbiyr+Mpgedkt4Lpr1RCo/bZFM78XtyXT/RDgibjALFQk3QHKJ2e7P
         u/gw==
X-Gm-Message-State: ANoB5pmvSv1CX5dxkZ+pLWVLFbrwMtsXNGg+UqC6m3/lzzXHKuSPdvBe
        DDzfsIzvg0M0pUKuaHf5Qgs=
X-Google-Smtp-Source: AA0mqf523WP7LEz4Sucylag7s2ER9408Co1kj3HdN5NSB/f0zHLPYGZEtAKK6TsGOztwCTeMzJJ0lw==
X-Received: by 2002:aa7:db9a:0:b0:46b:ada3:4ee with SMTP id u26-20020aa7db9a000000b0046bada304eemr2943692edt.64.1670335435656;
        Tue, 06 Dec 2022 06:03:55 -0800 (PST)
Received: from skbuf ([188.26.184.215])
        by smtp.gmail.com with ESMTPSA id y20-20020a50eb94000000b004589da5e5cesm1014033edr.41.2022.12.06.06.03.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Dec 2022 06:03:55 -0800 (PST)
Date:   Tue, 6 Dec 2022 16:03:53 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "Radu Nicolae Pirea (OSS)" <radu-nicolae.pirea@oss.nxp.com>
Cc:     gregkh@linuxfoundation.org, stable@vger.kernel.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com
Subject: Re: [PATCH] net: dsa: sja1105: fix new_retagging table size
Message-ID: <20221206140353.e5zxuoiavd4scukc@skbuf>
References: <20221206135104.734446-1-radu-nicolae.pirea@oss.nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221206135104.734446-1-radu-nicolae.pirea@oss.nxp.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I guess I would have named the subject-prefix "PATCH stable 5.10",
so this jumps out better.

On Tue, Dec 06, 2022 at 03:51:04PM +0200, Radu Nicolae Pirea (OSS) wrote:
> Allocate more memory for the new_retagging table according to its size.
> 
> Signed-off-by: Radu Nicolae Pirea (OSS) <radu-nicolae.pirea@oss.nxp.com>
> ---
>  drivers/net/dsa/sja1105/sja1105_main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Should be applied on top of 5.10.157.
> It is not relevant for newer LTS kernels.

The fix is correct.

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>

The code it fixes was deleted in commit 6dfd23d35e75 ("net: dsa:
sja1105: delete vlan delta save/restore logic"), which first appeared in v5.15,
and was introduced in commit ec5ae61076d0 ("net: dsa: sja1105:
save/restore VLANs using a delta commit method"), which first appeared in v5.9.

So the patch should be applied only to the currently maintained linux-stable
branches older than linux-5.15.y. That is indeed only linux-5.10.y.
