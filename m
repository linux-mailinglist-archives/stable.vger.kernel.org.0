Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A11424B07F1
	for <lists+stable@lfdr.de>; Thu, 10 Feb 2022 09:17:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237245AbiBJIQy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Feb 2022 03:16:54 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:53326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237105AbiBJIQw (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Feb 2022 03:16:52 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EC63109E;
        Thu, 10 Feb 2022 00:16:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E05E46128D;
        Thu, 10 Feb 2022 08:16:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65074C004E1;
        Thu, 10 Feb 2022 08:16:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644481013;
        bh=pY+kYYBMcgXvvd1QLrlQo1EVEtYJtXoEbZCyjGohZH4=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=l0PrDUi/YOlJDb3awfaQpXLyrwOJKeg/EJwZfN8ENdU3lrA/MsZsmizYBxuJLbdFC
         DQk2rLTIo0xE6Hu3v8wbiwez6hXg7SuR7fG8qxidrQy+dCTxPkc+/hlklyyPzla4Wb
         OLLoUQt5BF6gnOCW7RLmv3r6ICK3Vdvopmhi76jogVz5wSQoKTrUiOuKuawUGHErsT
         0rcmhq5AVdAWhoKpiTc/asL7bK5TYS+2BmW70VEyhj+XGEMy8Tl6LZpo61ONw5zQ+y
         W2pWf3bXCNmvkzJw0i5s0Ou5qbyxnMVW4F3svNw9Dy4AecZumfIbPDmKCD2oxGqUPP
         ySRoEwnhB2hsQ==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] iwlwifi: fix use-after-free
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20220208114728.e6b514cf4c85.Iffb575ca2a623d7859b542c33b2a507d01554251@changeid>
References: <20220208114728.e6b514cf4c85.Iffb575ca2a623d7859b542c33b2a507d01554251@changeid>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        stable@vger.kernel.org, Stefan Agner <stefan@agner.ch>,
        Wolfgang Walter <linux@stwm.de>,
        Jason Self <jason@bluehome.net>,
        Dominik Behr <dominik@dominikbehr.com>,
        =?utf-8?q?Marek_Marczykowski-G=C3=B3recki?= 
        <marmarek@invisiblethingslab.com>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <164448100914.10463.9523338503936670263.kvalo@kernel.org>
Date:   Thu, 10 Feb 2022 08:16:51 +0000 (UTC)
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Johannes Berg <johannes@sipsolutions.net> wrote:

> From: Johannes Berg <johannes.berg@intel.com>
> 
> If no firmware was present at all (or, presumably, all of the
> firmware files failed to parse), we end up unbinding by calling
> device_release_driver(), which calls remove(), which then in
> iwlwifi calls iwl_drv_stop(), freeing the 'drv' struct. However
> the new code I added will still erroneously access it after it
> was freed.
> 
> Set 'failure=false' in this case to avoid the access, all data
> was already freed anyway.
> 
> Cc: stable@vger.kernel.org
> Reported-by: Stefan Agner <stefan@agner.ch>
> Reported-by: Wolfgang Walter <linux@stwm.de>
> Reported-by: Jason Self <jason@bluehome.net>
> Reported-by: Dominik Behr <dominik@dominikbehr.com>
> Reported-by: Marek Marczykowski-Górecki <marmarek@invisiblethingslab.com>
> Fixes: ab07506b0454 ("iwlwifi: fix leaks/bad data after failed firmware load")
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>

Patch applied to wireless.git, thanks.

bea2662e7818 iwlwifi: fix use-after-free

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20220208114728.e6b514cf4c85.Iffb575ca2a623d7859b542c33b2a507d01554251@changeid/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

