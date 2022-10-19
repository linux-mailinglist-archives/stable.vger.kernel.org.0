Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A4B9604531
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 14:25:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231229AbiJSMZS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 08:25:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231512AbiJSMXp (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 08:23:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0E7D7E028;
        Wed, 19 Oct 2022 04:59:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2EB03617E8;
        Wed, 19 Oct 2022 09:20:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81634C433D7;
        Wed, 19 Oct 2022 09:20:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666171219;
        bh=iEkEwO3dfbGbgLtTVIir5lJP9wDtzb6rk+4abbikf5I=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VkauozMFq7Gsp/OFZ8WjDfm1VbQmIKDIVXr9hIDm75UJ68QwgLxASI7wv3zezLMyu
         0i8MQlTEmsScSZwI9zrt6I/hmssm5uAlF0JRFc1NjpBqsa4v9NBigNf9/EB0R1B/id
         mPYfrXJxVDh3TLjsRm4Nu6m2skkJNeNqhZC0aabrhc0GfyDFElexA/yddNUiGlM3bc
         tAChp4QKfhVa7W5t6X8/OmAiEwIk9hT7rwrLHfeGIW43SgjhaBv/YRpHUqjKDre/p9
         3nY65GeQBb6YV3ez1nDRTWhYVZ5ZR6uVKMz8/Jl6HE3Ymcuh+grHCiYW4nKk1QKhcD
         BJKvje4AgXwDQ==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1ol5F9-00059Q-MO; Wed, 19 Oct 2022 11:20:07 +0200
Date:   Wed, 19 Oct 2022 11:20:07 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Johan Hovold <johan+linaro@kernel.org>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.0 585/862] phy: qcom-qmp-pcie: fix resource mapping for
 SDM845 QHP PHY
Message-ID: <Y0/BR5Qct1LNqPvM@hovoldconsulting.com>
References: <20221019083249.951566199@linuxfoundation.org>
 <20221019083315.815097879@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221019083315.815097879@linuxfoundation.org>
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 19, 2022 at 10:31:12AM +0200, Greg Kroah-Hartman wrote:
> From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
> 
> [ Upstream commit 0a40891b83f257b25a2b983758f72f6813f361cb ]
> 
> On SDM845 one of PCIe PHYs (the QHP one) has the same region for TX and
> RX registers. Since the commit 4be26f695ffa ("phy: qcom-qmp-pcie: fix
> memleak on probe deferral") added checking that resources are not
> allocated beforehand, this PHY can not be probed anymore. Fix this by
> skipping the map of ->rx resource on the QHP PHY and assign it manually.
> 
> Fixes: 4be26f695ffa ("phy: qcom-qmp-pcie: fix memleak on probe deferral")

This one is not needed in 6.0 since the offending commit should not be
backported.

> Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
> Reviewed-by: Johan Hovold <johan+linaro@kernel.org>
> Link: https://lore.kernel.org/r/20220926172514.880776-1-dmitry.baryshkov@linaro.org
> Signed-off-by: Vinod Koul <vkoul@kernel.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>

Johan
