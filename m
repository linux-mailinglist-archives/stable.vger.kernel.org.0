Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF0915819CE
	for <lists+stable@lfdr.de>; Tue, 26 Jul 2022 20:34:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231511AbiGZSee (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Jul 2022 14:34:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229969AbiGZSed (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Jul 2022 14:34:33 -0400
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D82DF20F65;
        Tue, 26 Jul 2022 11:34:32 -0700 (PDT)
Received: by mail-pf1-f172.google.com with SMTP id w205so10637599pfc.8;
        Tue, 26 Jul 2022 11:34:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=9iC4DHntD7xvX1eDSC1HBk4kQ5QLIBClygzO/QGwT38=;
        b=2ZVtjyfTkVcBHpeJ/PxwkCXafFiibKCCNK7Me6oQFlAUIO/Byz8bvgU2J7QpXLveWD
         x9ARqvjvcTbVhKYQyzSc4vlYfqnOEjEgDpiYBJJpiQzeeNNKc4p0bDO5lXbQs3kGLi+R
         e8ffXDrVQZ8gCtr4loiqfjjQKR1BpN9R21dMRa03rj3k1NLnpa/8ZnDoc6i3VtVggiOw
         XvpfmjfVLCzqQ0fGW0UwEXz42BzoRKYTVTC14WJG1mY/JQB5qFXEVEA59mMsnu1iRo6j
         EjRVfuP/PixzljJy2dPnMpEozXIzrtNAGyxyCLTmL0+1qoOQLBvD1L573XJdioqhV9qq
         pdMA==
X-Gm-Message-State: AJIora9RRSdSxsptkwn7A3+CCxgneF/OE0MNJXaYlur3VjdCknXbcBIJ
        PxiSd+rJaUjMR+S50GqkJto=
X-Google-Smtp-Source: AGRyM1trXbSNGbtwlha5HjgkQeZN1fwHLv0GvtlpTt7idl6MXS34Uje3AbSmSUUjU1P1n8BRbnpuRQ==
X-Received: by 2002:a63:6116:0:b0:41b:29b2:f6c9 with SMTP id v22-20020a636116000000b0041b29b2f6c9mr4189599pgb.300.1658860472246;
        Tue, 26 Jul 2022 11:34:32 -0700 (PDT)
Received: from ?IPV6:2620:0:1000:2514:d651:8cbe:9208:2d2e? ([2620:0:1000:2514:d651:8cbe:9208:2d2e])
        by smtp.gmail.com with ESMTPSA id f4-20020a170902684400b0016c1cdd2de3sm11812609pln.281.2022.07.26.11.34.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Jul 2022 11:34:31 -0700 (PDT)
Message-ID: <99a93de2-70ee-da5f-4e94-676c0666acc2@acm.org>
Date:   Tue, 26 Jul 2022 11:34:29 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v4] ufs: core: correct ufshcd_shutdown flow
Content-Language: en-US
To:     peter.wang@mediatek.com, stanley.chu@mediatek.com,
        linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        avri.altman@wdc.com, alim.akhtar@samsung.com, jejb@linux.ibm.com
Cc:     wsd_upstream@mediatek.com, linux-mediatek@lists.infradead.org,
        chun-hung.wu@mediatek.com, alice.chao@mediatek.com,
        cc.chou@mediatek.com, chaotian.jing@mediatek.com,
        jiajie.hao@mediatek.com, powen.kao@mediatek.com,
        qilin.tan@mediatek.com, lin.gui@mediatek.com,
        stable@vger.kernel.org
References: <20220726113653.25024-1-peter.wang@mediatek.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20220726113653.25024-1-peter.wang@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/26/22 04:36, peter.wang@mediatek.com wrote:
> In normal case: ufshcd_wl_shutdown -> ufshcd_shtdown
> ufshcd_shtdown should turn off clock/power after ufshcd_wl_shutdown
> which set device power off and link off.

The above sentence is confusing: it mentions "normal case" which 
suggests there is also an abnormal case. Isn't the order in which 
ufshcd_wl_shutdown() and ufshcd_shutdown() are called always the same?

Otherwise this patch looks good to me.

Thanks,

Bart.
