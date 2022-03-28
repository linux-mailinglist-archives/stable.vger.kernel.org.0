Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D49704E915E
	for <lists+stable@lfdr.de>; Mon, 28 Mar 2022 11:31:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231818AbiC1JdM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Mar 2022 05:33:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239841AbiC1JdK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Mar 2022 05:33:10 -0400
Received: from smtp-out.xnet.cz (smtp-out.xnet.cz [178.217.244.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28485541A8
        for <stable@vger.kernel.org>; Mon, 28 Mar 2022 02:31:29 -0700 (PDT)
Received: from meh.true.cz (meh.true.cz [108.61.167.218])
        (Authenticated sender: petr@true.cz)
        by smtp-out.xnet.cz (Postfix) with ESMTPSA id 86FCF18FEE;
        Mon, 28 Mar 2022 11:31:26 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=true.cz; s=xnet;
        t=1648459886; bh=CWeJLEmKqOBetX/qaLgAr8BaFCyVFkxLfFNeOJrE4Pg=;
        h=From:To:Cc:Subject:Date;
        b=fbK7KZOCYPk1cHgM1Xb9OaEgK8+pC4Je8G6Dt+6rhXglwJe5GaKXwlCya2FOGZSng
         s4XNJnkK61VSrm2t7s4ylJBDymLAxVSDKkOLfWBy8KlNTvqKIL3EPoaVc8nnoME9QV
         gn214tcSQEzJ/kLFrPDSsUL6LYxQ8vT3NLE9LZYA=
Received: by meh.true.cz (OpenSMTPD) with ESMTP id 2621b737;
        Mon, 28 Mar 2022 11:31:02 +0200 (CEST)
From:   =?UTF-8?q?Petr=20=C5=A0tetiar?= <ynezz@true.cz>
To:     stable@vger.kernel.org
Cc:     =?UTF-8?q?Petr=20=C5=A0tetiar?= <ynezz@true.cz>,
        linux-hyperv@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>
Subject: Backport fix for 5.15: hv: utils: add PTP_1588_CLOCK to Kconfig to fix build
Date:   Mon, 28 Mar 2022 11:31:15 +0200
Message-Id: <20220328093115.7486-1-ynezz@true.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

I would like to ask for a backport of upstream commit 1dc2f2b81a6a ("hv:
utils: add PTP_1588_CLOCK to Kconfig to fix build") to 5.15 kernel series as
it fixes following build failure for me with 5.15.31:

 x86_64-openwrt-linux-musl-ld: drivers/hv/hv_util.o: in function `hv_timesync_deinit':
 linux-x86_64/linux-5.15.31/drivers/hv/hv_util.c:770: undefined reference to `ptp_clock_unregister'
 x86_64-openwrt-linux-musl-ld: drivers/hv/hv_util.o: in function `hv_timesync_init':
 linux-x86_64/linux-5.15.31/drivers/hv/hv_util.c:746: undefined reference to `ptp_clock_register'

Thanks!

Cheers,

Petr
