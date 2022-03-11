Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B724E4D56D5
	for <lists+stable@lfdr.de>; Fri, 11 Mar 2022 01:38:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231950AbiCKAjb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Mar 2022 19:39:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234656AbiCKAjb (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Mar 2022 19:39:31 -0500
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 408C9506E9
        for <stable@vger.kernel.org>; Thu, 10 Mar 2022 16:38:28 -0800 (PST)
Received: by mail-pg1-x52d.google.com with SMTP id t14so6109595pgr.3
        for <stable@vger.kernel.org>; Thu, 10 Mar 2022 16:38:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language
         :from:to:cc:references:in-reply-to:content-transfer-encoding;
        bh=7aGbdxDhXZ8wDd++KZCUu5nZoO1j5tDQvd2lHwBG6gQ=;
        b=QoALnnAujshwavRdNcUsNmYGnQUk0UCd7p0d3d0iTiFV810dm5E41PmYs0J6OgmSom
         lUSRkW60tzL4GL7b09uCb4rVbYiSBOz28eiTpA0cI+Dr23HHCdxwo+ZYqgo3k/H+G3z7
         kusxKx44zrR3p2Ss6ZPID4XJSlqLatdlCVDXvl0y+gLT2HFurDSFwSDKCeZkYTacs983
         jw6F4ye813rjb55/9BOTBHyj8cW4pu8bJCUvOvgJO2iaGTfMoCxSd8RoNPoE6UtEvwwT
         /v69q2X3wzP87G3dkWG6NlxnWrggieQwa1akAkHVcyjluoiGBTa8b5HRnKk1qzGH4zkF
         sLfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:cc:references:in-reply-to
         :content-transfer-encoding;
        bh=7aGbdxDhXZ8wDd++KZCUu5nZoO1j5tDQvd2lHwBG6gQ=;
        b=yNMKTp/MfhYV0Qivw+cL1jFCr4bZ9c0ZCW88/mGLeaAktN1EBQsM8YvV9OmBKgSEZR
         XdkI6T+MIKiSZtkMWK0WxJ+hurscCWjirl3Veeq6yVjnK3ft1ViQN6LmzmCUG7mT4aUd
         f7UxfFU0Wd4LZpkByNhXbnkTd2L99bQqamye+vpIkv1VDlhQSFnkGRth1BS4cGP9mUi+
         gyTFKIKbf1gdk7fk9dgGrckeZoyXmt5DrRCZZnEXEymYc3R/z+TmHVplW6ucHawYyOom
         li7NXjGBEJXLwobP3DxDue3liycGiaZdrwnT/ra7QusXShnn8Hn9drKXC09GAOLvk3aV
         l1EA==
X-Gm-Message-State: AOAM531FV0rlqFMseAPPSeIkXkzo+b3+5VY3htCZdaFsDvMzn98iqIa+
        DEevCvvqnhvsV+QNpZkPyoSlDg==
X-Google-Smtp-Source: ABdhPJxiGWAnrjoZu6vpBcFjJNkjglYBHZWw3rDGcDIMSYQXiuBSnmpSdBvQJ0Zr7CSoOqa5xQbCIg==
X-Received: by 2002:a05:6a00:174d:b0:4f6:67e3:965 with SMTP id j13-20020a056a00174d00b004f667e30965mr7727461pfc.39.1646959107674;
        Thu, 10 Mar 2022 16:38:27 -0800 (PST)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id s30-20020a056a001c5e00b004f73f27aa40sm8101678pfw.161.2022.03.10.16.38.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Mar 2022 16:38:27 -0800 (PST)
Message-ID: <e66ac6f0-ea7d-36d2-bcff-b18a0f84e57b@kernel.dk>
Date:   Thu, 10 Mar 2022 17:38:26 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [PATCH] block: check more requests for multiple_queues in
 blk_attempt_plug_merge
Content-Language: en-US
From:   Jens Axboe <axboe@kernel.dk>
To:     Song Liu <song@kernel.org>
Cc:     linux-block@vger.kernel.org,
        linux-raid <linux-raid@vger.kernel.org>, stable@vger.kernel.org,
        Larkin Lowrey <llowrey@nuclearwinter.com>,
        Wilson Jonathan <i400sjon@gmail.com>,
        Roger Heflin <rogerheflin@gmail.com>
References: <20220309064209.4169303-1-song@kernel.org>
 <9516f407-bb91-093b-739d-c32bda1b5d8d@kernel.dk>
 <CAPhsuW5zX96VaBMu-o=JUqDz2KLRBcNFM_gEsT=tHjeYqrngSQ@mail.gmail.com>
 <38f7aaf5-2043-b4f4-1fa5-52a7c883772b@kernel.dk>
 <CAPhsuW7zdYZqxaJ7SOWdnVOx-cASSoXS4OwtWVbms_jOHNh=Kw@mail.gmail.com>
 <2b437948-ba2a-c59c-1059-e937ea8636bd@kernel.dk>
 <CAPhsuW6ueGM_DZuAWvMbaB4PNftA5_MaqzMiY8_Bz7Bqy-ahZA@mail.gmail.com>
 <40ae10bd-6839-2246-c2d7-aa11e671d7d4@kernel.dk>
In-Reply-To: <40ae10bd-6839-2246-c2d7-aa11e671d7d4@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/10/22 5:36 PM, Jens Axboe wrote:
> I'm assuming you have a plug setup for doing the reads, which is why you
> see the big difference (or there would be none). But
> blk_mq_flush_plug_list() should really take care of this when the plug
> is flushed, requests should be merged at that point. And from your
> description, doesn't sound like they are at all.

Maybe you need a list sort in blk_mq_flush_plug_list(). If you
round-robin all the drives, then we'll hit that "run queue" path for
each of them when we flush.

-- 
Jens Axboe

