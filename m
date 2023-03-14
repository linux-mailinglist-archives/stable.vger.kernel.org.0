Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 473BC6B891F
	for <lists+stable@lfdr.de>; Tue, 14 Mar 2023 04:45:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229582AbjCNDpJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Mar 2023 23:45:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbjCNDpH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Mar 2023 23:45:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DFAD1C310;
        Mon, 13 Mar 2023 20:45:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CC7B5615C6;
        Tue, 14 Mar 2023 03:45:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B4A1C433D2;
        Tue, 14 Mar 2023 03:45:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678765505;
        bh=ArYrY/9+cCXJxZ6fwPVtoQLz6z4U6hCI/8ZtMgB0F1o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RcOxTyzHAiMued+5V3VfdwpUr7phcyfzAq8QLYBAOOX/xdNydMmc7aMQRGG8N8u0p
         VSpwTLM992C3CXZmp4BpLn/XFSB1yjgEe5UMhzje7VeE8KHE4LN9cHH6SyJ5bG0zjO
         aSOUItcSphJsNaw+bjcJMPspTSDtuzwMKxkDYqUchWz3jID7MvvFm/Ip0Y2J7qzlg5
         ClxCzTVZt6qWBQmbCNNrckJUFx71IytDu0rnvZiV3NRYZ37xeLFNs9H2/0zMN5zawM
         BgfbKQKtjDF6kubhxmpvP+zmCAUGKVNxCatkbcIrE7wbDtJ28UmMWULxU6WYNPrtR8
         rp2HpEe7fO9DA==
Date:   Tue, 14 Mar 2023 11:44:58 +0800
From:   Shawn Guo <shawnguo@kernel.org>
To:     Ivan Bornyakov <i.bornyakov@metrotek.ru>
Cc:     linux-imx@nxp.com, s.hauer@pengutronix.de, kernel@pengutronix.de,
        festevam@gmail.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2] bus: imx-weim: fix branch condition evaluates to a
 garbage value
Message-ID: <20230314034458.GQ143566@dragon>
References: <20230306060505.11657-1-i.bornyakov@metrotek.ru>
 <20230306132526.8763-1-i.bornyakov@metrotek.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230306132526.8763-1-i.bornyakov@metrotek.ru>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 06, 2023 at 04:25:26PM +0300, Ivan Bornyakov wrote:
> If bus type is other than imx50_weim_devtype and have no child devices,
> variable 'ret' in function weim_parse_dt() will not be initialized, but
> will be used as branch condition and return value. Fix this by
> initializing 'ret' with 0.
> 
> This was discovered with help of clang-analyzer, but the situation is
> quite possible in real life.
> 
> Fixes: 52c47b63412b ("bus: imx-weim: improve error handling upon child probe-failure")
> Signed-off-by: Ivan Bornyakov <i.bornyakov@metrotek.ru>
> Cc: stable@vger.kernel.org
> Reviewed-by: Fabio Estevam <festevam@gmail.com>

Ok, picked this version up instead.
