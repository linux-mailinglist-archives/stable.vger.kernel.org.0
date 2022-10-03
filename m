Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A001B5F2FCE
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 13:49:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229655AbiJCLty (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Oct 2022 07:49:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbiJCLtx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Oct 2022 07:49:53 -0400
X-Greylist: delayed 72 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 03 Oct 2022 04:49:49 PDT
Received: from forward100j.mail.yandex.net (forward100j.mail.yandex.net [IPv6:2a02:6b8:0:801:2::100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D57ADEDC
        for <stable@vger.kernel.org>; Mon,  3 Oct 2022 04:49:47 -0700 (PDT)
Received: from myt5-2f5ba0466eb8.qloud-c.yandex.net (myt5-2f5ba0466eb8.qloud-c.yandex.net [IPv6:2a02:6b8:c12:1c83:0:640:2f5b:a046])
        by forward100j.mail.yandex.net (Yandex) with ESMTP id BAB9F64F70E8;
        Mon,  3 Oct 2022 14:48:26 +0300 (MSK)
Received: by myt5-2f5ba0466eb8.qloud-c.yandex.net (smtp/Yandex) with ESMTPSA id RZaKs5lePN-mPh4aSZi;
        Mon, 03 Oct 2022 14:48:26 +0300
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client certificate not present)
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail; t=1664797706;
        bh=4ACklEBNB8dMLIciKTy9QH+Lvpf49HkK/QI4un4eVck=;
        h=Message-Id:Date:Cc:Subject:To:From;
        b=A3glqLpMzDDXubOrXgCa8t3FpXWPt7eBUwyRFLBBi6bNvo6yLwtHSidPH08ApUXbI
         aaHlp4iKklq/ZnfKF5exde8hvcSWmMyqjCCviWdoT3psEzfj6dwh4BCusO64apiRc2
         W8T/zxCQI5L1AeWJV+wrjNgF38fRSvFEKvIkUnmQ=
Authentication-Results: myt5-2f5ba0466eb8.qloud-c.yandex.net; dkim=pass header.i=@yandex.ru
From:   Peter Kosyh <pkosyh@yandex.ru>
To:     stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Peter Kosyh <pkosyh@yandex.ru>,
        Netanel Belgazal <netanel@amazon.com>,
        Arthur Kiyanovski <akiyano@amazon.com>,
        Guy Tzalik <gtzalik@amazon.com>,
        Saeed Bishara <saeedb@amazon.com>,
        Zorik Machulsky <zorik@amazon.com>,
        lvc-project@linuxtesting.org
Subject: [PATCH 5.10 0/1] eth: ena: Check return value of xdp_convert_buff_to_frame
Date:   Mon,  3 Oct 2022 14:48:18 +0300
Message-Id: <20221003114819.349535-1-pkosyh@yandex.ru>
X-Mailer: git-send-email 2.37.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Return value of a function 'xdp_convert_buff_to_frame' is dereferenced
without checking for null, but it is usually checked for this function.

This fixed in upstream commit <e8223eeff02> while refactoring. So,
simpler patch is offered for a stable version.

Found by Linux Verification Center (linuxtesting.org) with SVACE.
