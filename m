Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80519652828
	for <lists+stable@lfdr.de>; Tue, 20 Dec 2022 22:01:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234120AbiLTVBA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Dec 2022 16:01:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234282AbiLTVA6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Dec 2022 16:00:58 -0500
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 565FC1DF1D
        for <stable@vger.kernel.org>; Tue, 20 Dec 2022 13:00:57 -0800 (PST)
Received: by mail-ed1-x52d.google.com with SMTP id d14so19247562edj.11
        for <stable@vger.kernel.org>; Tue, 20 Dec 2022 13:00:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=88yRQkH8x/8fi3zx+xak9LdLlIZZTX7XIR+oFyhPiJU=;
        b=ikVGT9c7jlXGiAFQm/eF+ljkcJz0xH53jGjqSJQ1ajIIdtYfc4fc9uKpjQNwfNhecR
         eA7UTfijcug1LXEFvL1mgLlq+tZwAmOmN+yKewwD3SOIvwlaLX9tDOqZUdupCtj/4H/c
         jug5yeGyniAbp7KxvhH8WsQeFxPHU3HJV9rz4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=88yRQkH8x/8fi3zx+xak9LdLlIZZTX7XIR+oFyhPiJU=;
        b=BS0fi8G7LC15aGsT1k7rUeFyfQQuoK31U6gH/L9QvkqqnLVx4pr9W8pg+qCjANnkiF
         zt5voQMnPZaAz3C0OmgXveKU+s3NSz8IHGNqMWKWc6tyngt7Y2v49nXutnNg1jT3WF4a
         7xCLY9X5Y1W87oGaQMg2CXK5XebU32+oBq+wDPGGMoe0QbwYzD/N2eqfwo9cyoYEBvvz
         +zTx7d/gLZalhZ1zJ1IGrtYrNw3kGncawG5RBMYsZc0ldKXZVDLDZpXIXkYcHcimdyP6
         9wbKDX99oUmhvXCaWds1r9XcpaDtrdaN0yd4MHFmN6IFb3gQH3Bz8o6ilvggV37q4uWN
         K9qA==
X-Gm-Message-State: ANoB5pkkmgtSFPeMqK9FtOBQZYciirHwIN4el3W3Ps/Roe794qr2Ki5V
        0sSuuAIG0/ZsdlE1U1RdfGDSCidnm35N+dNlB4ZDZg==
X-Google-Smtp-Source: AA0mqf540Ch/JyuFpiiDKWPOAX59KoM461AXv5sAa0B7Q2e4Vyjz9hcXS6IiMrETD1/aDN3GVzZMwHYxSRcJwIai+dA=
X-Received: by 2002:a05:6402:f1c:b0:46a:b1a9:c34e with SMTP id
 i28-20020a0564020f1c00b0046ab1a9c34emr33491776eda.212.1671570055865; Tue, 20
 Dec 2022 13:00:55 -0800 (PST)
MIME-Version: 1.0
References: <20221208072520.26210-1-peter.wang@mediatek.com> <yq14jtyekv2.fsf@ca-mkp.ca.oracle.com>
In-Reply-To: <yq14jtyekv2.fsf@ca-mkp.ca.oracle.com>
From:   Daniil Lunev <dlunev@chromium.org>
Date:   Wed, 21 Dec 2022 08:00:44 +1100
Message-ID: <CAONX=-d-LZSV9-R=oLDFKsBG8Zd90wXOcGR44kPaorDH-Y7MnQ@mail.gmail.com>
Subject: Re: [PATCH v6] ufs: core: wlun suspend SSU/enter hibern8 fail recovery
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     peter.wang@mediatek.com, stanley.chu@mediatek.com,
        linux-scsi@vger.kernel.org, avri.altman@wdc.com,
        alim.akhtar@samsung.com, jejb@linux.ibm.com,
        wsd_upstream@mediatek.com, linux-mediatek@lists.infradead.org,
        chun-hung.wu@mediatek.com, alice.chao@mediatek.com,
        cc.chou@mediatek.com, chaotian.jing@mediatek.com,
        jiajie.hao@mediatek.com, powen.kao@mediatek.com,
        qilin.tan@mediatek.com, lin.gui@mediatek.com,
        tun-yu.yu@mediatek.com, eddie.huang@mediatek.com,
        naomi.chu@mediatek.com, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> Applied to 6.2/scsi-staging, thanks!

There is an interesting side effect of the patch in this iteration
(which I am not sure was present in the past iteration I tried):
If the device auto suspends while running purge - controller is
seemingly recent and thus the purge is aborted (with no patch at all
it hangs).
That might be ok behaviour though - it will just make it an explicit
requirement to disable runtime suspend during the management
operation.

localhost ~ # ufs-utils fl -t 6 -e -p /dev/bsg/ufs-bsg0
localhost ~ # ufs-utils attr -a -p /dev/bsg/ufs-bsg0 | grep bPurgeStatus
bPurgeStatus               := 0x00

[   25.801980] ufs_device_wlun 0:0:0:49488: START_STOP failed for
power mode: 2, result 2
[   25.802002] ufs_device_wlun 0:0:0:49488: Sense Key : Not Ready [current]
[   25.802009] ufs_device_wlun 0:0:0:49488: Add. Sense: No additional
sense information
[   25.802020] ufs_device_wlun 0:0:0:49488: ufshcd_wl_runtime_suspend
failed: -16
