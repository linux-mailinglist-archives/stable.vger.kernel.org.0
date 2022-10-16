Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBD205FFFE6
	for <lists+stable@lfdr.de>; Sun, 16 Oct 2022 16:46:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229633AbiJPOqt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 16 Oct 2022 10:46:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229577AbiJPOqs (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 16 Oct 2022 10:46:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7448F2C64E;
        Sun, 16 Oct 2022 07:46:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EADA760B8B;
        Sun, 16 Oct 2022 14:46:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 197D3C433D6;
        Sun, 16 Oct 2022 14:46:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665931606;
        bh=75PnQdYsQ5WAhnnJexT0fXaGnLlhuJBW9vcYq/nL+xQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Qa5cfHDQnzd1mCdEqRlY7U7rIx10G8pGGJ3iEZD8OSrgpVE1DDgiA8Q3pO2nZc6le
         bczBeq4ohP83HgCZjiPdIHis893XNPyrQx0G2da3BHGZnHxm/SR085i7SWRaE/vh+g
         G1MGcGFdd28eUMF7CVL/lVVJm81q+g5NzQFPIv7aCbn+7nd5cVL7d+7zI7ACiLg/XW
         9nWEltNz7CsShdHiQBOFzZ8Ju5EWWxnkHfgGzs3+eFbFkEo8g5SjfiYPD6bKC2Hnxj
         q072LX7llS4V/DG88O6r1xJWpHAECR1MD9qLaqDvjE+/TNZsLDnmiH6jW1qNK1rV3F
         Ik0ZXMMU0xHFA==
Date:   Sun, 16 Oct 2022 10:46:44 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Jean Delvare <jdelvare@suse.de>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel test robot <lkp@intel.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Chenglin Xu <chenglin.xu@mediatek.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: Re: [PATCH AUTOSEL 6.0 04/46] soc: mediatek: Let PMIC Wrapper and
 SCPSYS depend on OF
Message-ID: <Y0wZVNIAqZJmqoRJ@sashalap>
References: <20221011145015.1622882-1-sashal@kernel.org>
 <20221011145015.1622882-4-sashal@kernel.org>
 <20221012004949.06d45f74@endymion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20221012004949.06d45f74@endymion.delvare>
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 12, 2022 at 12:49:49AM +0200, Jean Delvare wrote:
>Hi Sasha,
>
>On Tue, 11 Oct 2022 10:49:32 -0400, Sasha Levin wrote:
>> From: Jean Delvare <jdelvare@suse.de>
>>
>> [ Upstream commit 2778caedb5667239823a29148dfc48b26a8b3c2a ]
>>
>> With the following configuration options:
>> CONFIG_OF is not set
>> CONFIG_MTK_PMIC_WRAP=y
>> CONFIG_MTK_SCPSYS=y
>> we get the following build warnings:
>>
>>   CC      drivers/soc/mediatek/mtk-pmic-wrap.o
>> drivers/soc/mediatek/mtk-pmic-wrap.c:2138:34: warning: ‘of_pwrap_match_tbl’ defined but not used [-Wunused-const-variable=]
>> drivers/soc/mediatek/mtk-pmic-wrap.c:1953:34: warning: ‘of_slave_match_tbl’ defined but not used [-Wunused-const-variable=]
>>   CC      drivers/soc/mediatek/mtk-scpsys.o
>> drivers/soc/mediatek/mtk-scpsys.c:1084:34: warning: ‘of_scpsys_match_tbl’ defined but not used [-Wunused-const-variable=]
>> (...)
>
>This is warning only, pretty harmless, so I don't think this qualifies
>for stable kernel trees.

Ack, I can drop it.

-- 
Thanks,
Sasha
