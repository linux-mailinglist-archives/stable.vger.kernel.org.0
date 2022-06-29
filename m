Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5573E55FEEA
	for <lists+stable@lfdr.de>; Wed, 29 Jun 2022 13:41:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233205AbiF2LjT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Jun 2022 07:39:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233204AbiF2LjG (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Jun 2022 07:39:06 -0400
Received: from relay5-d.mail.gandi.net (relay5-d.mail.gandi.net [217.70.183.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9417A3F301
        for <stable@vger.kernel.org>; Wed, 29 Jun 2022 04:39:02 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id B97C91C0007;
        Wed, 29 Jun 2022 11:38:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1656502737;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MzDaS83uRvN7N2712p5p6kNZK0guhzhsJz4z5vTBUnI=;
        b=kqOt8I4U1SxqkuWTomp/zztwci316/QgGWxEBeTRPSTMiPX/wBWekh0krNzGxOuMvORZ4L
        P3l9LN654tz9Q9IH2KGiv4+JNA2u+i2b49F+0XpI5zYqoP0JEvyYfexbXxZ5YPImlA7Wvk
        q7CKzA9b9uLl2CVmrRzClewX1XJ9ONN7KqHeafhVXaoAGjHql8525xn4ma+K2yRT7YqOIN
        dESv5cMTaOUSv+Q9GO8Pkm+VZxZoo0YvmQRs441V2jEWy8+QxDBuBG/PMKeD/LRWeKfE2A
        JN0qwMm1ummEPsj0vdDWd3dAiJYtUJqcsSPDo+Irj/Gd9B6quMVf1Mzkjknk/w==
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Amit Kumar Mahapatra <amit.kumar-mahapatra@xilinx.com>,
        miquel.raynal@bootlin.com, nagasure@xilinx.com, vigneshr@ti.com
Cc:     boris.brezillon@collabora.com, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org, git@amd.com, richard@nod.at,
        amit.kumar-mahapatra@amd.com, Olga Kitaina <okitain@gmail.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH v3 2/2] mtd: rawnand: arasan: Fix clock rate in NV-DDR
Date:   Wed, 29 Jun 2022 13:38:55 +0200
Message-Id: <20220629113855.283760-1-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220628154824.12222-3-amit.kumar-mahapatra@xilinx.com>
References: 
MIME-Version: 1.0
X-linux-mtd-patch-notification: thanks
X-linux-mtd-patch-commit: b'e16eceea863b417fd328588b1be1a79de0bc937f'
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 2022-06-28 at 15:48:24 UTC, Amit Kumar Mahapatra wrote:
> From: Olga Kitaina <okitain@gmail.com>
> 
> According to the Arasan NAND controller spec, the flash clock rate for SDR
> must be <= 100 MHz, while for NV-DDR it must be the same as the rate of the
> CLK line for the mode. The driver previously always set 100 MHz for NV-DDR,
> which would result in incorrect behavior for NV-DDR modes 0-4.
> 
> The appropriate clock rate can be calculated from the NV-DDR timing
> parameters as 1/tCK, or for rates measured in picoseconds,
> 10^12 / nand_nvddr_timings->tCK_min.
> 
> Fixes: 197b88fecc50 ("mtd: rawnand: arasan: Add new Arasan NAND controller")
> CC: stable@vger.kernel.org # 5.8+
> Signed-off-by: Olga Kitaina <okitain@gmail.com>
> Signed-off-by: Amit Kumar Mahapatra <amit.kumar-mahapatra@xilinx.com>

Applied to https://git.kernel.org/pub/scm/linux/kernel/git/mtd/linux.git nand/next, thanks.

Miquel
