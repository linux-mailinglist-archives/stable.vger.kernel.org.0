Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82226672A29
	for <lists+stable@lfdr.de>; Wed, 18 Jan 2023 22:15:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231160AbjARVPb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Jan 2023 16:15:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231232AbjARVOz (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 Jan 2023 16:14:55 -0500
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E64A14EC9;
        Wed, 18 Jan 2023 13:14:53 -0800 (PST)
Received: by mail-pj1-f52.google.com with SMTP id s13-20020a17090a6e4d00b0022900843652so3811609pjm.1;
        Wed, 18 Jan 2023 13:14:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dv90MU3s7P6C1enlVNdFxj7LNTywIPZMW/7xiG3iIug=;
        b=r81jXquB9LOALENvwG3VmOcEqNwmEgotG+mXDYdnMYb7Blw3f7n8oYe7hqhYZD9bSS
         yzRp2TSJJtzvSuq7BgMe5aTfwy3Wax7Mm0aWtgca5apTOZOrQ/yrQucgTIOGs5c4eRUf
         iurXY1w4MrJsrSqAOgrIGDIllpzKCk1PHy2eM9qxxMPW4ujuoNB379XV4r5D7W13RLwT
         Pvpw270WUNIqnZpbEun3e7OJKsrQUVf7xmNGK1ZEdB9K9DI+Gnz5uUHcQswUvAHxUGGO
         GOoIOGc+waNTj+PW0Tzz0x9JdkRjvrMBrnrUfYOolaOX17cfLYRLtR0+HMZLdxrcb5IQ
         qMTQ==
X-Gm-Message-State: AFqh2krP6S9n2gWV1AHAaSo/6CUOw3ZNfuCxEqrvr2lRt/0iIH97lG66
        9no5VPn1IQI+zgTXMOWbiD0=
X-Google-Smtp-Source: AMrXdXuD+IpP5W5cjMy3ZqxMBCedqoDJ4KIYHyhExt2x2UOUjVDJRKOZSwo5cIcOcDRGOjQOd/50uA==
X-Received: by 2002:a17:90a:d306:b0:229:7d9d:c47f with SMTP id p6-20020a17090ad30600b002297d9dc47fmr8672239pju.41.1674076493311;
        Wed, 18 Jan 2023 13:14:53 -0800 (PST)
Received: from ?IPV6:2620:15c:211:201:22ae:3ae3:fde6:2308? ([2620:15c:211:201:22ae:3ae3:fde6:2308])
        by smtp.gmail.com with ESMTPSA id kx8-20020a17090b228800b00218d894fac3sm1811640pjb.3.2023.01.18.13.14.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Jan 2023 13:14:52 -0800 (PST)
Message-ID: <638f5b7f-e0af-1021-24a6-d8bdc4101af7@acm.org>
Date:   Wed, 18 Jan 2023 13:14:50 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH v2] scsi: ufs: core: fix devfreq deadlocks
Content-Language: en-US
To:     Johan Hovold <johan+linaro@kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Can Guo <quic_cang@quicinc.com>,
        Andrew Halaney <ahalaney@redhat.com>
References: <20230116161201.16923-1-johan+linaro@kernel.org>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20230116161201.16923-1-johan+linaro@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/16/23 08:12, Johan Hovold wrote:
> There is a lock inversion and rwsem read-lock recursion in the devfreq
> target callback which can lead to deadlocks.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
