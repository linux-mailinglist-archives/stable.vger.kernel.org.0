Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31C0550B4E0
	for <lists+stable@lfdr.de>; Fri, 22 Apr 2022 12:21:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1446384AbiDVKX3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Apr 2022 06:23:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1446488AbiDVKX1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 22 Apr 2022 06:23:27 -0400
Received: from phobos.denx.de (phobos.denx.de [IPv6:2a01:238:438b:c500:173d:9f52:ddab:ee01])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 128AC517DB
        for <stable@vger.kernel.org>; Fri, 22 Apr 2022 03:20:34 -0700 (PDT)
Received: from [127.0.0.1] (p578adb1c.dip0.t-ipconnect.de [87.138.219.28])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: marex@denx.de)
        by phobos.denx.de (Postfix) with ESMTPSA id 01B4D8186D;
        Fri, 22 Apr 2022 12:20:31 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
        s=phobos-20191101; t=1650622832;
        bh=yeXCy8Cb1RsGX+3Y7Y0UR70/7s+DiZZ4vOcYAtIzurM=;
        h=Date:To:Cc:From:Subject:From;
        b=IwgXjlgwFtofCNOFqTlfDSuwp/PonzpncLByXO6uVvfIxT6sBP4qBipbvaNOoSagW
         VjUQTvfBD0mQNuMvK8Cd6cywyFWrMbVi8vgxXHue6nk29fL88vq8UK6Xf9ePhg2yDf
         d3HrD6J8EsmXG4dWMKzDiz2xXv64E2CEGbdOkVuEn/7nBxMr3hQHY9RuwdvtDzFQmm
         HBn7RzjuR4dLZhvPZKVlvZIDMOzwcOns3yYJYdqkMHICFQnWCHzzr79NbHPrBEPlp7
         88xwC4MVnG88+JAqJZQKqOB3Rh9j1lyANsczlDPeYsUDd1+mmopSpyIqnXcpJZ7Hdw
         e4iwU6mG0SwRA==
Message-ID: <7f3dedb3-7d5d-dcf3-8d7f-631251173d33@denx.de>
Date:   Fri, 22 Apr 2022 12:20:31 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Content-Language: en-US
To:     linux-stable <stable@vger.kernel.org>,
        Randy Dunlap <rdunlap@infradead.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>
From:   Marek Vasut <marex@denx.de>
Subject: net: micrel: fix KS8851_MLL Kconfig -- missing dependency in 5.10.112
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Virus-Scanned: clamav-milter 0.103.5 at phobos.denx.de
X-Virus-Status: Clean
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Since linux-stable 5.10.112 commit:

1ff5359afa5e ("net: micrel: fix KS8851_MLL Kconfig")

it is not possible to select KS8851_MLL symbol.

This is because the commit adds dependency on Kconfig symbol

PTP_1588_CLOCK_OPTIONAL

which was added in Linux upstream commit:

e5f31552674e ("ethernet: fix PTP_1588_CLOCK dependencies")

And the aforementioned commit is not part of stable 5.10.112.
