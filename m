Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A67D658DF46
	for <lists+stable@lfdr.de>; Tue,  9 Aug 2022 20:43:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344408AbiHISnh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Aug 2022 14:43:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245692AbiHISnA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Aug 2022 14:43:00 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EECF27FE6
        for <stable@vger.kernel.org>; Tue,  9 Aug 2022 11:18:40 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id z20so14251031edb.9
        for <stable@vger.kernel.org>; Tue, 09 Aug 2022 11:18:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=84/r2kjt0BJMekeYeQ77BY29KzxyLybs6RfEESK+qPI=;
        b=J8+U8EA7SF5sCR6LUu2gmHOOndwyu68HjL4TE5JCsV2MQWoJOIU/7RJUQldtv9u7Iy
         5alUWdmu/AQN/GXjTho9scPaTzSqjahNbZ57mYsYNQQCdg6042c+WyJB3dZF7tGsi60f
         YKKxlt/6Zggh0JeJQsKkExDPQZrCdMOXdfTIgTO4h9SvEgByZ0HmJwfL+6NNOEviIg1y
         mmdYFn0OLGlheeIoMs4yuP+L/nu4ei2mVpzoqCzanmt0S80QySlMgZBaK2kgyJHzcMtn
         ant2AAenZ2n0r+zNllRTw160XVIxO4p4Ehl9wmQpEeVKOU32L8NNdWYvslJIJ+9gtWO+
         ZR2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=84/r2kjt0BJMekeYeQ77BY29KzxyLybs6RfEESK+qPI=;
        b=v3Ckup6/mJmcH95HU1RYDqkhlv2j59wMg2e9xvjmY+NFjTUB8YrFzDhGIqxQXTxB5M
         7h9eEAkm6RCOVO0KYYti3nYose+QLqnXXM6IfIqGEWDdVysJ4U/6f0ETmXIkCR5eaEqV
         9hFA7E43G82geDWCJaKWbzLXPz5VuwI61qF+XAyjsIY9n4UIBEm7e29jvEyTLUztWfRk
         txwIDEFjiGDyY7GgNsQb70eLgtI9dWdX969Dx7Lq0s5R5ZunMJEHTtpN+A8xWqtWLbk6
         d8PyPn6mtfhDYcH5NX9uMjfLlh5aJvZHSROfSCjPKAblSRvOzPgRwecFmQaKLNsPCQcC
         1uaA==
X-Gm-Message-State: ACgBeo1JVpere3tFd4MRUa4PblPHMfjvoW19KB9rdllpGXT/4NkXUk0x
        cxEkQ13BIvZeLMflxBeI5Oo=
X-Google-Smtp-Source: AA6agR5Wktfsx0DLag0YDckFSUsSp3LklAn4f+SH2tYvfFhK5qHOplVLQmBAvMMI3VWOlMrIrDVQ0A==
X-Received: by 2002:a05:6402:34c3:b0:43d:d8d7:a328 with SMTP id w3-20020a05640234c300b0043dd8d7a328mr23351975edc.297.1660069118991;
        Tue, 09 Aug 2022 11:18:38 -0700 (PDT)
Received: from localhost.localdomain (109-178-233-54.pat.ren.cosmote.net. [109.178.233.54])
        by smtp.gmail.com with ESMTPSA id u19-20020aa7db93000000b0043bbb3535d6sm6318694edt.66.2022.08.09.11.18.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Aug 2022 11:18:38 -0700 (PDT)
From:   Michael Bestas <mkbestas@gmail.com>
To:     gregkh@linuxfoundation.org
Cc:     hsinyi@chromium.org, mkbestas@gmail.com, rppt@linux.ibm.com,
        stable@vger.kernel.org, swboyd@chromium.org, will@kernel.org
Subject: Re: [PATCH] arm64: map FDT as RW for early_init_dt_scan()
Date:   Tue,  9 Aug 2022 21:17:53 +0300
Message-Id: <20220809181753.2556152-1-mkbestas@gmail.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <YvKVlhUZ2I1omy5S@kroah.com>
References: <YvKVlhUZ2I1omy5S@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=0.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 9 Aug 2022 19:12:54 +0200
Greg KH <gregkh@linuxfoundation.org> wrote:

> What about 4.14.y and newer?
> 
> thanks,
> 
> greg k-h  

This patch should be required on all stable kernels that got commit
"fdt: add support for rng-seed", however I have not tested it.

A similar backport exists in android 4.19 kernel:
https://android-review.googlesource.com/c/kernel/common/+/1238592

Without this patch, Google Pixel 3/3a fails at a very early boot
stage after merging v4.9.320+ due to the random backport.

Sorry if I messed something up with the emails, this is the first
time I submit something to a mailing list.

Thanks,

Michael Bestas
