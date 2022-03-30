Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD14E4EBF6A
	for <lists+stable@lfdr.de>; Wed, 30 Mar 2022 13:00:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245677AbiC3LCK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Mar 2022 07:02:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241893AbiC3LCJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Mar 2022 07:02:09 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2B3E6DF70
        for <stable@vger.kernel.org>; Wed, 30 Mar 2022 04:00:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1648638024;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=m+qM5BYUh2SbXwwdXm4zRTzrbjo9fFBpkgpHvRbLLWk=;
        b=aIfFxhdpxqtcB4W/HE3VtOuBJEfSLZkTIThmuJpLjge/P8z2Mx8VJOdqk/JwL5ddnvtLvz
        MdLdw6pZRVcOCqNEA7NTMP85kSV292/46pUQbKs0oTzRhZBNueAYOP1mTglkxgMwKQuVVr
        oomMaRRJ4NoC8rsE21O1ZV5blIA7+rE=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-327-ScfOH63tOK-NrmS9j5ESmg-1; Wed, 30 Mar 2022 07:00:21 -0400
X-MC-Unique: ScfOH63tOK-NrmS9j5ESmg-1
Received: by mail-wr1-f70.google.com with SMTP id i64-20020adf90c6000000b00203f2b5e090so5757729wri.9
        for <stable@vger.kernel.org>; Wed, 30 Mar 2022 04:00:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=m+qM5BYUh2SbXwwdXm4zRTzrbjo9fFBpkgpHvRbLLWk=;
        b=XY2HVjw+d1NhH2zhPnOmPelaSFknVZ21kfqKFKiEMAqBf3m/r1QdXO4xGKqkac/gg9
         CPaVRmaDqJahB9s5WJhH0uJscG3qt1CiBefbsCefEb+9sCwjgz7rvqtAlY5V2B0SVw84
         vIzR0SNjM4sEO3v/UQJVsjx0Z5d9Blsieo/Q2mV/TaggYx0+b6sJkVEpSYC1SJrZt847
         8etV+Eog5ayRff7rg0AJQfUnLxN4imVeb51wjKwz9bNkGmWj1Og73XAkA8ZDB3qP4Dc4
         G/896EvntrU0L12V75Td6jwCdFpRfF1uWgB/Aoird3KbiUV471wpIPDC3dKyaQPRfdJa
         kmEw==
X-Gm-Message-State: AOAM532ifjqoqjP8S+qWAYQHneYfsgxxfzcakMZohtTXLnKO9vxAFvg0
        3bpUHCcZWTUA0ebpIeRNtLitbYkJU++Cy6eG3hcb9e2rB1mAEheOyHVGRbVFlXr49jSQ1i3anvs
        vxMl/xsXobnB9ogow
X-Received: by 2002:a5d:64ce:0:b0:204:1175:690c with SMTP id f14-20020a5d64ce000000b002041175690cmr35770939wri.602.1648638020721;
        Wed, 30 Mar 2022 04:00:20 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz0dyHvdosHH+/8LXcjPRuKM5vmxXIvKxc6vTr6ZDvMg+Zy/VL77xlZ0PXwyuL4Ayn4lVdqVA==
X-Received: by 2002:a5d:64ce:0:b0:204:1175:690c with SMTP id f14-20020a5d64ce000000b002041175690cmr35770929wri.602.1648638020511;
        Wed, 30 Mar 2022 04:00:20 -0700 (PDT)
Received: from redhat.com ([2.52.9.207])
        by smtp.gmail.com with ESMTPSA id y15-20020a05600015cf00b00203e324347bsm19968551wry.102.2022.03.30.04.00.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Mar 2022 04:00:20 -0700 (PDT)
Date:   Wed, 30 Mar 2022 07:00:16 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Lee Jones <lee.jones@linaro.org>
Cc:     stable@vger.kernel.org, Xie Yongji <xieyongji@bytedance.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 1/1] virtio-blk: Use blk_validate_block_size() to
 validate block size
Message-ID: <20220330065954-mutt-send-email-mst@kernel.org>
References: <20220330105841.464954-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220330105841.464954-1-lee.jones@linaro.org>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 30, 2022 at 11:58:41AM +0100, Lee Jones wrote:

empty patch. Try using git send email.

-- 
MST

