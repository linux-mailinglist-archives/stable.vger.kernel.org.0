Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E933F6B877D
	for <lists+stable@lfdr.de>; Tue, 14 Mar 2023 02:19:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230043AbjCNBSg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Mar 2023 21:18:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229834AbjCNBSe (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Mar 2023 21:18:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 532E04C30;
        Mon, 13 Mar 2023 18:18:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E457161591;
        Tue, 14 Mar 2023 01:18:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96661C433EF;
        Tue, 14 Mar 2023 01:18:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678756711;
        bh=KLf/FUDnFAKt1b8cInxL4tc7SQPgD86Zsjy4duwD4hk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZXM15SCBZENIO48uv3gXoIbNlCUanfUy3hBKrtJT31ae1R7SNfMKe69nK2GNMscFJ
         RfKJBRp1xH7riXfVeH8sl7uDxEGxihRKYs3rMtNDBJlQpcKyJ/cBtGwIInLVfc6Gcc
         wGBEvrYCChyFptmnSX77R9Zy1qRCDbQGgQbrRV22+3YW5IYPcv1uRRZR3rPmzSmeyI
         67DngttA0zm9bwV/OsgYRyPm58cv1ZtO21wc43TBmkQNr3DXEDTOvcYPk2oRUyLnwC
         cmaK3iBBwul1fROAP8TjS4KTxIe57/QqrTpAgdnHoEAuvTChtrbT9RFnFX1jE3hLth
         x6i4eEX8VhmEQ==
Date:   Tue, 14 Mar 2023 09:18:25 +0800
From:   Shawn Guo <shawnguo@kernel.org>
To:     Ivan Bornyakov <i.bornyakov@metrotek.ru>
Cc:     linux-imx@nxp.com, s.hauer@pengutronix.de, kernel@pengutronix.de,
        festevam@gmail.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] bus: imx-weim: fix branch condition evaluates to a
 garbage value
Message-ID: <20230314011825.GZ143566@dragon>
References: <20230217135950.19469-1-i.bornyakov@metrotek.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230217135950.19469-1-i.bornyakov@metrotek.ru>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 17, 2023 at 04:59:50PM +0300, Ivan Bornyakov wrote:
> If bus type is other than imx50_weim_devtype and have no child devices,
> variable 'ret' in function weim_parse_dt() will not be initialized, but
> will be used as branch condition and return value. Fix this by
> initializing 'ret' with 0.
> 
> This was discovered with help of clang-analyzer, but the situation is
> quite possible in real life.
> 
> Signed-off-by: Ivan Bornyakov <i.bornyakov@metrotek.ru>
> Cc: stable@vger.kernel.org

Applied with Fixes tag below.  Let me know if it's incorrect.

Fixes: 52c47b63412b ("bus: imx-weim: improve error handling upon child probe-failure")

Shawn
