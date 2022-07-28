Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 670BF5845EB
	for <lists+stable@lfdr.de>; Thu, 28 Jul 2022 20:53:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229486AbiG1S1X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Jul 2022 14:27:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229485AbiG1S1X (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 Jul 2022 14:27:23 -0400
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 804BA6D556;
        Thu, 28 Jul 2022 11:27:22 -0700 (PDT)
Received: by mail-pj1-f49.google.com with SMTP id d65-20020a17090a6f4700b001f303a97b14so3002399pjk.1;
        Thu, 28 Jul 2022 11:27:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=BcO9zWJV/5IIyHkNAzGcQRIZepKEay3HAgW3uDP3bO4=;
        b=A3678kZSaTBWE+PnqVo6RKCFjvzdDj3LjqRuMxw507Q8B0WCXHarITyssO3aLjJ12k
         jNFweg6wE3bIuyjsQ5C2WZhEY0eZ+iT60KpjJ5wLvCnuhCIcDmdpNObRoeWH+Fez5aSd
         JIPwCPoU9np2jssBpcrq7VgyGqVJ3/1d6rMKhA4hNRFFfsMVPds7E7eGq67vUH9VtsEV
         QUYN4Ymu6CeyGZFsjvxOtwc1OPSmrU3magQBleDI4uZifY5MrauUtBLNuf75DV9wKuwg
         Br6ZVpisrmykyif4IChUyiAcgpl9FtCnF8YLjVREfCxSEhgWWJ08Puh0JkkNjfBXNC52
         9+Lw==
X-Gm-Message-State: ACgBeo34k7oQk4M7njaWmFmH24xZUrJHD1UZNvyUvP1otQ8r3NdOrP/y
        zhf7GollnNEobC8k8kOrej9ltJk7EPi4CA==
X-Google-Smtp-Source: AA6agR5UvcsZRci6YYhjar/7IaAFMMqondM4nB22m0cab+nGstuwrbBojrS830efi/1BOuZWDL9zGg==
X-Received: by 2002:a17:902:7c05:b0:16d:2c63:da90 with SMTP id x5-20020a1709027c0500b0016d2c63da90mr204105pll.27.1659032841845;
        Thu, 28 Jul 2022 11:27:21 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:9520:2952:8318:8e3e? ([2620:15c:211:201:9520:2952:8318:8e3e])
        by smtp.gmail.com with ESMTPSA id y10-20020a62640a000000b0052c849d0886sm1101263pfb.86.2022.07.28.11.27.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Jul 2022 11:27:21 -0700 (PDT)
Message-ID: <c70d8e24-d46a-560e-ad12-49160c8ffa29@acm.org>
Date:   Thu, 28 Jul 2022 11:27:18 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v4] ufs: core: fix lockdep warning of clk_scaling_lock
Content-Language: en-US
To:     Peter Wang <peter.wang@mediatek.com>, stanley.chu@mediatek.com,
        linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        avri.altman@wdc.com, alim.akhtar@samsung.com, jejb@linux.ibm.com
Cc:     wsd_upstream@mediatek.com, linux-mediatek@lists.infradead.org,
        chun-hung.wu@mediatek.com, alice.chao@mediatek.com,
        cc.chou@mediatek.com, chaotian.jing@mediatek.com,
        jiajie.hao@mediatek.com, powen.kao@mediatek.com,
        qilin.tan@mediatek.com, lin.gui@mediatek.com,
        stable@vger.kernel.org
References: <20220727032110.31168-1-peter.wang@mediatek.com>
 <5fab3d4f-914e-63f8-a3e8-7dd92ecdb04a@acm.org>
 <47d1efed-69a7-cabf-e586-48b09a9afd78@mediatek.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <47d1efed-69a7-cabf-e586-48b09a9afd78@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/28/22 00:13, Peter Wang wrote:
> Maybe we can have another choice, let vendor decide ufshcd_wb_toggle 
> with clock scaling or not?

I prefer that this code behaves identical for all UFS host controllers 
and all UFS devices. Making this code behave different per vendor would 
make it harder to read and to verify this code.

Thanks,

Bart.
