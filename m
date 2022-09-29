Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A4325EFB27
	for <lists+stable@lfdr.de>; Thu, 29 Sep 2022 18:44:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235859AbiI2Qow (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Sep 2022 12:44:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235802AbiI2Qov (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Sep 2022 12:44:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D9D4627A;
        Thu, 29 Sep 2022 09:44:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C3B2CB823CB;
        Thu, 29 Sep 2022 16:44:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E30F2C433D6;
        Thu, 29 Sep 2022 16:44:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664469878;
        bh=08DZeiJIcmGMGqxP734VuYdAt4eOjHGyRG2ZlK6jCII=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=l+z9UV3tEk6GZM38E8dzL+JQKVzwmK2yZV25zL4p1L6BYaQRMT52hQ2QaR1jQc0+W
         5eAuZkTZfqmFlikwNnMswhqGk6hVrXV7QE0B2XtnwGyONEcOKfBk8N6yLVS2/uSFEc
         K+T9vfurzt953JdfqkXyUKOQ9q1rvCYOBfAYZ4fuKr0H10bZhtjvfePlLJxwaKDINi
         d40IP+fdhcaqBVgXtZ2rnXv/Z5ekcDbeVwmMGqJclkFQT/Bwc66/m4RvBDqegrU3Ue
         aMpA5PVAO/rkEbCDrRKxDMgOeKxiT5P7yxDI8HGC6heJWeelrkfcVCGOj9S12CDk5u
         W+NrTu/90JdFw==
Date:   Thu, 29 Sep 2022 22:14:34 +0530
From:   Vinod Koul <vkoul@kernel.org>
To:     Christian Marangi <ansuelsmth@gmail.com>
Cc:     Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@somainline.org>,
        Arnd Bergmann <arnd@arndb.de>, Mark Brown <broonie@kernel.org>,
        Thomas Pedersen <twp@codeaurora.org>,
        Jonathan McDowell <noodles@earth.li>,
        linux-arm-msm@vger.kernel.org, dmaengine@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] dmaengine: qcom-adm: fix wrong calling convention for
 prep_slave_sg
Message-ID: <YzXLcvv1eiRXzrND@matsya>
References: <20220916041256.7104-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220916041256.7104-1-ansuelsmth@gmail.com>
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 16-09-22, 06:12, Christian Marangi wrote:
> The calling convention for pre_slave_sg is to return NULL on error and
> provide an error log to the system. Qcom-adm instead provide error
> pointer when an error occur. This indirectly cause kernel panic for
> example for the nandc driver that checks only if the pointer returned by
> device_prep_slave_sg is not NULL. Returning an error pointer makes nandc
> think the device_prep_slave_sg function correctly completed and makes
> the kernel panics later in the code.
> 
> While nandc is the one that makes the kernel crash, it was pointed out
> that the real problem is qcom-adm not following calling convention for
> that function.
> 
> To fix this, drop returning error pointer and return NULL with an error
> log.

Applied, thanks

-- 
~Vinod
